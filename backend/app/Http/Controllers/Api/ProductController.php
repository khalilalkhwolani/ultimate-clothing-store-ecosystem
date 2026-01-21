<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\ProductIndexRequest;
use App\Http\Requests\ProductStoreRequest;
use App\Http\Requests\ProductUpdateRequest;
use App\Http\Resources\ProductResource;
use App\Models\Product;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class ProductController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(ProductIndexRequest $request): JsonResponse
    {
        $query = Product::with(['category', 'productVariants', 'media']);

        // Filtering
        if ($request->filled('category_id')) {
            $query->where('category_id', $request->category_id);
        }

        if ($request->filled('brand')) {
            $query->where('brand', 'like', '%' . $request->brand . '%');
        }

        if ($request->filled('is_featured')) {
            $query->where('is_featured', $request->boolean('is_featured'));
        }

        // Filter by product variants
        if ($request->filled('size')) {
            $query->whereHas('productVariants', function ($q) use ($request) {
                $q->where('size', $request->size);
            });
        }

        if ($request->filled('color')) {
            $query->whereHas('productVariants', function ($q) use ($request) {
                $q->where('color', $request->color);
            });
        }

        if ($request->filled('price_min') || $request->filled('price_max')) {
            $query->whereHas('productVariants', function ($q) use ($request) {
                if ($request->filled('price_min')) {
                    $q->where('price', '>=', $request->price_min);
                }
                if ($request->filled('price_max')) {
                    $q->where('price', '<=', $request->price_max);
                }
            });
        }

        // Sorting
        $sortBy = $request->get('sort_by', 'created_at');
        $sortOrder = $request->get('sort_order', 'desc');

        switch ($sortBy) {
            case 'price':
                $query->join('product_variants', 'products.id', '=', 'product_variants.product_id')
                    ->orderBy('product_variants.price', $sortOrder)
                    ->select('products.*');
                break;
            case 'popularity':
                // Assuming popularity is based on some field, for now sort by created_at
                $query->orderBy('created_at', $sortOrder);
                break;
            case 'rating':
                // Assuming rating is not implemented yet, sort by created_at
                $query->orderBy('created_at', $sortOrder);
                break;
            default:
                $query->orderBy($sortBy, $sortOrder);
        }

        $products = $query->paginate($request->get('per_page', 15));

        return response()->json([
            'data' => ProductResource::collection($products),
            'meta' => [
                'current_page' => $products->currentPage(),
                'last_page' => $products->lastPage(),
                'per_page' => $products->perPage(),
                'total' => $products->total(),
            ],
        ]);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(ProductStoreRequest $request): JsonResponse
    {
        $product = Product::create($request->validated());

        // Create default variant
        $product->productVariants()->create([
            'size' => 'default',
            'color' => 'default',
            'sku' => 'SKU-' . $product->id . '-' . time(),
            'price' => $request->base_price,
            'stock' => $request->stock_quantity,
            'weight' => 0,
            'is_available' => true,
        ]);

        return response()->json([
            'message' => 'Product created successfully',
            'data' => new ProductResource($product->load(['category', 'productVariants', 'media'])),
        ], 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(Product $product): JsonResponse
    {
        return response()->json([
            'data' => new ProductResource($product->load(['category', 'productVariants', 'media'])),
        ]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(ProductUpdateRequest $request, Product $product): JsonResponse
    {
        $product->update($request->validated());

        return response()->json([
            'message' => 'Product updated successfully',
            'data' => new ProductResource($product->load(['category', 'productVariants', 'media'])),
        ]);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Product $product): JsonResponse
    {
        $product->delete();

        return response()->json([
            'message' => 'Product deleted successfully',
        ]);
    }
}
