<?php

use Illuminate\Contracts\Console\Kernel;
use App\Models\Order;

require __DIR__ . '/vendor/autoload.php';
$app = require __DIR__ . '/bootstrap/app.php';
$app->make(Kernel::class)->bootstrap();

echo "--- Backfilling Order Numbers ---\n";

$orders = Order::whereNull('order_number')->get();

if ($orders->isEmpty()) {
    echo "No orders found with missing order numbers.\n";
    exit;
}

echo "Found " . $orders->count() . " orders to update.\n";

foreach ($orders as $order) {
    $orderNumber = 'ORD-' . strtoupper(uniqid());
    $order->update(['order_number' => $orderNumber]);
    echo "Updated Order ID {$order->id} with Number: {$orderNumber}\n";
}

echo "--- Backfill Complete ---\n";
