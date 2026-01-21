import { ListParams } from './api.types';

// Category model
export interface Category {
    id: number;
    name: string;
    name_ar?: string;
    slug?: string;
    description?: string;
    parent_id?: number | null;
    parent?: Category;
    children?: Category[];
    is_active: boolean;
    created_at: string;
    updated_at: string;
}

// Product model matching ProductResource
export interface Product {
    id: number;
    name: string;
    name_ar?: string;
    description?: string;
    brand?: string;
    base_price: number;
    price?: number; // Alias for base_price (UI compatibility)
    stock_quantity: number;
    category_id: number;
    category?: Category;
    is_featured: boolean;
    product_variants?: ProductVariant[];
    media?: ProductMedia[];
    status: 'active' | 'inactive';
    created_at: string;
    updated_at: string;
}

// Product variant model
export interface ProductVariant {
    id: number;
    product_id: number;
    size: string;
    color: string;
    sku: string;
    price: number;
    stock: number;
    weight?: number;
    is_available: boolean;
}

// Product media/images
export interface ProductMedia {
    id: number;
    url: string;
    thumbnail_url?: string;
    alt?: string;
    sort_order: number;
}

// Product filters for listing
export interface ProductFilters extends ListParams {
    category_id?: number;
    brand?: string;
    is_featured?: boolean;
    size?: string;
    color?: string;
    price_min?: number;
    price_max?: number;
}

// Create/Update product payload
export interface ProductPayload {
    name: string;
    name_ar?: string;
    description?: string;
    brand?: string;
    base_price: number;
    stock_quantity: number;
    category_id: number;
    is_featured?: boolean;
    status?: 'active' | 'inactive';
}

// Category payload
export interface CategoryPayload {
    name: string;
    name_ar?: string;
    description?: string;
    parent_id?: number | null;
    is_active?: boolean;
}
