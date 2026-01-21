// Standard API response wrapper
export interface ApiResponse<T> {
    success?: boolean;
    message?: string;
    data: T;
}

// Paginated response matching Laravel pagination
export interface PaginatedResponse<T> {
    data: T[];
    meta: {
        current_page: number;
        last_page: number;
        per_page: number;
        total: number;
    };
}

// Error response from backend
export interface ApiError {
    message: string;
    errors?: Record<string, string[]>;
}

// Query params for listing endpoints
export interface ListParams {
    page?: number;
    per_page?: number;
    sort_by?: string;
    sort_order?: 'asc' | 'desc';
    search?: string;
}
