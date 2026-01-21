<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Services\ReportService;
use Illuminate\Http\Request;

class DashboardController extends Controller
{
    protected $reportService;

    public function __construct(ReportService $reportService)
    {
        $this->reportService = $reportService;
    }

    public function stats()
    {
        $metrics = $this->reportService->getDashboardMetrics();

        return response()->json([
            'success' => true,
            'data' => $metrics,
        ]);
    }

    public function charts()
    {
        $revenueData = $this->reportService->getRevenueChartData();

        return response()->json([
            'success' => true,
            'data' => $revenueData,
        ]);
    }

    public function topProducts()
    {
        $topProducts = $this->reportService->getTopProducts();

        return response()->json([
            'success' => true,
            'data' => $topProducts,
        ]);
    }

    public function recentOrders()
    {
        $recentOrders = $this->reportService->getRecentOrders();

        return response()->json([
            'success' => true,
            'data' => $recentOrders,
        ]);
    }
}