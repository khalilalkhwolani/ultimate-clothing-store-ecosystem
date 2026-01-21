<?php

namespace Database\Seeders;

use App\Models\Cart;
use App\Models\CartItem;
use App\Models\ProductVariant;
use Faker\Factory as Faker;
use Illuminate\Database\Seeder;

class CartItemSeeder extends Seeder
{
    public function run(): void
    {
        $faker = Faker::create();
        $carts = Cart::all();
        $variants = ProductVariant::all();

        foreach ($carts as $cart) {
            // Create 1-4 items per cart
            $numItems = $faker->numberBetween(1, 4);
            $selectedVariants = $variants->random(min($numItems, $variants->count()));

            foreach ($selectedVariants as $variant) {
                CartItem::create([
                    'cart_id' => $cart->id,
                    'product_variant_id' => $variant->id,
                    'quantity' => $faker->numberBetween(1, 5),
                ]);
            }
        }
    }
}