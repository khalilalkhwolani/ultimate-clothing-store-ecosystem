import { useState, useEffect } from 'react';
import { useTranslation } from 'react-i18next';
import { useTheme } from 'next-themes';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/app/components/ui/card';
import { Label } from '@/app/components/ui/label';
import { Switch } from '@/app/components/ui/switch';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/app/components/ui/select';
import { Input } from '@/app/components/ui/input';
import { Button } from '@/app/components/ui/button';
import { Separator } from '@/app/components/ui/separator';
import { Alert, AlertDescription } from '@/app/components/ui/alert';
import { AlertCircle } from 'lucide-react';
import { settingsService } from '@/services';
import type { Setting } from '@/types';

export function Settings() {
  const { t, i18n } = useTranslation();
  const { theme, setTheme } = useTheme();
  const [settings, setSettings] = useState<Setting[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [storeSettings, setStoreSettings] = useState({
    store_name: '',
    store_name_ar: '',
    email: '',
    phone: '',
  });

  useEffect(() => {
    fetchSettings();
  }, []);

  const fetchSettings = async () => {
    try {
      setLoading(true);
      const settingsData = await settingsService.getAll();
      setSettings(settingsData);

      // Extract store settings
      const storeName = settingsData.find((s: Setting) => s.key === 'store_name')?.value || '';
      const storeNameAr = settingsData.find((s: Setting) => s.key === 'store_name_ar')?.value || '';
      const email = settingsData.find((s: Setting) => s.key === 'store_email')?.value || '';
      const phone = settingsData.find((s: Setting) => s.key === 'store_phone')?.value || '';

      setStoreSettings({
        store_name: storeName,
        store_name_ar: storeNameAr,
        email: email,
        phone: phone,
      });
    } catch (err) {
      console.error('Error fetching settings:', err);
      setError(t('failedToLoadSettings'));
    } finally {
      setLoading(false);
    }
  };

  const updateSettingByKey = async (key: string, value: string) => {
    try {
      // Find the setting by key to get its ID
      const setting = settings.find(s => s.key === key);
      if (setting) {
        await settingsService.update(setting.id, { key, value });
        fetchSettings();
      }
    } catch (err) {
      console.error('Error updating setting:', err);
      setError(t('failedToUpdateSetting'));
    }
  };

  const handleSaveStoreInfo = async () => {
    try {
      await Promise.all([
        updateSettingByKey('store_name', storeSettings.store_name),
        updateSettingByKey('store_name_ar', storeSettings.store_name_ar),
        updateSettingByKey('store_email', storeSettings.email),
        updateSettingByKey('store_phone', storeSettings.phone),
      ]);
    } catch (err) {
      console.error('Error saving store info:', err);
    }
  };

  if (loading) {
    return (
      <div className="space-y-6">
        <Card>
          <CardHeader>
            <CardTitle>{t('settings')}</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="animate-pulse space-y-4">
              {[...Array(3)].map((_, i) => (
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
      {/* Store Information */}
      <Card>
        <CardHeader>
          <CardTitle>{t('storeInformation')}</CardTitle>
          <CardDescription>
            {i18n.language === 'ar'
              ? 'قم بإدارة معلومات متجرك الأساسية'
              : 'Manage your store basic information'}
          </CardDescription>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="grid grid-cols-2 gap-4">
            <div className="space-y-2">
              <Label>
                {i18n.language === 'ar' ? 'اسم المتجر (English)' : 'Store Name (English)'}
              </Label>
              <Input
                value={storeSettings.store_name}
                onChange={(e) => setStoreSettings({ ...storeSettings, store_name: e.target.value })}
              />
            </div>
            <div className="space-y-2">
              <Label>
                {i18n.language === 'ar' ? 'اسم المتجر (العربية)' : 'Store Name (Arabic)'}
              </Label>
              <Input
                value={storeSettings.store_name_ar}
                onChange={(e) => setStoreSettings({ ...storeSettings, store_name_ar: e.target.value })}
                dir="rtl"
              />
            </div>
          </div>
          <div className="space-y-2">
            <Label>{i18n.language === 'ar' ? 'البريد الإلكتروني' : 'Email'}</Label>
            <Input
              type="email"
              value={storeSettings.email}
              onChange={(e) => setStoreSettings({ ...storeSettings, email: e.target.value })}
            />
          </div>
          <div className="space-y-2">
            <Label>{i18n.language === 'ar' ? 'رقم الهاتف' : 'Phone'}</Label>
            <Input
              value={storeSettings.phone}
              onChange={(e) => setStoreSettings({ ...storeSettings, phone: e.target.value })}
            />
          </div>
          <Button onClick={handleSaveStoreInfo}>{t('save')}</Button>
        </CardContent>
      </Card>

      {/* Language & Appearance */}
      <Card>
        <CardHeader>
          <CardTitle>{t('language')} & {t('darkMode')}</CardTitle>
          <CardDescription>
            {i18n.language === 'ar'
              ? 'قم بتخصيص تفضيلات اللغة والمظهر'
              : 'Customize your language and appearance preferences'}
          </CardDescription>
        </CardHeader>
        <CardContent className="space-y-6">
          <div className="flex items-center justify-between">
            <div className="space-y-0.5">
              <Label>{t('language')}</Label>
              <p className="text-sm text-muted-foreground">
                {i18n.language === 'ar'
                  ? 'اختر لغة لوحة التحكم'
                  : 'Choose your dashboard language'}
              </p>
            </div>
            <Select
              value={i18n.language}
              onValueChange={(lang) => i18n.changeLanguage(lang)}
            >
              <SelectTrigger className="w-[180px]">
                <SelectValue />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="ar">العربية</SelectItem>
                <SelectItem value="en">English</SelectItem>
              </SelectContent>
            </Select>
          </div>

          <Separator />

          <div className="flex items-center justify-between">
            <div className="space-y-0.5">
              <Label>{t('darkMode')}</Label>
              <p className="text-sm text-muted-foreground">
                {i18n.language === 'ar'
                  ? 'قم بتبديل بين الوضع الفاتح والداكن'
                  : 'Toggle between light and dark mode'}
              </p>
            </div>
            <Switch
              checked={theme === 'dark'}
              onCheckedChange={(checked) => setTheme(checked ? 'dark' : 'light')}
            />
          </div>
        </CardContent>
      </Card>

      {/* Roles & Permissions */}
      <Card>
        <CardHeader>
          <CardTitle>{t('rolesPermissions')}</CardTitle>
          <CardDescription>
            {i18n.language === 'ar'
              ? 'إدارة أدوار وصلاحيات المستخدمين'
              : 'Manage user roles and permissions'}
          </CardDescription>
        </CardHeader>
        <CardContent>
          <div className="space-y-4">
            {['Store Owner', 'Admin', 'Staff', 'Viewer'].map((role) => (
              <div key={role} className="flex items-center justify-between p-4 border rounded-lg">
                <div>
                  <p className="font-medium">{role}</p>
                  <p className="text-sm text-muted-foreground">
                    {i18n.language === 'ar' ? 'صلاحيات كاملة' : 'Full permissions'}
                  </p>
                </div>
                <Button variant="outline" size="sm">
                  {t('edit')}
                </Button>
              </div>
            ))}
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
