<?php

namespace App\Http\Controllers;

use App\Http\Requests\LoginRequest;
use App\Http\Requests\RegisterRequest;
use App\Http\Requests\ResetPasswordRequest;
use App\Http\Requests\UpdateProfileRequest;
use App\Models\RefreshToken;
use App\Models\User;
use Illuminate\Auth\Events\PasswordReset;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Password;
use Illuminate\Support\Str;
use Laravel\Sanctum\PersonalAccessToken;

class AuthController extends Controller
{
    public function register(RegisterRequest $request)
    {
        $user = User::create([
            'name' => $request->name,
            'email' => $request->email,
            'password' => Hash::make($request->password),
        ]);

        $accessToken = $user->createToken('API Token')->plainTextToken;
        $refreshToken = RefreshToken::create([
            'token' => Str::random(64),
            'user_id' => $user->id,
            'expires_at' => now()->addDays(30),
        ]);

        return response()->json([
            'data' => [
                'user' => $user,
                'access_token' => $accessToken,
                'refresh_token' => $refreshToken->token,
                'token_type' => 'Bearer',
                'expires_in' => 3600, // 1 hour in seconds
            ]
        ], 201);
    }

    public function login(LoginRequest $request)
    {
        \Log::info('Login attempt started', ['email' => $request->email]);
        
        $user = User::where('email', $request->email)->first();

        if (!$user) {
            \Log::warning('Login failed: User not found', ['email' => $request->email]);
            return response()->json(['message' => 'Invalid credentials'], 401);
        }

        // Check if account is locked
        if ($user->locked_until && $user->locked_until->isFuture()) {
            \Log::warning('Login failed: Account locked', ['email' => $request->email]);
            return response()->json(['message' => 'Account is locked due to too many failed attempts. Try again later.'], 423);
        }

        // Check password
        if (!Hash::check($request->password, $user->password)) {
            \Log::warning('Login failed: Invalid password', ['email' => $request->email]);
            // Increment failed attempts
            $user->increment('failed_attempts');

            // Lock account after 5 failed attempts for 15 minutes
            if ($user->failed_attempts >= 5) {
                $user->update([
                    'locked_until' => now()->addMinutes(15),
                    'failed_attempts' => 0, // Reset after locking
                ]);
                return response()->json(['message' => 'Account locked due to too many failed attempts. Try again in 15 minutes.'], 423);
            }

            return response()->json(['message' => 'Invalid credentials'], 401);
        }

        // Successful login: reset failed attempts and unlock
        $user->update(['failed_attempts' => 0, 'locked_until' => null]);

        \Log::info('Login successful', ['email' => $request->email, 'user_id' => $user->id]);

        $accessToken = $user->createToken('API Token')->plainTextToken;
        $refreshToken = RefreshToken::create([
            'token' => Str::random(64),
            'user_id' => $user->id,
            'expires_at' => now()->addDays(30), // Refresh token expires in 30 days
        ]);

        return response()->json([
            'data' => [
                'user' => $user,
                'access_token' => $accessToken,
                'refresh_token' => $refreshToken->token,
                'token_type' => 'Bearer',
                'expires_in' => 3600, // 1 hour in seconds
            ]
        ]);
    }

    public function logout(Request $request)
    {
        $request->user()->currentAccessToken()->delete();

        // Invalidate all refresh tokens for the user
        RefreshToken::where('user_id', $request->user()->id)->delete();

        return response()->json(['message' => 'Logged out successfully']);
    }

    public function refreshToken(Request $request)
    {
        $request->validate([
            'refresh_token' => 'required|string',
        ]);

        $refreshToken = RefreshToken::where('token', $request->refresh_token)->first();

        if (!$refreshToken || $refreshToken->isExpired()) {
            return response()->json(['message' => 'Invalid or expired refresh token'], 401);
        }

        $user = $refreshToken->user;

        // Invalidate old access token
        $user->currentAccessToken()->delete();

        // Generate new access token
        $accessToken = $user->createToken('API Token')->plainTextToken;

        // Generate new refresh token
        $newRefreshToken = RefreshToken::create([
            'token' => Str::random(64),
            'user_id' => $user->id,
            'expires_at' => now()->addDays(30),
        ]);

        // Delete the old refresh token
        $refreshToken->delete();

        return response()->json([
            'access_token' => $accessToken,
            'refresh_token' => $newRefreshToken->token,
        ]);
    }

    public function updateProfile(UpdateProfileRequest $request)
    {
        $user = $request->user();
        $user->update($request->only(['name', 'email']));

        return response()->json([
            'user' => $user,
        ]);
    }

    public function resetPassword(ResetPasswordRequest $request)
    {
        $status = Password::reset(
            $request->only('email', 'password', 'password_confirmation', 'token'),
            function (User $user, string $password) {
                $user->forceFill([
                    'password' => Hash::make($password)
                ])->setRememberToken(Str::random(60));

                $user->save();

                event(new PasswordReset($user));
            }
        );

        return $status === Password::PASSWORD_RESET
            ? response()->json(['message' => 'Password reset successfully'])
            : response()->json(['message' => 'Password reset failed'], 400);
    }

    public function profile(Request $request)
    {
        return response()->json([
            'user' => $request->user(),
        ]);
    }
}