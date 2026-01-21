<?php

use App\Services\ReportService;
use Illuminate\Support\Facades\Log;

require __DIR__ . '/vendor/autoload.php';

$app = require_once __DIR__ . '/bootstrap/app.php';

$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

echo "Starting ReportService Test...\n";

try {
    $service = new ReportService();

    echo "Testing getDashboardMetrics...\n";
    $metrics = $service->getDashboardMetrics();
    echo "Metrics: " . json_encode($metrics) . "\n";

    echo "Testing getRevenueChartData...\n";
    $chart = $service->getRevenueChartData();
    echo "Chart Data: " . count($chart) . " items\n";

    echo "Testing getTopProducts...\n";
    $topProducts = $service->getTopProducts();
    echo "Top Products: " . json_encode($topProducts) . "\n";

    echo "Testing getRecentOrders...\n";
    $recentOrders = $service->getRecentOrders();
    echo "Recent Orders: " . json_encode($recentOrders) . "\n";

    echo "Testing getAnalyticsData...\n";
    $analytics = $service->getAnalyticsData();
    echo "Analytics: " . json_encode($analytics) . "\n";

    echo "All tests passed!\n";
} catch (\Throwable $e) {
    echo "ERROR: " . $e->getMessage() . "\n";
    echo "File: " . $e->getFile() . "\n";
    echo "Line: " . $e->getLine() . "\n";
    echo "Trace:\n" . $e->getTraceAsString() . "\n";
}
