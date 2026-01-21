<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\UploadImageRequest;
use App\Models\Media;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Str;
use Intervention\Image\ImageManager;
use Intervention\Image\Drivers\Gd\Driver;

class UploadController extends Controller
{
    /**
     * Upload a single image and associate it with a model.
     */
    public function uploadSingleImage(UploadImageRequest $request, string $model_type, int $model_id): JsonResponse
    {
        // Validate the request
        $validated = $request->validated();
        
        // Get the uploaded image
        $image = $request->file('images')[0];
        
        // Generate a unique file name
        $fileName = Str::uuid() . '.' . $image->getClientOriginalExtension();
        
        // Initialize Intervention Image manager
        $manager = new ImageManager(new Driver());
        
        // Define base path for storing images
        $basePath = 'images/' . $model_type . '/';
        
        // Create organized folder structure for different sizes
        $originalPath = $basePath . 'original/' . $fileName;
        $thumbnailPath = $basePath . 'thumbnail/' . $fileName;
        $mediumPath = $basePath . 'medium/' . $fileName;
        $largePath = $basePath . 'large/' . $fileName;
        
        // Store the original image
        $image->storeAs('public/' . $originalPath, $fileName);
        
        // Process and store resized images using Intervention Image
        $this->processImageSizes($manager, $image, $fileName, $basePath);
        
        // Create a media record in the database with all image paths
        $media = Media::create([
            'model_type' => $model_type,
            'model_id' => $model_id,
            'file_path' => $originalPath,
            'file_name' => $fileName,
            'mime_type' => $image->getClientMimeType(),
            'alt_text' => $request->input('alt_text', ''),
            'thumbnail_path' => $thumbnailPath,
            'medium_path' => $mediumPath,
            'large_path' => $largePath,
        ]);
        
        // Return a JSON response with the media data
        return response()->json([
            'message' => 'Image uploaded and processed successfully',
            'data' => $media,
        ], 201);
    }
    
    /**
     * Process image and create resized versions
     */
    private function processImageSizes(ImageManager $manager, $image, string $fileName, string $basePath): void
    {
        // Read the original image
        $originalImage = $manager->read($image->getPathname());
        
        // Define image sizes
        $sizes = [
            ['width' => 150, 'height' => 150, 'folder' => 'thumbnail'],
            ['width' => 600, 'height' => 600, 'folder' => 'medium'],
            ['width' => 1200, 'height' => 1200, 'folder' => 'large'],
        ];
        
        // Create directories if they don't exist
        foreach ($sizes as $size) {
            $directory = storage_path('app/public/' . $basePath . $size['folder']);
            if (!file_exists($directory)) {
                mkdir($directory, 0755, true);
            }
        }
        
        // Process each size
        foreach ($sizes as $size) {
            $resizedImage = $originalImage->resize($size['width'], $size['height'], function ($constraint) {
                $constraint->aspectRatio();
                $constraint->upsize();
            });
            
            // Optimize for web
            $resizedImage->toJpeg(85); // Convert to JPEG with 85% quality
            
            // Save the resized image
            $resizedImage->save(storage_path('app/public/' . $basePath . $size['folder'] . '/' . $fileName));
        }
    }

    /**
     * Upload multiple images and associate them with a model.
     */
    public function uploadMultipleImages(UploadImageRequest $request, string $model_type, int $model_id): JsonResponse
    {
        // Validate the request
        $validated = $request->validated();
        
        // Get all uploaded images
        $images = $request->file('images');
        
        $uploadedMedia = [];
        
        // Initialize Intervention Image manager
        $manager = new ImageManager(new Driver());
        
        // Define base path for storing images
        $basePath = 'images/' . $model_type . '/';
        
        // Process each image
        foreach ($images as $image) {
            // Generate a unique file name
            $fileName = Str::uuid() . '.' . $image->getClientOriginalExtension();
            
            // Create organized folder structure for different sizes
            $originalPath = $basePath . 'original/' . $fileName;
            $thumbnailPath = $basePath . 'thumbnail/' . $fileName;
            $mediumPath = $basePath . 'medium/' . $fileName;
            $largePath = $basePath . 'large/' . $fileName;
            
            // Store the original image
            $image->storeAs('public/' . $originalPath, $fileName);
            
            // Process and store resized images using Intervention Image
            $this->processImageSizes($manager, $image, $fileName, $basePath);
            
            // Create a media record in the database with all image paths
            $media = Media::create([
                'model_type' => $model_type,
                'model_id' => $model_id,
                'file_path' => $originalPath,
                'file_name' => $fileName,
                'mime_type' => $image->getClientMimeType(),
                'alt_text' => $request->input('alt_text', ''),
                'thumbnail_path' => $thumbnailPath,
                'medium_path' => $mediumPath,
                'large_path' => $largePath,
            ]);
            
            $uploadedMedia[] = $media;
        }
        
        // Return a JSON response with the uploaded media data
        return response()->json([
            'message' => 'Images uploaded and processed successfully',
            'data' => $uploadedMedia,
        ], 201);
    }
}
