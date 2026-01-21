import { useTranslation } from 'react-i18next';
import { useApp } from '@/contexts/AppContext';
import {
  LayoutDashboard,
  Package,
  FolderTree,
  ShoppingCart,
  Users,
  Warehouse,
  Tag,
  BarChart3,
  Bell,
  Settings,
  UserCircle,
} from 'lucide-react';

// Group navigation items for better organization
const navGroups = [
  {
    title: 'analytics',
    items: [
      { id: 'dashboard', icon: LayoutDashboard, label: 'dashboard' },
      { id: 'reports', icon: BarChart3, label: 'reports' },
    ]
  },
  {
    title: 'management',
    items: [
      { id: 'products', icon: Package, label: 'products' },
      { id: 'categories', icon: FolderTree, label: 'categories' },
      { id: 'orders', icon: ShoppingCart, label: 'orders' },
      { id: 'inventory', icon: Warehouse, label: 'inventory' },
    ]
  },
  {
    title: 'customers',
    items: [
      { id: 'customers', icon: Users, label: 'customers' },
      { id: 'users', icon: UserCircle, label: 'users' },
    ]
  },
  {
    title: 'marketing',
    items: [
      { id: 'discounts', icon: Tag, label: 'discounts' },
      { id: 'notifications', icon: Bell, label: 'notifications' },
    ]
  },
  {
    title: 'system',
    items: [
      { id: 'settings', icon: Settings, label: 'settings' },
    ]
  },
];

export function Sidebar() {
  const { t } = useTranslation();
  const { currentPage, setCurrentPage, isRTL } = useApp();

  return (
    <aside className="w-64 bg-sidebar text-sidebar-foreground h-screen sticky top-0 flex flex-col border-e border-sidebar-border">
      {/* Logo/Brand Section */}
      <div className="p-6 border-b border-sidebar-border">
        <h1 className="text-xl font-bold bg-gradient-to-r from-indigo-400 via-purple-400 to-pink-400 bg-clip-text text-transparent">
          {isRTL ? ' EseaShope متجر' : 'EseaShope Store'}
        </h1>
        <p className="text-xs text-sidebar-muted mt-1">
          {isRTL ? 'لوحة الإدارة' : 'Admin Dashboard'}
        </p>
      </div>

      {/* Navigation */}
      <nav className="flex-1 overflow-y-auto p-3 space-y-4">
        {navGroups.map((group) => (
          <div key={group.title}>
            <div className="sidebar-section-title">
              {t(group.title)}
            </div>
            <div className="space-y-1">
              {group.items.map((item) => {
                const Icon = item.icon;
                const isActive = currentPage === item.id;

                return (
                  <button
                    key={item.id}
                    onClick={() => setCurrentPage(item.id)}
                    className={`sidebar-item w-full flex items-center gap-3 px-3 py-2.5 text-sm transition-all ${isActive
                      ? 'sidebar-item-active text-sidebar-foreground font-medium'
                      : 'text-sidebar-muted hover:text-sidebar-foreground'
                      }`}
                  >
                    <Icon className="w-[18px] h-[18px] shrink-0" />
                    <span className="flex-1 text-start truncate">
                      {t(item.label)}
                    </span>
                  </button>
                );
              })}
            </div>
          </div>
        ))}
      </nav>

      {/* Footer - Version/Help */}
      <div className="p-4 border-t border-sidebar-border">
        <p className="text-xs text-sidebar-muted text-center">
          v1.0.0
        </p>
      </div>
    </aside>
  );
}
