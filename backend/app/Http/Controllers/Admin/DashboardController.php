<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Services\ReportService;
use Inertia\Inertia;

class DashboardController extends Controller
{
    protected $reportService;

    public function __construct(ReportService $reportService)
    {
        $this->reportService = $reportService;
    }

    public function index()
    {
        // Get dashboard metrics
        $metrics = $this->reportService->getDashboardMetrics();

        return Inertia::render('Dashboard', [
            'metrics' => $metrics
        ]);
    }
}