<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class MediaResource extends JsonResource
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
            'model_type' => htmlspecialchars($this->model_type, ENT_QUOTES, 'UTF-8'),
            'model_id' => $this->model_id,
            'file_path' => htmlspecialchars($this->file_path, ENT_QUOTES, 'UTF-8'),
            'file_name' => htmlspecialchars($this->file_name, ENT_QUOTES, 'UTF-8'),
            'mime_type' => htmlspecialchars($this->mime_type, ENT_QUOTES, 'UTF-8'),
            'alt_text' => htmlspecialchars($this->alt_text, ENT_QUOTES, 'UTF-8'),
            'created_at' => $this->created_at,
            'updated_at' => $this->updated_at,
        ];
    }
}