import { ListParams } from './api.types';
import { OrderStatus, PaymentStatus } from './dashboard.types';

// User model
export interface User {
    id: number;
    name: string;
    email: string;
    phone?: string;
    role: UserRole;
    avatar_url?: string;
    is_active: boolean;
    email_verified_at?: string;
    created_at: string;
    updated_at: string;
}

export type UserRole = 'admin' | 'manager' | 'customer';

// User filters
export interface UserFilters extends ListParams {
    role?: UserRole;
    is_active?: boolean;
}

// User create/update payload
export interface UserPayload {
    name: string;
    email: string;
    phone?: string;
    password?: string;
    role?: UserRole;
    is_active?: boolean;
}

// Order item
export interface OrderItem {
    id: number;
    product_id: number;
    product_variant_id?: number;
    product_name: string;
    quantity: number;
    price: number;
    total_price: number;
    product?: {
        id: number;
        name: string;
        name_ar?: string;
    };
}

// Order model
export interface Order {
    id: number;
    order_number: string;
    user_id: number;
    user?: User;
    total_amount: number;
    subtotal: number;
    tax?: number;
    shipping_cost?: number;
    discount?: number;
    status: OrderStatus;
    payment_status: PaymentStatus;
    payment_method?: string;
    shipping_address?: Address;
    billing_address?: Address;
    order_items?: OrderItem[];
    notes?: string;
    created_at: string;
    updated_at: string;
}

// Address
export interface Address {
    street: string;
    city: string;
    state?: string;
    country: string;
    postal_code?: string;
    phone?: string;
}

// Order filters
export interface OrderFilters extends ListParams {
    status?: OrderStatus;
    payment_status?: PaymentStatus;
    user_id?: number;
    date_from?: string;
    date_to?: string;
}

// Order status update
export interface OrderStatusUpdate {
    status?: OrderStatus;
    payment_status?: PaymentStatus;
    notes?: string;
}
