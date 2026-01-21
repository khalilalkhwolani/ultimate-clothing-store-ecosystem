<?php

namespace Database\Seeders;

use App\Models\Inventory;
use App\Models\ProductVariant;
use Faker\Factory as Faker;
use Illuminate\Database\Seeder;

class InventorySeeder extends Seeder
{
    public function run(): void
    {
        $faker = Faker::create();
        $variants = ProductVariant::all();

        foreach ($variants as $variant) {
            Inventory::create([
                'product_variant_id' => $variant->id,
                'quantity' => $faker->numberBetween(0, 200),
                'low_stock_threshold' => $faker->numberBetween(5, 20),
                'last_restocked_at' => $faker->boolean(70) ? $faker->dateTimeThisYear : null,
                'status' => $faker->randomElement(['active', 'discontinued', 'out_of_stock']),
            ]);
        }
    }
}