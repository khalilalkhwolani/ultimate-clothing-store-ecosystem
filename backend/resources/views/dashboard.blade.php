<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>لوحة التحكم - متجر الملابس</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa;
        }
        .sidebar {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            color: white;
        }
        .sidebar .nav-link {
            color: rgba(255,255,255,0.8);
            padding: 12px 20px;
            border-radius: 8px;
            margin: 5px 0;
            transition: all 0.3s;
        }
        .sidebar .nav-link:hover, .sidebar .nav-link.active {
            background-color: rgba(255,255,255,0.1);
            color: white;
        }
        .card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            transition: transform 0.3s;
        }
        .card:hover {
            transform: translateY(-5px);
        }
        .stat-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .stat-card-success {
            background: linear-gradient(135deg, #56ab2f 0%, #a8e6cf 100%);
        }
        .stat-card-warning {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
        }
        .stat-card-info {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
        }
        .navbar-brand {
            font-weight: bold;
            font-size: 1.5rem;
        }
        .table {
            border-radius: 10px;
            overflow: hidden;
        }
        .btn-custom {
            border-radius: 25px;
            padding: 8px 20px;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-3 col-lg-2 sidebar p-0">
                <div class="p-4">
                    <h4 class="text-center mb-4">
                        <i class="fas fa-store"></i>
                        متجر الملابس
                    </h4>
                    <nav class="nav flex-column">
                        <a class="nav-link active" href="#dashboard">
                            <i class="fas fa-tachometer-alt me-2"></i>
                            لوحة التحكم
                        </a>
                        <a class="nav-link" href="#products">
                            <i class="fas fa-tshirt me-2"></i>
                            المنتجات
                        </a>
                        <a class="nav-link" href="#orders">
                            <i class="fas fa-shopping-cart me-2"></i>
                            الطلبات
                        </a>
                        <a class="nav-link" href="#customers">
                            <i class="fas fa-users me-2"></i>
                            العملاء
                        </a>
                        <a class="nav-link" href="#categories">
                            <i class="fas fa-tags me-2"></i>
                            الفئات
                        </a>
                        <a class="nav-link" href="#inventory">
                            <i class="fas fa-boxes me-2"></i>
                            المخزون
                        </a>
                        <a class="nav-link" href="#reports">
                            <i class="fas fa-chart-bar me-2"></i>
                            التقارير
                        </a>
                        <a class="nav-link" href="#settings">
                            <i class="fas fa-cog me-2"></i>
                            الإعدادات
                        </a>
                    </nav>
                </div>
            </div>

            <!-- Main Content -->
            <div class="col-md-9 col-lg-10">
                <!-- Top Navigation -->
                <nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm mb-4">
                    <div class="container-fluid">
                        <span class="navbar-brand">مرحباً، {{ auth()->user()->name ?? 'المدير' }}</span>
                        <div class="d-flex">
                            <button class="btn btn-outline-primary btn-custom me-2">
                                <i class="fas fa-bell"></i>
                                الإشعارات
                            </button>
                            <button class="btn btn-primary btn-custom">
                                <i class="fas fa-user"></i>
                                الملف الشخصي
                            </button>
                        </div>
                    </div>
                </nav>

                <!-- Dashboard Content -->
                <div class="container-fluid">
                    <!-- Statistics Cards -->
                    <div class="row mb-4">
                        <div class="col-xl-3 col-md-6 mb-4">
                            <div class="card stat-card">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between">
                                        <div>
                                            <h6 class="card-title">إجمالي المنتجات</h6>
                                            <h2 class="mb-0">245</h2>
                                        </div>
                                        <div class="align-self-center">
                                            <i class="fas fa-tshirt fa-2x"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-xl-3 col-md-6 mb-4">
                            <div class="card stat-card-success">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between">
                                        <div>
                                            <h6 class="card-title">الطلبات الجديدة</h6>
                                            <h2 class="mb-0">18</h2>
                                        </div>
                                        <div class="align-self-center">
                                            <i class="fas fa-shopping-cart fa-2x"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-xl-3 col-md-6 mb-4">
                            <div class="card stat-card-warning">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between">
                                        <div>
                                            <h6 class="card-title">إجمالي العملاء</h6>
                                            <h2 class="mb-0">1,234</h2>
                                        </div>
                                        <div class="align-self-center">
                                            <i class="fas fa-users fa-2x"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-xl-3 col-md-6 mb-4">
                            <div class="card stat-card-info">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between">
                                        <div>
                                            <h6 class="card-title">إجمالي المبيعات</h6>
                                            <h2 class="mb-0">$45,678</h2>
                                        </div>
                                        <div class="align-self-center">
                                            <i class="fas fa-dollar-sign fa-2x"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Recent Orders Table -->
                    <div class="row">
                        <div class="col-12">
                            <div class="card">
                                <div class="card-header bg-primary text-white">
                                    <h5 class="mb-0">
                                        <i class="fas fa-list me-2"></i>
                                        الطلبات الأخيرة
                                    </h5>
                                </div>
                                <div class="card-body">
                                    <div class="table-responsive">
                                        <table class="table table-hover">
                                            <thead class="table-light">
                                                <tr>
                                                    <th>رقم الطلب</th>
                                                    <th>اسم العميل</th>
                                                    <th>المنتجات</th>
                                                    <th>المبلغ</th>
                                                    <th>الحالة</th>
                                                    <th>التاريخ</th>
                                                    <th>الإجراءات</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr>
                                                    <td>#ORD-001</td>
                                                    <td>أحمد محمد</td>
                                                    <td>قميص أزرق، بنطلون جينز</td>
                                                    <td>$89.99</td>
                                                    <td><span class="badge bg-success">مكتمل</span></td>
                                                    <td>2026-01-21</td>
                                                    <td>
                                                        <button class="btn btn-sm btn-outline-primary">عرض</button>
                                                        <button class="btn btn-sm btn-outline-secondary">طباعة</button>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>#ORD-002</td>
                                                    <td>فاطمة علي</td>
                                                    <td>فستان أحمر، حذاء أسود</td>
                                                    <td>$156.50</td>
                                                    <td><span class="badge bg-warning">قيد المعالجة</span></td>
                                                    <td>2026-01-21</td>
                                                    <td>
                                                        <button class="btn btn-sm btn-outline-primary">عرض</button>
                                                        <button class="btn btn-sm btn-outline-secondary">طباعة</button>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>#ORD-003</td>
                                                    <td>محمد سالم</td>
                                                    <td>جاكيت شتوي، قفازات</td>
                                                    <td>$234.00</td>
                                                    <td><span class="badge bg-info">تم الشحن</span></td>
                                                    <td>2026-01-20</td>
                                                    <td>
                                                        <button class="btn btn-sm btn-outline-primary">عرض</button>
                                                        <button class="btn btn-sm btn-outline-secondary">طباعة</button>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>#ORD-004</td>
                                                    <td>سارة أحمد</td>
                                                    <td>تنورة، بلوزة بيضاء</td>
                                                    <td>$67.25</td>
                                                    <td><span class="badge bg-danger">ملغي</span></td>
                                                    <td>2026-01-20</td>
                                                    <td>
                                                        <button class="btn btn-sm btn-outline-primary">عرض</button>
                                                        <button class="btn btn-sm btn-outline-secondary">طباعة</button>
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Quick Actions -->
                    <div class="row mt-4">
                        <div class="col-12">
                            <div class="card">
                                <div class="card-header bg-success text-white">
                                    <h5 class="mb-0">
                                        <i class="fas fa-bolt me-2"></i>
                                        إجراءات سريعة
                                    </h5>
                                </div>
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-md-3 mb-3">
                                            <button class="btn btn-primary btn-lg w-100 btn-custom">
                                                <i class="fas fa-plus-circle me-2"></i>
                                                إضافة منتج جديد
                                            </button>
                                        </div>
                                        <div class="col-md-3 mb-3">
                                            <button class="btn btn-success btn-lg w-100 btn-custom">
                                                <i class="fas fa-eye me-2"></i>
                                                عرض جميع الطلبات
                                            </button>
                                        </div>
                                        <div class="col-md-3 mb-3">
                                            <button class="btn btn-warning btn-lg w-100 btn-custom">
                                                <i class="fas fa-chart-line me-2"></i>
                                                تقرير المبيعات
                                            </button>
                                        </div>
                                        <div class="col-md-3 mb-3">
                                            <button class="btn btn-info btn-lg w-100 btn-custom">
                                                <i class="fas fa-warehouse me-2"></i>
                                                إدارة المخزون
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // إضافة تفاعل للروابط
        document.querySelectorAll('.nav-link').forEach(link => {
            link.addEventListener('click', function(e) {
                e.preventDefault();
                document.querySelectorAll('.nav-link').forEach(l => l.classList.remove('active'));
                this.classList.add('active');
            });
        });
    </script>
</body>
</html>