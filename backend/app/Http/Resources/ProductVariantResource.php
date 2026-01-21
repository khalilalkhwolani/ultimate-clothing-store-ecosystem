<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class ProductVariantResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'product_id' => $this->product_id,
            'size' => htmlspecialchars($this->size, ENT_QUOTES, 'UTF-8'),
            'color' => htmlspecialchars($this->color, ENT_QUOTES, 'UTF-8'),
            'sku' => htmlspecialchars($this->sku, ENT_QUOTES, 'UTF-8'),
            'price' => $this->price,
            'stock' => $this->stock,
            'weight' => $this->weight,
            'is_available' => $this->is_available,
            'created_at' => $this->created_at,
            'updated_at' => $this->updated_at,
            'product' => new ProductResource($this->whenLoaded('product')),
        ];
    }
}