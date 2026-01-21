import { ListParams } from './api.types';

// Inventory model matching InventoryController
export interface Inventory {
    id: number;
    product_id: number;
    product_variant_id?: number;
    quantity: number;
    reserved_quantity: number;
    available_quantity: number;
    low_stock_threshold: number;
    location?: string;
    product?: {
        id: number;
        name: string;
        name_ar?: string;
    };
    created_at: string;
    updated_at: string;
}

// Inventory filters
export interface InventoryFilters extends ListParams {
    product_id?: number;
    low_stock?: boolean;
}

// Restock payload
export interface RestockPayload {
    quantity: number;
    notes?: string;
}

// Deduct stock payload
export interface DeductStockPayload {
    quantity: number;
    reason?: string;
}

// Coupon model matching CouponController
export interface Coupon {
    id: number;
    code: string;
    type: 'percentage' | 'fixed';
    value: number;
    min_order_value?: number;
    max_uses?: number;
    used_count: number;
    starts_at?: string;
    expires_at?: string;
    is_active: boolean;
    created_at: string;
    updated_at: string;
}

// Coupon filters
export interface CouponFilters extends ListParams {
    is_active?: boolean;
    type?: 'percentage' | 'fixed';
}

// Coupon payload
export interface CouponPayload {
    code: string;
    type: 'percentage' | 'fixed';
    value: number;
    min_order_value?: number;
    max_uses?: number;
    starts_at?: string;
    expires_at?: string;
    is_active?: boolean;
}

// Settings model
export interface Setting {
    id: number;
    key: string;
    value: string;
    group?: string;
    type?: 'string' | 'number' | 'boolean' | 'json';
    created_at: string;
    updated_at: string;
}

// Settings payload
export interface SettingPayload {
    key: string;
    value: string;
    group?: string;
    type?: 'string' | 'number' | 'boolean' | 'json';
}
