<?php

namespace Database\Seeders;

use App\Models\Category;
use Illuminate\Database\Seeder;
use Illuminate\Support\Str;

class CategorySeeder extends Seeder
{
    public function run(): void
    {
        // Create top level categories
        $clothing = Category::create([
            'name' => 'Clothing',
            'slug' => Str::slug('Clothing'),
            'image' => null,
            'parent_id' => null,
            'is_active' => true,
        ]);

        $shoes = Category::create([
            'name' => 'Shoes',
            'slug' => Str::slug('Shoes'),
            'image' => null,
            'parent_id' => null,
            'is_active' => true,
        ]);

        Category::create([
            'name' => 'Accessories',
            'slug' => Str::slug('Accessories'),
            'image' => null,
            'parent_id' => null,
            'is_active' => true,
        ]);

        // Create children
        Category::create([
            'name' => 'Men\'s Clothing',
            'slug' => Str::slug('Men\'s Clothing'),
            'image' => null,
            'parent_id' => $clothing->id,
            'is_active' => true,
        ]);

        Category::create([
            'name' => 'Women\'s Clothing',
            'slug' => Str::slug('Women\'s Clothing'),
            'image' => null,
            'parent_id' => $clothing->id,
            'is_active' => true,
        ]);

        Category::create([
            'name' => 'Men\'s Shoes',
            'slug' => Str::slug('Men\'s Shoes'),
            'image' => null,
            'parent_id' => $shoes->id,
            'is_active' => true,
        ]);

        Category::create([
            'name' => 'Women\'s Shoes',
            'slug' => Str::slug('Women\'s Shoes'),
            'image' => null,
            'parent_id' => $shoes->id,
            'is_active' => true,
        ]);
    }
}