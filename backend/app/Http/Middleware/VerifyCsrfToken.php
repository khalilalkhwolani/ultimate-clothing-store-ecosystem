<?php

namespace App\Http\Middleware;

use Illuminate\Foundation\Http\Middleware\VerifyCsrfToken as Middleware;

class VerifyCsrfToken extends Middleware
{
    /**
     * The URIs that should be excluded from CSRF verification.
     *
     * @var array<int, string>
     */
    protected $except = [
        // All API routes use token-based authentication (Sanctum) and don't need CSRF protection
        'api/*',
        
        // Sanctum CSRF cookie endpoint
        'sanctum/csrf-cookie',
    ];

    /**
     * Determine if the request has a URI that should pass through CSRF verification.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return bool
     */
    protected function inExceptArray($request)
    {
        // API routes are always excluded from CSRF verification
        // They use token-based authentication (Sanctum) instead
        if ($request->is('api/*')) {
            return true;
        }

        return parent::inExceptArray($request);
    }

    /**
     * Determine if the request is for an authentication route.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return bool
     */
    protected function isAuthenticationRoute($request): bool
    {
        $authRoutes = [
            'api/login',
            'api/register',
            'api/logout',
            'api/refresh-token',
            'api/reset-password',
            'api/profile',
        ];

        $path = $request->path();
        
        foreach ($authRoutes as $route) {
            if ($path === $route || str_starts_with($path, $route . '/')) {
                return true;
            }
        }

        return false;
    }

    /**
     * Determine if the request is a state-changing operation.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return bool
     */
    protected function isStateChangingOperation($request): bool
    {
        return in_array($request->method(), ['POST', 'PUT', 'PATCH', 'DELETE']);
    }

    /**
     * Handle an incoming request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Closure  $next
     * @return mixed
     *
     * @throws \Illuminate\Session\TokenMismatchException
     */
    public function handle($request, \Closure $next)
    {
        // Log CSRF validation attempts for security monitoring
        if ($this->shouldValidateToken($request)) {
            \Log::info('CSRF validation attempt', [
                'ip' => $request->ip(),
                'user_agent' => $request->userAgent(),
                'method' => $request->method(),
                'path' => $request->path(),
                'has_token' => $request->hasHeader('X-CSRF-TOKEN') || $request->hasHeader('X-XSRF-TOKEN') || $request->has('_token'),
                'session_id' => $request->session()->getId(),
            ]);
        }

        try {
            return parent::handle($request, $next);
        } catch (\Illuminate\Session\TokenMismatchException $e) {
            // Log CSRF failures for security monitoring
            \Log::warning('CSRF token mismatch', [
                'ip' => $request->ip(),
                'user_agent' => $request->userAgent(),
                'method' => $request->method(),
                'path' => $request->path(),
                'session_id' => $request->session()->getId(),
                'provided_token_hash' => $this->getTokenFromRequest($request) ? hash('sha256', $this->getTokenFromRequest($request)) : null,
                'expected_token_hash' => $request->session()->token() ? hash('sha256', $request->session()->token()) : null,
            ]);

            // Return structured error response for API requests
            if ($request->expectsJson() || $request->is('api/*')) {
                return response()->json([
                    'message' => 'CSRF token mismatch. Please refresh the page and try again.',
                    'error' => 'csrf_token_mismatch',
                    'code' => 419
                ], 419);
            }

            throw $e;
        }
    }

    /**
     * Determine if the session and input CSRF tokens match.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return bool
     */
    protected function tokensMatch($request)
    {
        $token = $this->getTokenFromRequest($request);

        return is_string($request->session()->token()) &&
               is_string($token) &&
               hash_equals($request->session()->token(), $token);
    }

    /**
     * Get the CSRF token from the request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return string|null
     */
    protected function getTokenFromRequest($request)
    {
        $token = $request->input('_token') ?: $request->header('X-CSRF-TOKEN');

        if (! $token && $header = $request->header('X-XSRF-TOKEN')) {
            $token = $this->encryptCookies
                        ? decrypt($header, static::serialized())
                        : $header;
        }

        return $token;
    }

    /**
     * Determine if the token should be validated for the given request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return bool
     */
    protected function shouldValidateToken($request): bool
    {
        return $this->isReading($request) === false &&
               $this->runningUnitTests() === false &&
               $this->inExceptArray($request) === false &&
               $this->tokensMatch($request) === false;
    }
}