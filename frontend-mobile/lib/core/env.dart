class Env {
  // For Laravel Backend (php artisan serve runs on port 8000)
  // Use 127.0.0.1 for physical device with USB debugging
  // Or use 10.0.2.2 for Android Emulator
  static const String laravelBaseUrl = 'http://127.0.0.1:8000/api/v1';

  static const String fakeStoreBaseUrl = 'https://fakestoreapi.com';
}
