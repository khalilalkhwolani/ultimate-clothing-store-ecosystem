<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class ProductVariantUpdateRequest extends FormRequest
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
            'product_id' => 'sometimes|required|exists:products,id',
            'size' => 'nullable|string|max:255',
            'color' => 'nullable|string|max:255',
            'sku' => ['sometimes', 'required', 'string', 'max:255', Rule::unique('product_variants')->ignore($this->route('productVariant'))],
            'price' => 'sometimes|required|numeric|min:0',
            'stock' => 'sometimes|required|integer|min:0',
            'weight' => 'nullable|numeric|min:0',
            'is_available' => 'boolean',
        ];
    }

    /**
     * Prepare the data for validation.
     */
    protected function prepareForValidation(): void
    {
        $this->merge([
            'size' => isset($this->size) ? trim(strip_tags($this->size)) : $this->size,
            'color' => isset($this->color) ? trim(strip_tags($this->color)) : $this->color,
            'sku' => isset($this->sku) ? trim(strip_tags($this->sku)) : $this->sku,
        ]);
    }
}