<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class ProductVariantStoreRequest extends FormRequest
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
            'product_id' => 'required|exists:products,id',
            'size' => 'nullable|string|max:255',
            'color' => 'nullable|string|max:255',
            'sku' => 'required|string|max:255|unique:product_variants',
            'price' => 'required|numeric|min:0',
            'stock' => 'required|integer|min:0',
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
            'size' => $this->size ? trim(strip_tags($this->size)) : null,
            'color' => $this->color ? trim(strip_tags($this->color)) : null,
            'sku' => trim(strip_tags($this->sku)),
        ]);
    }
}