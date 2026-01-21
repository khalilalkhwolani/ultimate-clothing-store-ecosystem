import React, { lazy, Suspense } from 'react';
import { ThemeProvider } from 'next-themes';
import { I18nextProvider } from 'react-i18next';
import i18n from '@/lib/i18n';
import { AppProvider, useApp } from '@/contexts/AppContext';
import { AuthProvider, useAuth } from '@/contexts/AuthContext';
import { ProtectedRoute } from '@/app/components/ProtectedRoute';
import { Login } from '@/app/components/pages/Login';
import { Sidebar } from '@/app/components/Sidebar';
import { Header } from '@/app/components/Header';
import { PlaceholderPage } from '@/app/components/pages/PlaceholderPage';

// Lazy load components
const Dashboard = lazy(() => import('@/app/components/pages/Dashboard').then(module => ({ default: module.Dashboard })));
const Products = lazy(() => import('@/app/components/pages/Products').then(module => ({ default: module.Products })));
const Categories = lazy(() => import('@/app/components/pages/Categories').then(module => ({ default: module.Categories })));
const Orders = lazy(() => import('@/app/components/pages/Orders').then(module => ({ default: module.Orders })));
const Settings = lazy(() => import('@/app/components/pages/Settings').then(module => ({ default: module.Settings })));
const Reports = lazy(() => import('@/app/components/pages/Reports').then(module => ({ default: module.Reports })));
const Customers = lazy(() => import('@/app/components/pages/Customers').then(module => ({ default: module.Customers })));
const Users = lazy(() => import('@/app/components/pages/Users').then(module => ({ default: module.Users })));
import {
  FolderTree,
  Warehouse,
  Tag,
  Bell
} from 'lucide-react';

function DashboardContent() {
  const { currentPage } = useApp();

  const renderPage = () => {
    switch (currentPage) {
      case 'dashboard':
        return <Dashboard />;
      case 'products':
        return <Products />;
      case 'categories':
        return <Categories />;
      case 'orders':
        return <Orders />;
      case 'customers':
        return <Customers />;
      case 'users':
        return <Users />;
      case 'inventory':
        return <PlaceholderPage title="Inventory" icon={<Warehouse className="w-8 h-8" />} />;
      case 'discounts':
        return <PlaceholderPage title="Discounts & Coupons" icon={<Tag className="w-8 h-8" />} />;
      case 'reports':
        return <Reports />;
      case 'notifications':
        return <PlaceholderPage title="Notifications" icon={<Bell className="w-8 h-8" />} />;
      case 'settings':
        return <Settings />;
      default:
        return <Dashboard />;
    }
  };

  return (
    <div className="flex h-screen overflow-hidden">
      <Sidebar />
      <div className="flex-1 flex flex-col overflow-hidden">
        <Header />
        <main className="flex-1 overflow-y-auto p-6 bg-background">
          <Suspense fallback={<div className="flex items-center justify-center h-64"><div className="animate-spin rounded-full h-8 w-8 border-b-2 border-gray-900"></div></div>}>
            {renderPage()}
          </Suspense>
        </main>
      </div>
    </div>
  );
}

function AppContent() {
  const { isAuthenticated, isLoading } = useAuth();

  if (isLoading) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <div className="animate-spin rounded-full h-32 w-32 border-b-2 border-gray-900"></div>
      </div>
    );
  }

  return isAuthenticated ? (
    <AppProvider>
      <DashboardContent />
    </AppProvider>
  ) : (
    <Login />
  );
}

export default function App() {
  return (
    <I18nextProvider i18n={i18n}>
      <ThemeProvider attribute="class" defaultTheme="light" enableSystem>
        <AuthProvider>
          <AppContent />
        </AuthProvider>
      </ThemeProvider>
    </I18nextProvider>
  );
}