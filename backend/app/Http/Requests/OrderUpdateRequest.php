<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class OrderUpdateRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true;
    }

    /**
     * Prepare the data for validation.
     */
    protected function prepareForValidation(): void
    {
        $dataToMerge = [];

        if ($this->has('user_id') && $this->user_id) {
            $dataToMerge['user_id'] = trim($this->user_id);
        }
        if ($this->has('status') && $this->status) {
            $dataToMerge['status'] = trim($this->status);
        }
        if ($this->has('payment_method') && $this->payment_method) {
            $dataToMerge['payment_method'] = trim($this->payment_method);
        }
        if ($this->has('payment_status') && $this->payment_status) {
            $dataToMerge['payment_status'] = trim($this->payment_status);
        }

        if (!empty($dataToMerge)) {
            $this->merge($dataToMerge);
        }
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        return [
            'user_id' => 'sometimes|required|exists:users,id',
            'total_amount' => 'sometimes|required|numeric|min:0',
            'status' => 'sometimes|required|string|max:255',
            'shipping_address' => 'sometimes|required|array',
            'billing_address' => 'sometimes|required|array',
            'payment_method' => 'sometimes|required|string|max:255',
            'payment_status' => 'sometimes|required|string|max:255',
        ];
    }
}
