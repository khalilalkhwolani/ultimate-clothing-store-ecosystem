import { useState, useEffect } from 'react';
import { useTranslation } from 'react-i18next';
import { Card, CardContent, CardHeader, CardTitle } from '@/app/components/ui/card';
import { Badge } from '@/app/components/ui/badge';
import { Button } from '@/app/components/ui/button';
import { Input } from '@/app/components/ui/input';
import { Label } from '@/app/components/ui/label';
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from '@/app/components/ui/table';
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
  DialogFooter,
} from '@/app/components/ui/dialog';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/app/components/ui/select';
import { Eye, Download, AlertCircle, Edit, CheckCircle2, Circle, Clock, Truck, Package } from 'lucide-react';
import { Alert, AlertDescription } from '@/app/components/ui/alert';
import { orderService } from '@/services';
import type { Order } from '@/types';

export function Orders() {
  const { t, i18n } = useTranslation();
  const [orders, setOrders] = useState<Order[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [selectedOrder, setSelectedOrder] = useState<Order | null>(null);
  const [isDetailsDialogOpen, setIsDetailsDialogOpen] = useState(false);
  const [isEditDialogOpen, setIsEditDialogOpen] = useState(false);
  const [editFormData, setEditFormData] = useState({
    status: '',
    payment_status: '',
  });

  useEffect(() => {
    fetchOrders();
  }, []);

  const fetchOrders = async () => {
    try {
      setLoading(true);
      const response = await orderService.getAll();
      setOrders(response.data);
    } catch (err) {
      console.error('Error fetching orders:', err);
      setError(t('failedToLoadOrders'));
    } finally {
      setLoading(false);
    }
  };

  const fetchOrderDetails = async (orderId: number) => {
    try {
      const order = await orderService.getById(orderId);
      setSelectedOrder(order);
      setIsDetailsDialogOpen(true);
    } catch (err) {
      console.error('Error fetching order details:', err);
      setError(t('failedToLoadOrderDetails'));
    }
  };

  const openEditDialog = (order: Order) => {
    setSelectedOrder(order);
    setEditFormData({
      status: order.status,
      payment_status: order.payment_status,
    });
    setIsEditDialogOpen(true);
  };

  const handleUpdateOrder = async () => {
    if (!selectedOrder) return;

    try {
      await orderService.update(selectedOrder.id, editFormData as any);
      setIsEditDialogOpen(false);
      fetchOrders(); // Refresh list
      // Also update selected order if details are open
      if (isDetailsDialogOpen && selectedOrder.id === selectedOrder.id) {
        const updated = await orderService.getById(selectedOrder.id);
        setSelectedOrder(updated);
      }
    } catch (err) {
      console.error('Error updating order:', err);
      setError(t('failedToUpdateOrder'));
    }
  };

  const getPaymentStatusColor = (status: string) => {
    return status === 'paid' ? 'bg-green-500' : 'bg-red-500';
  };

  const getDeliveryStatusColor = (status: string) => {
    const colors: Record<string, string> = {
      shipped: 'bg-blue-500',
      processing: 'bg-yellow-500',
      delivered: 'bg-green-500',
      pending: 'bg-gray-500',
      cancelled: 'bg-red-500',
    };
    return colors[status] || 'bg-gray-500';
  };

  const formatCurrency = (amount: number) => {
    return new Intl.NumberFormat('en-US', {
      style: 'currency',
      currency: 'USD',
    }).format(amount);
  };

  const formatDate = (dateString: string) => {
    return new Date(dateString).toLocaleDateString();
  };

  // Order Progress Steps
  const getProgressSteps = (currentStatus: string) => {
    const steps = [
      { status: 'pending', label: t('pending'), icon: Clock },
      { status: 'processing', label: t('processing'), icon: Package },
      { status: 'shipped', label: t('shipped'), icon: Truck },
      { status: 'delivered', label: t('delivered'), icon: CheckCircle2 },
    ];

    const statusOrder = ['pending', 'processing', 'shipped', 'delivered'];
    const currentIndex = statusOrder.indexOf(currentStatus);
    const isCancelled = currentStatus === 'cancelled';

    return (
      <div className="flex items-center justify-between w-full mb-8 relative">
        {/* Progress Bar Background */}
        <div className="absolute top-1/2 left-0 w-full h-1 bg-gray-200 -z-10 transform -translate-y-1/2"></div>

        {/* Active Progress Bar */}
        {!isCancelled && currentIndex >= 0 && (
          <div
            className="absolute top-1/2 left-0 h-1 bg-primary -z-10 transform -translate-y-1/2 transition-all duration-500"
            style={{ width: `${(currentIndex / (steps.length - 1)) * 100}%` }}
          ></div>
        )}

        {steps.map((step, index) => {
          const Icon = step.icon;
          const isActive = !isCancelled && index <= currentIndex;
          const isCurrent = !isCancelled && index === currentIndex;

          return (
            <div key={step.status} className="flex flex-col items-center bg-white dark:bg-gray-800 px-2">
              <div className={`
                w-10 h-10 rounded-full flex items-center justify-center border-2 transition-colors duration-300
                ${isActive ? 'bg-primary border-primary text-primary-foreground' : 'bg-background border-muted text-muted-foreground'}
                ${isCancelled ? 'opacity-50' : ''}
              `}>
                <Icon className="w-5 h-5" />
              </div>
              <span className={`text-xs mt-2 font-medium ${isActive ? 'text-primary' : 'text-muted-foreground'}`}>
                {step.label}
              </span>
            </div>
          );
        })}
      </div>
    );
  };

  if (loading) {
    return (
      <div className="space-y-6">
        <Card>
          <CardHeader>
            <CardTitle>{t('orders')}</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="animate-pulse space-y-4">
              {[...Array(5)].map((_, i) => (
                <div key={i} className="h-12 bg-gray-200 rounded"></div>
              ))}
            </div>
          </CardContent>
        </Card>
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
      <Card>
        <CardHeader>
          <div className="flex items-center justify-between">
            <CardTitle>{t('orders')}</CardTitle>
            <Button variant="outline" size="sm">
              <Download className="w-4 h-4 mr-2" />
              {t('export')}
            </Button>
          </div>
        </CardHeader>
        <CardContent>
          <div className="border rounded-lg overflow-hidden">
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead className="text-start">{t('orderNumber')}</TableHead>
                  <TableHead className="text-start">{t('customer')}</TableHead>
                  <TableHead className="text-start">{t('date')}</TableHead>
                  <TableHead className="text-start">{t('total')}</TableHead>
                  <TableHead className="text-center">{t('paymentStatus')}</TableHead>
                  <TableHead className="text-center">{t('deliveryStatus')}</TableHead>
                  <TableHead className="text-end">{t('actions')}</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {orders.map((order) => (
                  <TableRow key={order.id}>
                    <TableCell className="font-medium">{order.order_number}</TableCell>
                    <TableCell>
                      {order.user?.name || 'Unknown'}
                    </TableCell>
                    <TableCell>{formatDate(order.created_at)}</TableCell>
                    <TableCell className="font-medium">{formatCurrency(order.total_amount)}</TableCell>
                    <TableCell className="text-center">
                      <Badge className={getPaymentStatusColor(order.payment_status)}>
                        {t(order.payment_status)}
                      </Badge>
                    </TableCell>
                    <TableCell className="text-center">
                      <Badge className={getDeliveryStatusColor(order.status)}>
                        {t(order.status)}
                      </Badge>
                    </TableCell>
                    <TableCell className="text-end">
                      <div className="flex justify-end gap-2">
                        <Button variant="ghost" size="icon" onClick={() => openEditDialog(order)} title={t('edit')}>
                          <Edit className="w-4 h-4" />
                        </Button>
                        <Button variant="ghost" size="icon" onClick={() => fetchOrderDetails(order.id)} title={t('viewDetails')}>
                          <Eye className="w-4 h-4" />
                        </Button>
                      </div>
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          </div>
        </CardContent>
      </Card>

      {/* Order Details Dialog */}
      <Dialog open={isDetailsDialogOpen} onOpenChange={setIsDetailsDialogOpen}>
        <DialogContent className="max-w-4xl">
          <DialogHeader>
            <DialogTitle className="flex items-center gap-2">
              {t('orderDetails')} - <span className="text-primary">{selectedOrder?.order_number}</span>
            </DialogTitle>
          </DialogHeader>
          {selectedOrder && (
            <div className="space-y-8">
              {/* Order Progress */}
              <div className="py-4">
                {getProgressSteps(selectedOrder.status)}
              </div>

              <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                <Card>
                  <CardHeader className="pb-2">
                    <CardTitle className="text-sm font-medium text-muted-foreground">{t('customerInfo')}</CardTitle>
                  </CardHeader>
                  <CardContent>
                    <div className="space-y-1">
                      <p className="text-lg font-semibold">{selectedOrder.user?.name}</p>
                      <p className="text-sm text-muted-foreground">{selectedOrder.user?.email}</p>
                      <div className="mt-4 pt-4 border-t">
                        <p className="text-sm font-medium mb-1">{t('shippingAddress')}</p>
                        <p className="text-sm text-muted-foreground">
                          {selectedOrder.shipping_address?.street}, {selectedOrder.shipping_address?.city}, {selectedOrder.shipping_address?.country}
                        </p>
                      </div>
                    </div>
                  </CardContent>
                </Card>

                <Card>
                  <CardHeader className="pb-2">
                    <CardTitle className="text-sm font-medium text-muted-foreground">{t('orderSummary')}</CardTitle>
                  </CardHeader>
                  <CardContent>
                    <div className="space-y-2">
                      <div className="flex justify-between">
                        <span className="text-muted-foreground">{t('orderDate')}:</span>
                        <span className="font-medium">{formatDate(selectedOrder.created_at)}</span>
                      </div>
                      <div className="flex justify-between">
                        <span className="text-muted-foreground">{t('paymentMethod')}:</span>
                        <span className="font-medium capitalize">{selectedOrder.payment_method?.replace('_', ' ')}</span>
                      </div>
                      <div className="flex justify-between">
                        <span className="text-muted-foreground">{t('paymentStatus')}:</span>
                        <Badge className={getPaymentStatusColor(selectedOrder.payment_status)}>{t(selectedOrder.payment_status)}</Badge>
                      </div>
                      <div className="flex justify-between pt-2 border-t mt-2">
                        <span className="font-bold">{t('total')}:</span>
                        <span className="font-bold text-lg text-primary">{formatCurrency(selectedOrder.total_amount)}</span>
                      </div>
                    </div>
                  </CardContent>
                </Card>
              </div>

              <div>
                <h3 className="font-semibold mb-4">{t('orderItems')}</h3>
                <div className="border rounded-lg overflow-hidden">
                  <Table>
                    <TableHeader>
                      <TableRow>
                        <TableHead>{t('product')}</TableHead>
                        <TableHead className="text-center">{t('quantity')}</TableHead>
                        <TableHead className="text-end">{t('price')}</TableHead>
                        <TableHead className="text-end">{t('total')}</TableHead>
                      </TableRow>
                    </TableHeader>
                    <TableBody>
                      {selectedOrder.order_items?.map((item) => (
                        <TableRow key={item.id}>
                          <TableCell className="font-medium">{item.product?.name || 'Unknown Product'}</TableCell>
                          <TableCell className="text-center">{item.quantity}</TableCell>
                          <TableCell className="text-end">{formatCurrency(item.price)}</TableCell>
                          <TableCell className="text-end">{formatCurrency(item.total_price)}</TableCell>
                        </TableRow>
                      ))}
                    </TableBody>
                  </Table>
                </div>
              </div>
            </div>
          )}
        </DialogContent>
      </Dialog>

      {/* Edit Order Dialog */}
      <Dialog open={isEditDialogOpen} onOpenChange={setIsEditDialogOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>{t('editOrder')} - {selectedOrder?.order_number}</DialogTitle>
          </DialogHeader>
          <div className="space-y-4 py-4">
            <div className="space-y-2">
              <Label>{t('deliveryStatus')}</Label>
              <Select
                value={editFormData.status}
                onValueChange={(value) => setEditFormData({ ...editFormData, status: value })}
              >
                <SelectTrigger>
                  <SelectValue placeholder="Select status" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="pending">{t('pending')}</SelectItem>
                  <SelectItem value="processing">{t('processing')}</SelectItem>
                  <SelectItem value="shipped">{t('shipped')}</SelectItem>
                  <SelectItem value="delivered">{t('delivered')}</SelectItem>
                  <SelectItem value="cancelled">{t('cancelled')}</SelectItem>
                </SelectContent>
              </Select>
            </div>
            <div className="space-y-2">
              <Label>{t('paymentStatus')}</Label>
              <Select
                value={editFormData.payment_status}
                onValueChange={(value) => setEditFormData({ ...editFormData, payment_status: value })}
              >
                <SelectTrigger>
                  <SelectValue placeholder="Select payment status" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="pending">{t('pending')}</SelectItem>
                  <SelectItem value="paid">{t('paid')}</SelectItem>
                  <SelectItem value="failed">{t('failed')}</SelectItem>
                </SelectContent>
              </Select>
            </div>
          </div>
          <DialogFooter>
            <Button variant="outline" onClick={() => setIsEditDialogOpen(false)}>{t('cancel')}</Button>
            <Button onClick={handleUpdateOrder}>{t('saveChanges')}</Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  );
}
