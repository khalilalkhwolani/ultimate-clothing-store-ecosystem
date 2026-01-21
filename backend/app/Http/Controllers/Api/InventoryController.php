<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\DeductStockRequest;
use App\Http\Requests\InventoryIndexRequest;
use App\Http\Requests\InventoryStoreRequest;
use App\Http\Requests\InventoryUpdateRequest;
use App\Http\Requests\RestockRequest;
use App\Http\Resources\InventoryResource;
use App\Models\Inventory;
use App\Models\ProductVariant;
use Illuminate\Http\Request;

class InventoryController extends Controller
{
    public function index(InventoryIndexRequest $request)
    {
        $inventories = Inventory::with('productVariant')->get();
        return InventoryResource::collection($inventories);
    }

    public function show($id)
    {
        $inventory = Inventory::with('productVariant')->findOrFail($id);
        return new InventoryResource($inventory);
    }

    public function store(InventoryStoreRequest $request)
    {
        $inventory = Inventory::create($request->all());
        return new InventoryResource($inventory);
    }

    public function update(InventoryUpdateRequest $request, $id)
    {
        $inventory = Inventory::findOrFail($id);

        $inventory->update($request->all());
        return new InventoryResource($inventory);
    }

    public function destroy($id)
    {
        $inventory = Inventory::findOrFail($id);
        $inventory->delete();
        return response()->json(['message' => 'Inventory deleted successfully']);
    }

    public function restock(RestockRequest $request, $id)
    {
        $inventory = Inventory::findOrFail($id);

        $inventory->restock($request->quantity);
        return new InventoryResource($inventory);
    }

    public function deductStock(DeductStockRequest $request, $id)
    {
        $inventory = Inventory::findOrFail($id);

        $success = $inventory->deductStock($request->quantity);
        if (!$success) {
            return response()->json(['message' => 'Insufficient stock'], 400);
        }

        return new InventoryResource($inventory);
    }

    public function lowStock()
    {
        $inventories = Inventory::with('productVariant')->whereColumn('quantity', '<=', 'low_stock_threshold')->get();
        return InventoryResource::collection($inventories);
    }
}