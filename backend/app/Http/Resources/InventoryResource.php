<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class InventoryResource extends JsonResource
{
    public function toArray($request)
    {
        return [
            'id' => $this->id,
            'product_variant_id' => $this->product_variant_id,
            'product_variant' => new ProductVariantResource($this->whenLoaded('productVariant')),
            'quantity' => $this->quantity,
            'low_stock_threshold' => $this->low_stock_threshold,
            'last_restocked_at' => $this->last_restocked_at,
            'status' => htmlspecialchars($this->status, ENT_QUOTES, 'UTF-8'),
            'is_low_stock' => $this->isLowStock(),
            'created_at' => $this->created_at,
            'updated_at' => $this->updated_at,
        ];
    }
}