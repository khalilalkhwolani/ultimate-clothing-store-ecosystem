<?php

namespace Database\Seeders;

use App\Models\Product;
use App\Models\ProductVariant;
use Faker\Factory as Faker;
use Illuminate\Database\Seeder;

class ProductVariantSeeder extends Seeder
{
    public function run(): void
    {
        $faker = Faker::create();
        $products = Product::all();
        $sizes = ['S', 'M', 'L', 'XL', 'XXL'];
        $colors = ['Red', 'Blue', 'Green', 'Black', 'White', 'Gray'];

        foreach ($products as $product) {
            // Create 2-4 variants per product
            $numVariants = $faker->numberBetween(2, 4);
            for ($i = 0; $i < $numVariants; $i++) {
                ProductVariant::create([
                    'product_id' => $product->id,
                    'size' => $faker->randomElement($sizes),
                    'color' => $faker->randomElement($colors),
                    'sku' => strtoupper($faker->unique()->bothify('???-####')),
                    'price' => $faker->randomFloat(2, $product->base_price * 0.8, $product->base_price * 1.5),
                    'stock' => $faker->numberBetween(10, 100),
                    'weight' => $faker->randomFloat(2, 0.5, 5.0),
                    'is_available' => $faker->boolean(90), // 90% chance available
                ]);
            }
        }
    }
}