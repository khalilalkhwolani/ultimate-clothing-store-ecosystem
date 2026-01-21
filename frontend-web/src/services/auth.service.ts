import api from '@/lib/api';
import { ApiResponse } from '@/types/api.types';

// Auth response types
interface LoginResponse {
    access_token: string;
    refresh_token: string;
    token_type: string;
    expires_in: number;
    user: AuthUser;
}

interface AuthUser {
    id: number;
    name: string;
    email: string;
    role: string;
}

interface LoginPayload {
    email: string;
    password: string;
}

interface RegisterPayload {
    name: string;
    email: string;
    password: string;
    password_confirmation: string;
}

// Token storage keys
const ACCESS_TOKEN_KEY = 'access_token';
const REFRESH_TOKEN_KEY = 'refresh_token';

/**
 * Auth Service
 * Handles authentication, registration, and profile management
 */
export const authService = {
    /**
     * Login user
     * Endpoint: POST /login
     */
    login: async (data: LoginPayload): Promise<LoginResponse> => {
        const response = await api.post<{ data: LoginResponse }>('/login', data);

        // Store tokens
        localStorage.setItem(ACCESS_TOKEN_KEY, response.data.data.access_token);
        localStorage.setItem(REFRESH_TOKEN_KEY, response.data.data.refresh_token);

        return response.data.data;
    },

    /**
     * Register new user
     * Endpoint: POST /register
     */
    register: async (data: RegisterPayload): Promise<LoginResponse> => {
        const response = await api.post<{ data: LoginResponse }>('/register', data);

        // Store tokens
        localStorage.setItem(ACCESS_TOKEN_KEY, response.data.data.access_token);
        localStorage.setItem(REFRESH_TOKEN_KEY, response.data.data.refresh_token);

        return response.data.data;
    },

    /**
     * Logout user
     * Endpoint: POST /logout
     */
    logout: async (): Promise<void> => {
        try {
            await api.post('/logout');
        } finally {
            // Always clear tokens
            localStorage.removeItem(ACCESS_TOKEN_KEY);
            localStorage.removeItem(REFRESH_TOKEN_KEY);
        }
    },

    /**
     * Get current user profile
     * Endpoint: GET /profile
     */
    getProfile: async (): Promise<AuthUser> => {
        const response = await api.get<ApiResponse<AuthUser>>('/profile');
        return response.data.data;
    },

    /**
     * Update current user profile
     * Endpoint: PUT /profile
     */
    updateProfile: async (data: Partial<AuthUser>): Promise<AuthUser> => {
        const response = await api.put<ApiResponse<AuthUser>>('/profile', data);
        return response.data.data;
    },

    /**
     * Reset password request
     * Endpoint: POST /reset-password
     */
    resetPassword: async (email: string): Promise<void> => {
        await api.post('/reset-password', { email });
    },

    /**
     * Check if user is authenticated
     */
    isAuthenticated: (): boolean => {
        return !!localStorage.getItem(ACCESS_TOKEN_KEY);
    },

    /**
     * Get stored access token
     */
    getToken: (): string | null => {
        return localStorage.getItem(ACCESS_TOKEN_KEY);
    },
};

export default authService;
