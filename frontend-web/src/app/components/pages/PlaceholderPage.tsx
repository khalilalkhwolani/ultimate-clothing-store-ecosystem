import React from 'react';
import { useTranslation } from 'react-i18next';
import { Card, CardContent, CardHeader, CardTitle } from '@/app/components/ui/card';
import { Package } from 'lucide-react';

interface PlaceholderPageProps {
  title: string;
  icon?: React.ReactNode;
}

export function PlaceholderPage({ title, icon }: PlaceholderPageProps) {
  const { i18n } = useTranslation();

  return (
    <div className="space-y-6">
      <Card>
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            {icon || <Package className="w-6 h-6" />}
            {title}
          </CardTitle>
        </CardHeader>
        <CardContent>
          <div className="flex flex-col items-center justify-center py-12 space-y-4">
            <div className="w-16 h-16 rounded-full bg-accent flex items-center justify-center">
              {icon || <Package className="w-8 h-8 text-muted-foreground" />}
            </div>
            <h3 className="text-xl font-semibold">
              {i18n.language === 'ar' ? 'قيد التطوير' : 'Coming Soon'}
            </h3>
            <p className="text-muted-foreground text-center max-w-md">
              {i18n.language === 'ar' 
                ? 'هذه الصفحة قيد التطوير حالياً. سنقوم بإضافة المزيد من الميزات قريباً.'
                : 'This page is currently under development. More features will be added soon.'}
            </p>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
