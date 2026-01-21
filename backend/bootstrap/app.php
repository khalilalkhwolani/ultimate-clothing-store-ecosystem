<?php

use Illuminate\Foundation\Application;
use Illuminate\Foundation\Configuration\Exceptions;
use Illuminate\Foundation\Configuration\Middleware;

return Application::configure(basePath: dirname(__DIR__))
    ->withRouting(
        web: __DIR__.'/../routes/web.php',
        api: __DIR__.'/../routes/api.php',
        commands: __DIR__.'/../routes/console.php',
        health: '/up',
    )
    ->withMiddleware(function (Middleware $middleware) {
        $middleware->web(append: \App\Http\Middleware\HandleInertiaRequests::class);
        
        // Configure CSRF token validation with custom middleware
        $middleware->validateCsrfTokens(except: [
            // API routes use token-based authentication and don't need CSRF protection
            'api/*',
        ]);
        
        $middleware->alias([
            'admin' => \App\Http\Middleware\AdminMiddleware::class,
            'throttle.auth' => \Illuminate\Routing\Middleware\ThrottleRequests::class.':10,1',
            'throttle.upload' => \Illuminate\Routing\Middleware\ThrottleRequests::class.':5,1',
            'throttle.read' => \Illuminate\Routing\Middleware\ThrottleRequests::class.':100,1',
            'throttle.write' => \Illuminate\Routing\Middleware\ThrottleRequests::class.':30,1',
            'throttle.dashboard' => \Illuminate\Routing\Middleware\ThrottleRequests::class.':50,1',
            'throttle.admin' => \Illuminate\Routing\Middleware\ThrottleRequests::class.':20,1',
            'throttle.cart' => \Illuminate\Routing\Middleware\ThrottleRequests::class.':50,1',
        ]);
    })
    ->withExceptions(function (Exceptions $exceptions) {
        //
    })->create();
