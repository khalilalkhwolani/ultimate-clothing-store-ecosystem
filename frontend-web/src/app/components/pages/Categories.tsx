import React, { useState, useEffect } from 'react';
import { useTranslation } from 'react-i18next';
import { Card, CardContent, CardHeader, CardTitle } from '@/app/components/ui/card';
import { Button } from '@/app/components/ui/button';
import { Input } from '@/app/components/ui/input';
import { Badge } from '@/app/components/ui/badge';
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
} from '@/app/components/ui/dialog';
import { Plus, Edit, Trash2, Search, Filter, Download, AlertCircle } from 'lucide-react';
import { Label } from '@/app/components/ui/label';
import {
    Select,
    SelectContent,
    SelectItem,
    SelectTrigger,
    SelectValue,
} from '@/app/components/ui/select';
import { Alert, AlertDescription } from '@/app/components/ui/alert';
import api from '@/lib/api';

interface Category {
    id: number;
    name: string;
    slug: string;
    parent_id: number | null;
    parent?: {
        id: number;
        name: string;
    };
    is_active: boolean;
    created_at: string; 
    updated_at: string;
}

export function Categories() {
    const { t } = useTranslation();
    const [categories, setCategories] = useState<Category[]>([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState<string | null>(null);
    const [searchTerm, setSearchTerm] = useState('');
    const [isCreateDialogOpen, setIsCreateDialogOpen] = useState(false);
    const [isEditDialogOpen, setIsEditDialogOpen] = useState(false);
    const [editingCategory, setEditingCategory] = useState<Category | null>(null);
    const [formData, setFormData] = useState({
        name: '',
        slug: '',
        parent_id: 'null',
        is_active: true,
    });

    useEffect(() => {
        fetchCategories();
    }, []);

    const fetchCategories = async () => {
        try {
            setLoading(true);
            const response = await api.get('/v1/categories');
            setCategories(response.data.data);
        } catch (err) {
            console.error('Error fetching categories:', err);
            setError('Failed to load categories');
        } finally {
            setLoading(false);
        }
    };

    const generateSlug = (name: string) => {
        return name
            .toLowerCase()
            .replace(/[^a-z0-9]+/g, '-')
            .replace(/(^-|-$)+/g, '');
    };

    const handleNameChange = (e: React.ChangeEvent<HTMLInputElement>) => {
        const name = e.target.value;
        setFormData({
            ...formData,
            name,
            slug: generateSlug(name),
        });
    };

    const handleCreateCategory = async () => {
        try {
            const categoryData = {
                ...formData,
                parent_id: formData.parent_id === 'null' ? null : parseInt(formData.parent_id),
            };

            await api.post('/v1/categories', categoryData);
            setIsCreateDialogOpen(false);
            resetForm();
            fetchCategories();
        } catch (err) {
            console.error('Error creating category:', err);
            setError('Failed to create category');
        }
    };

    const handleUpdateCategory = async () => {
        if (!editingCategory) return;

        try {
            const categoryData = {
                ...formData,
                parent_id: formData.parent_id === 'null' ? null : parseInt(formData.parent_id),
            };

            await api.put(`/v1/categories/${editingCategory.id}`, categoryData);
            setIsEditDialogOpen(false);
            setEditingCategory(null);
            resetForm();
            fetchCategories();
        } catch (err) {
            console.error('Error updating category:', err);
            setError('Failed to update category');
        }
    };

    const handleDeleteCategory = async (id: number) => {
        if (!confirm('Are you sure you want to delete this category?')) return;

        try {
            await api.delete(`/v1/categories/${id}`);
            fetchCategories();
        } catch (err) {
            console.error('Error deleting category:', err);
            setError('Failed to delete category');
        }
    };

    const resetForm = () => {
        setFormData({
            name: '',
            slug: '',
            parent_id: 'null',
            is_active: true,
        });
    };

    const openEditDialog = (category: Category) => {
        setEditingCategory(category);
        setFormData({
            name: category.name,
            slug: category.slug,
            parent_id: category.parent_id ? category.parent_id.toString() : 'null',
            is_active: category.is_active,
        });
        setIsEditDialogOpen(true);
    };

    const filteredCategories = categories.filter((category) =>
        category.name.toLowerCase().includes(searchTerm.toLowerCase())
    );

    if (loading) {
        return (
            <div className="space-y-6">
                <Card>
                    <CardHeader>
                        <CardTitle>{t('categories')}</CardTitle>
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
                        <CardTitle>{t('categories')}</CardTitle>
                        <div className="flex gap-2">
                            <Button variant="outline" size="sm">
                                <Download className="w-4 h-4 mr-2" />
                                {t('export')}
                            </Button>
                            <Dialog open={isCreateDialogOpen} onOpenChange={setIsCreateDialogOpen}>
                                <DialogTrigger asChild>
                                    <Button size="sm">
                                        <Plus className="w-4 h-4 mr-2" />
                                        {t('addCategory')}
                                    </Button>
                                </DialogTrigger>
                                <DialogContent>
                                    <DialogHeader>
                                        <DialogTitle>{t('addCategory')}</DialogTitle>
                                    </DialogHeader>
                                    <div className="space-y-4">
                                        <div className="space-y-2">
                                            <Label>{t('categoryName')}</Label>
                                            <Input
                                                placeholder="Enter category name"
                                                value={formData.name}
                                                onChange={handleNameChange}
                                            />
                                        </div>
                                        <div className="space-y-2">
                                            <Label>{t('slug')}</Label>
                                            <Input
                                                placeholder="category-slug"
                                                value={formData.slug}
                                                onChange={(e) => setFormData({ ...formData, slug: e.target.value })}
                                            />
                                        </div>
                                        <div className="space-y-2">
                                            <Label>{t('parentCategory')}</Label>
                                            <Select
                                                value={formData.parent_id}
                                                onValueChange={(value) => setFormData({ ...formData, parent_id: value })}
                                            >
                                                <SelectTrigger>
                                                    <SelectValue placeholder="Select parent category" />
                                                </SelectTrigger>
                                                <SelectContent>
                                                    <SelectItem value="null">None</SelectItem>
                                                    {categories.map((category) => (
                                                        <SelectItem key={category.id} value={category.id.toString()}>
                                                            {category.name}
                                                        </SelectItem>
                                                    ))}
                                                </SelectContent>
                                            </Select>
                                        </div>
                                        <div className="space-y-2">
                                            <Label>{t('status')}</Label>
                                            <Select
                                                value={formData.is_active ? 'true' : 'false'}
                                                onValueChange={(value) => setFormData({ ...formData, is_active: value === 'true' })}
                                            >
                                                <SelectTrigger>
                                                    <SelectValue placeholder="Select status" />
                                                </SelectTrigger>
                                                <SelectContent>
                                                    <SelectItem value="true">{t('active')}</SelectItem>
                                                    <SelectItem value="false">{t('inactive')}</SelectItem>
                                                </SelectContent>
                                            </Select>
                                        </div>
                                        <div className="flex justify-end gap-2 mt-4">
                                            <Button variant="outline" onClick={() => setIsCreateDialogOpen(false)}>
                                                {t('cancel')}
                                            </Button>
                                            <Button onClick={handleCreateCategory}>{t('save')}</Button>
                                        </div>
                                    </div>
                                </DialogContent>
                            </Dialog>
                        </div>
                    </div>
                </CardHeader>
                <CardContent>
                    <div className="flex gap-2 mb-4">
                        <div className="relative flex-1">
                            <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground" />
                            <Input
                                placeholder={t('search')}
                                value={searchTerm}
                                onChange={(e) => setSearchTerm(e.target.value)}
                                className="pl-10"
                            />
                        </div>
                    </div>

                    <div className="border rounded-lg">
                        <Table>
                            <TableHeader>
                                <TableRow>
                                    <TableHead>{t('categoryName')}</TableHead>
                                    <TableHead>{t('slug')}</TableHead>
                                    <TableHead>{t('parentCategory')}</TableHead>
                                    <TableHead>{t('status')}</TableHead>
                                    <TableHead className="text-right">{t('actions')}</TableHead>
                                </TableRow>
                            </TableHeader>
                            <TableBody>
                                {filteredCategories.map((category) => (
                                    <TableRow key={category.id}>
                                        <TableCell className="font-medium">{category.name}</TableCell>
                                        <TableCell>{category.slug}</TableCell>
                                        <TableCell>{category.parent?.name || '-'}</TableCell>
                                        <TableCell>
                                            <Badge variant={category.is_active ? 'default' : 'secondary'}>
                                                {category.is_active ? t('active') : t('inactive')}
                                            </Badge>
                                        </TableCell>
                                        <TableCell className="text-right">
                                            <div className="flex gap-2 justify-end">
                                                <Button variant="ghost" size="icon" onClick={() => openEditDialog(category)}>
                                                    <Edit className="w-4 h-4" />
                                                </Button>
                                                <Button variant="ghost" size="icon" onClick={() => handleDeleteCategory(category.id)}>
                                                    <Trash2 className="w-4 h-4 text-destructive" />
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

            {/* Edit Dialog */}
            <Dialog open={isEditDialogOpen} onOpenChange={setIsEditDialogOpen}>
                <DialogContent>
                    <DialogHeader>
                        <DialogTitle>{t('editCategory')}</DialogTitle>
                    </DialogHeader>
                    <div className="space-y-4">
                        <div className="space-y-2">
                            <Label>{t('categoryName')}</Label>
                            <Input
                                placeholder="Enter category name"
                                value={formData.name}
                                onChange={handleNameChange}
                            />
                        </div>
                        <div className="space-y-2">
                            <Label>{t('slug')}</Label>
                            <Input
                                placeholder="category-slug"
                                value={formData.slug}
                                onChange={(e) => setFormData({ ...formData, slug: e.target.value })}
                            />
                        </div>
                        <div className="space-y-2">
                            <Label>{t('parentCategory')}</Label>
                            <Select
                                value={formData.parent_id}
                                onValueChange={(value) => setFormData({ ...formData, parent_id: value })}
                            >
                                <SelectTrigger>
                                    <SelectValue placeholder="Select parent category" />
                                </SelectTrigger>
                                <SelectContent>
                                    <SelectItem value="null">None</SelectItem>
                                    {categories
                                        .filter(c => c.id !== editingCategory?.id) // Prevent selecting self as parent
                                        .map((category) => (
                                            <SelectItem key={category.id} value={category.id.toString()}>
                                                {category.name}
                                            </SelectItem>
                                        ))}
                                </SelectContent>
                            </Select>
                        </div>
                        <div className="space-y-2">
                            <Label>{t('status')}</Label>
                            <Select
                                value={formData.is_active ? 'true' : 'false'}
                                onValueChange={(value) => setFormData({ ...formData, is_active: value === 'true' })}
                            >
                                <SelectTrigger>
                                    <SelectValue placeholder="Select status" />
                                </SelectTrigger>
                                <SelectContent>
                                    <SelectItem value="true">{t('active')}</SelectItem>
                                    <SelectItem value="false">{t('inactive')}</SelectItem>
                                </SelectContent>
                            </Select>
                        </div>
                        <div className="flex justify-end gap-2 mt-4">
                            <Button variant="outline" onClick={() => setIsEditDialogOpen(false)}>
                                {t('cancel')}
                            </Button>
                            <Button onClick={handleUpdateCategory}>{t('save')}</Button>
                        </div>
                    </div>
                </DialogContent>
            </Dialog>
        </div>
    );
}
