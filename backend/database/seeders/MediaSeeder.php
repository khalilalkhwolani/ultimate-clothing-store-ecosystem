<?php

namespace Database\Seeders;

use App\Models\Category;
use App\Models\Media;
use App\Models\Product;
use App\Models\ProductVariant;
use Faker\Factory as Faker;
use Illuminate\Database\Seeder;

class MediaSeeder extends Seeder
{
    public function run(): void
    {
        $faker = Faker::create();

        // Media for categories
        $categories = Category::all();
        foreach ($categories as $category) {
            Media::create([
                'model_type' => Category::class,
                'model_id' => $category->id,
                'file_path' => 'images/categories/' . $faker->uuid . '.jpg',
                'file_name' => $category->name . '.jpg',
                'mime_type' => 'image/jpeg',
                'alt_text' => $category->name . ' category image',
                'thumbnail_path' => 'images/categories/thumbnails/' . $faker->uuid . '.jpg',
                'medium_path' => 'images/categories/medium/' . $faker->uuid . '.jpg',
                'large_path' => 'images/categories/large/' . $faker->uuid . '.jpg',
            ]);
        }

        // Media for products
        $products = Product::all();
        foreach ($products as $product) {
            $numImages = $faker->numberBetween(1, 3);
            for ($i = 0; $i < $numImages; $i++) {
                Media::create([
                    'model_type' => Product::class,
                    'model_id' => $product->id,
                    'file_path' => 'images/products/' . $faker->uuid . '.jpg',
                    'file_name' => $product->name . '_' . ($i + 1) . '.jpg',
                    'mime_type' => 'image/jpeg',
                    'alt_text' => $product->name . ' product image',
                    'thumbnail_path' => 'images/products/thumbnails/' . $faker->uuid . '.jpg',
                    'medium_path' => 'images/products/medium/' . $faker->uuid . '.jpg',
                    'large_path' => 'images/products/large/' . $faker->uuid . '.jpg',
                ]);
            }
        }

        // Media for product variants (specific images)
        $variants = ProductVariant::all();
        foreach ($variants as $variant) {
            if ($faker->boolean(50)) { // 50% chance
                Media::create([
                    'model_type' => ProductVariant::class,
                    'model_id' => $variant->id,
                    'file_path' => 'images/variants/' . $faker->uuid . '.jpg',
                    'file_name' => $variant->product->name . '_' . $variant->color . '_' . $variant->size . '.jpg',
                    'mime_type' => 'image/jpeg',
                    'alt_text' => $variant->product->name . ' ' . $variant->color . ' ' . $variant->size,
                    'thumbnail_path' => 'images/variants/thumbnails/' . $faker->uuid . '.jpg',
                    'medium_path' => 'images/variants/medium/' . $faker->uuid . '.jpg',
                    'large_path' => 'images/variants/large/' . $faker->uuid . '.jpg',
                ]);
            }
        }
    }
}