<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class ProductUpdateRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true; // Add authorization logic if needed
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        return [
            'name' => 'sometimes|required|string|max:255',
            'description' => 'nullable|string',
            'category_id' => 'sometimes|required|exists:categories,id',
            'brand' => 'nullable|string|max:255',
            'base_price' => 'sometimes|required|numeric|min:0',
            'is_featured' => 'boolean',
        ];
    }

    /**
     * Prepare the data for validation.
     */
    protected function prepareForValidation(): void
    {
        $this->merge([
            'name' => isset($this->name) ? trim(strip_tags($this->name)) : $this->name,
            'description' => isset($this->description) ? trim(strip_tags($this->description)) : $this->description,
            'brand' => isset($this->brand) ? trim(strip_tags($this->brand)) : $this->brand,
        ]);
    }
}