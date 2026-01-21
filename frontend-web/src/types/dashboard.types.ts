// Dashboard Stats from /v1/dashboard/stats
export interface DashboardStats {
    total_revenue: number;
    revenue_change: number;
    total_orders: number;
    orders_change: number;
    total_customers: number;
    customers_change: number;
    average_order_value: number;
    average_order_change: number;
}

// Chart data from /v1/dashboard/charts
export interface ChartDataPoint {
    month: string;
    revenue: number;
    orders: number;
}

// Top product from /v1/dashboard/top-products
export interface TopProduct {
    id: number;
    name: string;
    name_ar?: string;
    sales: number;
    revenue: number;
}

// Recent order from /v1/dashboard/recent-orders
export interface RecentOrder {
    id: number;
    order_number: string;
    customer: string;
    total: number;
    status: OrderStatus;
    payment_status: PaymentStatus;
    created_at: string;
}

// Order status enum
export type OrderStatus = 'pending' | 'processing' | 'shipped' | 'delivered' | 'cancelled';
export type PaymentStatus = 'pending' | 'paid' | 'failed' | 'refunded';
