<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class CategoryResource extends JsonResource
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
            'name' => htmlspecialchars($this->name, ENT_QUOTES, 'UTF-8'),
            'description' => htmlspecialchars($this->description ?? '', ENT_QUOTES, 'UTF-8'),
            'slug' => htmlspecialchars($this->slug, ENT_QUOTES, 'UTF-8'),
            'image' => $this->image ? htmlspecialchars($this->image, ENT_QUOTES, 'UTF-8') : null,
            'imageUrl' => $this->image ? htmlspecialchars($this->image, ENT_QUOTES, 'UTF-8') : null, // Flutter expects 'imageUrl'
            'parent_id' => $this->parent_id,
            'is_active' => $this->is_active,
            'created_at' => $this->created_at,
            'updated_at' => $this->updated_at,
            'parent' => $this->whenLoaded('parent'),
            'children' => CategoryResource::collection($this->whenLoaded('children')),
        ];
    }
}
