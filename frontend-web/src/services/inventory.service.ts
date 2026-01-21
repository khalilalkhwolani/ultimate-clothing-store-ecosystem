import api from '@/lib/api';
import { ApiResponse, PaginatedResponse } from '@/types/api.types';
import {
    Inventory,
    InventoryFilters,
    RestockPayload,
    DeductStockPayload,
    Coupon,
    CouponFilters,
    CouponPayload,
    Setting,
    SettingPayload
} from '@/types/inventory.types';

/**
 * Inventory Service
 * Handles all inventory/stock management API calls
 */
export const inventoryService = {
    /**
     * Get paginated list of inventory items
     * Endpoint: GET /v1/inventories
     */
    getAll: async (filters?: InventoryFilters): Promise<PaginatedResponse<Inventory>> => {
        const response = await api.get<PaginatedResponse<Inventory>>('/v1/inventories', {
            params: filters
        });
        return response.data;
    },

    /**
     * Get single inventory item by ID
     * Endpoint: GET /v1/inventories/:id
     */
    getById: async (id: number): Promise<Inventory> => {
        const response = await api.get<ApiResponse<Inventory>>(`/v1/inventories/${id}`);
        return response.data.data;
    },

    /**
     * Get low stock items
     * Endpoint: GET /v1/inventories/low-stock
     */
    getLowStock: async (): Promise<Inventory[]> => {
        const response = await api.get<ApiResponse<Inventory[]>>('/v1/inventories/low-stock');
        return response.data.data;
    },

    /**
     * Restock inventory item
     * Endpoint: POST /v1/inventories/:id/restock
     */
    restock: async (id: number, data: RestockPayload): Promise<Inventory> => {
        const response = await api.post<ApiResponse<Inventory>>(`/v1/inventories/${id}/restock`, data);
        return response.data.data;
    },

    /**
     * Deduct stock from inventory
     * Endpoint: POST /v1/inventories/:id/deduct
     */
    deductStock: async (id: number, data: DeductStockPayload): Promise<Inventory> => {
        const response = await api.post<ApiResponse<Inventory>>(`/v1/inventories/${id}/deduct`, data);
        return response.data.data;
    },
};

/**
 * Coupon Service
 * Handles all coupon/discount API calls
 */
export const couponService = {
    /**
     * Get all coupons
     * Endpoint: GET /v1/coupons
     */
    getAll: async (filters?: CouponFilters): Promise<Coupon[]> => {
        const response = await api.get<ApiResponse<Coupon[]>>('/v1/coupons', {
            params: filters
        });
        return response.data.data;
    },

    /**
     * Get single coupon by ID
     * Endpoint: GET /v1/coupons/:id
     */
    getById: async (id: number): Promise<Coupon> => {
        const response = await api.get<ApiResponse<Coupon>>(`/v1/coupons/${id}`);
        return response.data.data;
    },

    /**
     * Create new coupon
     * Endpoint: POST /v1/coupons
     */
    create: async (data: CouponPayload): Promise<Coupon> => {
        const response = await api.post<ApiResponse<Coupon>>('/v1/coupons', data);
        return response.data.data;
    },

    /**
     * Update existing coupon
     * Endpoint: PUT /v1/coupons/:id
     */
    update: async (id: number, data: Partial<CouponPayload>): Promise<Coupon> => {
        const response = await api.put<ApiResponse<Coupon>>(`/v1/coupons/${id}`, data);
        return response.data.data;
    },

    /**
     * Delete coupon
     * Endpoint: DELETE /v1/coupons/:id
     */
    delete: async (id: number): Promise<void> => {
        await api.delete(`/v1/coupons/${id}`);
    },
};

/**
 * Settings Service
 * Handles all system settings API calls
 */
export const settingsService = {
    /**
     * Get all settings
     * Endpoint: GET /v1/settings
     */
    getAll: async (): Promise<Setting[]> => {
        const response = await api.get<ApiResponse<Setting[]>>('/v1/settings');
        return response.data.data;
    },

    /**
     * Get single setting by ID
     * Endpoint: GET /v1/settings/:id
     */
    getById: async (id: number): Promise<Setting> => {
        const response = await api.get<ApiResponse<Setting>>(`/v1/settings/${id}`);
        return response.data.data;
    },

    /**
     * Create new setting
     * Endpoint: POST /v1/settings
     */
    create: async (data: SettingPayload): Promise<Setting> => {
        const response = await api.post<ApiResponse<Setting>>('/v1/settings', data);
        return response.data.data;
    },

    /**
     * Update existing setting
     * Endpoint: PUT /v1/settings/:id
     */
    update: async (id: number, data: Partial<SettingPayload>): Promise<Setting> => {
        const response = await api.put<ApiResponse<Setting>>(`/v1/settings/${id}`, data);
        return response.data.data;
    },

    /**
     * Delete setting
     * Endpoint: DELETE /v1/settings/:id
     */
    delete: async (id: number): Promise<void> => {
        await api.delete(`/v1/settings/${id}`);
    },
};

export default inventoryService;
