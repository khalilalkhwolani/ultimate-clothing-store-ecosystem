<?php

use Illuminate\Contracts\Console\Kernel;
use App\Models\Order;
use App\Http\Resources\OrderResource;

require __DIR__ . '/vendor/autoload.php';
$app = require __DIR__ . '/bootstrap/app.php';
$app->make(Kernel::class)->bootstrap();

try {
    echo "--- Starting Order Debug ---\n";

    $count = Order::count();
    echo "Total Orders in DB: $count\n";

    if ($count === 0) {
        echo "No orders to test.\n";
        exit;
    }

    $orders = Order::take(1)->get();
    foreach ($orders as $order) {
        echo "Testing Order ID: " . $order->id . "\n";

        // Test 1: Check if order_number attribute exists
        echo "Order Number Attribute: " . ($order->order_number ?? 'NULL') . "\n";

        // Test 2: Try to resolve Resource
        echo "Attempting to resolve OrderResource...\n";
        $resource = new OrderResource($order);
        $data = $resource->resolve();

        echo "Resource Resolved Successfully.\n";
        print_r($data);
    }
} catch (\Throwable $e) {
    echo "\n!!! EXCEPTION CAUGHT !!!\n";
    echo "Message: " . $e->getMessage() . "\n";
    echo "File: " . $e->getFile() . "\n";
    echo "Line: " . $e->getLine() . "\n";
}
