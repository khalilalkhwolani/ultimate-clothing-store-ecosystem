<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class ProductIndexRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        return [
            'category_id' => 'nullable|exists:categories,id',
            'brand' => 'nullable|string|max:255',
            'is_featured' => 'nullable|boolean',
            'size' => 'nullable|string|max:50',
            'color' => 'nullable|string|max:50',
            'price_min' => 'nullable|numeric|min:0',
            'price_max' => 'nullable|numeric|min:0',
            'sort_by' => 'nullable|in:created_at,price,popularity,rating',
            'sort_order' => 'nullable|in:asc,desc',
            'per_page' => 'nullable|integer|min:1|max:100',
        ];
    }

    /**
     * Prepare the data for validation.
     */
    protected function prepareForValidation(): void
    {
        $this->merge([
            'brand' => $this->brand ? trim(strip_tags($this->brand)) : null,
            'size' => $this->size ? trim(strip_tags($this->size)) : null,
            'color' => $this->color ? trim(strip_tags($this->color)) : null,
        ]);
    }
}