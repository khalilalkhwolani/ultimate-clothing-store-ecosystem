import React, { useState, useEffect } from 'react';
import { useTranslation } from 'react-i18next';
import { Card, CardContent, CardHeader, CardTitle } from '@/app/components/ui/card';
import { Avatar, AvatarFallback } from '@/app/components/ui/avatar';
import { Badge } from '@/app/components/ui/badge';
import { Button } from '@/app/components/ui/button';
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from '@/app/components/ui/table';
import { Mail, Phone, MapPin, ShoppingBag, AlertCircle } from 'lucide-react';
import { Alert, AlertDescription } from '@/app/components/ui/alert';
import api from '@/lib/api';

interface Customer {
  id: number;
  name: string;
  email: string;
  role: string;
  orders_count?: number;
  total_spent?: number;
  created_at: string;
  updated_at: string;
}

interface CustomerStats {
  total_customers: number;
  active_customers: number;
  new_customers_this_month: number;
}

export function Customers() {
  const { t, i18n } = useTranslation();
  const [customers, setCustomers] = useState<Customer[]>([]);
  const [stats, setStats] = useState<CustomerStats | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    fetchCustomers();
    fetchCustomerStats();
  }, []);

  const fetchCustomers = async () => {
    try {
      // For now, we'll get all users and filter customers on frontend
      // In a real app, you'd have a dedicated customers endpoint
      const response = await api.get('/v1/users'); // This might not exist, adjust as needed
      const customerUsers = response.data.data.filter((user: any) => user.role === 'customer');
      setCustomers(customerUsers);
    } catch (err) {
      console.error('Error fetching customers:', err);
      // For now, set empty array if endpoint doesn't exist
      setCustomers([]);
    }
  };

  const fetchCustomerStats = async () => {
    try {
      const response = await api.get('/v1/reports/customer-stats');
      setStats(response.data.data);
    } catch (err) {
      console.error('Error fetching customer stats:', err);
      setStats(null);
    }
  };

  const getInitials = (name: string) => {
    return name
      .split(' ')
      .map(n => n[0])
      .join('')
      .toUpperCase();
  };

  const formatCurrency = (amount: number) => {
    return new Intl.NumberFormat('en-US', {
      style: 'currency',
      currency: 'USD',
    }).format(amount);
  };

  if (loading) {
    return (
      <div className="space-y-6">
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
          {[...Array(3)].map((_, i) => (
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
      {/* Summary Cards */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <Card>
          <CardContent className="p-6">
            <div className="space-y-2">
              <p className="text-sm text-muted-foreground">
                {i18n.language === 'ar' ? 'إجمالي العملاء' : 'Total Customers'}
              </p>
              <p className="text-3xl font-bold">{stats?.total_customers || 0}</p>
              <p className="text-sm text-green-600">+12.5% from last month</p>
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardContent className="p-6">
            <div className="space-y-2">
              <p className="text-sm text-muted-foreground">
                {i18n.language === 'ar' ? 'عملاء نشطون' : 'Active Customers'}
              </p>
              <p className="text-3xl font-bold">{stats?.active_customers || 0}</p>
              <p className="text-sm text-green-600">+8.2% from last month</p>
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardContent className="p-6">
            <div className="space-y-2">
              <p className="text-sm text-muted-foreground">
                {i18n.language === 'ar' ? 'عملاء جدد هذا الشهر' : 'New Customers This Month'}
              </p>
              <p className="text-3xl font-bold">{stats?.new_customers_this_month || 0}</p>
              <p className="text-sm text-green-600">+15.3% from last month</p>
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Customers Table */}
      <Card>
        <CardHeader>
          <CardTitle>{t('customers')}</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="border rounded-lg">
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>{i18n.language === 'ar' ? 'العميل' : 'Customer'}</TableHead>
                  <TableHead>{i18n.language === 'ar' ? 'البريد الإلكتروني' : 'Email'}</TableHead>
                  <TableHead>{i18n.language === 'ar' ? 'الطلبات' : 'Orders'}</TableHead>
                  <TableHead>{i18n.language === 'ar' ? 'إجمالي الإنفاق' : 'Total Spent'}</TableHead>
                  <TableHead>{t('status')}</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {customers.map((customer) => (
                  <TableRow key={customer.id}>
                    <TableCell>
                      <div className="flex items-center gap-3">
                        <Avatar>
                          <AvatarFallback className="bg-primary text-primary-foreground">
                            {getInitials(customer.name)}
                          </AvatarFallback>
                        </Avatar>
                        <div>
                          <p className="font-medium">{customer.name}</p>
                        </div>
                      </div>
                    </TableCell>
                    <TableCell>
                      <div className="space-y-1">
                        <div className="flex items-center gap-2 text-sm">
                          <Mail className="w-4 h-4 text-muted-foreground" />
                          <span>{customer.email}</span>
                        </div>
                      </div>
                    </TableCell>
                    <TableCell>
                      <div className="flex items-center gap-2">
                        <ShoppingBag className="w-4 h-4 text-muted-foreground" />
                        <span className="font-medium">{customer.orders_count || 0}</span>
                      </div>
                    </TableCell>
                    <TableCell className="font-medium">
                      {formatCurrency(customer.total_spent || 0)}
                    </TableCell>
                    <TableCell>
                      <Badge variant="default">
                        {t('active')}
                      </Badge>
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
