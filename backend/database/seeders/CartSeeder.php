<?php

namespace Database\Seeders;

use App\Models\Cart;
use App\Models\User;
use Faker\Factory as Faker;
use Illuminate\Database\Seeder;

class CartSeeder extends Seeder
{
    public function run(): void
    {
        $faker = Faker::create();
        $customers = User::where('role', 'customer')->get();

        foreach ($customers as $customer) {
            // Some customers have carts, some don't
            if ($faker->boolean(70)) { // 70% chance
                Cart::create([
                    'user_id' => $customer->id,
                    'session_id' => $faker->boolean(20) ? $faker->uuid : null, // Some have session_id
                ]);
            }
        }

        // Also create some guest carts
        for ($i = 0; $i < 3; $i++) {
            Cart::create([
                'user_id' => null,
                'session_id' => $faker->uuid,
            ]);
        }
    }
}