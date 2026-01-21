<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class UserUpdateRequest extends FormRequest
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
            'name' => 'sometimes|required|string|max:255',
            'email' => ['sometimes', 'required', 'string', 'email', 'max:255', Rule::unique('users')->ignore($this->route('user')->id)],
            'password' => 'sometimes|nullable|string|min:8',
            'role' => 'sometimes|required|in:customer,admin',
        ];
    }

    /**
     * Prepare the data for validation.
     */
    protected function prepareForValidation(): void
    {
        $this->merge([
            'name' => $this->name ? trim(strip_tags($this->name)) : null,
            'email' => $this->email ? trim(strip_tags($this->email)) : null,
            'password' => $this->password ? trim(strip_tags($this->password)) : null,
            'role' => $this->role ? trim(strip_tags($this->role)) : null,
        ]);
    }
}