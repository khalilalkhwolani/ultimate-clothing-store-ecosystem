<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\RevenueChartRequest;
use App\Services\ReportService;
use Illuminate\Http\Request;

class ReportsController extends Controller
{
    protected $reportService;

    public function __construct(ReportService $reportService)
    {
        $this->reportService = $reportService;
    }

    public function analytics()
    {
        $analytics = $this->reportService->getAnalyticsData();

        return response()->json([
            'success' => true,
            'data' => $analytics,
        ]);
    }

    public function revenueChart(RevenueChartRequest $request)
    {
        $months = $request->get('months', 12);
        $data = $this->reportService->getRevenueChartData($months);

        return response()->json([
            'success' => true,
            'data' => $data,
        ]);
    }

    public function customerStats()
    {
        $stats = $this->reportService->getCustomerStats();

        return response()->json([
            'success' => true,
            'data' => $stats,
        ]);
    }
}