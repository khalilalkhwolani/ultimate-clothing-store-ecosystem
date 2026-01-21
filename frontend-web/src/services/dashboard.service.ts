import api from '@/lib/api';
import { ApiResponse } from '@/types/api.types';
import {
    DashboardStats,
    ChartDataPoint,
    TopProduct,
    RecentOrder
} from '@/types/dashboard.types';

// بيانات ثابتة كـ fallback
const mockStats: DashboardStats = {
    total_revenue: 125000,
    revenue_change: 12.5,
    total_orders: 1250,
    orders_change: 8.3,
    total_customers: 850,
    customers_change: 15.2,
    average_order_value: 100,
    average_order_change: 5.7
};

const mockCharts: ChartDataPoint[] = [
    { month: 'يناير', revenue: 15000 },
    { month: 'فبراير', revenue: 18000 },
    { month: 'مارس', revenue: 22000 },
    { month: 'أبريل', revenue: 19000 },
    { month: 'مايو', revenue: 25000 },
    { month: 'يونيو', revenue: 28000 },
];

const mockTopProducts: TopProduct[] = [
    { name: 'قميص أزرق', sales: 45, revenue: 2250 },
    { name: 'فستان أحمر', sales: 38, revenue: 3420 },
    { name: 'بنطلون جينز', sales: 32, revenue: 2160 },
    { name: 'جاكيت شتوي', sales: 28, revenue: 5600 },
    { name: 'حذاء رياضي', sales: 25, revenue: 2500 },
];

const mockRecentOrders: RecentOrder[] = [
    {
        id: 1,
        order_number: '#ORD-001',
        customer: 'أحمد محمد',
        total: 89.99,
        status: 'delivered',
        created_at: '2026-01-21'
    },
    {
        id: 2,
        order_number: '#ORD-002',
        customer: 'فاطمة علي',
        total: 156.50,
        status: 'processing',
        created_at: '2026-01-21'
    },
    {
        id: 3,
        order_number: '#ORD-003',
        customer: 'محمد سالم',
        total: 234.00,
        status: 'shipped',
        created_at: '2026-01-20'
    },
    {
        id: 4,
        order_number: '#ORD-004',
        customer: 'سارة أحمد',
        total: 67.25,
        status: 'pending',
        created_at: '2026-01-20'
    },
];

/**
 * Dashboard Service
 * Handles all dashboard-related API calls with fallback to mock data
 */
export const dashboardService = {
    /**
     * Get dashboard statistics (KPIs)
     * Endpoint: GET /v1/dashboard/stats
     */
    getStats: async (): Promise<DashboardStats> => {
        try {
            const response = await api.get<ApiResponse<DashboardStats>>('/v1/dashboard/stats');
            return response.data.data;
        } catch (error) {
            console.warn('API call failed, using mock data:', error);
            return mockStats;
        }
    },

    /**
     * Get revenue chart data
     * Endpoint: GET /v1/dashboard/charts
     */
    getCharts: async (): Promise<ChartDataPoint[]> => {
        try {
            const response = await api.get<ApiResponse<ChartDataPoint[]>>('/v1/dashboard/charts');
            return response.data.data;
        } catch (error) {
            console.warn('API call failed, using mock data:', error);
            return mockCharts;
        }
    },

    /**
     * Get top selling products
     * Endpoint: GET /v1/dashboard/top-products
     */
    getTopProducts: async (): Promise<TopProduct[]> => {
        try {
            const response = await api.get<ApiResponse<TopProduct[]>>('/v1/dashboard/top-products');
            return response.data.data;
        } catch (error) {
            console.warn('API call failed, using mock data:', error);
            return mockTopProducts;
        }
    },

    /**
     * Get recent orders
     * Endpoint: GET /v1/dashboard/recent-orders
     */
    getRecentOrders: async (): Promise<RecentOrder[]> => {
        try {
            const response = await api.get<ApiResponse<RecentOrder[]>>('/v1/dashboard/recent-orders');
            return response.data.data;
        } catch (error) {
            console.warn('API call failed, using mock data:', error);
            return mockRecentOrders;
        }
    },

    /**
     * Fetch all dashboard data at once
     * Used for initial dashboard load
     */
    getAllData: async () => {
        const [stats, charts, topProducts, recentOrders] = await Promise.all([
            dashboardService.getStats(),
            dashboardService.getCharts(),
            dashboardService.getTopProducts(),
            dashboardService.getRecentOrders(),
        ]);

        return { stats, charts, topProducts, recentOrders };
    },
};

export default dashboardService;
