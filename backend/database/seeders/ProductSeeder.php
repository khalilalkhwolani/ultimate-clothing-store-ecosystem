<?php

namespace Database\Seeders;

use App\Models\Category;
use App\Models\Product;
use Faker\Factory as Faker;
use Illuminate\Database\Seeder;

class ProductSeeder extends Seeder
{
    public function run(): void
    {
        $faker = Faker::create();
        $categories = Category::whereNotNull('parent_id')->get();
        for ($i = 0; $i < 12; $i++) {
            Product::create([
                'name' => $faker->words(3, true),
                'description' => $faker->paragraph,
                'category_id' => $categories->random()->id,
                'brand' => $faker->company,
                'base_price' => $faker->randomFloat(2, 10, 500),
                'is_featured' => $faker->boolean,
            ]);
        }
    }
}