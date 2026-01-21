<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\CartItemIndexRequest;
use App\Http\Requests\CartItemStoreRequest;
use App\Http\Requests\CartItemUpdateRequest;
use App\Http\Resources\CartItemResource;
use App\Models\Cart;
use App\Models\CartItem;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Session;

class CartItemController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(CartItemIndexRequest $request): JsonResponse
    {
        $cart = $this->getOrCreateCart();
        $cartItems = $cart->cartItems()->with('productVariant')->paginate($request->get('per_page', 15));

        return response()->json([
            'data' => CartItemResource::collection($cartItems),
            'meta' => [
                'current_page' => $cartItems->currentPage(),
                'last_page' => $cartItems->lastPage(),
                'per_page' => $cartItems->perPage(),
                'total' => $cartItems->total(),
            ],
        ]);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(CartItemStoreRequest $request): JsonResponse
    {
        $cart = $this->getOrCreateCart();

        $cartItem = CartItem::where('cart_id', $cart->id)
            ->where('product_variant_id', $request->product_variant_id)
            ->first();

        if ($cartItem) {
            $cartItem->quantity += $request->quantity;
            $cartItem->save();
        } else {
            $cartItem = CartItem::create([
                'cart_id' => $cart->id,
                'product_variant_id' => $request->product_variant_id,
                'quantity' => $request->quantity,
            ]);
        }

        return response()->json([
            'message' => 'Cart item added successfully',
            'data' => new CartItemResource($cartItem->load('productVariant')),
        ], 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(CartItem $cartItem): JsonResponse
    {
        // Ensure the cart item belongs to the user's cart
        $cart = $this->getOrCreateCart();
        if ($cartItem->cart_id !== $cart->id) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        return response()->json([
            'data' => new CartItemResource($cartItem->load('productVariant')),
        ]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(CartItemUpdateRequest $request, CartItem $cartItem): JsonResponse
    {
        $cart = $this->getOrCreateCart();
        if ($cartItem->cart_id !== $cart->id) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $cartItem->update($request->validated());

        return response()->json([
            'message' => 'Cart item updated successfully',
            'data' => new CartItemResource($cartItem->load('productVariant')),
        ]);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(CartItem $cartItem): JsonResponse
    {
        $cart = $this->getOrCreateCart();
        if ($cartItem->cart_id !== $cart->id) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $cartItem->delete();

        return response()->json([
            'message' => 'Cart item deleted successfully',
        ]);
    }

    /**
     * Get or create cart for user or guest.
     */
    private function getOrCreateCart(): Cart
    {
        $userId = Auth::id();
        $sessionId = Session::getId();

        if ($userId) {
            $cart = Cart::where('user_id', $userId)->first();
            if (!$cart) {
                $cart = Cart::create(['user_id' => $userId]);
            }
        } else {
            $cart = Cart::where('session_id', $sessionId)->first();
            if (!$cart) {
                $cart = Cart::create(['session_id' => $sessionId]);
            }
        }

        return $cart;
    }
}