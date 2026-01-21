<?php

namespace Database\Seeders;

use App\Models\Setting;
use Illuminate\Database\Seeder;

class SettingSeeder extends Seeder
{
    public function run(): void
    {
        $settings = [
            ['key' => 'site_name', 'value' => 'E-Commerce Store', 'type' => 'string'],
            ['key' => 'site_description', 'value' => 'Your one-stop shop for quality products', 'type' => 'string'],
            ['key' => 'contact_email', 'value' => 'support@ecommerce.com', 'type' => 'string'],
            ['key' => 'contact_phone', 'value' => '+1-234-567-8900', 'type' => 'string'],
            ['key' => 'currency', 'value' => 'USD', 'type' => 'string'],
            ['key' => 'tax_rate', 'value' => '8.25', 'type' => 'decimal'],
            ['key' => 'shipping_fee', 'value' => '9.99', 'type' => 'decimal'],
            ['key' => 'free_shipping_threshold', 'value' => '100.00', 'type' => 'decimal'],
            ['key' => 'maintenance_mode', 'value' => 'false', 'type' => 'boolean'],
            ['key' => 'allow_guest_checkout', 'value' => 'true', 'type' => 'boolean'],
            ['key' => 'max_order_quantity', 'value' => '10', 'type' => 'integer'],
            ['key' => 'default_language', 'value' => 'en', 'type' => 'string'],
        ];

        foreach ($settings as $setting) {
            Setting::create($setting);
        }
    }
}