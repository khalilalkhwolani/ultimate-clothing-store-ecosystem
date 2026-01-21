<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class UserResource extends JsonResource
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
            'email' => htmlspecialchars($this->email, ENT_QUOTES, 'UTF-8'),
            'role' => htmlspecialchars($this->role, ENT_QUOTES, 'UTF-8'),
            'email_verified_at' => $this->email_verified_at,
            'created_at' => $this->created_at,
            'updated_at' => $this->updated_at,
        ];
    }
}