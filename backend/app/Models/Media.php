<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\MorphTo;

class Media extends Model
{
    protected $fillable = ['model_type', 'model_id', 'file_path', 'file_name', 'mime_type', 'alt_text', 'thumbnail_path', 'medium_path', 'large_path'];

    public function model(): MorphTo
    {
        return $this->morphTo();
    }
}
