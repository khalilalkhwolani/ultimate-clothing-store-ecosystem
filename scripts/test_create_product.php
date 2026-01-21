<?php

require __DIR__ . '/vendor/autoload.php';

$app = require_once __DIR__ . '/bootstrap/app.php';

$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

use App\Models\Category;
use App\Models\Product;

$category = Category::first();

if (!$category) {
    echo "No Categories Found. Please create a category first.\n";
    exit(1);
}

echo "Found Category: " . $category->name . " (ID: " . $category->id . ")\n";

try {
    $product = Product::create([
        'name' => 'Test Product Script',
        'description' => 'Test Description',
        'category_id' => $category->id,
        'brand' => 'Test Brand',
        'base_price' => 150.00,
        'is_featured' => true,
    ]);

    echo "Product Created Successfully!\n";
    echo "ID: " . $product->id . "\n";
    echo "Name: " . $product->name . "\n";

    // Create default variant manually as the controller does
    $product->productVariants()->create([
        'size' => 'default',
        'color' => 'default',
        'sku' => 'SKU-' . $product->id . '-' . time(),
        'price' => 150.00,
        'stock' => 10,
        'weight' => 0,
        'is_available' => true,
    ]);
    echo "Default Variant Created.\n";
} catch (\Exception $e) {
    echo "Error Creating Product: " . $e->getMessage() . "\n";
    exit(1);
}
