import api from '@/lib/api';
import { ApiResponse, PaginatedResponse } from '@/types/api.types';
import { User, UserFilters, UserPayload } from '@/types/order.types';

/**
 * User Service
 * Handles all user management API calls (admin only)
 */
export const userService = {
    /**
     * Get paginated list of users
     * Endpoint: GET /v1/users
     */
    getAll: async (filters?: UserFilters): Promise<PaginatedResponse<User>> => {
        const response = await api.get<PaginatedResponse<User>>('/v1/users', {
            params: filters
        });
        return response.data;
    },

    /**
     * Get single user by ID
     * Endpoint: GET /v1/users/:id
     */
    getById: async (id: number): Promise<User> => {
        const response = await api.get<ApiResponse<User>>(`/v1/users/${id}`);
        return response.data.data;
    },

    /**
     * Create new user
     * Endpoint: POST /v1/users
     */
    create: async (data: UserPayload): Promise<User> => {
        const response = await api.post<ApiResponse<User>>('/v1/users', data);
        return response.data.data;
    },

    /**
     * Update existing user
     * Endpoint: PUT /v1/users/:id
     */
    update: async (id: number, data: Partial<UserPayload>): Promise<User> => {
        const response = await api.put<ApiResponse<User>>(`/v1/users/${id}`, data);
        return response.data.data;
    },

    /**
     * Delete user
     * Endpoint: DELETE /v1/users/:id
     */
    delete: async (id: number): Promise<void> => {
        await api.delete(`/v1/users/${id}`);
    },
};

export default userService;
