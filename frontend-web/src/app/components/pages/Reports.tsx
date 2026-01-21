import { useState, useEffect } from 'react';
import { useTranslation } from 'react-i18next';
import { Card, CardContent, CardHeader, CardTitle } from '@/app/components/ui/card';
import {
  LineChart,
  Line,
  BarChart,
  Bar,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  Legend,
  ResponsiveContainer,
} from 'recharts';
import { TrendingUp, DollarSign, Package, Users, AlertCircle } from 'lucide-react';
import { Alert, AlertDescription } from '@/app/components/ui/alert';
import { reportsService } from '@/services';

interface AnalyticsData {
  revenue: {
    current_month: number;
    last_month: number;
    growth: number;
  };
  orders: {
    current_month: number;
    last_month: number;
    growth: number;
  };
  customers: {
    new_this_month: number;
  };
  products: {
    total: number;
    active: number;
  };
}

interface ChartData {
  month: string;
  revenue: number;
  orders: number;
}

export function Reports() {
  const { t, i18n } = useTranslation();
  const [analytics, setAnalytics] = useState<AnalyticsData | null>(null);
  const [chartData, setChartData] = useState<ChartData[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    fetchAnalytics();
    fetchChartData();
  }, []);

  const fetchAnalytics = async () => {
    try {
      setLoading(true);
      const data = await reportsService.getAnalytics();
      setAnalytics(data as unknown as AnalyticsData);
    } catch (err) {
      console.error('Error fetching analytics:', err);
      setError(t('failedToLoadAnalytics'));
    } finally {
      setLoading(false);
    }
  };

  const fetchChartData = async () => {
    try {
      const data = await reportsService.getRevenueChart();
      setChartData(data as ChartData[]);
    } catch (err) {
      console.error('Error fetching chart data:', err);
    }
  };

  const formatCurrency = (amount: number) => {
    return new Intl.NumberFormat('en-US', {
      style: 'currency',
      currency: 'USD',
    }).format(amount);
  };

  const stats = analytics ? [
    {
      title: i18n.language === 'ar' ? 'إجمالي المبيعات' : 'Total Sales',
      value: formatCurrency(analytics.revenue.current_month),
      change: `${analytics.revenue.growth >= 0 ? '+' : ''}${analytics.revenue.growth}%`,
      icon: DollarSign,
      color: 'text-green-600',
    },
    {
      title: i18n.language === 'ar' ? 'الطلبات' : 'Orders',
      value: analytics.orders.current_month.toString(),
      change: `${analytics.orders.growth >= 0 ? '+' : ''}${analytics.orders.growth}%`,
      icon: Package,
      color: 'text-blue-600',
    },
    {
      title: i18n.language === 'ar' ? 'المنتجات' : 'Products',
      value: analytics.products.total.toString(),
      change: '',
      icon: TrendingUp,
      color: 'text-purple-600',
    },
    {
      title: i18n.language === 'ar' ? 'عملاء جدد' : 'New Customers',
      value: analytics.customers.new_this_month.toString(),
      change: '',
      icon: Users,
      color: 'text-orange-600',
    },
  ] : [];

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
      {/* Stats Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        {stats.map((stat, index) => {
          const Icon = stat.icon;
          return (
            <Card key={index}>
              <CardContent className="p-6">
                <div className="flex items-center justify-between">
                  <div className="space-y-2">
                    <p className="text-sm text-muted-foreground">{stat.title}</p>
                    <p className="text-3xl font-bold">{stat.value}</p>
                    <p className="text-sm text-green-600">{stat.change}</p>
                  </div>
                  <div className={`p-3 rounded-full bg-accent ${stat.color}`}>
                    <Icon className="w-6 h-6" />
                  </div>
                </div>
              </CardContent>
            </Card>
          );
        })}
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Sales Trend */}
        <Card>
          <CardHeader>
            <CardTitle>
              {i18n.language === 'ar' ? 'اتجاه المبيعات' : 'Sales Trend'}
            </CardTitle>
          </CardHeader>
          <CardContent>
            <ResponsiveContainer width="100%" height={300}>
              <LineChart data={chartData}>
                <CartesianGrid strokeDasharray="3 3" />
                <XAxis dataKey="month" />
                <YAxis tickFormatter={(value) => formatCurrency(value)} />
                <Tooltip formatter={(value: number) => [formatCurrency(value), 'Revenue']} />
                <Legend />
                <Line type="monotone" dataKey="revenue" stroke="#8b5cf6" strokeWidth={2} />
              </LineChart>
            </ResponsiveContainer>
          </CardContent>
        </Card>

        {/* Revenue vs Orders */}
        <Card>
          <CardHeader>
            <CardTitle>
              {i18n.language === 'ar' ? 'الإيرادات والطلبات' : 'Revenue vs Orders'}
            </CardTitle>
          </CardHeader>
          <CardContent>
            <ResponsiveContainer width="100%" height={300}>
              <BarChart data={chartData}>
                <CartesianGrid strokeDasharray="3 3" />
                <XAxis dataKey="month" />
                <YAxis yAxisId="left" />
                <YAxis yAxisId="right" orientation="right" />
                <Tooltip />
                <Legend />
                <Bar yAxisId="left" dataKey="revenue" fill="#8b5cf6" name="Revenue" />
                <Bar yAxisId="right" dataKey="orders" fill="#ec4899" name="Orders" />
              </BarChart>
            </ResponsiveContainer>
          </CardContent>
        </Card>
      </div>

      {/* Orders Chart */}
      <Card>
        <CardHeader>
          <CardTitle>
            {i18n.language === 'ar' ? 'الطلبات الشهرية' : 'Monthly Orders'}
          </CardTitle>
        </CardHeader>
        <CardContent>
          <ResponsiveContainer width="100%" height={300}>
            <BarChart data={chartData}>
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="month" />
              <YAxis />
              <Tooltip />
              <Legend />
              <Bar dataKey="orders" fill="#8b5cf6" name="Orders" />
            </BarChart>
          </ResponsiveContainer>
        </CardContent>
      </Card>
    </div>
  );
}
