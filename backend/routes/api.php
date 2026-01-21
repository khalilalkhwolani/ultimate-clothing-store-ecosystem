<?php

use App\Http\Controllers\Api\CartController;
use App\Http\Controllers\Api\CartItemController;
use App\Http\Controllers\Api\CategoryController;
use App\Http\Controllers\Api\CouponController;
use App\Http\Controllers\Api\DashboardController;
use App\Http\Controllers\Api\InventoryController;
use App\Http\Controllers\Api\OrderController;
use App\Http\Controllers\Api\PaymentController;
use App\Http\Controllers\Api\ProductController;
use App\Http\Controllers\Api\ProductVariantController;
use App\Http\Controllers\Api\ReportsController;
use App\Http\Controllers\Api\SettingController;
use App\Http\Controllers\Api\UserController;
use App\Http\Controllers\AuthController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

// Test route
Route::get('/test', function () {
    \Log::info('Test route accessed');
    return response()->json(['message' => 'Test route works']);
});

// Public API routes - no authentication required
Route::apiResource('products', ProductController::class)->only(['index', 'show']);
Route::apiResource('categories', CategoryController::class)->only(['index', 'show']);

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

Route::middleware('throttle.auth')->group(function () {
    Route::post('/register', [AuthController::class, 'register']);
    Route::post('/login', [AuthController::class, 'login']);
    Route::post('/refresh-token', [AuthController::class, 'refreshToken']);
    Route::post('/reset-password', [AuthController::class, 'resetPassword']);
});

Route::middleware(['auth:sanctum', 'throttle.write'])->group(function () {
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/profile', [AuthController::class, 'profile']);
    Route::put('/profile', [AuthController::class, 'updateProfile']);
});

// Payment webhook (no auth required)
Route::post('payments/webhook', [PaymentController::class, 'webhook']);

// API v1 routes
Route::prefix('v1')->group(function () {
    // Authentication routes
    Route::middleware('throttle.auth')->group(function () {
        Route::post('/register', [AuthController::class, 'register']);
        Route::post('/login', [AuthController::class, 'login']);
        Route::post('/refresh-token', [AuthController::class, 'refreshToken']);
        Route::post('/reset-password', [AuthController::class, 'resetPassword']);
    });

    Route::middleware(['auth:sanctum', 'throttle.write'])->group(function () {
        Route::post('/logout', [AuthController::class, 'logout']);
        Route::get('/profile', [AuthController::class, 'profile']);
        Route::put('/profile', [AuthController::class, 'updateProfile']);
    });

    // Public routes
    Route::middleware('throttle.read')->group(function () {
        Route::apiResource('categories', CategoryController::class)->only(['index', 'show']);

        Route::apiResource('products', ProductController::class)->only(['index', 'show']);
        Route::apiResource('product-variants', ProductVariantController::class)->only(['index', 'show']);
        Route::apiResource('coupons', CouponController::class)->only(['index', 'show']);
        Route::apiResource('settings', SettingController::class)->only(['index', 'show']);
    });

    // Cart routes (guest allowed)
    Route::middleware('throttle.cart')->group(function () {
        Route::get('cart', [CartController::class, 'index']);
        Route::apiResource('cart-items', CartItemController::class);
    });

    // Authenticated routes
    Route::middleware(['auth:sanctum', 'throttle.write'])->group(function () {
        // Dashboard routes
        Route::middleware('throttle.dashboard')->prefix('dashboard')->group(function () {
            Route::get('stats', [DashboardController::class, 'stats']);
            Route::get('charts', [DashboardController::class, 'charts']);
            Route::get('top-products', [DashboardController::class, 'topProducts']);
            Route::get('recent-orders', [DashboardController::class, 'recentOrders']);
        });

        // Reports routes
        Route::middleware('throttle.dashboard')->prefix('reports')->group(function () {
            Route::get('analytics', [ReportsController::class, 'analytics']);
            Route::get('revenue-chart', [ReportsController::class, 'revenueChart']);
            Route::get('customer-stats', [ReportsController::class, 'customerStats']);
        });

        Route::apiResource('categories', CategoryController::class)->except(['index', 'show']);
        Route::apiResource('products', ProductController::class)->except(['index', 'show']);
        Route::apiResource('product-variants', ProductVariantController::class)->except(['index', 'show']);
        Route::apiResource('inventories', InventoryController::class);
        Route::post('inventories/{id}/restock', [InventoryController::class, 'restock']);
        Route::post('inventories/{id}/deduct', [InventoryController::class, 'deductStock']);
        Route::get('inventories/low-stock', [InventoryController::class, 'lowStock']);
        Route::apiResource('orders', OrderController::class);
        Route::apiResource('coupons', CouponController::class)->except(['index', 'show']);
        Route::apiResource('settings', SettingController::class)->except(['index', 'show']);
        Route::apiResource('cart', CartController::class)->except(['index']);

        // User management routes (admin only)
        Route::middleware(['admin', 'throttle.admin'])->group(function () {
            Route::apiResource('users', UserController::class);
        });

        // Checkout and payment endpoints
        Route::post('checkout', [OrderController::class, 'checkout']);
        Route::prefix('payments')->group(function () {
            Route::get('intent/{id}', [PaymentController::class, 'getPaymentIntent']);
        });

        // Additional endpoints
        Route::get('orders/{order}/track', [OrderController::class, 'track'])->name('orders.track');

        Route::get('notifications', function () {
            // Placeholder for notifications
            return response()->json(['message' => 'Notifications placeholder']);
        });
    });
});

// Image upload endpoints (publicly accessible)
Route::middleware('throttle.upload')->prefix('upload')->group(function () {
    // Single image upload endpoint
    // Uploads and processes a single image, creating multiple sizes (thumbnail, medium, large)
    // and associates it with the specified model
    Route::post('{model_type}/{model_id}', [\App\Http\Controllers\Api\UploadController::class, 'uploadSingleImage'])
        ->name('upload.single');

    // Multiple images upload endpoint
    // Uploads and processes multiple images, creating multiple sizes for each image
    // and associates them with the specified model
    Route::post('multiple/{model_type}/{model_id}', [\App\Http\Controllers\Api\UploadController::class, 'uploadMultipleImages'])
        ->name('upload.multiple');
});
