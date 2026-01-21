import api from '@/lib/api';
import { ApiResponse, PaginatedResponse } from '@/types/api.types';
import {
    Order,
    OrderFilters,
    OrderStatusUpdate
} from '@/types/order.types';

// بيانات ثابتة للطلبات
const mockOrders: Order[] = [
    {
        id: 1,
        order_number: '#ORD-001',
        customer_id: 1,
        customer_name: 'أحمد محمد علي',
        customer_email: 'ahmed@example.com',
        total_amount: 89.99,
        status: 'delivered',
        payment_status: 'paid',
        shipping_address: 'الرياض، المملكة العربية السعودية',
        created_at: '2026-01-21',
        updated_at: '2026-01-21',
        items: [
            {
                id: 1,
                product_id: 1,
                product_name: 'قميص أزرق',
                quantity: 1,
                price: 45.99,
                total: 45.99
            },
            {
                id: 2,
                product_id: 3,
                product_name: 'بنطلون جينز',
                quantity: 1,
                price: 44.00,
                total: 44.00
            }
        ]
    },
    {
        id: 2,
        order_number: '#ORD-002',
        customer_id: 2,
        customer_name: 'فاطمة علي حسن',
        customer_email: 'fatima@example.com',
        total_amount: 156.50,
        status: 'processing',
        payment_status: 'paid',
        shipping_address: 'جدة، المملكة العربية السعودية',
        created_at: '2026-01-21',
        updated_at: '2026-01-21',
        items: [
            {
                id: 3,
                product_id: 2,
                product_name: 'فستان أحمر',
                quantity: 1,
                price: 89.99,
                total: 89.99
            }
        ]
    },
    {
        id: 3,
        order_number: '#ORD-003',
        customer_id: 3,
        customer_name: 'محمد سالم أحمد',
        customer_email: 'mohammed@example.com',
        total_amount: 234.00,
        status: 'shipped',
        payment_status: 'paid',
        shipping_address: 'الدمام، المملكة العربية السعودية',
        created_at: '2026-01-20',
        updated_at: '2026-01-21',
        items: [
            {
                id: 4,
                product_id: 1,
                product_name: 'جاكيت شتوي',
                quantity: 1,
                price: 150.00,
                total: 150.00
            },
            {
                id: 5,
                product_id: 2,
                product_name: 'قفازات',
                quantity: 2,
                price: 42.00,
                total: 84.00
            }
        ]
    }
];

/**
 * Order Service
 * Handles all order-related API calls with fallback to mock data
 */
export const orderService = {
    /**
     * Get paginated list of orders with filters
     * Endpoint: GET /v1/orders
     */
    getAll: async (filters?: OrderFilters): Promise<PaginatedResponse<Order>> => {
        try {
            const response = await api.get<PaginatedResponse<Order>>('/v1/orders', {
                params: filters
            });
            return response.data;
        } catch (error) {
            console.warn('API call failed, using mock data:', error);
            return {
                data: mockOrders,
                current_page: 1,
                last_page: 1,
                per_page: 10,
                total: mockOrders.length,
                from: 1,
                to: mockOrders.length
            };
        }
    },

    /**
     * Get single order by ID with all details
     * Endpoint: GET /v1/orders/:id
     */
    getById: async (id: number): Promise<Order> => {
        try {
            const response = await api.get<ApiResponse<Order>>(`/v1/orders/${id}`);
            return response.data.data;
        } catch (error) {
            console.warn('API call failed, using mock data:', error);
            const order = mockOrders.find(o => o.id === id);
            if (!order) throw new Error('Order not found');
            return order;
        }
    },

    /**
     * Update order
     * Endpoint: PUT /v1/orders/:id
     */
    update: async (id: number, data: Partial<Order>): Promise<Order> => {
        try {
            const response = await api.put<ApiResponse<Order>>(`/v1/orders/${id}`, data);
            return response.data.data;
        } catch (error) {
            console.warn('API call failed, using mock data:', error);
            const order = mockOrders.find(o => o.id === id);
            if (!order) throw new Error('Order not found');
            return { ...order, ...data, updated_at: new Date().toISOString().split('T')[0] };
        }
    },

    /**
     * Track order
     * Endpoint: GET /v1/orders/:id/track
     */
    track: async (id: number): Promise<unknown> => {
        try {
            const response = await api.get(`/v1/orders/${id}/track`);
            return response.data;
        } catch (error) {
            console.warn('API call failed, using mock data:', error);
            return {
                order_id: id,
                status: 'shipped',
                tracking_number: 'TRK123456789',
                estimated_delivery: '2026-01-25',
                tracking_history: [
                    { status: 'pending', date: '2026-01-20', description: 'تم استلام الطلب' },
                    { status: 'processing', date: '2026-01-21', description: 'جاري تحضير الطلب' },
                    { status: 'shipped', date: '2026-01-22', description: 'تم شحن الطلب' }
                ]
            };
        }
    },

    /**
     * Delete order (admin only)
     * Endpoint: DELETE /v1/orders/:id
     */
    delete: async (id: number): Promise<void> => {
        try {
            await api.delete(`/v1/orders/${id}`);
        } catch (error) {
            console.warn('API call failed, simulating delete:', error);
            // في البيانات الوهمية، نتجاهل الحذف
        }
    },
};

export default orderService;
