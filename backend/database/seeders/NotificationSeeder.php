<?php

namespace Database\Seeders;

use App\Models\Notification;
use App\Models\User;
use Faker\Factory as Faker;
use Illuminate\Database\Seeder;

class NotificationSeeder extends Seeder
{
    public function run(): void
    {
        $faker = Faker::create();
        $users = User::all();
        $types = ['order_update', 'promotion', 'system', 'account'];

        foreach ($users as $user) {
            // Create 0-3 notifications per user
            $numNotifications = $faker->numberBetween(0, 3);
            for ($i = 0; $i < $numNotifications; $i++) {
                $type = $faker->randomElement($types);
                $data = [];

                switch ($type) {
                    case 'order_update':
                        $data = ['order_id' => $faker->numberBetween(1, 100)];
                        break;
                    case 'promotion':
                        $data = ['discount' => $faker->numberBetween(10, 50) . '%'];
                        break;
                    case 'system':
                        $data = ['message' => 'System maintenance scheduled'];
                        break;
                    case 'account':
                        $data = ['action' => 'Password changed'];
                        break;
                }

                Notification::create([
                    'user_id' => $user->id,
                    'title' => $faker->sentence(3),
                    'message' => $faker->paragraph,
                    'type' => $type,
                    'data' => $data,
                    'is_read' => $faker->boolean(50),
                    'read_at' => $faker->boolean(50) ? $faker->dateTimeThisMonth : null,
                ]);
            }
        }
    }
}