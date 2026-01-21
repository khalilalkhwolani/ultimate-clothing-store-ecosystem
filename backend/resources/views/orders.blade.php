<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>إدارة الطلبات - متجر الملابس</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa;
        }
        .card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
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
    <div class="container-fluid mt-4">
        <!-- Header -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2><i class="fas fa-shopping-cart me-2"></i>إدارة الطلبات</h2>
            <div>
                <button class="btn btn-success btn-custom me-2">
                    <i class="fas fa-download me-2"></i>تصدير Excel
                </button>
                <a href="/dashboard" class="btn btn-primary btn-custom">
                    <i class="fas fa-arrow-right me-2"></i>العودة للوحة التحكم
                </a>
            </div>
        </div>

        <!-- Filter Cards -->
        <div class="row mb-4">
            <div class="col-md-3 mb-3">
                <div class="card text-center" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white;">
                    <div class="card-body">
                        <h3>45</h3>
                        <p class="mb-0">إجمالي الطلبات</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3 mb-3">
                <div class="card text-center" style="background: linear-gradient(135deg, #56ab2f 0%, #a8e6cf 100%); color: white;">
                    <div class="card-body">
                        <h3>18</h3>
                        <p class="mb-0">طلبات مكتملة</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3 mb-3">
                <div class="card text-center" style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); color: white;">
                    <div class="card-body">
                        <h3>12</h3>
                        <p class="mb-0">قيد المعالجة</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3 mb-3">
                <div class="card text-center" style="background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%); color: white;">
                    <div class="card-body">
                        <h3>15</h3>
                        <p class="mb-0">تم الشحن</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Orders Table -->
        <div class="card">
            <div class="card-header bg-primary text-white">
                <h5 class="mb-0">
                    <i class="fas fa-list me-2"></i>
                    جميع الطلبات
                </h5>
            </div>
            <div class="card-body">
                <!-- Search and Filter -->
                <div class="row mb-3">
                    <div class="col-md-6">
                        <div class="input-group">
                            <input type="text" class="form-control" placeholder="البحث في الطلبات...">
                            <button class="btn btn-outline-secondary" type="button">
                                <i class="fas fa-search"></i>
                            </button>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <select class="form-select">
                            <option>جميع الحالات</option>
                            <option>مكتمل</option>
                            <option>قيد المعالجة</option>
                            <option>تم الشحن</option>
                            <option>ملغي</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <select class="form-select">
                            <option>آخر 30 يوم</option>
                            <option>آخر 7 أيام</option>
                            <option>هذا الشهر</option>
                            <option>الشهر الماضي</option>
                        </select>
                    </div>
                </div>

                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead class="table-light">
                            <tr>
                                <th>رقم الطلب</th>
                                <th>اسم العميل</th>
                                <th>البريد الإلكتروني</th>
                                <th>المنتجات</th>
                                <th>الكمية</th>
                                <th>المبلغ الإجمالي</th>
                                <th>الحالة</th>
                                <th>تاريخ الطلب</th>
                                <th>الإجراءات</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><strong>#ORD-001</strong></td>
                                <td>أحمد محمد علي</td>
                                <td>ahmed@example.com</td>
                                <td>قميص أزرق، بنطلون جينز</td>
                                <td>2</td>
                                <td><strong>$89.99</strong></td>
                                <td><span class="badge bg-success">مكتمل</span></td>
                                <td>2026-01-21</td>
                                <td>
                                    <button class="btn btn-sm btn-outline-primary" title="عرض التفاصيل">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                    <button class="btn btn-sm btn-outline-success" title="طباعة الفاتورة">
                                        <i class="fas fa-print"></i>
                                    </button>
                                    <button class="btn btn-sm btn-outline-warning" title="تعديل الحالة">
                                        <i class="fas fa-edit"></i>
                                    </button>
                                </td>
                            </tr>
                            <tr>
                                <td><strong>#ORD-002</strong></td>
                                <td>فاطمة علي حسن</td>
                                <td>fatima@example.com</td>
                                <td>فستان أحمر، حذاء أسود</td>
                                <td>2</td>
                                <td><strong>$156.50</strong></td>
                                <td><span class="badge bg-warning">قيد المعالجة</span></td>
                                <td>2026-01-21</td>
                                <td>
                                    <button class="btn btn-sm btn-outline-primary" title="عرض التفاصيل">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                    <button class="btn btn-sm btn-outline-success" title="طباعة الفاتورة">
                                        <i class="fas fa-print"></i>
                                    </button>
                                    <button class="btn btn-sm btn-outline-warning" title="تعديل الحالة">
                                        <i class="fas fa-edit"></i>
                                    </button>
                                </td>
                            </tr>
                            <tr>
                                <td><strong>#ORD-003</strong></td>
                                <td>محمد سالم أحمد</td>
                                <td>mohammed@example.com</td>
                                <td>جاكيت شتوي، قفازات، وشاح</td>
                                <td>3</td>
                                <td><strong>$234.00</strong></td>
                                <td><span class="badge bg-info">تم الشحن</span></td>
                                <td>2026-01-20</td>
                                <td>
                                    <button class="btn btn-sm btn-outline-primary" title="عرض التفاصيل">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                    <button class="btn btn-sm btn-outline-success" title="طباعة الفاتورة">
                                        <i class="fas fa-print"></i>
                                    </button>
                                    <button class="btn btn-sm btn-outline-warning" title="تعديل الحالة">
                                        <i class="fas fa-edit"></i>
                                    </button>
                                </td>
                            </tr>
                            <tr>
                                <td><strong>#ORD-004</strong></td>
                                <td>سارة أحمد محمد</td>
                                <td>sara@example.com</td>
                                <td>تنورة، بلوزة بيضاء</td>
                                <td>2</td>
                                <td><strong>$67.25</strong></td>
                                <td><span class="badge bg-danger">ملغي</span></td>
                                <td>2026-01-20</td>
                                <td>
                                    <button class="btn btn-sm btn-outline-primary" title="عرض التفاصيل">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                    <button class="btn btn-sm btn-outline-success" title="طباعة الفاتورة">
                                        <i class="fas fa-print"></i>
                                    </button>
                                    <button class="btn btn-sm btn-outline-warning" title="تعديل الحالة">
                                        <i class="fas fa-edit"></i>
                                    </button>
                                </td>
                            </tr>
                            <tr>
                                <td><strong>#ORD-005</strong></td>
                                <td>خالد عبدالله</td>
                                <td>khalid@example.com</td>
                                <td>بدلة رسمية، ربطة عنق</td>
                                <td>2</td>
                                <td><strong>$299.99</strong></td>
                                <td><span class="badge bg-success">مكتمل</span></td>
                                <td>2026-01-19</td>
                                <td>
                                    <button class="btn btn-sm btn-outline-primary" title="عرض التفاصيل">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                    <button class="btn btn-sm btn-outline-success" title="طباعة الفاتورة">
                                        <i class="fas fa-print"></i>
                                    </button>
                                    <button class="btn btn-sm btn-outline-warning" title="تعديل الحالة">
                                        <i class="fas fa-edit"></i>
                                    </button>
                                </td>
                            </tr>
                            <tr>
                                <td><strong>#ORD-006</strong></td>
                                <td>نورا حسام</td>
                                <td>nora@example.com</td>
                                <td>معطف شتوي، بوت جلدي</td>
                                <td>2</td>
                                <td><strong>$189.75</strong></td>
                                <td><span class="badge bg-info">تم الشحن</span></td>
                                <td>2026-01-19</td>
                                <td>
                                    <button class="btn btn-sm btn-outline-primary" title="عرض التفاصيل">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                    <button class="btn btn-sm btn-outline-success" title="طباعة الفاتورة">
                                        <i class="fas fa-print"></i>
                                    </button>
                                    <button class="btn btn-sm btn-outline-warning" title="تعديل الحالة">
                                        <i class="fas fa-edit"></i>
                                    </button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <!-- Pagination -->
                <nav aria-label="Page navigation" class="mt-4">
                    <ul class="pagination justify-content-center">
                        <li class="page-item disabled">
                            <a class="page-link" href="#" tabindex="-1">السابق</a>
                        </li>
                        <li class="page-item active"><a class="page-link" href="#">1</a></li>
                        <li class="page-item"><a class="page-link" href="#">2</a></li>
                        <li class="page-item"><a class="page-link" href="#">3</a></li>
                        <li class="page-item">
                            <a class="page-link" href="#">التالي</a>
                        </li>
                    </ul>
                </nav>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>