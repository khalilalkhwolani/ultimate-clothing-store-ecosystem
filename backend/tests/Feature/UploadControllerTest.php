<?php

namespace Tests\Feature;

use App\Models\Product;
use App\Models\Media;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;
use Tests\TestCase;

class UploadControllerTest extends TestCase
{
    use RefreshDatabase, WithFaker;

    protected $product;

    protected function setUp(): void
    {
        parent::setUp();
        
        // Create a test category first
        $category = \App\Models\Category::create([
            'name' => 'Test Category',
            'slug' => 'test-category',
            'description' => 'Test category for upload functionality',
        ]);
        
        // Create a test product for uploads
        $this->product = Product::create([
            'name' => 'Test Product',
            'description' => 'Test product for upload functionality',
            'base_price' => 99.99,
            'brand' => 'Test Brand',
            'category_id' => $category->id,
        ]);
    }

    public function test_single_image_upload()
    {
        Storage::fake('public');
        
        // Create a test image
        $file = UploadedFile::fake()->image('test_image.jpg', 800, 600);
        
        // Make the request
        $response = $this->post('/api/upload/product/' . $this->product->id, [
            'images' => [$file],
            'alt_text' => 'Test image alt text'
        ]);
        
        // Assert the response is successful
        $response->assertStatus(201);
        
        // Assert the image was stored
        $response->assertJsonStructure([
            'message',
            'data' => [
                'id',
                'model_type',
                'model_id',
                'file_path',
                'file_name',
                'mime_type',
                'alt_text',
                'thumbnail_path',
                'medium_path',
                'large_path',
                'created_at',
                'updated_at'
            ]
        ]);
        
        // Assert the media record was created
        $this->assertDatabaseHas('media', [
            'model_type' => 'product',
            'model_id' => $this->product->id,
            'alt_text' => 'Test image alt text'
        ]);
        
        // Verify all image sizes were created
        $media = Media::first();
        $this->assertNotNull($media->thumbnail_path);
        $this->assertNotNull($media->medium_path);
        $this->assertNotNull($media->large_path);
        
        // Verify the paths are set correctly
        $this->assertStringContainsString('images/product/original/', $media->file_path);
        $this->assertStringContainsString('images/product/thumbnail/', $media->thumbnail_path);
        $this->assertStringContainsString('images/product/medium/', $media->medium_path);
        $this->assertStringContainsString('images/product/large/', $media->large_path);
    }

    public function test_multiple_image_upload()
    {
        Storage::fake('public');
        
        // Create test images
        $files = [
            UploadedFile::fake()->image('test_image1.jpg', 800, 600),
            UploadedFile::fake()->image('test_image2.jpg', 1024, 768),
        ];
        
        // Make the request
        $response = $this->post('/api/upload/multiple/product/' . $this->product->id, [
            'images' => $files,
            'alt_text' => 'Multiple test images'
        ]);
        
        // Assert the response is successful
        $response->assertStatus(201);
        
        // Assert multiple media records were created
        $this->assertCount(2, Media::all());
        
        // Verify all images have their size paths
        foreach (Media::all() as $media) {
            $this->assertNotNull($media->thumbnail_path);
            $this->assertNotNull($media->medium_path);
            $this->assertNotNull($media->large_path);
        }
    }
}
