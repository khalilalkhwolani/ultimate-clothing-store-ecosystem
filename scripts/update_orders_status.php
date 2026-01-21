<?php

use Illuminate\Contracts\Console\Kernel;
use App\Models\Order;

require __DIR__ . '/vendor/autoload.php';
$app = require __DIR__ . '/bootstrap/app.php';
$app->make(Kernel::class)->bootstrap();

echo "--- Updating Order Statuses ---\n";

// Update all orders to 'delivered' to test reports
$updated = Order::query()->update(['status' => 'delivered']);

echo "Updated $updated orders to 'delivered' status.\n";
