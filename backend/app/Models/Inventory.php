<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Inventory extends Model
{
    use HasFactory;

    protected $fillable = [
        'product_variant_id',
        'quantity',
        'low_stock_threshold',
        'last_restocked_at',
        'status',
    ];

    protected $casts = [
        'last_restocked_at' => 'datetime',
    ];

    public function productVariant()
    {
        return $this->belongsTo(ProductVariant::class);
    }

    public function isLowStock()
    {
        return $this->quantity <= $this->low_stock_threshold;
    }

    public function updateStock($quantity)
    {
        $this->quantity = $quantity;
        $this->save();
    }

    public function restock($quantity)
    {
        $this->quantity += $quantity;
        $this->last_restocked_at = now();
        $this->save();
    }

    public function deductStock($quantity)
    {
        if ($this->quantity >= $quantity) {
            $this->quantity -= $quantity;
            $this->save();
            return true;
        }
        return false;
    }
}