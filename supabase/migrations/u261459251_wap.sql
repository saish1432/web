-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Aug 13, 2025 at 04:56 AM
-- Server version: 10.11.10-MariaDB-log
-- PHP Version: 7.2.34

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `u261459251_wap`
--

-- --------------------------------------------------------

--
-- Table structure for table `admins`
--

CREATE TABLE `admins` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` enum('admin','manager','editor') DEFAULT 'admin',
  `status` enum('active','inactive') DEFAULT 'active',
  `profile_image_url` varchar(500) DEFAULT NULL,
  `last_login` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `admins`
--

INSERT INTO `admins` (`id`, `username`, `email`, `password_hash`, `role`, `status`, `profile_image_url`, `last_login`, `created_at`, `updated_at`) VALUES
(1, 'Admin', 'ADMIN@GTAI.IN', '$2y$10$.r7KaRDEyMRjmfV1SaQ2.eQDpekROZ0X7VUMeAuhfT1a9MFwRXW0e', 'admin', 'active', 'https://i.ibb.co/KpnvQbTG/Whats-App-Image-2024-12-02-at-8-48-16-AM.jpg', '2025-08-12 07:40:03', '2025-08-12 07:11:11', '2025-08-12 09:00:25');

-- --------------------------------------------------------

--
-- Table structure for table `admin_bypass_tokens`
--

CREATE TABLE `admin_bypass_tokens` (
  `id` int(11) NOT NULL,
  `admin_id` int(11) NOT NULL,
  `token` varchar(64) NOT NULL,
  `expires_at` timestamp NOT NULL,
  `used` tinyint(1) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `banners`
--

CREATE TABLE `banners` (
  `id` int(11) NOT NULL,
  `title` varchar(200) DEFAULT NULL,
  `image_url` varchar(500) NOT NULL,
  `link_url` varchar(500) DEFAULT NULL,
  `position` enum('top','bottom','both') DEFAULT 'both',
  `status` enum('active','inactive') DEFAULT 'active',
  `sort_order` int(11) DEFAULT 0,
  `click_count` int(11) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `banners`
--

INSERT INTO `banners` (`id`, `title`, `image_url`, `link_url`, `position`, `status`, `sort_order`, `click_count`, `created_at`, `updated_at`) VALUES
(1, 'Special Offer Banner', 'https://images.pexels.com/photos/3184360/pexels-photo-3184360.jpeg?auto=compress&cs=tinysrgb&w=800&h=200', 'https://example.com/offer', 'both', 'active', 1, 0, '2025-08-12 07:11:11', '2025-08-12 07:11:11'),
(2, 'New Products Banner', 'https://images.pexels.com/photos/3184338/pexels-photo-3184338.jpeg?auto=compress&cs=tinysrgb&w=800&h=200', 'https://example.com/products', 'both', 'active', 2, 0, '2025-08-12 07:11:11', '2025-08-12 07:11:11'),
(3, 'Contact Us Banner', 'https://images.pexels.com/photos/3184465/pexels-photo-3184465.jpeg?auto=compress&cs=tinysrgb&w=800&h=200', 'https://example.com/contact', 'both', 'active', 3, 0, '2025-08-12 07:11:11', '2025-08-12 07:11:11'),
(4, 'festivl sale', 'https://i.ibb.co/84QPFqXD/gradient-sale-landing-page-template-with-photo-23-2149042095.jpg', 'https://www.galaxytribes.in', 'top', 'active', 0, 0, '2025-08-12 08:50:24', '2025-08-12 08:50:24');

-- --------------------------------------------------------

--
-- Table structure for table `free_website_requests`
--

CREATE TABLE `free_website_requests` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `mobile` varchar(20) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `business_details` text DEFAULT NULL,
  `status` enum('pending','contacted','completed') DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `free_website_requests`
--

INSERT INTO `free_website_requests` (`id`, `name`, `mobile`, `email`, `business_details`, `status`, `created_at`, `updated_at`) VALUES
(1, 'maharaja', '9820323232', 'maharaja@yahoo.com', 'i need this', 'contacted', '2025-08-12 07:13:31', '2025-08-12 07:22:43');

-- --------------------------------------------------------

--
-- Table structure for table `gallery`
--

CREATE TABLE `gallery` (
  `id` int(11) NOT NULL,
  `title` varchar(200) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `image_url` varchar(500) NOT NULL,
  `thumbnail_url` varchar(500) DEFAULT NULL,
  `alt_text` varchar(200) DEFAULT NULL,
  `status` enum('active','inactive') DEFAULT 'active',
  `sort_order` int(11) DEFAULT 0,
  `upload_date` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `gallery`
--

INSERT INTO `gallery` (`id`, `title`, `description`, `image_url`, `thumbnail_url`, `alt_text`, `status`, `sort_order`, `upload_date`, `updated_at`) VALUES
(1, 'Office Interior', 'Our modern office space', 'https://images.pexels.com/photos/3184360/pexels-photo-3184360.jpeg?auto=compress&cs=tinysrgb&w=600', 'https://images.pexels.com/photos/3184360/pexels-photo-3184360.jpeg?auto=compress&cs=tinysrgb&w=300', 'Modern office interior', 'active', 1, '2025-08-12 07:11:11', '2025-08-12 07:11:11'),
(2, 'Team Meeting', 'Our professional team in action', 'https://images.pexels.com/photos/3184338/pexels-photo-3184338.jpeg?auto=compress&cs=tinysrgb&w=600', 'https://images.pexels.com/photos/3184338/pexels-photo-3184338.jpeg?auto=compress&cs=tinysrgb&w=300', 'Team meeting', 'active', 2, '2025-08-12 07:11:11', '2025-08-12 07:11:11'),
(3, 'Product Display', 'Our premium products showcase', 'https://images.pexels.com/photos/3184465/pexels-photo-3184465.jpeg?auto=compress&cs=tinysrgb&w=600', 'https://images.pexels.com/photos/3184465/pexels-photo-3184465.jpeg?auto=compress&cs=tinysrgb&w=300', 'Product display', 'active', 3, '2025-08-12 07:11:11', '2025-08-12 07:11:11'),
(4, 'Workshop', 'Behind the scenes of our production', 'https://images.pexels.com/photos/3184432/pexels-photo-3184432.jpeg?auto=compress&cs=tinysrgb&w=600', 'https://images.pexels.com/photos/3184432/pexels-photo-3184432.jpeg?auto=compress&cs=tinysrgb&w=300', 'Production workshop', 'active', 4, '2025-08-12 07:11:11', '2025-08-12 07:11:11');

-- --------------------------------------------------------

--
-- Table structure for table `inquiries`
--

CREATE TABLE `inquiries` (
  `id` int(11) NOT NULL,
  `user_name` varchar(100) NOT NULL,
  `user_phone` varchar(20) DEFAULT NULL,
  `user_email` varchar(100) DEFAULT NULL,
  `products` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`products`)),
  `message` text DEFAULT NULL,
  `status` enum('pending','contacted','completed') DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `user_id` int(11) DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `inquiries`
--

INSERT INTO `inquiries` (`id`, `user_name`, `user_phone`, `user_email`, `products`, `message`, `status`, `created_at`, `updated_at`, `user_id`, `ip_address`) VALUES
(1, 'Guest User', '', '', '[{\"id\":5,\"title\":\"Website Development\",\"price\":\"12000.00\",\"image_url\":\"https:\\/\\/images.pexels.com\\/photos\\/3184360\\/pexels-photo-3184360.jpeg?auto=compress&cs=tinysrgb&w=400\"}]', 'Product Inquiry:\n\nWebsite Development - ₹12000.00\n\nPlease provide more details about these products.', 'pending', '2025-08-12 07:14:16', '2025-08-12 07:14:16', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `inquiry_products`
--

CREATE TABLE `inquiry_products` (
  `id` int(11) NOT NULL,
  `title` varchar(200) NOT NULL,
  `description` text DEFAULT NULL,
  `price` decimal(10,2) NOT NULL DEFAULT 0.00,
  `image_url` varchar(500) NOT NULL,
  `file_size` int(11) DEFAULT NULL,
  `status` enum('active','inactive') DEFAULT 'active',
  `sort_order` int(11) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `inquiry_products`
--

INSERT INTO `inquiry_products` (`id`, `title`, `description`, `price`, `image_url`, `file_size`, `status`, `sort_order`, `created_at`, `updated_at`) VALUES
(1, 'Custom Logo Design', 'Professional logo design with unlimited revisions', 1500.00, 'https://images.pexels.com/photos/3184432/pexels-photo-3184432.jpeg?auto=compress&cs=tinysrgb&w=400', 150000, 'active', 1, '2025-08-12 08:22:59', '2025-08-12 08:22:59'),
(2, 'Website Development', 'Custom website development with responsive design', 15000.00, 'https://images.pexels.com/photos/3184360/pexels-photo-3184360.jpeg?auto=compress&cs=tinysrgb&w=400', 180000, 'active', 2, '2025-08-12 08:22:59', '2025-08-12 08:22:59'),
(3, 'Branding Package', 'Complete branding solution for your business', 5000.00, 'https://images.pexels.com/photos/3184339/pexels-photo-3184339.jpeg?auto=compress&cs=tinysrgb&w=400', 160000, 'active', 3, '2025-08-12 08:22:59', '2025-08-12 08:22:59'),
(4, 'Digital Marketing', 'Social media and digital marketing services', 3000.00, 'https://images.pexels.com/photos/3184465/pexels-photo-3184465.jpeg?auto=compress&cs=tinysrgb&w=400', 170000, 'active', 4, '2025-08-12 08:22:59', '2025-08-12 08:22:59');

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` int(11) NOT NULL,
  `order_number` varchar(50) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `user_name` varchar(100) DEFAULT NULL,
  `user_phone` varchar(20) DEFAULT NULL,
  `user_email` varchar(100) DEFAULT NULL,
  `total_amount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `discount_amount` decimal(10,2) DEFAULT 0.00,
  `final_amount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `status` enum('pending','confirmed','paid','shipped','delivered','cancelled') DEFAULT 'pending',
  `payment_status` enum('pending','paid','failed','refunded') DEFAULT 'pending',
  `payment_method` varchar(50) DEFAULT 'upi',
  `notes` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `order_number`, `user_id`, `user_name`, `user_phone`, `user_email`, `total_amount`, `discount_amount`, `final_amount`, `status`, `payment_status`, `payment_method`, `notes`, `created_at`, `updated_at`) VALUES
(1, 'ORD202508131003', NULL, 'Guest User', '', '', 99.00, 0.00, 99.00, 'pending', 'pending', 'upi', NULL, '2025-08-13 04:54:54', '2025-08-13 04:54:54'),
(2, 'ORD202508135476', NULL, 'Guest User', '', '', 399.00, 0.00, 399.00, 'pending', 'pending', 'upi', NULL, '2025-08-13 04:55:08', '2025-08-13 04:55:08');

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--

CREATE TABLE `order_items` (
  `id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `product_title` varchar(200) NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT 1,
  `unit_price` decimal(10,2) NOT NULL DEFAULT 0.00,
  `total_price` decimal(10,2) NOT NULL DEFAULT 0.00,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `order_items`
--

INSERT INTO `order_items` (`id`, `order_id`, `product_id`, `product_title`, `quantity`, `unit_price`, `total_price`, `created_at`) VALUES
(1, 1, 6, 'NFC Card', 1, 99.00, 99.00, '2025-08-13 04:54:54'),
(2, 2, 1, 'Premium Business Card', 1, 399.00, 399.00, '2025-08-13 04:55:08');

-- --------------------------------------------------------

--
-- Table structure for table `pdfs`
--

CREATE TABLE `pdfs` (
  `id` int(11) NOT NULL,
  `title` varchar(200) NOT NULL,
  `description` text DEFAULT NULL,
  `file_url` varchar(500) NOT NULL,
  `file_size` int(11) DEFAULT NULL,
  `status` enum('active','inactive') DEFAULT 'active',
  `sort_order` int(11) DEFAULT 0,
  `download_count` int(11) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `pdfs`
--

INSERT INTO `pdfs` (`id`, `title`, `description`, `file_url`, `file_size`, `status`, `sort_order`, `download_count`, `created_at`, `updated_at`) VALUES
(1, 'Company Brochure', 'Download our complete company brochure', 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 1024000, 'active', 1, 0, '2025-08-12 07:11:11', '2025-08-12 07:11:11'),
(2, 'Product Catalog', 'Complete catalog of all our products and services', 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 2048000, 'active', 2, 0, '2025-08-12 07:11:11', '2025-08-12 07:11:11'),
(3, 'Price List', 'Current pricing for all products and services', 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 512000, 'active', 3, 0, '2025-08-12 07:11:11', '2025-08-12 07:11:11'),
(4, 'Company Profile', 'Detailed company profile and credentials', 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 1536000, 'active', 4, 0, '2025-08-12 07:11:11', '2025-08-12 07:11:11'),
(5, 'Portfolio', 'Portfolio of our completed projects', 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 3072000, 'active', 5, 0, '2025-08-12 07:11:11', '2025-08-12 07:11:11');

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `id` int(11) NOT NULL,
  `title` varchar(200) NOT NULL,
  `description` text DEFAULT NULL,
  `price` decimal(10,2) NOT NULL DEFAULT 0.00,
  `discount_price` decimal(10,2) DEFAULT NULL,
  `qty_stock` int(11) DEFAULT 0,
  `image_url` varchar(500) NOT NULL,
  `gallery_images` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`gallery_images`)),
  `inquiry_only` tinyint(1) DEFAULT 0,
  `status` enum('active','inactive') DEFAULT 'active',
  `sort_order` int(11) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `title`, `description`, `price`, `discount_price`, `qty_stock`, `image_url`, `gallery_images`, `inquiry_only`, `status`, `sort_order`, `created_at`, `updated_at`) VALUES
(1, 'Premium Business Card', 'High-quality business cards with premium finish and professional design', 500.00, 399.00, 100, 'https://images.pexels.com/photos/6289065/pexels-photo-6289065.jpeg?auto=compress&cs=tinysrgb&w=400', NULL, 0, 'active', 1, '2025-08-12 07:11:11', '2025-08-12 07:11:11'),
(2, 'Digital Visiting Card', 'Modern digital visiting card solution with QR code and social media integration', 299.00, NULL, 50, 'https://images.pexels.com/photos/6289025/pexels-photo-6289025.jpeg?auto=compress&cs=tinysrgb&w=400', NULL, 0, 'active', 2, '2025-08-12 07:11:11', '2025-08-12 07:11:11'),
(3, 'Corporate Branding Package', 'Complete corporate branding solution including logo, letterhead, and business cards', 2999.00, 1999.00, 20, 'https://images.pexels.com/photos/3184339/pexels-photo-3184339.jpeg?auto=compress&cs=tinysrgb&w=400', NULL, 0, 'active', 3, '2025-08-12 07:11:11', '2025-08-12 07:11:11'),
(4, 'Logo Design Service', 'Professional logo design service with unlimited revisions', 1500.00, NULL, 0, 'https://images.pexels.com/photos/3184432/pexels-photo-3184432.jpeg?auto=compress&cs=tinysrgb&w=400', NULL, 1, 'active', 4, '2025-08-12 07:11:11', '2025-08-12 07:11:11'),
(5, 'Website Development', 'Custom website development with responsive design and SEO optimization', 15000.00, 12000.00, 0, 'https://images.pexels.com/photos/3184360/pexels-photo-3184360.jpeg?auto=compress&cs=tinysrgb&w=400', NULL, 1, 'active', 5, '2025-08-12 07:11:11', '2025-08-12 07:11:11'),
(6, 'NFC Card', 'Tap to share', 199.00, 99.00, 0, 'https://i.ibb.co/2X73Dpp/color-gt-tag-n.jpg', NULL, 0, 'active', 6, '2025-08-12 07:21:43', '2025-08-12 08:22:59'),
(8, 'Google Extractor Tool', 'Lifetime Get Leads for your Business', 999.00, 499.00, 0, 'https://i.ibb.co/wNd5MPBW/google-extr.jpg', NULL, 0, 'active', 0, '2025-08-12 08:46:28', '2025-08-12 08:46:28');

-- --------------------------------------------------------

--
-- Table structure for table `reviews`
--

CREATE TABLE `reviews` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `rating` int(11) NOT NULL CHECK (`rating` >= 1 and `rating` <= 5),
  `comment` text NOT NULL,
  `status` enum('pending','approved','rejected') DEFAULT 'pending',
  `ip_address` varchar(45) DEFAULT NULL,
  `approved_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `reviews`
--

INSERT INTO `reviews` (`id`, `name`, `email`, `phone`, `rating`, `comment`, `status`, `ip_address`, `approved_at`, `created_at`, `updated_at`) VALUES
(1, 'Rajesh Kumar', 'rajesh@example.com', '9876543210', 5, 'Excellent service and professional quality work. Highly recommended for business cards!', 'approved', NULL, '2025-08-12 07:11:11', '2025-08-12 07:11:11', '2025-08-12 07:11:11'),
(2, 'Priya Singh', 'priya@example.com', '9876543211', 4, 'Great experience with their team. Very responsive and helpful throughout the process.', 'approved', NULL, '2025-08-12 07:11:11', '2025-08-12 07:11:11', '2025-08-12 07:11:11'),
(3, 'Amit Patel', 'amit@example.com', '9876543212', 5, 'Outstanding digital visiting card service. Modern design and quick delivery.', 'approved', NULL, '2025-08-12 07:11:11', '2025-08-12 07:11:11', '2025-08-12 07:11:11'),
(4, 'Sneha Sharma', 'sneha@example.com', '9876543213', 4, 'Professional branding package exceeded my expectations. Worth every penny!', 'approved', NULL, '2025-08-12 07:11:11', '2025-08-12 07:11:11', '2025-08-12 07:11:11'),
(5, 'rani', 'rani@yahoo.com', '9865326598', 5, 'loved it service', 'approved', '2401:4900:1c9a:d026:3024:4c0:7d17:e807', '2025-08-12 07:19:20', '2025-08-12 07:14:46', '2025-08-12 07:19:20');

-- --------------------------------------------------------

--
-- Table structure for table `site_settings`
--

CREATE TABLE `site_settings` (
  `id` int(11) NOT NULL,
  `setting_key` varchar(100) NOT NULL,
  `setting_value` text DEFAULT NULL,
  `setting_type` enum('text','number','boolean','json') DEFAULT 'text',
  `description` text DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `site_settings`
--

INSERT INTO `site_settings` (`id`, `setting_key`, `setting_value`, `setting_type`, `description`, `updated_at`) VALUES
(1, 'site_title', 'GT Digital', 'text', 'Website title', '2025-08-12 07:24:14'),
(2, 'company_name', 'GalaxyTribes', 'text', 'Company name', '2025-08-12 07:24:14'),
(3, 'director_name', 'GTAI', 'text', 'Director name', '2025-08-12 07:24:14'),
(4, 'director_title', 'FOUNDER', 'text', 'Director title', '2025-08-12 07:11:11'),
(5, 'contact_phone1', '9765834383', 'text', 'Primary phone number', '2025-08-12 07:11:11'),
(6, 'contact_phone2', '9765834383', 'text', 'Secondary phone number', '2025-08-12 07:11:11'),
(7, 'contact_email', 'info@galaxytribes.in', 'text', 'Contact email', '2025-08-12 07:11:11'),
(8, 'contact_address', 'Nashik, Maharashtra, India', 'text', 'Business address', '2025-08-12 07:11:11'),
(9, 'whatsapp_number', '919765834383', 'text', 'WhatsApp number with country code', '2025-08-12 07:11:11'),
(10, 'website_url', 'https://galaxytribes.in', 'text', 'Website URL', '2025-08-12 07:11:11'),
(11, 'upi_id', 'vishrajrathod@kotak', 'text', 'UPI ID for payments', '2025-08-12 07:24:14'),
(12, 'meta_description', 'Professional digital visiting card and business services. Get your custom business card, logo design, and corporate branding solutions.', 'text', 'Meta description for SEO', '2025-08-12 07:11:11'),
(13, 'meta_keywords', 'visiting card, business card, digital card, logo design, branding, corporate identity', 'text', 'Meta keywords for SEO', '2025-08-12 07:11:11'),
(14, 'current_theme', 'blue-dark', 'text', 'Current website theme', '2025-08-12 07:49:08'),
(15, 'discount_text', 'DISCOUNT UPTO 50% Live ', 'text', 'Discount popup text', '2025-08-12 07:24:14'),
(16, 'show_discount_popup', '1', 'boolean', 'Show discount popup', '2025-08-12 07:24:14'),
(17, 'show_pwa_prompt', '1', 'boolean', 'Show PWA install prompt', '2025-08-12 07:38:29'),
(18, 'social_facebook', 'https://facebook.com/demo', 'text', 'Facebook page URL', '2025-08-12 07:11:11'),
(19, 'social_youtube', 'https://youtube.com/demo', 'text', 'YouTube channel URL', '2025-08-12 07:11:11'),
(20, 'social_twitter', 'https://twitter.com/demo', 'text', 'Twitter profile URL', '2025-08-12 07:11:11'),
(21, 'social_instagram', 'https://instagram.com/demo', 'text', 'Instagram profile URL', '2025-08-12 07:11:11'),
(22, 'social_linkedin', 'https://linkedin.com/company/demo', 'text', 'LinkedIn page URL', '2025-08-12 07:11:11'),
(23, 'social_pinterest', 'https://pinterest.com/demo', 'text', 'Pinterest profile URL', '2025-08-12 07:11:11'),
(24, 'social_telegram', 'https://t.me/demo', 'text', 'Telegram channel URL', '2025-08-12 07:11:11'),
(25, 'social_zomato', 'https://zomato.com/demo', 'text', 'Zomato restaurant URL', '2025-08-12 07:11:11'),
(26, 'view_count', '51', 'text', NULL, '2025-08-13 04:53:55');

-- --------------------------------------------------------

--
-- Table structure for table `transactions`
--

CREATE TABLE `transactions` (
  `id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `transaction_id` varchar(100) DEFAULT NULL,
  `upi_id` varchar(100) DEFAULT NULL,
  `amount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `status` enum('pending','success','failed','cancelled') DEFAULT 'pending',
  `payment_method` varchar(50) DEFAULT 'upi',
  `gateway_response` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`gateway_response`)),
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `translations`
--

CREATE TABLE `translations` (
  `id` int(11) NOT NULL,
  `language_code` varchar(5) NOT NULL,
  `translation_key` varchar(100) NOT NULL,
  `translation_value` text NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `translations`
--

INSERT INTO `translations` (`id`, `language_code`, `translation_key`, `translation_value`, `created_at`, `updated_at`) VALUES
(1, 'en', 'welcome', 'Welcome', '2025-08-12 07:11:11', '2025-08-12 07:11:11'),
(2, 'en', 'home', 'Home', '2025-08-12 07:11:11', '2025-08-12 07:11:11'),
(3, 'en', 'about', 'About Us', '2025-08-12 07:11:11', '2025-08-12 07:11:11'),
(4, 'en', 'products', 'Products', '2025-08-12 07:11:11', '2025-08-12 07:11:11'),
(5, 'en', 'contact', 'Contact', '2025-08-12 07:11:11', '2025-08-12 07:11:11'),
(6, 'en', 'gallery', 'Gallery', '2025-08-12 07:11:11', '2025-08-12 07:11:11'),
(7, 'en', 'videos', 'Videos', '2025-08-12 07:11:11', '2025-08-12 07:11:11'),
(8, 'en', 'reviews', 'Reviews', '2025-08-12 07:11:11', '2025-08-12 07:11:11'),
(9, 'en', 'cart', 'Cart', '2025-08-12 07:11:11', '2025-08-12 07:11:11'),
(10, 'en', 'add_to_cart', 'Add to Cart', '2025-08-12 07:11:11', '2025-08-12 07:11:11'),
(11, 'en', 'inquiry', 'Inquiry', '2025-08-12 07:11:11', '2025-08-12 07:11:11'),
(12, 'hi', 'welcome', 'स्वागत', '2025-08-12 07:11:11', '2025-08-12 07:11:11'),
(13, 'hi', 'home', 'होम', '2025-08-12 07:11:11', '2025-08-12 07:11:11'),
(14, 'hi', 'about', 'हमारे बारे में', '2025-08-12 07:11:11', '2025-08-12 07:11:11'),
(15, 'hi', 'products', 'उत्पाद', '2025-08-12 07:11:11', '2025-08-12 07:11:11'),
(16, 'hi', 'contact', 'संपर्क', '2025-08-12 07:11:11', '2025-08-12 07:11:11'),
(17, 'hi', 'gallery', 'गैलरी', '2025-08-12 07:11:11', '2025-08-12 07:11:11'),
(18, 'hi', 'videos', 'वीडियो', '2025-08-12 07:11:11', '2025-08-12 07:11:11'),
(19, 'hi', 'reviews', 'समीक्षा', '2025-08-12 07:11:11', '2025-08-12 07:11:11'),
(20, 'hi', 'cart', 'कार्ट', '2025-08-12 07:11:11', '2025-08-12 07:11:11'),
(21, 'hi', 'add_to_cart', 'कार्ट में जोड़ें', '2025-08-12 07:11:11', '2025-08-12 07:11:11'),
(22, 'hi', 'inquiry', 'पूछताछ', '2025-08-12 07:11:11', '2025-08-12 07:11:11');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `password_hash` varchar(255) NOT NULL,
  `status` enum('active','inactive') DEFAULT 'active',
  `email_verified` tinyint(1) DEFAULT 0,
  `last_login` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `username`, `email`, `phone`, `password_hash`, `status`, `email_verified`, `last_login`, `created_at`, `updated_at`) VALUES
(1, 'vishal', 'vishal', 'vishal@yahoo.com', '9820326565', '$2y$10$nDAphDthk3VvtophxHJRIO.YWqyNNBD3pKqXnW/IIC59GgulvpKB.', 'active', 0, '2025-08-12 07:15:46', '2025-08-12 07:15:39', '2025-08-12 07:15:46'),
(2, 'swami', 'swami', 'swami@yahoo.com', '9865989898', '$2y$10$B5MNX7n0p2a2k4C4WFzAJOYf.d.1nfdneUfIzJWbQAbpihsggdvcC', 'active', 0, '2025-08-12 07:16:37', '2025-08-12 07:16:29', '2025-08-12 07:16:37'),
(3, 'Ram', 'ram', 'ram@gmail.com', '9820333333', '$2y$10$GUu02WQtrXCiJYPNqagSiuYxGu9/Wkne97Uw6P3t9vJfuqUFsgnN.', 'active', 0, '2025-08-12 07:32:01', '2025-08-12 07:31:51', '2025-08-12 07:32:01'),
(4, 'kusum', 'kusum', 'kusum@yahoo.com', '9865656565', '$2y$10$8vVDR3R2KD1KYEt1TDphbOP6LDcYXu2M8e4/Co8dOXdNVpDC3uQsi', 'active', 0, '2025-08-12 08:47:39', '2025-08-12 08:47:31', '2025-08-12 08:47:39');

-- --------------------------------------------------------

--
-- Table structure for table `videos`
--

CREATE TABLE `videos` (
  `id` int(11) NOT NULL,
  `title` varchar(200) NOT NULL,
  `description` text DEFAULT NULL,
  `youtube_url` varchar(500) NOT NULL,
  `embed_code` varchar(500) DEFAULT NULL,
  `thumbnail_url` varchar(500) DEFAULT NULL,
  `status` enum('active','inactive') DEFAULT 'active',
  `sort_order` int(11) DEFAULT 0,
  `view_count` int(11) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `videos`
--

INSERT INTO `videos` (`id`, `title`, `description`, `youtube_url`, `embed_code`, `thumbnail_url`, `status`, `sort_order`, `view_count`, `created_at`, `updated_at`) VALUES
(1, 'Company Introduction', 'Learn about our company and services', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', 'https://www.youtube.com/embed/dQw4w9WgXcQ', NULL, 'active', 1, 0, '2025-08-12 07:11:11', '2025-08-12 07:11:11'),
(2, 'Product Showcase', 'Showcase of our premium products and services', 'https://www.youtube.com/watch?v=jNQXAC9IVRw', 'https://www.youtube.com/embed/jNQXAC9IVRw', NULL, 'active', 2, 0, '2025-08-12 07:11:11', '2025-08-12 07:11:11'),
(3, 'Customer Testimonials', 'What our customers say about our services', 'https://www.youtube.com/watch?v=9bZkp7q19f0', 'https://www.youtube.com/embed/9bZkp7q19f0', NULL, 'active', 3, 0, '2025-08-12 07:11:11', '2025-08-12 07:11:11');

-- --------------------------------------------------------

--
-- Table structure for table `visits`
--

CREATE TABLE `visits` (
  `id` int(11) NOT NULL,
  `page` varchar(100) NOT NULL DEFAULT 'home',
  `ip_address` varchar(45) NOT NULL,
  `user_agent` text DEFAULT NULL,
  `referer` varchar(500) DEFAULT NULL,
  `visit_date` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `visits`
--

INSERT INTO `visits` (`id`, `page`, `ip_address`, `user_agent`, `referer`, `visit_date`) VALUES
(1, 'home', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36', NULL, '2025-08-12 07:11:11'),
(2, 'home', '192.168.1.1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X)', NULL, '2025-08-12 07:11:11'),
(3, 'home', '10.0.0.1', 'Mozilla/5.0 (Android 10; Mobile; rv:81.0)', NULL, '2025-08-12 07:11:11'),
(4, 'home', '2401:4900:1c9a:d026:3024:4c0:7d17:e807', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '', '2025-08-12 07:12:53'),
(5, 'home', '2401:4900:1c9a:d026:3024:4c0:7d17:e807', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '', '2025-08-12 07:15:18'),
(6, 'home', '135.148.100.196', '', '', '2025-08-12 07:15:43'),
(7, 'home', '2401:4900:1c9a:d026:3024:4c0:7d17:e807', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'https://wap.galaxytribes.in/', '2025-08-12 07:15:46'),
(8, 'home', '2401:4900:1c9a:d026:3024:4c0:7d17:e807', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'https://wap.galaxytribes.in/', '2025-08-12 07:16:37'),
(9, 'home', '2401:4900:1c9a:d026:3024:4c0:7d17:e807', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'https://wap.galaxytribes.in/', '2025-08-12 07:21:54'),
(10, 'home', '2401:4900:1c9a:d026:3024:4c0:7d17:e807', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'https://wap.galaxytribes.in/', '2025-08-12 07:23:05'),
(11, 'home', '2401:4900:1c9a:d026:3024:4c0:7d17:e807', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'https://wap.galaxytribes.in/', '2025-08-12 07:24:18'),
(12, 'home', '2401:4900:1c9a:d026:3024:4c0:7d17:e807', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'https://wap.galaxytribes.in/', '2025-08-12 07:28:47'),
(13, 'home', '2401:4900:1c9a:d026:75fc:c3e2:8935:c958', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Mobile Safari/537.36', '', '2025-08-12 07:28:59'),
(14, 'home', '2401:4900:1c9a:d026:75fc:c3e2:8935:c958', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Mobile Safari/537.36', '', '2025-08-12 07:29:04'),
(15, 'home', '2401:4900:1c9a:d026:75fc:c3e2:8935:c958', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Mobile Safari/537.36', 'https://wap.galaxytribes.in/', '2025-08-12 07:32:01'),
(16, 'home', '2401:4900:1c9a:d026:3024:4c0:7d17:e807', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'https://wap.galaxytribes.in/admin/backup.php', '2025-08-12 07:37:42'),
(17, 'home', '2401:4900:1c9a:d026:3024:4c0:7d17:e807', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'https://wap.galaxytribes.in/', '2025-08-12 07:38:31'),
(18, 'home', '2401:4900:1c9a:d026:3024:4c0:7d17:e807', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '', '2025-08-12 07:38:41'),
(19, 'home', '2401:4900:1c9a:d026:3024:4c0:7d17:e807', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '', '2025-08-12 07:38:42'),
(20, 'home', '2401:4900:1c9a:d026:75fc:c3e2:8935:c958', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Mobile Safari/537.36', 'https://wap.galaxytribes.in/', '2025-08-12 07:38:56'),
(21, 'home', '2401:4900:1c9a:d026:3024:4c0:7d17:e807', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'https://wap.galaxytribes.in/', '2025-08-12 07:39:21'),
(22, 'home', '2401:4900:1c9a:d026:75fc:c3e2:8935:c958', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Mobile Safari/537.36', '', '2025-08-12 07:41:01'),
(23, 'home', '2401:4900:1c9a:d026:3024:4c0:7d17:e807', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'https://wap.galaxytribes.in/', '2025-08-12 07:41:18'),
(24, 'home', '2401:4900:1c9a:d026:3024:4c0:7d17:e807', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'https://wap.galaxytribes.in/', '2025-08-12 07:41:24'),
(25, 'home', '2401:4900:1c9a:d026:3024:4c0:7d17:e807', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'https://wap.galaxytribes.in/admin/profile.php', '2025-08-12 07:43:57'),
(26, 'home', '2401:4900:1c9a:d026:75fc:c3e2:8935:c958', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Mobile Safari/537.36', '', '2025-08-12 07:44:23'),
(27, 'home', '2401:4900:1c9a:d026:3024:4c0:7d17:e807', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'https://wap.galaxytribes.in/index.php', '2025-08-12 07:49:02'),
(28, 'home', '2401:4900:1c9a:d026:3024:4c0:7d17:e807', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'https://wap.galaxytribes.in/index.php', '2025-08-12 07:49:08'),
(29, 'home', '2401:4900:1c9a:d026:3024:4c0:7d17:e807', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '', '2025-08-12 08:39:18'),
(30, 'home', '2401:4900:1c9a:d026:3024:4c0:7d17:e807', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '', '2025-08-12 08:46:34'),
(31, 'home', '2401:4900:1c9a:d026:3024:4c0:7d17:e807', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'https://wap.galaxytribes.in/', '2025-08-12 08:47:39'),
(32, 'home', '2401:4900:1c9a:d026:3024:4c0:7d17:e807', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'https://wap.galaxytribes.in/', '2025-08-12 08:50:27'),
(33, 'home', '2401:4900:1c9a:d026:3024:4c0:7d17:e807', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'https://wap.galaxytribes.in/', '2025-08-12 08:52:26'),
(34, 'home', '2401:4900:1c9a:d026:3024:4c0:7d17:e807', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'https://wap.galaxytribes.in/', '2025-08-12 08:53:08'),
(35, 'home', '2401:4900:1c9a:d026:3024:4c0:7d17:e807', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '', '2025-08-12 09:51:48'),
(36, 'home', '2401:4900:1c9a:d026:3024:4c0:7d17:e807', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '', '2025-08-12 09:58:42'),
(37, 'home', '2401:4900:1c9a:d026:3024:4c0:7d17:e807', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'https://gtai.in/', '2025-08-12 10:04:08'),
(38, 'home', '2401:4900:1c9a:d026:3024:4c0:7d17:e807', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'https://gtai.in/', '2025-08-12 10:05:54'),
(39, 'home', '2a02:4780:11:c0de::e', 'Go-http-client/2.0', '', '2025-08-12 14:09:27'),
(40, 'home', '203.194.96.3', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Mobile Safari/537.36', '', '2025-08-12 14:21:42'),
(41, 'home', '34.29.249.145', 'Mozilla/5.0 (compatible; CMS-Checker/1.0; +https://example.com)', 'http://www.wap.galaxytribes.in', '2025-08-12 16:52:22'),
(42, 'home', '34.9.206.18', 'Mozilla/5.0 (compatible; CMS-Checker/1.0; +https://example.com)', 'http://wap.galaxytribes.in', '2025-08-12 17:08:19'),
(43, 'home', '44.249.166.219', 'Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_4; en-US) AppleWebKit/534.3 (KHTML, like Gecko) Chrome/6.0.464.0 Safari/534.3', '', '2025-08-12 17:38:07'),
(44, 'home', '51.38.227.113', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Mobile Safari/537.36', '', '2025-08-12 18:06:51'),
(45, 'home', '138.197.91.89', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '', '2025-08-12 20:11:00'),
(46, 'home', '44.249.166.219', 'Mozilla/5.0 (Linux; Android 8.1.0; Redmi 5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.99 Mobile Safari/537.36', '', '2025-08-13 00:16:47'),
(47, 'home', '2a02:4780:11:c0de::e', 'Go-http-client/2.0', '', '2025-08-13 01:16:06'),
(48, 'home', '2401:4900:1c9b:ae2d:81:52bf:1ffa:8e9b', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'https://hpanel.hostinger.com/', '2025-08-13 04:53:33'),
(49, 'home', '66.249.68.66', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.84 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', '', '2025-08-13 04:53:47'),
(50, 'home', '66.249.68.67', 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', '', '2025-08-13 04:53:48'),
(51, 'home', '2401:4900:1c9b:ae2d:81:52bf:1ffa:8e9b', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '', '2025-08-13 04:53:55');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admins`
--
ALTER TABLE `admins`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `admin_bypass_tokens`
--
ALTER TABLE `admin_bypass_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `token` (`token`),
  ADD KEY `admin_id` (`admin_id`);

--
-- Indexes for table `banners`
--
ALTER TABLE `banners`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_banners_position_status` (`position`,`status`,`sort_order`);

--
-- Indexes for table `free_website_requests`
--
ALTER TABLE `free_website_requests`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `gallery`
--
ALTER TABLE `gallery`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_gallery_status_sort` (`status`,`sort_order`);

--
-- Indexes for table `inquiries`
--
ALTER TABLE `inquiries`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_inquiries_user_id` (`user_id`);

--
-- Indexes for table `inquiry_products`
--
ALTER TABLE `inquiry_products`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_inquiry_products_status` (`status`,`sort_order`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `order_number` (`order_number`),
  ADD KEY `idx_orders_date_status` (`created_at`,`status`),
  ADD KEY `idx_orders_user_id` (`user_id`);

--
-- Indexes for table `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `pdfs`
--
ALTER TABLE `pdfs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_pdfs_status_sort` (`status`,`sort_order`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_products_status_sort` (`status`,`sort_order`);

--
-- Indexes for table `reviews`
--
ALTER TABLE `reviews`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_reviews_status_date` (`status`,`created_at`);

--
-- Indexes for table `site_settings`
--
ALTER TABLE `site_settings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `setting_key` (`setting_key`);

--
-- Indexes for table `transactions`
--
ALTER TABLE `transactions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `transaction_id` (`transaction_id`),
  ADD KEY `order_id` (`order_id`);

--
-- Indexes for table `translations`
--
ALTER TABLE `translations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_translation` (`language_code`,`translation_key`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `videos`
--
ALTER TABLE `videos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_videos_status_sort` (`status`,`sort_order`);

--
-- Indexes for table `visits`
--
ALTER TABLE `visits`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admins`
--
ALTER TABLE `admins`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `admin_bypass_tokens`
--
ALTER TABLE `admin_bypass_tokens`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `banners`
--
ALTER TABLE `banners`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `free_website_requests`
--
ALTER TABLE `free_website_requests`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `gallery`
--
ALTER TABLE `gallery`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `inquiries`
--
ALTER TABLE `inquiries`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `inquiry_products`
--
ALTER TABLE `inquiry_products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `pdfs`
--
ALTER TABLE `pdfs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `reviews`
--
ALTER TABLE `reviews`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `site_settings`
--
ALTER TABLE `site_settings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=137;

--
-- AUTO_INCREMENT for table `transactions`
--
ALTER TABLE `transactions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `translations`
--
ALTER TABLE `translations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `videos`
--
ALTER TABLE `videos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `visits`
--
ALTER TABLE `visits`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=52;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `admin_bypass_tokens`
--
ALTER TABLE `admin_bypass_tokens`
  ADD CONSTRAINT `admin_bypass_tokens_ibfk_1` FOREIGN KEY (`admin_id`) REFERENCES `admins` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `inquiries`
--
ALTER TABLE `inquiries`
  ADD CONSTRAINT `fk_inquiries_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `transactions`
--
ALTER TABLE `transactions`
  ADD CONSTRAINT `transactions_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
