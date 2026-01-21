<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class OrderItemResource extends JsonResource
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
            'orderId' => $this->order_id, // Flutter expects 'orderId'
            'order_id' => $this->order_id,
            'productId' => $this->product_variant_id, // Flutter expects 'productId'
            'product_variant_id' => $this->product_variant_id,
            'quantity' => $this->quantity,
            'price' => $this->price,
            'created_at' => $this->created_at,
            'updated_at' => $this->updated_at,

            // Include product details for Flutter
            'product' => new ProductVariantResource($this->whenLoaded('productVariant')),
            'product_variant' => new ProductVariantResource($this->whenLoaded('productVariant')),
        ];
    }
}
