import { useState, useEffect, memo, useMemo } from 'react';
import { useTranslation } from 'react-i18next';
import { Card, CardContent, CardHeader, CardTitle } from '@/app/components/ui/card';
import { DollarSign, ShoppingCart, Users, TrendingUp, AlertCircle } from 'lucide-react';
import {
  AreaChart,
  Area,
  BarChart,
  Bar,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
} from 'recharts';
import { Badge } from '@/app/components/ui/badge';
import { Alert, AlertDescription } from '@/app/components/ui/alert';
import { dashboardService } from '@/services';
import type { DashboardStats, ChartDataPoint, TopProduct, RecentOrder } from '@/types';

export const Dashboard = memo(function Dashboard() {
  const { t } = useTranslation();
  const [stats, setStats] = useState<DashboardStats | null>(null);
  const [chartData, setChartData] = useState<ChartDataPoint[]>([]);
  const [topProducts, setTopProducts] = useState<TopProduct[]>([]);
  const [recentOrders, setRecentOrders] = useState<RecentOrder[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchDashboardData = async () => {
      try {
        setLoading(true);
        setError(null);

        // Use typed dashboardService instead of raw api.get
        const data = await dashboardService.getAllData();

        setStats(data.stats);
        setChartData(data.charts);
        setTopProducts(data.topProducts);
        setRecentOrders(data.recentOrders);
      } catch (err) {
        console.error('Error fetching dashboard data:', err);
        setError(t('failedToLoadDashboard'));
      } finally {
        setLoading(false);
      }
    };

    fetchDashboardData();
  }, [t]);


  const formatCurrency = (amount: number) => {
    return new Intl.NumberFormat('en-US', {
      style: 'currency',
      currency: 'USD',
    }).format(amount);
  };

  const formatNumber = (num: number) => {
    return new Intl.NumberFormat('en-US').format(num);
  };

  const statsCards = useMemo(() => stats ? [
    {
      title: t('totalRevenue'),
      value: formatCurrency(stats.total_revenue),
      change: `${stats.revenue_change >= 0 ? '+' : ''}${stats.revenue_change}%`,
      icon: DollarSign,
      color: 'text-green-600',
    },
    {
      title: t('totalOrders'),
      value: formatNumber(stats.total_orders),
      change: `${stats.orders_change >= 0 ? '+' : ''}${stats.orders_change}%`,
      icon: ShoppingCart,
      color: 'text-blue-600',
    },
    {
      title: t('totalCustomers'),
      value: formatNumber(stats.total_customers),
      change: `${stats.customers_change >= 0 ? '+' : ''}${stats.customers_change}%`,
      icon: Users,
      color: 'text-purple-600',
    },
    {
      title: t('averageOrder'),
      value: formatCurrency(stats.average_order_value),
      change: `${stats.average_order_change >= 0 ? '+' : ''}${stats.average_order_change}%`,
      icon: TrendingUp,
      color: 'text-orange-600',
    },
  ] : [], [stats]);

  const getStatusColor = (status: string) => {
    const colors: Record<string, string> = {
      shipped: 'bg-blue-500',
      processing: 'bg-yellow-500',
      delivered: 'bg-green-500',
      pending: 'bg-gray-500',
    };
    return colors[status] || 'bg-gray-500';
  };

  if (loading) {
    return (
      <div className="space-y-6">
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
          {[...Array(4)].map((_, i) => (
            <Card key={i}>
              <CardContent className="p-6">
                <div className="animate-pulse space-y-2">
                  <div className="h-4 bg-gray-200 rounded w-20"></div>
                  <div className="h-8 bg-gray-200 rounded w-16"></div>
                  <div className="h-4 bg-gray-200 rounded w-12"></div>
                </div>
              </CardContent>
            </Card>
          ))}
        </div>
      </div>
    );
  }

  if (error) {
    return (
      <Alert>
        <AlertCircle className="h-4 w-4" />
        <AlertDescription>{error}</AlertDescription>
      </Alert>
    );
  }

  return (
    <div className="space-y-6">
      {/* Stats Cards */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-5">
        {statsCards.map((stat, index) => {
          const Icon = stat.icon;
          const gradients = [
            'kpi-gradient-primary',
            'kpi-gradient-info',
            'kpi-gradient-success',
            'kpi-gradient-warning',
          ];
          const iconContainers = [
            'icon-container-primary',
            'icon-container-info',
            'icon-container-success',
            'icon-container-warning',
          ];
          return (
            <Card key={index} className="card-premium overflow-hidden">
              <CardContent className={`p-5 ${gradients[index % 4]}`}>
                <div className="flex items-start justify-between">
                  <div className="space-y-1.5">
                    <p className="text-sm font-medium text-muted-foreground">{stat.title}</p>
                    <p className="text-2xl font-bold tracking-tight">{stat.value}</p>
                    <div className={`inline-flex items-center gap-1 text-sm font-medium ${stat.change.startsWith('+') ? 'trend-up' : 'trend-down'}`}>
                      <span>{stat.change}</span>
                      <span className="text-xs text-muted-foreground">{t('vsLastMonth')}</span>
                    </div>
                  </div>
                  <div className={`icon-container ${iconContainers[index % 4]}`}>
                    <Icon className="w-5 h-5" />
                  </div>
                </div>
              </CardContent>
            </Card>
          );
        })}
      </div>

      {/* Revenue Chart */}
      <Card className="card-premium overflow-hidden">
        <CardHeader>
          <CardTitle>{t('revenueOverview')}</CardTitle>
        </CardHeader>
        <CardContent>
          <ResponsiveContainer width="100%" height={300}>
            <AreaChart data={chartData}>
              <defs>
                <linearGradient id="colorRevenue" x1="0" y1="0" x2="0" y2="1">
                  <stop offset="5%" stopColor="#4F46E5" stopOpacity={0.8} />
                  <stop offset="95%" stopColor="#7C3AED" stopOpacity={0.05} />
                </linearGradient>
              </defs>
              <CartesianGrid strokeDasharray="3 3" stroke="var(--border)" />
              <XAxis dataKey="month" stroke="var(--muted-foreground)" fontSize={12} />
              <YAxis tickFormatter={(value) => formatCurrency(value)} stroke="var(--muted-foreground)" fontSize={12} />
              <Tooltip
                formatter={(value: number) => [formatCurrency(value), t('revenue')]}
                contentStyle={{
                  backgroundColor: 'var(--card)',
                  border: '1px solid var(--border)',
                  borderRadius: '8px',
                  boxShadow: 'var(--shadow-md)'
                }}
              />
              <Area
                type="monotone"
                dataKey="revenue"
                stroke="#4F46E5"
                strokeWidth={2}
                fillOpacity={1}
                fill="url(#colorRevenue)"
              />
            </AreaChart>
          </ResponsiveContainer>
        </CardContent>
      </Card>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Top Products */}
        <Card>
          <CardHeader>
            <CardTitle>{t('topProducts')}</CardTitle>
          </CardHeader>
          <CardContent>
            <ResponsiveContainer width="100%" height={250}>
              <BarChart data={topProducts}>
                <CartesianGrid strokeDasharray="3 3" />
                <XAxis dataKey="name" />
                <YAxis />
                <Tooltip formatter={(value: number, name: string) => [
                  name === 'sales' ? value : formatCurrency(value),
                  name === 'sales' ? 'Sales' : 'Revenue'
                ]} />
                <Bar dataKey="sales" fill="#8b5cf6" />
              </BarChart>
            </ResponsiveContainer>
          </CardContent>
        </Card>

        {/* Recent Orders */}
        <Card>
          <CardHeader>
            <CardTitle>{t('recentOrders')}</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="space-y-4">
              {recentOrders.map((order) => (
                <div key={order.id} className="flex items-center justify-between p-3 rounded-lg bg-accent/50">
                  <div className="space-y-1">
                    <p className="font-medium">{order.order_number}</p>
                    <p className="text-sm text-muted-foreground">{order.customer}</p>
                  </div>
                  <div className="text-right space-y-1">
                    <p className="font-medium">{formatCurrency(order.total)}</p>
                    <Badge className={getStatusColor(order.status)}>
                      {t(order.status)}
                    </Badge>
                  </div>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  );
})
