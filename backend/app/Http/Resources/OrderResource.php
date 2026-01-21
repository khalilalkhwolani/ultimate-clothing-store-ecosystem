<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class OrderResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        // Extract shipping info from shipping_address array
        $shippingAddress = is_array($this->shipping_address) ? $this->shipping_address : [];

        return [
            'id' => $this->id,
            'order_number' => $this->order_number,
            'userId' => $this->user_id, // Flutter expects 'userId'
            'user_id' => $this->user_id,
            'orderDate' => $this->created_at?->toIso8601String(), // Flutter expects 'orderDate'
            'totalAmount' => $this->total_amount, // Flutter expects 'totalAmount'
            'total_amount' => $this->total_amount,
            'status' => $this->status,
            'shipping_address' => $this->shipping_address,
            'billing_address' => $this->billing_address,
            'payment_method' => $this->payment_method,
            'paymentMethod' => $this->payment_method, // Flutter expects 'paymentMethod'
            'payment_status' => $this->payment_status,
            'paymentStatus' => $this->payment_status, // Flutter expects 'paymentStatus'

            // Extract shipping details for Flutter
            'shippingName' => $shippingAddress['name'] ?? null,
            'shippingAddress' => $shippingAddress['address'] ?? null,
            'shippingPhone' => $shippingAddress['phone'] ?? null,

            'created_at' => $this->created_at,
            'updated_at' => $this->updated_at,

            // Relationships
            'user' => new UserResource($this->whenLoaded('user')),
            'items' => OrderItemResource::collection($this->whenLoaded('orderItems')), // Flutter expects 'items'
            'order_items' => OrderItemResource::collection($this->whenLoaded('orderItems')),
        ];
    }
}
