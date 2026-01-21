<?php

use Illuminate\Support\Facades\Route;
use App\Models\User;

Route::get('/', function () {
    return view('welcome');
});

// Route مباشر للوحة التحكم بدون مصادقة (للاختبار فقط)
Route::get('/dashboard-direct', function () {
    // إنشاء مستخدم وهمي للجلسة
    $user = User::first(); // أخذ أول مستخدم من قاعدة البيانات
    
    if (!$user) {
        // إنشاء مستخدم تجريبي إذا لم يوجد
        $user = User::create([
            'name' => 'Admin User',
            'email' => 'admin@test.com',
            'password' => bcrypt('password'),
            'role' => 'admin',
            'email_verified_at' => now(),
        ]);
    }
    
    // تسجيل دخول المستخدم تلقائياً
    auth()->login($user);
    
    // إعادة توجيه للوحة التحكم
    return redirect('/dashboard');
});

// صفحة لوحة التحكم البسيطة
Route::get('/dashboard', function () {
    return view('dashboard');
})->name('dashboard');

// صفحة المنتجات
Route::get('/products', function () {
    return view('products');
})->name('products');

// صفحة الطلبات
Route::get('/orders', function () {
    return view('orders');
})->name('orders');

// صفحة العملاء
Route::get('/customers', function () {
    return view('customers');
})->name('customers');