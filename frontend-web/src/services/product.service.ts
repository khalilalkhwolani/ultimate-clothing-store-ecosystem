import api from '@/lib/api';
import { ApiResponse, PaginatedResponse } from '@/types/api.types';
import {
    Product,
    ProductFilters,
    ProductPayload,
    Category,
    CategoryPayload
} from '@/types/product.types';

// بيانات ثابتة للمنتجات
const mockProducts: Product[] = [
    {
        id: 1,
        name: 'قميص أزرق كلاسيكي',
        description: 'قميص أزرق أنيق مناسب للمناسبات الرسمية',
        price: 45.99,
        stock: 25,
        category_id: 1,
        category: { id: 1, name: 'قمصان', description: 'قمصان رجالية' },
        status: 'active',
        image_url: 'https://via.placeholder.com/300x200/007bff/ffffff?text=قميص+أزرق',
        created_at: '2026-01-20',
        updated_at: '2026-01-21'
    },
    {
        id: 2,
        name: 'فستان أحمر أنيق',
        description: 'فستان أحمر جميل مناسب للحفلات والمناسبات',
        price: 89.99,
        stock: 15,
        category_id: 2,
        category: { id: 2, name: 'فساتين', description: 'فساتين نسائية' },
        status: 'active',
        image_url: 'https://via.placeholder.com/300x200/28a745/ffffff?text=فستان+أحمر',
        created_at: '2026-01-19',
        updated_at: '2026-01-21'
    },
    {
        id: 3,
        name: 'بنطلون جينز كلاسيكي',
        description: 'بنطلون جينز مريح ومناسب للاستخدام اليومي',
        price: 67.50,
        stock: 30,
        category_id: 3,
        category: { id: 3, name: 'بناطيل', description: 'بناطيل متنوعة' },
        status: 'active',
        image_url: 'https://via.placeholder.com/300x200/6c757d/ffffff?text=بنطلون+جينز',
        created_at: '2026-01-18',
        updated_at: '2026-01-21'
    }
];

const mockCategories: Category[] = [
    { id: 1, name: 'قمصان', description: 'قمصان رجالية ونسائية' },
    { id: 2, name: 'فساتين', description: 'فساتين نسائية أنيقة' },
    { id: 3, name: 'بناطيل', description: 'بناطيل متنوعة للرجال والنساء' },
    { id: 4, name: 'أحذية', description: 'أحذية رياضية وكلاسيكية' },
    { id: 5, name: 'إكسسوارات', description: 'إكسسوارات متنوعة' }
];

/**
 * Product Service
 * Handles all product-related API calls with fallback to mock data
 */
export const productService = {
    /**
     * Get paginated list of products with filters
     * Endpoint: GET /v1/products
     */
    getAll: async (filters?: ProductFilters): Promise<PaginatedResponse<Product>> => {
        try {
            const response = await api.get<PaginatedResponse<Product>>('/v1/products', {
                params: filters
            });
            return response.data;
        } catch (error) {
            console.warn('API call failed, using mock data:', error);
            return {
                data: mockProducts,
                current_page: 1,
                last_page: 1,
                per_page: 10,
                total: mockProducts.length,
                from: 1,
                to: mockProducts.length
            };
        }
    },

    /**
     * Get single product by ID
     * Endpoint: GET /v1/products/:id
     */
    getById: async (id: number): Promise<Product> => {
        try {
            const response = await api.get<ApiResponse<Product>>(`/v1/products/${id}`);
            return response.data.data;
        } catch (error) {
            console.warn('API call failed, using mock data:', error);
            const product = mockProducts.find(p => p.id === id);
            if (!product) throw new Error('Product not found');
            return product;
        }
    },

    /**
     * Create new product
     * Endpoint: POST /v1/products
     */
    create: async (data: ProductPayload): Promise<Product> => {
        try {
            const response = await api.post<ApiResponse<Product>>('/v1/products', data);
            return response.data.data;
        } catch (error) {
            console.warn('API call failed, using mock data:', error);
            const newProduct: Product = {
                id: Math.max(...mockProducts.map(p => p.id)) + 1,
                ...data,
                category: mockCategories.find(c => c.id === data.category_id) || mockCategories[0],
                status: 'active',
                image_url: 'https://via.placeholder.com/300x200/007bff/ffffff?text=منتج+جديد',
                created_at: new Date().toISOString().split('T')[0],
                updated_at: new Date().toISOString().split('T')[0]
            };
            return newProduct;
        }
    },

    /**
     * Update existing product
     * Endpoint: PUT /v1/products/:id
     */
    update: async (id: number, data: Partial<ProductPayload>): Promise<Product> => {
        try {
            const response = await api.put<ApiResponse<Product>>(`/v1/products/${id}`, data);
            return response.data.data;
        } catch (error) {
            console.warn('API call failed, using mock data:', error);
            const product = mockProducts.find(p => p.id === id);
            if (!product) throw new Error('Product not found');
            return { ...product, ...data, updated_at: new Date().toISOString().split('T')[0] };
        }
    },

    /**
     * Delete product
     * Endpoint: DELETE /v1/products/:id
     */
    delete: async (id: number): Promise<void> => {
        try {
            await api.delete(`/v1/products/${id}`);
        } catch (error) {
            console.warn('API call failed, simulating delete:', error);
            // في البيانات الوهمية، نتجاهل الحذف
        }
    },
};

/**
 * Category Service
 * Handles all category-related API calls with fallback to mock data
 */
export const categoryService = {
    /**
     * Get all categories
     * Endpoint: GET /v1/categories
     */
    getAll: async (): Promise<Category[]> => {
        try {
            const response = await api.get<ApiResponse<Category[]>>('/v1/categories');
            return response.data.data;
        } catch (error) {
            console.warn('API call failed, using mock data:', error);
            return mockCategories;
        }
    },

    /**
     * Get single category by ID
     * Endpoint: GET /v1/categories/:id
     */
    getById: async (id: number): Promise<Category> => {
        try {
            const response = await api.get<ApiResponse<Category>>(`/v1/categories/${id}`);
            return response.data.data;
        } catch (error) {
            console.warn('API call failed, using mock data:', error);
            const category = mockCategories.find(c => c.id === id);
            if (!category) throw new Error('Category not found');
            return category;
        }
    },

    /**
     * Create new category
     * Endpoint: POST /v1/categories
     */
    create: async (data: CategoryPayload): Promise<Category> => {
        try {
            const response = await api.post<ApiResponse<Category>>('/v1/categories', data);
            return response.data.data;
        } catch (error) {
            console.warn('API call failed, using mock data:', error);
            const newCategory: Category = {
                id: Math.max(...mockCategories.map(c => c.id)) + 1,
                ...data
            };
            return newCategory;
        }
    },

    /**
     * Update existing category
     * Endpoint: PUT /v1/categories/:id
     */
    update: async (id: number, data: Partial<CategoryPayload>): Promise<Category> => {
        try {
            const response = await api.put<ApiResponse<Category>>(`/v1/categories/${id}`, data);
            return response.data.data;
        } catch (error) {
            console.warn('API call failed, using mock data:', error);
            const category = mockCategories.find(c => c.id === id);
            if (!category) throw new Error('Category not found');
            return { ...category, ...data };
        }
    },

    /**
     * Delete category
     * Endpoint: DELETE /v1/categories/:id
     */
    delete: async (id: number): Promise<void> => {
        try {
            await api.delete(`/v1/categories/${id}`);
        } catch (error) {
            console.warn('API call failed, simulating delete:', error);
            // في البيانات الوهمية، نتجاهل الحذف
        }
    },
};

export default productService;
