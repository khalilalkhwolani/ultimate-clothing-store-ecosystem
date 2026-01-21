<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class CouponUpdateRequest extends FormRequest
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
            'code' => [
                'sometimes',
                'required',
                'string',
                'max:255',
                Rule::unique('coupons')->ignore($this->route('coupon')),
            ],
            'discount_type' => 'sometimes|required|string|max:255',
            'discount_value' => 'sometimes|required|numeric|min:0',
            'min_order_amount' => 'nullable|numeric|min:0',
            'usage_limit' => 'nullable|integer|min:0',
            'used_count' => 'integer|min:0',
            'expires_at' => 'nullable|date',
            'is_active' => 'boolean',
        ];
    }

    /**
     * Prepare the data for validation.
     */
    protected function prepareForValidation(): void
    {
        $this->merge([
            'code' => $this->code ? trim(strip_tags($this->code)) : null,
            'discount_type' => $this->discount_type ? trim(strip_tags($this->discount_type)) : null,
        ]);
    }
}