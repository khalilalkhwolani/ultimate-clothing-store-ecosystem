<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\SettingIndexRequest;
use App\Http\Requests\SettingStoreRequest;
use App\Http\Requests\SettingUpdateRequest;
use App\Http\Resources\SettingResource;
use App\Models\Setting;
use Illuminate\Http\JsonResponse;

class SettingController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(SettingIndexRequest $request): JsonResponse
    {
        $query = Setting::query();

        if ($request->has('type')) {
            $query->where('type', $request->type);
        }

        $settings = $query->paginate($request->get('per_page', 15));

        return response()->json([
            'data' => SettingResource::collection($settings),
            'meta' => [
                'current_page' => $settings->currentPage(),
                'last_page' => $settings->lastPage(),
                'per_page' => $settings->perPage(),
                'total' => $settings->total(),
            ],
        ]);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(SettingStoreRequest $request): JsonResponse
    {
        $setting = Setting::create($request->validated());

        return response()->json([
            'message' => 'Setting created successfully',
            'data' => new SettingResource($setting),
        ], 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(Setting $setting): JsonResponse
    {
        return response()->json([
            'data' => new SettingResource($setting),
        ]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(SettingUpdateRequest $request, Setting $setting): JsonResponse
    {
        $setting->update($request->validated());

        return response()->json([
            'message' => 'Setting updated successfully',
            'data' => new SettingResource($setting),
        ]);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Setting $setting): JsonResponse
    {
        $setting->delete();

        return response()->json([
            'message' => 'Setting deleted successfully',
        ]);
    }
}