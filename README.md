# 🛍️ Ultimate Clothing Store Ecosystem

A comprehensive, professional-grade e-commerce solution featuring a robust **Laravel API**, a dynamic **React/Vite Web Dashboard**, and a sleek **Flutter Mobile Application**.

[![Laravel](https://img.shields.io/badge/Backend-Laravel%2011-red?style=for-the-badge&logo=laravel)](https://laravel.com)
[![React](https://img.shields.io/badge/Web-React%2018-blue?style=for-the-badge&logo=react)](https://reactjs.org)
[![Flutter](https://img.shields.io/badge/Mobile-Flutter-02569B?style=for-the-badge&logo=flutter)](https://flutter.dev)
[![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)

---

## 🚀 Overview

This project is a full-stack ecosystem designed for modern clothing retail. It provides a seamless experience for both customers (via Mobile App) and administrators (via Web Dashboard), all powered by a high-performance RESTful API.

### ✨ Key Features

- **Backend (Laravel):**
  - Secure JWT Authentication.
  - Advanced Order Management & Lifecycle.
  - Inventory & Category Tracking.
  - Real-time Notifications via Firebase.
- **Web Dashboard (React + Vite):**
  - Premium UI with Shadcn/UI & Tailwind CSS.
  - Real-time Sales Analytics.
  - Product & Inventory Management.
  - User & Role Management.
- **Mobile App (Flutter):**
  - Smooth, Native UI/UX.
  - Firebase Integration for Auth & Messaging.
  - Dynamic Product Catalog & Search.
  - Real-time Order Tracking.

---

## 🏗️ Architecture

```mermaid
graph TD
    A[Flutter Mobile App] -->|REST API| B(Laravel Backend)
    C[React Web Dashboard] -->|REST API| B
    B --> D[(PostgreSQL/MySQL)]
    B --> E[Firebase Cloud Messaging]
    B --> F[Storage/S3]
```

---

## 📂 Project Structure

```text
.
├── backend/             # Laravel 11 API
├── frontend-web/        # React + Vite Dashboard
├── frontend-mobile/     # Flutter Mobile Application
├── docs/                # Documentation & API Specs
├── scripts/             # Maintenance & Utility Scripts
└── LICENSE              # MIT License
```

---

## 🛠️ Quick Start

### 1. Backend Setup
```bash
cd backend
composer install
cp .env.example .env
php artisan key:generate
php artisan migrate --seed
php artisan serve
```

### 2. Web Dashboard Setup
```bash
cd frontend-web
npm install
npm run dev
```

### 3. Mobile App Setup
```bash
cd frontend-mobile
flutter pub get
flutter run
```

---

## 📸 Gallery

### 📱 Mobile Application

| Home Screen | Product Details | Shopping Cart | Products Grid |
|-------------|-----------------|---------------|---------------|
| ![Home Screen](docs/img/mobile_home.png) | ![Product Details](docs/img/mobile_product.png) | ![Shopping Cart](docs/img/mobile_cart.png) | ![Products Grid](docs/img/products.jpg) |

| Login Screen | Signup Screen | Chat Feature | Multi-language |
|--------------|---------------|--------------|----------------|
| ![Login Screen](docs/img/login.jpg) | ![Signup Screen](docs/img/singup.jpg) | ![Chat Feature](docs/img/chat.jpg) | ![Multi-language](docs/img/lang-ar-en.jpg) |

### 💻 Web Dashboard

![Main Dashboard](docs/img/web_dashboard.png)
*Main Dashboard - Real-time Analytics & Management*

![Order Management](docs/img/order-web.png)
*Order Management System*

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---
<p align="center">Made with ❤️ for the Developer Community</p>
