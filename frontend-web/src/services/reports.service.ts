import api from '@/lib/api';
import { ApiResponse } from '@/types/api.types';
import { ChartDataPoint } from '@/types/dashboard.types';

// Analytics data types
interface AnalyticsData {
    total_sales: number;
    total_orders: number;
    total_customers: number;
    conversion_rate: number;
    average_order_value: number;
    top_categories: { name: string; sales: number }[];
    top_products: { name: string; sales: number }[];
}

interface CustomerStats {
    new_customers: number;
    returning_customers: number;
    churn_rate: number;
    lifetime_value: number;
}

/**
 * Reports Service
 * Handles all analytics and reporting API calls
 */
export const reportsService = {
    /**
     * Get analytics overview
     * Endpoint: GET /v1/reports/analytics
     */
    getAnalytics: async (): Promise<AnalyticsData> => {
        const response = await api.get<ApiResponse<AnalyticsData>>('/v1/reports/analytics');
        return response.data.data;
    },

    /**
     * Get revenue chart data
     * Endpoint: GET /v1/reports/revenue-chart
     */
    getRevenueChart: async (): Promise<ChartDataPoint[]> => {
        const response = await api.get<ApiResponse<ChartDataPoint[]>>('/v1/reports/revenue-chart');
        return response.data.data;
    },

    /**
     * Get customer statistics
     * Endpoint: GET /v1/reports/customer-stats
     */
    getCustomerStats: async (): Promise<CustomerStats> => {
        const response = await api.get<ApiResponse<CustomerStats>>('/v1/reports/customer-stats');
        return response.data.data;
    },
};

export default reportsService;
