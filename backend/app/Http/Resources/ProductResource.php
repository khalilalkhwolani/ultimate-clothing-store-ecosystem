<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class ProductResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        $variants = $this->whenLoaded('productVariants');
        $price = $this->base_price;
        $stock_quantity = 0;
        if ($variants) {
            $prices = $variants->pluck('price');
            $price = $prices->min() ?? $this->base_price;
            $stock_quantity = $variants->sum('stock');
        }

        // Get first media URL for Flutter compatibility
        $imageUrl = null;
        $mediaCollection = $this->whenLoaded('media');
        if ($mediaCollection && $mediaCollection->isNotEmpty()) {
            $imageUrl = $mediaCollection->first()->url ?? $mediaCollection->first()->original_url;
        }

        return [
            'id' => $this->id,
            'name' => htmlspecialchars($this->name, ENT_QUOTES, 'UTF-8'),
            'description' => htmlspecialchars($this->description ?? '', ENT_QUOTES, 'UTF-8'),
            'name_ar' => null, // Not implemented
            'price' => $price,
            'stock' => $stock_quantity, // Flutter expects 'stock'
            'stock_quantity' => $stock_quantity, // Keep for backward compatibility
            'category_id' => $this->category_id,
            'imageUrl' => $imageUrl, // Flutter expects 'imageUrl'
            'status' => $this->is_featured ? 'active' : 'inactive',
            'createdAt' => $this->created_at?->toIso8601String(),
            'created_at' => $this->created_at,
            'updatedAt' => $this->updated_at?->toIso8601String(),
            'updated_at' => $this->updated_at,
            'category' => new CategoryResource($this->whenLoaded('category')),
            'product_variants' => ProductVariantResource::collection($this->whenLoaded('productVariants')),
            'media' => MediaResource::collection($this->whenLoaded('media')),
        ];
    }
}
