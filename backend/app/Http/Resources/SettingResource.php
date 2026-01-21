<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class SettingResource extends JsonResource
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
            'key' => htmlspecialchars($this->key, ENT_QUOTES, 'UTF-8'),
            'value' => htmlspecialchars($this->value, ENT_QUOTES, 'UTF-8'),
            'type' => htmlspecialchars($this->type, ENT_QUOTES, 'UTF-8'),
            'created_at' => $this->created_at,
            'updated_at' => $this->updated_at,
        ];
    }
}