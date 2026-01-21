<?php

namespace Database\Seeders;

use App\Models\Order;
use App\Models\User;
use Faker\Factory as Faker;
use Illuminate\Database\Seeder;

class OrderSeeder extends Seeder
{
    public function run(): void
    {
        $faker = Faker::create();
        $customers = User::where('role', 'customer')->get();
        $statuses = ['pending', 'processing', 'shipped', 'delivered', 'cancelled'];
        $paymentStatuses = ['pending', 'paid', 'failed', 'refunded'];
        $paymentMethods = ['credit_card', 'paypal', 'bank_transfer', 'cash_on_delivery'];

        foreach ($customers as $customer) {
            // Create 1-3 orders per customer
            $numOrders = $faker->numberBetween(1, 3);
            for ($i = 0; $i < $numOrders; $i++) {
                $shippingAddress = [
                    'street' => $faker->streetAddress,
                    'city' => $faker->city,
                    'state' => $faker->state,
                    'zip_code' => $faker->postcode,
                    'country' => $faker->country,
                ];

                $billingAddress = $faker->boolean(80) ? $shippingAddress : [
                    'street' => $faker->streetAddress,
                    'city' => $faker->city,
                    'state' => $faker->state,
                    'zip_code' => $faker->postcode,
                    'country' => $faker->country,
                ];

                Order::create([
                    'user_id' => $customer->id,
                    'total_amount' => $faker->randomFloat(2, 50, 500),
                    'status' => $faker->randomElement($statuses),
                    'shipping_address' => $shippingAddress,
                    'billing_address' => $billingAddress,
                    'payment_method' => $faker->randomElement($paymentMethods),
                    'payment_status' => $faker->randomElement($paymentStatuses),
                ]);
            }
        }
    }
}