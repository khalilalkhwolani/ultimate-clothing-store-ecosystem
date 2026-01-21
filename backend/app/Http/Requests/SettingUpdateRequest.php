<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class SettingUpdateRequest extends FormRequest
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
            'key' => [
                'sometimes',
                'required',
                'string',
                'max:255',
                Rule::unique('settings')->ignore($this->route('setting')),
            ],
            'value' => 'sometimes|required|string',
            'type' => 'sometimes|required|string|max:255',
        ];
    }

    /**
     * Prepare the data for validation.
     */
    protected function prepareForValidation(): void
    {
        $this->merge([
            'key' => isset($this->key) ? trim(strip_tags($this->key)) : $this->key,
            'value' => isset($this->value) ? trim(strip_tags($this->value)) : $this->value,
            'type' => isset($this->type) ? trim(strip_tags($this->type)) : $this->type,
        ]);
    }
}