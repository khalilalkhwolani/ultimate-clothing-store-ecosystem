<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\ProductVariantIndexRequest;
use App\Http\Requests\ProductVariantStoreRequest;
use App\Http\Requests\ProductVariantUpdateRequest;
use App\Http\Resources\ProductVariantResource;
use App\Models\ProductVariant;
use Illuminate\Http\JsonResponse;

class ProductVariantController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(ProductVariantIndexRequest $request): JsonResponse
    {
        $query = ProductVariant::with('product');

        if ($request->has('product_id')) {
            $query->where('product_id', $request->product_id);
        }

        if ($request->has('is_available')) {
            $query->where('is_available', $request->boolean('is_available'));
        }

        $productVariants = $query->paginate($request->get('per_page', 15));

        return response()->json([
            'data' => ProductVariantResource::collection($productVariants),
            'meta' => [
                'current_page' => $productVariants->currentPage(),
                'last_page' => $productVariants->lastPage(),
                'per_page' => $productVariants->perPage(),
                'total' => $productVariants->total(),
            ],
        ]);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(ProductVariantStoreRequest $request): JsonResponse
    {
        $productVariant = ProductVariant::create($request->validated());

        return response()->json([
            'message' => 'Product variant created successfully',
            'data' => new ProductVariantResource($productVariant->load('product')),
        ], 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(ProductVariant $productVariant): JsonResponse
    {
        return response()->json([
            'data' => new ProductVariantResource($productVariant->load('product')),
        ]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(ProductVariantUpdateRequest $request, ProductVariant $productVariant): JsonResponse
    {
        $productVariant->update($request->validated());

        return response()->json([
            'message' => 'Product variant updated successfully',
            'data' => new ProductVariantResource($productVariant->load('product')),
        ]);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(ProductVariant $productVariant): JsonResponse
    {
        $productVariant->delete();

        return response()->json([
            'message' => 'Product variant deleted successfully',
        ]);
    }
}