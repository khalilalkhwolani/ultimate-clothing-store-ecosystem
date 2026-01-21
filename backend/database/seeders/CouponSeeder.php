<?php

namespace Database\Seeders;

use App\Models\Coupon;
use Faker\Factory as Faker;
use Illuminate\Database\Seeder;

class CouponSeeder extends Seeder
{
    public function run(): void
    {
        $faker = Faker::create();

        // Create some sample coupons
        $coupons = [
            [
                'code' => 'WELCOME10',
                'discount_type' => 'percentage',
                'discount_value' => 10.00,
                'min_order_amount' => 50.00,
                'usage_limit' => 100,
                'used_count' => $faker->numberBetween(0, 50),
                'expires_at' => $faker->dateTimeBetween('now', '+1 year'),
                'is_active' => true,
            ],
            [
                'code' => 'SAVE20',
                'discount_type' => 'fixed',
                'discount_value' => 20.00,
                'min_order_amount' => 100.00,
                'usage_limit' => 50,
                'used_count' => $faker->numberBetween(0, 25),
                'expires_at' => $faker->dateTimeBetween('now', '+6 months'),
                'is_active' => true,
            ],
            [
                'code' => 'FLASH50',
                'discount_type' => 'percentage',
                'discount_value' => 50.00,
                'min_order_amount' => 200.00,
                'usage_limit' => 10,
                'used_count' => $faker->numberBetween(0, 5),
                'expires_at' => $faker->dateTimeBetween('now', '+1 month'),
                'is_active' => true,
            ],
            [
                'code' => 'EXPIRED',
                'discount_type' => 'percentage',
                'discount_value' => 15.00,
                'min_order_amount' => 75.00,
                'usage_limit' => 20,
                'used_count' => 20,
                'expires_at' => $faker->dateTimeBetween('-1 month', '-1 day'),
                'is_active' => false,
            ],
        ];

        foreach ($coupons as $couponData) {
            Coupon::create($couponData);
        }
    }
}