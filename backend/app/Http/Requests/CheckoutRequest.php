<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class CheckoutRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true; // Auth handled by middleware
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        return [
            'coupon_code' => 'nullable|string|exists:coupons,code',
            'payment_method' => 'required|string|in:stripe',
            'shipping_address' => 'required|array',
            'shipping_address.line1' => 'required|string',
            'shipping_address.line2' => 'nullable|string',
            'shipping_address.city' => 'required|string',
            'shipping_address.state' => 'required|string',
            'shipping_address.postal_code' => 'required|string',
            'shipping_address.country' => 'required|string|size:2',
            'billing_address' => 'nullable|array',
            'billing_address.line1' => 'required_with:billing_address|string',
            'billing_address.line2' => 'nullable|string',
            'billing_address.city' => 'required_with:billing_address|string',
            'billing_address.state' => 'required_with:billing_address|string',
            'billing_address.postal_code' => 'required_with:billing_address|string',
            'billing_address.country' => 'required_with:billing_address|string|size:2',
        ];
    }
}