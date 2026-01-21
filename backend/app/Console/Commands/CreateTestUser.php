<?php

namespace App\Console\Commands;

use App\Models\User;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Hash;

class CreateTestUser extends Command
{
    protected $signature = 'user:create-test';
    protected $description = 'Create a test user for login testing';

    public function handle()
    {
        $email = 'test@example.com';
        
        // Check if user already exists
        if (User::where('email', $email)->exists()) {
            $this->info('Test user already exists!');
            $user = User::where('email', $email)->first();
        } else {
            // Create test user
            $user = User::create([
                'name' => 'Test User',
                'email' => $email,
                'password' => Hash::make('password123'),
                'role' => 'admin',
                'email_verified_at' => now(),
            ]);
            $this->info('Test user created successfully!');
        }
        
        $this->table(['Field', 'Value'], [
            ['ID', $user->id],
            ['Name', $user->name],
            ['Email', $user->email],
            ['Role', $user->role],
            ['Password', 'password123'],
        ]);
        
        return 0;
    }
}