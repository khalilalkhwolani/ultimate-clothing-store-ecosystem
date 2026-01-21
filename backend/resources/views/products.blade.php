<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>إدارة المنتجات - متجر الملابس</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f8f9fa; }
        .product-card { transition: transform 0.3s; }
        .product-card:hover { transform: translateY(-5px); }
        .product-image { height: 200px; object-fit: cover; }
    </style>
</head>
<body>
    <div class="container-fluid mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2><i class="fas fa-tshirt me-2"></i>إدارة المنتجات</h2>
            <button class="btn btn-primary">
                <i class="fas fa-plus me-2"></i>إضافة منتج جديد
            </button>
        </div>

        <div class="row">
            <div class="col-md-4 mb-4">
                <div class="card product-card">
                    <img src="https://via.placeholder.com/300x200/007bff/ffffff?text=قميص+أزرق" class="card-img-top product-image" alt="قميص أزرق">
                    <div class="card-body">
                        <h5 class="card-title">قميص أزرق كلاسيكي</h5>
                        <p class="card-text">قميص أزرق أنيق مناسب للمناسبات الرسمية</p>
                        <div class="d-flex justify-content-between align-items-center">
                            <span class="h5 text-primary">$45.99</span>
                            <div>
                                <button class="btn btn-sm btn-outline-primary">تعديل</button>
                                <button class="btn btn-sm btn-outline-danger">حذف</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-4 mb-4">
                <div class="card product-card">
                    <img src="https://via.placeholder.com/300x200/28a745/ffffff?text=فستان+أحمر" class="card-img-top product-image" alt="فستان أحمر">
                    <div class="card-body">
                        <h5 class="card-title">فستان أحمر أنيق</h5>
                        <p class="card-text">فستان أحمر جميل مناسب للحفلات والمناسبات</p>
                        <div class="d-flex justify-content-between align-items-center">
                            <span class="h5 text-primary">$89.99</span>
                            <div>
                                <button class="btn btn-sm btn-outline-primary">تعديل</button>
                                <button class="btn btn-sm btn-outline-danger">حذف</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-4 mb-4">
                <div class="card product-card">
                    <img src="https://via.placeholder.com/300x200/6c757d/ffffff?text=بنطلون+جينز" class="card-img-top product-image" alt="بنطلون جينز">
                    <div class="card-body">
                        <h5 class="card-title">بنطلون جينز كلاسيكي</h5>
                        <p class="card-text">بنطلون جينز مريح ومناسب للاستخدام اليومي</p>
                        <div class="d-flex justify-content-between align-items-center">
                            <span class="h5 text-primary">$67.50</span>
                            <div>
                                <button class="btn btn-sm btn-outline-primary">تعديل</button>
                                <button class="btn btn-sm btn-outline-danger">حذف</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>