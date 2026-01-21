<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
        Schema::table('orders', function (Blueprint $table) {
            $table->index('status');
            $table->index('created_at');
            $table->index(['status', 'created_at']);
        });
        Schema::table('users', function (Blueprint $table) {
            $table->index('role');
            $table->index('created_at');
            $table->index(['role', 'created_at']);
        });
        Schema::table('order_items', function (Blueprint $table) {
            $table->index('order_id');
        });
    }

    public function down()
    {
        Schema::table('orders', function (Blueprint $table) {
            $table->dropIndex('orders_status_index');
            $table->dropIndex('orders_created_at_index');
            $table->dropIndex('orders_status_created_at_index');
        });
        Schema::table('users', function (Blueprint $table) {
            $table->dropIndex('users_role_index');
            $table->dropIndex('users_created_at_index');
            $table->dropIndex('users_role_created_at_index');
        });
        Schema::table('order_items', function (Blueprint $table) {
            $table->dropIndex('order_items_order_id_index');
        });
    }
};