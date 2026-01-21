<?php

namespace App\Services;

use App\Models\Order;
use App\Models\Product;
use App\Models\User;
use Carbon\Carbon;
use Illuminate\Support\Facades\Cache;

class ReportService
{
    public function getDashboardMetrics()
    {
        return Cache::remember('dashboard_metrics_v2', 300, function () {
            $now = Carbon::now();
            $lastMonth = $now->copy()->subMonth();

            // Total revenue (excluding cancelled)
            $totalRevenue = Order::where('status', '!=', 'cancelled')->sum('total_amount');

            // Revenue change (compared to last month)
            $currentMonthRevenue = Order::where('status', '!=', 'cancelled')
                ->whereBetween('created_at', [$now->startOfMonth(), $now->endOfMonth()])
                ->sum('total_amount');
            $lastMonthRevenue = Order::where('status', '!=', 'cancelled')
                ->whereBetween('created_at', [$lastMonth->startOfMonth(), $lastMonth->endOfMonth()])
                ->sum('total_amount');
            $revenueChange = $lastMonthRevenue > 0 ? (($currentMonthRevenue - $lastMonthRevenue) / $lastMonthRevenue) * 100 : 0;

            // Total orders
            $totalOrders = Order::count();

            // Orders change
            $currentMonthOrders = Order::whereBetween('created_at', [$now->startOfMonth(), $now->endOfMonth()])->count();
            $lastMonthOrders = Order::whereBetween('created_at', [$lastMonth->startOfMonth(), $lastMonth->endOfMonth()])->count();
            $ordersChange = $lastMonthOrders > 0 ? (($currentMonthOrders - $lastMonthOrders) / $lastMonthOrders) * 100 : 0;

            // Total customers
            $totalCustomers = User::where('role', 'customer')->count();

            // Customers change
            $currentMonthCustomers = User::where('role', 'customer')
                ->whereBetween('created_at', [$now->startOfMonth(), $now->endOfMonth()])->count();
            $lastMonthCustomers = User::where('role', 'customer')
                ->whereBetween('created_at', [$lastMonth->startOfMonth(), $lastMonth->endOfMonth()])->count();
            $customersChange = $lastMonthCustomers > 0 ? (($currentMonthCustomers - $lastMonthCustomers) / $lastMonthCustomers) * 100 : 0;

            // Average order value
            $averageOrderValue = $totalOrders > 0 ? $totalRevenue / $totalOrders : 0;

            // Average order change (simplified calculation)
            $currentMonthAvg = $currentMonthOrders > 0 ? $currentMonthRevenue / $currentMonthOrders : 0;
            $lastMonthAvg = $lastMonthOrders > 0 ? $lastMonthRevenue / $lastMonthOrders : 0;
            $avgOrderChange = $lastMonthAvg > 0 ? (($currentMonthAvg - $lastMonthAvg) / $lastMonthAvg) * 100 : 0;

            return [
                'total_revenue' => $totalRevenue,
                'revenue_change' => round($revenueChange, 1),
                'total_orders' => $totalOrders,
                'orders_change' => round($ordersChange, 1),
                'total_customers' => $totalCustomers,
                'customers_change' => round($customersChange, 1),
                'average_order_value' => round($averageOrderValue, 2),
                'average_order_change' => round($avgOrderChange, 1),
            ];
        });
    }

    public function getRevenueChartData($months = 6)
    {
        return Cache::remember('dashboard_charts_v2_' . $months, 3600, function () use ($months) {
            $data = [];
            $now = Carbon::now();

            for ($i = $months - 1; $i >= 0; $i--) {
                $date = $now->copy()->subMonths($i);
                $startOfMonth = $date->startOfMonth();
                $endOfMonth = $date->endOfMonth();

                $revenue = Order::where('status', '!=', 'cancelled')
                    ->whereBetween('created_at', [$startOfMonth, $endOfMonth])
                    ->sum('total_amount');

                $orders = Order::whereBetween('created_at', [$startOfMonth, $endOfMonth])->count();

                $data[] = [
                    'month' => $date->format('M Y'),
                    'revenue' => (float) $revenue,
                    'orders' => $orders,
                ];
            }

            return $data;
        });
    }

    public function getTopProducts($limit = 5)
    {
        return Cache::remember('dashboard_top_products_v2_' . $limit, 300, function () use ($limit) {
            return Order::join('order_items', 'orders.id', '=', 'order_items.order_id')
                ->join('product_variants', 'order_items.product_variant_id', '=', 'product_variants.id')
                ->join('products', 'product_variants.product_id', '=', 'products.id')
                ->where('orders.status', '!=', 'cancelled')
                ->selectRaw('products.name, SUM(order_items.quantity) as sales, SUM(order_items.quantity * order_items.price) as revenue')
                ->groupBy('products.id', 'products.name')
                ->orderBy('sales', 'desc')
                ->limit($limit)
                ->get()
                ->map(function ($item) {
                    return [
                        'name' => $item->name,
                        'sales' => (int) $item->sales,
                        'revenue' => (float) $item->revenue,
                    ];
                });
        });
    }

    public function getRecentOrders($limit = 5)
    {
        return Cache::remember('dashboard_recent_orders_v2_' . $limit, 300, function () use ($limit) {
            return Order::with('user')
                ->orderBy('created_at', 'desc')
                ->limit($limit)
                ->get()
                ->map(function ($order) {
                    return [
                        'id' => $order->id,
                        'order_number' => $order->order_number,
                        'customer' => $order->user->name ?? 'Unknown',
                        'total' => (float) $order->total_amount,
                        'status' => $order->status,
                        'created_at' => $order->created_at->format('Y-m-d H:i:s'),
                    ];
                });
        });
    }

    public function getCustomerStats()
    {
        $totalCustomers = User::where('role', 'customer')->count();
        $activeCustomers = User::where('role', 'customer')
            ->whereHas('orders', function ($query) {
                $query->where('created_at', '>=', Carbon::now()->subDays(30));
            })->count();

        $newCustomersThisMonth = User::where('role', 'customer')
            ->whereBetween('created_at', [Carbon::now()->startOfMonth(), Carbon::now()->endOfMonth()])
            ->count();

        return [
            'total_customers' => $totalCustomers,
            'active_customers' => $activeCustomers,
            'new_customers_this_month' => $newCustomersThisMonth,
        ];
    }

    public function getAnalyticsData()
    {
        $now = Carbon::now();
        $lastMonth = $now->copy()->subMonth();

        // Revenue analytics
        $currentMonthRevenue = Order::where('status', 'delivered')
            ->whereBetween('created_at', [$now->startOfMonth(), $now->endOfMonth()])
            ->sum('total_amount');

        $lastMonthRevenue = Order::where('status', 'delivered')
            ->whereBetween('created_at', [$lastMonth->startOfMonth(), $lastMonth->endOfMonth()])
            ->sum('total_amount');

        // Order analytics
        $currentMonthOrders = Order::whereBetween('created_at', [$now->startOfMonth(), $now->endOfMonth()])->count();
        $lastMonthOrders = Order::whereBetween('created_at', [$lastMonth->startOfMonth(), $lastMonth->endOfMonth()])->count();

        // Customer analytics
        $currentMonthCustomers = User::where('role', 'customer')
            ->whereBetween('created_at', [$now->startOfMonth(), $now->endOfMonth()])->count();

        // Product performance
        $totalProducts = Product::count();
        $activeProducts = Product::whereHas('productVariants.orderItems')->count();

        return [
            'revenue' => [
                'current_month' => (float) $currentMonthRevenue,
                'last_month' => (float) $lastMonthRevenue,
                'growth' => $lastMonthRevenue > 0 ? round((($currentMonthRevenue - $lastMonthRevenue) / $lastMonthRevenue) * 100, 1) : 0,
            ],
            'orders' => [
                'current_month' => $currentMonthOrders,
                'last_month' => $lastMonthOrders,
                'growth' => $lastMonthOrders > 0 ? round((($currentMonthOrders - $lastMonthOrders) / $lastMonthOrders) * 100, 1) : 0,
            ],
            'customers' => [
                'new_this_month' => $currentMonthCustomers,
            ],
            'products' => [
                'total' => $totalProducts,
                'active' => $activeProducts,
            ],
        ];
    }
}
