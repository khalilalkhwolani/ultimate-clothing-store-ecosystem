# تعليمات تسجيل الدخول - Login Instructions

## المشكلة التي تم حلها
كان هناك تضارب في إعدادات المصادقة وتدخل من CSRF middleware و CORS headers يمنع تسجيل الدخول من المتصفح.

## الحلول المطبقة

### 1. إصلاح إعدادات المصادقة (config/auth.php)
- إزالة التعريف المكرر لـ `guard`
- إضافة `api` guard للـ Sanctum
- تعيين `api` كـ guard افتراضي

### 2. إصلاح AuthController
- استبدال `Auth::attempt()` بـ `Hash::check()` لأن Sanctum لا يدعم `attempt()`
- تحسين منطق التحقق من كلمة المرور

### 3. إصلاح CORS Configuration (config/cors.php)
- إزالة `X-CSRF-TOKEN` و `X-XSRF-TOKEN` من `allowed_headers`
- إزالة CSRF headers من `exposed_headers`
- هذا يمنع المتصفح من توقع CSRF tokens للـ API requests

### 4. إصلاح CSRF Middleware (app/Http/Middleware/VerifyCsrfToken.php)
- استثناء جميع الـ API routes (`api/*`) من CSRF verification
- إزالة القيود الإجبارية على authentication routes

### 5. إصلاح Middleware Configuration (bootstrap/app.php)
- إزالة `EnsureFrontendRequestsAreStateful` middleware من API routes
- هذا الـ middleware يفعل session-based authentication ويطلب CSRF tokens
- إضافة `api/*` للـ CSRF exceptions

### 6. تنظيف API Routes (routes/api.php)
- إزالة CSRF token endpoint لأنه غير مطلوب للـ token-based authentication

## بيانات المستخدم التجريبي
```
Email: test@example.com
Password: password123
Role: admin
```

## كيفية تسجيل الدخول عبر API

### 1. تسجيل الدخول
```bash
POST /api/login
Content-Type: application/json

{
    "email": "test@example.com",
    "password": "password123"
}
```

**الاستجابة:**
```json
{
    "user": {
        "id": 7,
        "name": "Test User",
        "email": "test@example.com",
        "role": "admin"
    },
    "access_token": "2|rgl6t6IdiqLydWUSoDoJ2DJCtHJcClkQ6oAaOJxv8eddf3f3",
    "refresh_token": "glec4GhlB8kOEjADnKFMxzFCEh32wutQUBeu0KEuZpNMkWqTNLTUhiGUFDgI7Yn4"
}
```

### 2. استخدام التوكن للوصول للـ APIs المحمية
```bash
GET /api/user
Authorization: Bearer YOUR_ACCESS_TOKEN
Accept: application/json
```

### 3. الحصول على الملف الشخصي
```bash
GET /api/profile
Authorization: Bearer YOUR_ACCESS_TOKEN
Accept: application/json
```

### 4. تسجيل الخروج
```bash
POST /api/logout
Authorization: Bearer YOUR_ACCESS_TOKEN
Accept: application/json
```

## ملاحظات مهمة

1. **لا حاجة لـ CSRF tokens**: الـ API routes تستخدم token-based authentication وليس sessions
2. **التوكن**: احفظ `access_token` واستخدمه في header `Authorization: Bearer TOKEN`
3. **انتهاء الصلاحية**: استخدم `refresh_token` لتجديد التوكن عند انتهاء صلاحيته
4. **الحماية**: النظام يحتوي على حماية ضد محاولات الدخول المتكررة (5 محاولات خاطئة = قفل لمدة 15 دقيقة)
5. **CORS**: تم إصلاح إعدادات CORS لتعمل مع المتصفحات بدون تدخل من CSRF

## إنشاء مستخدمين جدد
```bash
php artisan user:create-test
```

## التحقق من حالة النظام
```bash
# عدد المستخدمين
php artisan tinker --execute="echo App\Models\User::count();"

# حالة قاعدة البيانات
php artisan migrate:status
```

## الفرق بين Token-based و Session-based Authentication

### Token-based (المستخدم حالياً)
- يستخدم Bearer tokens في Authorization header
- لا يحتاج cookies أو sessions
- لا يحتاج CSRF protection
- مناسب للـ APIs والتطبيقات المحمولة

### Session-based (للـ web applications)
- يستخدم cookies و sessions
- يحتاج CSRF protection
- مناسب للـ traditional web applications