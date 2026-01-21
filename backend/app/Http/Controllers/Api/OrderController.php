<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\CheckoutRequest;
use App\Http\Requests\OrderIndexRequest;
use App\Http\Requests\OrderStoreRequest;
use App\Http\Requests\OrderUpdateRequest;
use App\Http\Resources\OrderResource;
use App\Models\Cart;
use App\Models\CartItem;
use App\Models\Coupon;
use App\Models\Order;
use App\Models\OrderItem;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Stripe\PaymentIntent;
use Stripe\Stripe;

class OrderController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(OrderIndexRequest $request): JsonResponse
    {
        $query = Order::with(['user', 'orderItems.productVariant']);

        if ($request->filled('user_id')) {
            $query->where('user_id', $request->user_id);
        }

        if ($request->filled('status')) {
            $query->where('status', $request->status);
        }

        $orders = $query->paginate($request->get('per_page', 15));

        return response()->json([
            'data' => OrderResource::collection($orders),
            'meta' => [
                'current_page' => $orders->currentPage(),
                'last_page' => $orders->lastPage(),
                'per_page' => $orders->perPage(),
                'total' => $orders->total(),
            ],
        ]);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(OrderStoreRequest $request): JsonResponse
    {
        $order = Order::create($request->validated());

        return response()->json([
            'message' => 'Order created successfully',
            'data' => new OrderResource($order->load(['user', 'orderItems.productVariant'])),
        ], 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(Order $order): JsonResponse
    {
        return response()->json([
            'data' => new OrderResource($order->load(['user', 'orderItems.productVariant'])),
        ]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(OrderUpdateRequest $request, Order $order): JsonResponse
    {
        $order->update($request->validated());

        return response()->json([
            'message' => 'Order updated successfully',
            'data' => new OrderResource($order->load(['user', 'orderItems.productVariant'])),
        ]);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Order $order): JsonResponse
    {
        $order->delete();

        return response()->json([
            'message' => 'Order deleted successfully',
        ]);
    }

    /**
     * Checkout the user's cart and create an order with payment intent.
     */
    public function checkout(CheckoutRequest $request): JsonResponse
    {
        $user = Auth::user();

        // Get user's cart
        $cart = Cart::where('user_id', $user->id)->with('cartItems.productVariant')->first();

        if (!$cart || $cart->cartItems->isEmpty()) {
            return response()->json(['message' => 'Cart is empty'], 400);
        }

        // Calculate subtotal
        $subtotal = 0;
        foreach ($cart->cartItems as $item) {
            $subtotal += $item->quantity * $item->productVariant->price;
        }

        // Apply coupon if provided
        $discount = 0;
        $coupon = null;
        if ($request->has('coupon_code')) {
            $coupon = Coupon::where('code', $request->coupon_code)
                ->where('is_active', true)
                ->where(function ($query) {
                    $query->whereNull('expires_at')->orWhere('expires_at', '>', now());
                })
                ->where(function ($query) {
                    $query->whereNull('usage_limit')->orWhereColumn('used_count', '<', 'usage_limit');
                })
                ->first();

            if ($coupon) {
                if ($subtotal >= $coupon->min_order_amount) {
                    if ($coupon->discount_type === 'percentage') {
                        $discount = $subtotal * ($coupon->discount_value / 100);
                    } else {
                        $discount = min($coupon->discount_value, $subtotal);
                    }
                } else {
                    return response()->json(['message' => 'Minimum order amount not met for coupon'], 400);
                }
            } else {
                return response()->json(['message' => 'Invalid or expired coupon'], 400);
            }
        }

        $total = $subtotal - $discount;

        $order = null;

        // Use transaction
        $order = DB::transaction(function () use ($user, $cart, $total, $request, $coupon) {
            // Create order
            $order = Order::create([
                'user_id' => $user->id,
                'order_number' => 'ORD-' . strtoupper(uniqid()),
                'total_amount' => $total,
                'status' => 'pending',
                'shipping_address' => $request->shipping_address,
                'billing_address' => $request->billing_address ?? $request->shipping_address,
                'payment_method' => $request->payment_method,
                'payment_status' => 'pending',
            ]);

            // Create order items
            foreach ($cart->cartItems as $cartItem) {
                OrderItem::create([
                    'order_id' => $order->id,
                    'product_variant_id' => $cartItem->product_variant_id,
                    'quantity' => $cartItem->quantity,
                    'price' => $cartItem->productVariant->price,
                ]);
            }

            // Increment coupon usage
            if ($coupon) {
                $coupon->increment('used_count');
            }

            // Clear cart
            $cart->cartItems()->delete();

            return $order;
        });

        // Create Stripe payment intent
        Stripe::setApiKey(config('services.stripe.secret'));

        $paymentIntent = PaymentIntent::create([
            'amount' => (int)($total * 100), // Amount in cents
            'currency' => 'usd',
            'metadata' => [
                'order_id' => $order->id,
            ],
        ]);

        return response()->json([
            'message' => 'Checkout successful',
            'data' => [
                'order' => new OrderResource($order->load(['orderItems.productVariant'])),
                'payment_intent' => [
                    'client_secret' => $paymentIntent->client_secret,
                    'id' => $paymentIntent->id,
                ],
            ],
        ], 201);
    }

    /**
     * Track the specified order.
     */
    public function track(Order $order): JsonResponse
    {
        // Ensure user owns the order
        if ($order->user_id !== Auth::id()) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        // Placeholder tracking info
        $tracking = [
            'order_id' => $order->id,
            'status' => $order->status,
            'tracking_number' => 'TRK' . $order->id,
            'estimated_delivery' => now()->addDays(3)->toDateString(),
        ];

        return response()->json([
            'data' => $tracking,
        ]);
    }
}
