import i18n from 'i18next';
import { initReactI18next } from 'react-i18next';

const resources = {
  ar: {
    translation: {
      // Navigation
      dashboard: 'لوحة التحكم',
      products: 'المنتجات',
      categories: 'الفئات',
      orders: 'الطلبات',
      customers: 'العملاء',
      inventory: 'المخزون',
      discounts: 'الخصومات والكوبونات',
      reports: 'التقارير والإحصائيات',
      notifications: 'مركز الإشعارات',
      settings: 'الإعدادات',
      
      // Dashboard
      totalRevenue: 'إجمالي الإيرادات',
      totalOrders: 'إجمالي الطلبات',
      totalCustomers: 'إجمالي العملاء',
      averageOrder: 'متوسط قيمة الطلب',
      revenueOverview: 'نظرة عامة على الإيرادات',
      recentOrders: 'الطلبات الأخيرة',
      topProducts: 'أفضل المنتجات مبيعاً',
      vsLastMonth: 'مقارنة بالشهر الماضي',
      revenue: 'الإيرادات',
      failedToLoadDashboard: 'فشل في تحميل بيانات لوحة التحكم',
      
      // Products
      addProduct: 'إضافة منتج',
      productName: 'اسم المنتج',
      price: 'السعر',
      stock: 'المخزون',
      category: 'الفئة',
      status: 'الحالة',
      actions: 'الإجراءات',
      edit: 'تعديل',
      delete: 'حذف',
      active: 'نشط',
      inactive: 'غير نشط',
      
      // Orders
      orderNumber: 'رقم الطلب',
      customer: 'العميل',
      date: 'التاريخ',
      total: 'المجموع',
      paymentStatus: 'حالة الدفع',
      deliveryStatus: 'حالة التسليم',
      paid: 'مدفوع',
      unpaid: 'غير مدفوع',
      pending: 'قيد الانتظار',
      processing: 'قيد المعالجة',
      shipped: 'تم الشحن',
      delivered: 'تم التسليم',
      
      // Settings
      storeInformation: 'معلومات المتجر',
      language: 'اللغة',
      darkMode: 'الوضع الليلي',
      rolesPermissions: 'الأدوار والصلاحيات',
      paymentSettings: 'إعدادات الدفع',
      
      // Common
      search: 'بحث',
      filter: 'تصفية',
      export: 'تصدير',
      import: 'استيراد',
      save: 'حفظ',
      cancel: 'إلغاء',
      viewDetails: 'عرض التفاصيل',
      loading: 'جاري التحميل...',
      noData: 'لا توجد بيانات',
    },
  },
  en: {
    translation: {
      // Navigation
      dashboard: 'Dashboard',
      products: 'Products',
      categories: 'Categories',
      orders: 'Orders',
      customers: 'Customers',
      inventory: 'Inventory',
      discounts: 'Discounts & Coupons',
      reports: 'Reports & Analytics',
      notifications: 'Notifications',
      settings: 'Settings',
      
      // Dashboard
      totalRevenue: 'Total Revenue',
      totalOrders: 'Total Orders',
      totalCustomers: 'Total Customers',
      averageOrder: 'Average Order Value',
      revenueOverview: 'Revenue Overview',
      recentOrders: 'Recent Orders',
      topProducts: 'Top Selling Products',
      vsLastMonth: 'vs last month',
      revenue: 'Revenue',
      failedToLoadDashboard: 'Failed to load dashboard data',
      
      // Products
      addProduct: 'Add Product',
      productName: 'Product Name',
      price: 'Price',
      stock: 'Stock',
      category: 'Category',
      status: 'Status',
      actions: 'Actions',
      edit: 'Edit',
      delete: 'Delete',
      active: 'Active',
      inactive: 'Inactive',
      
      // Orders
      orderNumber: 'Order Number',
      customer: 'Customer',
      date: 'Date',
      total: 'Total',
      paymentStatus: 'Payment Status',
      deliveryStatus: 'Delivery Status',
      paid: 'Paid',
      unpaid: 'Unpaid',
      pending: 'Pending',
      processing: 'Processing',
      shipped: 'Shipped',
      delivered: 'Delivered',
      
      // Settings
      storeInformation: 'Store Information',
      language: 'Language',
      darkMode: 'Dark Mode',
      rolesPermissions: 'Roles & Permissions',
      paymentSettings: 'Payment Settings',
      
      // Common
      search: 'Search',
      filter: 'Filter',
      export: 'Export',
      import: 'Import',
      save: 'Save',
      cancel: 'Cancel',
      viewDetails: 'View Details',
      loading: 'Loading...',
      noData: 'No data available',
    },
  },
};

i18n
  .use(initReactI18next)
  .init({
    resources,
    lng: 'ar', // default language
    fallbackLng: 'en',
    interpolation: {
      escapeValue: false,
    },
  });

export default i18n;
