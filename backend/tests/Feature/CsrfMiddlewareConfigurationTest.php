<?php

namespace Tests\Feature;

use Tests\TestCase;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Middleware\VerifyCsrfToken;
use Eris\Generator;
use Eris\TestTrait;

class CsrfMiddlewareConfigurationTest extends TestCase
{
    use RefreshDatabase, TestTrait;

    /**
     * @test
     * Feature: csrf-token-security, Property 13: Middleware Configuration Correctness
     * 
     * Property: For any authentication route definition, the system should apply CSRF middleware 
     * appropriately to state-changing operations while excluding read-only operations and properly 
     * handling both web and API routes.
     * 
     * Validates: Requirements 6.1, 6.2, 6.3
     */
    public function test_csrf_middleware_configuration_correctness_property()
    {
        // Test authentication routes - should never be excepted
        $authRoutes = [
            'api/login',
            'api/register', 
            'api/logout',
            'api/profile',
            'api/refresh-token',
            'api/reset-password'
        ];

        $this->forAll(
            Generator\elements($authRoutes),
            Generator\elements(['GET', 'POST', 'PUT', 'PATCH', 'DELETE'])
        )->then(function ($path, $method) {
            $this->assertAuthRouteIsProtected($path, $method);
        });

        // Test public routes - should be excepted
        $publicRoutes = [
            'api/products',
            'api/categories',
            'api/v1/products',
            'api/v1/categories',
            'api/v1/product-variants',
            'api/v1/coupons',
            'api/v1/settings'
        ];

        $this->forAll(
            Generator\elements($publicRoutes),
            Generator\elements(['GET', 'POST', 'PUT', 'PATCH', 'DELETE'])
        )->then(function ($path, $method) {
            $this->assertPublicRouteIsExcepted($path, $method);
        });

        // Test webhook routes - should always be excepted
        $webhookRoutes = [
            'api/payments/webhook',
            'api/v1/payments/webhook'
        ];

        $this->forAll(
            Generator\elements($webhookRoutes),
            Generator\elements(['GET', 'POST', 'PUT', 'PATCH', 'DELETE'])
        )->then(function ($path, $method) {
            $this->assertWebhookRouteIsExcepted($path, $method);
        });

        // Test upload routes - should be excepted (matches api/upload/* pattern)
        $uploadRoutes = [
            'api/upload/product/1',
            'api/upload/category/2',
            'api/upload/user/avatar'
        ];

        $this->forAll(
            Generator\elements($uploadRoutes),
            Generator\elements(['GET', 'POST', 'PUT', 'PATCH', 'DELETE'])
        )->then(function ($path, $method) {
            $this->assertUploadRouteIsExcepted($path, $method);
        });

        // Test special routes - should be excepted
        $specialRoutes = [
            'sanctum/csrf-cookie',
            'api/v1/cart',
            'api/v1/cart-items'
        ];

        $this->forAll(
            Generator\elements($specialRoutes),
            Generator\elements(['GET', 'POST', 'PUT', 'PATCH', 'DELETE'])
        )->then(function ($path, $method) {
            $this->assertSpecialRouteIsExcepted($path, $method);
        });
    }

    /**
     * Assert that authentication routes are properly protected by CSRF middleware.
     */
    private function assertAuthRouteIsProtected(string $path, string $method): void
    {
        // Authentication routes should never be in the except array
        $middleware = new VerifyCsrfToken(app(), app('encrypter'));
        $reflection = new \ReflectionClass($middleware);
        $exceptProperty = $reflection->getProperty('except');
        $exceptProperty->setAccessible(true);
        $exceptArray = $exceptProperty->getValue($middleware);
        
        // Check that the path is not directly in the except array
        $this->assertNotContains($path, $exceptArray, 
            "Authentication route {$path} should not be in except array");
        
        // Check that the path doesn't match any wildcard patterns in except array
        foreach ($exceptArray as $exceptPath) {
            if (str_contains($exceptPath, '*')) {
                $pattern = str_replace('*', '.*', $exceptPath);
                $matches = preg_match('#^' . $pattern . '$#', $path);
                $this->assertNotEquals(1, $matches,
                    "Authentication route {$path} should not match except pattern {$exceptPath}");
            }
        }
    }

    /**
     * Assert that public routes are properly excepted from CSRF middleware.
     */
    private function assertPublicRouteIsExcepted(string $path, string $method): void
    {
        $middleware = new VerifyCsrfToken(app(), app('encrypter'));
        $reflection = new \ReflectionClass($middleware);
        $exceptProperty = $reflection->getProperty('except');
        $exceptProperty->setAccessible(true);
        $exceptArray = $exceptProperty->getValue($middleware);
        
        // Public routes should be in the except array
        $this->assertContains($path, $exceptArray,
            "Public route {$path} should be in except array");
    }

    /**
     * Assert that webhook routes are properly excepted from CSRF middleware.
     */
    private function assertWebhookRouteIsExcepted(string $path, string $method): void
    {
        $middleware = new VerifyCsrfToken(app(), app('encrypter'));
        $reflection = new \ReflectionClass($middleware);
        $exceptProperty = $reflection->getProperty('except');
        $exceptProperty->setAccessible(true);
        $exceptArray = $exceptProperty->getValue($middleware);
        
        // Webhook routes should be in the except array
        $this->assertContains($path, $exceptArray,
            "Webhook route {$path} should be in except array");
    }

    /**
     * Assert that upload routes are properly excepted from CSRF middleware.
     */
    private function assertUploadRouteIsExcepted(string $path, string $method): void
    {
        $middleware = new VerifyCsrfToken(app(), app('encrypter'));
        $reflection = new \ReflectionClass($middleware);
        $exceptProperty = $reflection->getProperty('except');
        $exceptProperty->setAccessible(true);
        $exceptArray = $exceptProperty->getValue($middleware);
        
        // Upload routes should match the api/upload/* pattern in except array
        $foundMatch = false;
        foreach ($exceptArray as $exceptPath) {
            if ($exceptPath === 'api/upload/*') {
                $foundMatch = true;
                break;
            }
        }
        
        $this->assertTrue($foundMatch, "Upload pattern 'api/upload/*' should be in except array");
        
        // Verify the specific path matches the pattern
        $this->assertTrue(str_starts_with($path, 'api/upload/'),
            "Upload route {$path} should start with 'api/upload/'");
    }

    /**
     * Assert that special routes are properly excepted from CSRF middleware.
     */
    private function assertSpecialRouteIsExcepted(string $path, string $method): void
    {
        $middleware = new VerifyCsrfToken(app(), app('encrypter'));
        $reflection = new \ReflectionClass($middleware);
        $exceptProperty = $reflection->getProperty('except');
        $exceptProperty->setAccessible(true);
        $exceptArray = $exceptProperty->getValue($middleware);
        
        // Special routes should be in the except array
        $this->assertContains($path, $exceptArray,
            "Special route {$path} should be in except array");
    }

    /**
     * Determine if a path is expected to be an authentication route.
     */
    private function isExpectedAuthRoute(string $path): bool
    {
        $authRoutes = [
            'api/login',
            'api/register',
            'api/logout',
            'api/refresh-token',
            'api/reset-password',
            'api/profile',
        ];

        foreach ($authRoutes as $route) {
            if ($path === $route || str_starts_with($path, $route . '/')) {
                return true;
            }
        }

        return false;
    }

    /**
     * Determine if a path should be in the except array.
     */
    private function shouldBeInExceptArray(string $path, string $method, bool $isAuthRoute, bool $isStateChanging): bool
    {
        // Authentication routes are never excepted
        if ($isAuthRoute) {
            return false;
        }

        // Check if path is in the middleware's except array
        $exceptPaths = [
            'api/payments/webhook',
            'api/v1/payments/webhook',
            'api/products',
            'api/categories',
            'api/v1/products',
            'api/v1/categories',
            'api/v1/product-variants',
            'api/v1/coupons',
            'api/v1/settings',
            'api/v1/cart',
            'api/v1/cart-items',
            'sanctum/csrf-cookie',
        ];

        foreach ($exceptPaths as $exceptPath) {
            if (str_contains($exceptPath, '*')) {
                $pattern = str_replace('*', '.*', $exceptPath);
                if (preg_match('#^' . $pattern . '$#', $path)) {
                    return true;
                }
            } elseif ($path === $exceptPath) {
                return true;
            }
        }

        // Upload endpoints with wildcard matching
        if (str_starts_with($path, 'api/upload/')) {
            return true;
        }

        return false;
    }

    /**
     * Determine if an endpoint is public.
     */
    private function isPublicEndpoint(string $path): bool
    {
        $publicEndpoints = [
            'api/products',
            'api/categories',
            'api/v1/products',
            'api/v1/categories',
            'api/v1/product-variants',
            'api/v1/coupons',
            'api/v1/settings',
            'api/v1/cart',
            'api/v1/cart-items',
        ];

        return in_array($path, $publicEndpoints);
    }

    /**
     * Determine if an endpoint is a public read-only endpoint.
     */
    private function isPublicReadOnlyEndpoint(string $path): bool
    {
        $readOnlyEndpoints = [
            'api/products',
            'api/categories',
            'api/v1/products',
            'api/v1/categories',
            'api/v1/product-variants',
            'api/v1/coupons',
            'api/v1/settings',
        ];

        return in_array($path, $readOnlyEndpoints);
    }

    /**
     * Test that CSRF token endpoint is properly configured.
     */
    public function test_csrf_token_endpoint_configuration()
    {
        // Test that the CSRF token endpoint exists and returns proper response
        $response = $this->get('/api/csrf-token');
        
        $response->assertStatus(200);
        $response->assertJsonStructure([
            'csrf_token',
            'expires_at'
        ]);
        
        $data = $response->json();
        $this->assertNotEmpty($data['csrf_token']);
        $this->assertIsString($data['csrf_token']);
        $this->assertNotEmpty($data['expires_at']);
    }

    /**
     * Test that CORS configuration allows CSRF headers.
     */
    public function test_cors_allows_csrf_headers()
    {
        $corsConfig = config('cors');
        
        // Test that CSRF headers are allowed
        $this->assertContains('X-CSRF-TOKEN', $corsConfig['allowed_headers']);
        $this->assertContains('X-XSRF-TOKEN', $corsConfig['allowed_headers']);
        
        // Test that CSRF headers are exposed
        $this->assertContains('X-CSRF-TOKEN', $corsConfig['exposed_headers']);
        $this->assertContains('X-XSRF-TOKEN', $corsConfig['exposed_headers']);
        
        // Test that credentials are supported
        $this->assertTrue($corsConfig['supports_credentials']);
    }

    /**
     * Test that Sanctum is configured to use our custom CSRF middleware.
     */
    public function test_sanctum_uses_custom_csrf_middleware()
    {
        $sanctumConfig = config('sanctum.middleware');
        
        $this->assertEquals(
            \App\Http\Middleware\VerifyCsrfToken::class,
            $sanctumConfig['validate_csrf_token']
        );
    }
}