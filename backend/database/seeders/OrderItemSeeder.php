<?php

namespace Database\Seeders;

use App\Models\Order;
use App\Models\OrderItem;
use App\Models\ProductVariant;
use Faker\Factory as Faker;
use Illuminate\Database\Seeder;

class OrderItemSeeder extends Seeder
{
    public function run(): void
    {
        $faker = Faker::create();
        $orders = Order::all();
        $variants = ProductVariant::all();

        foreach ($orders as $order) {
            // Create 1-5 items per order
            $numItems = $faker->numberBetween(1, 5);
            $selectedVariants = $variants->random(min($numItems, $variants->count()));

            foreach ($selectedVariants as $variant) {
                OrderItem::create([
                    'order_id' => $order->id,
                    'product_variant_id' => $variant->id,
                    'quantity' => $faker->numberBetween(1, 3),
                    'price' => $variant->price,
                ]);
            }
        }
    }
}