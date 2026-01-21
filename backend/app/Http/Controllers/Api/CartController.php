<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\CartIndexRequest;
use App\Http\Requests\CartStoreRequest;
use App\Http\Requests\CartUpdateRequest;
use App\Http\Resources\CartResource;
use App\Models\Cart;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Session;

class CartController extends Controller
{
    /**
     * Display the current user's or guest cart.
     */
    public function index(CartIndexRequest $request): JsonResponse
    {
        $cart = $this->getOrCreateCart();

        return response()->json([
            'data' => new CartResource($cart->load('cartItems.productVariant')),
        ]);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(CartStoreRequest $request): JsonResponse
    {
        // Carts are created automatically, this might not be needed
        return response()->json(['message' => 'Use index to get or create cart'], 405);
    }

    /**
     * Display the specified resource.
     */
    public function show(Cart $cart): JsonResponse
    {
        // Ensure user owns the cart or it's a guest cart
        if ($cart->user_id && $cart->user_id !== Auth::id()) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        return response()->json([
            'data' => new CartResource($cart->load('cartItems.productVariant')),
        ]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(CartUpdateRequest $request, Cart $cart): JsonResponse
    {
        // Not typically used
        return response()->json(['message' => 'Method not allowed'], 405);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Cart $cart): JsonResponse
    {
        if ($cart->user_id && $cart->user_id !== Auth::id()) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $cart->delete();

        return response()->json([
            'message' => 'Cart deleted successfully',
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