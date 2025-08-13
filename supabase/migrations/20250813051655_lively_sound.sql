/*
  # Complete Microsite Database Fix
  
  1. Database Structure
    - All required tables with proper relationships
    - Enhanced admin and user management
    - Order tracking with payment status
    - Inquiry products management
    - Analytics and reporting
    
  2. Security
    - Admin bypass tokens for emergency access
    - Proper password hashing
    - Session management
    
  3. Features
    - Complete e-commerce functionality
    - User registration and order tracking
    - Admin notifications
    - Analytics dashboard
    - Multi-language support
*/

-- Create database if not exists
CREATE DATABASE IF NOT EXISTS microsite_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE microsite_db;

-- Admins table
CREATE TABLE IF NOT EXISTS `admins` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` enum('admin','manager','editor') DEFAULT 'admin',
  `status` enum('active','inactive') DEFAULT 'active',
  `profile_image_url` varchar(500) DEFAULT NULL,
  `last_login` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert default admin
INSERT IGNORE INTO `admins` (`id`, `username`, `email`, `password_hash`, `role`, `status`, `profile_image_url`) VALUES
(1, 'admin', 'admin@demo.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin', 'active', 'https://images.pexels.com/photos/3184360/pexels-photo-3184360.jpeg?auto=compress&cs=tinysrgb&w=200');

-- Admin bypass tokens table
CREATE TABLE IF NOT EXISTS `admin_bypass_tokens` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) NOT NULL,
  `token` varchar(64) NOT NULL,
  `expires_at` timestamp NOT NULL,
  `used` tinyint(1) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `token` (`token`),
  KEY `admin_id` (`admin_id`),
  CONSTRAINT `admin_bypass_tokens_ibfk_1` FOREIGN KEY (`admin_id`) REFERENCES `admins` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Users table
CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `password_hash` varchar(255) NOT NULL,
  `status` enum('active','inactive') DEFAULT 'active',
  `email_verified` tinyint(1) DEFAULT 0,
  `profile_image_url` varchar(500) DEFAULT NULL,
  `last_login` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Products table
CREATE TABLE IF NOT EXISTS `products` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
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
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_products_status_sort` (`status`,`sort_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert sample products
INSERT IGNORE INTO `products` (`id`, `title`, `description`, `price`, `discount_price`, `qty_stock`, `image_url`, `inquiry_only`, `status`, `sort_order`) VALUES
(1, 'Premium Business Card', 'High-quality business cards with premium finish and professional design', 500.00, 399.00, 100, 'https://images.pexels.com/photos/6289065/pexels-photo-6289065.jpeg?auto=compress&cs=tinysrgb&w=400', 0, 'active', 1),
(2, 'Digital Visiting Card', 'Modern digital visiting card solution with QR code and social media integration', 299.00, NULL, 50, 'https://images.pexels.com/photos/6289025/pexels-photo-6289025.jpeg?auto=compress&cs=tinysrgb&w=400', 0, 'active', 2),
(3, 'Corporate Branding Package', 'Complete corporate branding solution including logo, letterhead, and business cards', 2999.00, 1999.00, 20, 'https://images.pexels.com/photos/3184339/pexels-photo-3184339.jpeg?auto=compress&cs=tinysrgb&w=400', 0, 'active', 3),
(4, 'Logo Design Service', 'Professional logo design service with unlimited revisions', 1500.00, NULL, 0, 'https://images.pexels.com/photos/3184432/pexels-photo-3184432.jpeg?auto=compress&cs=tinysrgb&w=400', 1, 'active', 4),
(5, 'Website Development', 'Custom website development with responsive design and SEO optimization', 15000.00, 12000.00, 0, 'https://images.pexels.com/photos/3184360/pexels-photo-3184360.jpeg?auto=compress&cs=tinysrgb&w=400', 1, 'active', 5);

-- Inquiry products table
CREATE TABLE IF NOT EXISTS `inquiry_products` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(200) NOT NULL,
  `description` text DEFAULT NULL,
  `price` decimal(10,2) NOT NULL DEFAULT 0.00,
  `image_url` varchar(500) NOT NULL,
  `file_size` int(11) DEFAULT NULL,
  `status` enum('active','inactive') DEFAULT 'active',
  `sort_order` int(11) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_inquiry_products_status` (`status`,`sort_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert sample inquiry products
INSERT IGNORE INTO `inquiry_products` (`id`, `title`, `description`, `price`, `image_url`, `file_size`, `status`, `sort_order`) VALUES
(1, 'Custom Logo Design', 'Professional logo design with unlimited revisions', 1500.00, 'https://images.pexels.com/photos/3184432/pexels-photo-3184432.jpeg?auto=compress&cs=tinysrgb&w=400', 150000, 'active', 1),
(2, 'Website Development', 'Custom website development with responsive design', 15000.00, 'https://images.pexels.com/photos/3184360/pexels-photo-3184360.jpeg?auto=compress&cs=tinysrgb&w=400', 180000, 'active', 2),
(3, 'Branding Package', 'Complete branding solution for your business', 5000.00, 'https://images.pexels.com/photos/3184339/pexels-photo-3184339.jpeg?auto=compress&cs=tinysrgb&w=400', 160000, 'active', 3),
(4, 'Digital Marketing', 'Social media and digital marketing services', 3000.00, 'https://images.pexels.com/photos/3184465/pexels-photo-3184465.jpeg?auto=compress&cs=tinysrgb&w=400', 170000, 'active', 4);

-- Orders table
CREATE TABLE IF NOT EXISTS `orders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
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
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `order_number` (`order_number`),
  KEY `idx_orders_date_status` (`created_at`,`status`),
  KEY `idx_orders_user_id` (`user_id`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Order items table
CREATE TABLE IF NOT EXISTS `order_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `product_title` varchar(200) NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT 1,
  `unit_price` decimal(10,2) NOT NULL DEFAULT 0.00,
  `total_price` decimal(10,2) NOT NULL DEFAULT 0.00,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `order_id` (`order_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Reviews table
CREATE TABLE IF NOT EXISTS `reviews` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `rating` int(11) NOT NULL CHECK (`rating` >= 1 and `rating` <= 5),
  `comment` text NOT NULL,
  `status` enum('pending','approved','rejected') DEFAULT 'pending',
  `ip_address` varchar(45) DEFAULT NULL,
  `approved_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_reviews_status_date` (`status`,`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert sample reviews
INSERT IGNORE INTO `reviews` (`id`, `name`, `email`, `phone`, `rating`, `comment`, `status`, `approved_at`) VALUES
(1, 'Rajesh Kumar', 'rajesh@example.com', '9876543210', 5, 'Excellent service and professional quality work. Highly recommended for business cards!', 'approved', NOW()),
(2, 'Priya Singh', 'priya@example.com', '9876543211', 4, 'Great experience with their team. Very responsive and helpful throughout the process.', 'approved', NOW()),
(3, 'Amit Patel', 'amit@example.com', '9876543212', 5, 'Outstanding digital visiting card service. Modern design and quick delivery.', 'approved', NOW()),
(4, 'Sneha Sharma', 'sneha@example.com', '9876543213', 4, 'Professional branding package exceeded my expectations. Worth every penny!', 'approved', NOW());

-- Banners table
CREATE TABLE IF NOT EXISTS `banners` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(200) DEFAULT NULL,
  `image_url` varchar(500) NOT NULL,
  `link_url` varchar(500) DEFAULT NULL,
  `position` enum('top','bottom','both') DEFAULT 'both',
  `status` enum('active','inactive') DEFAULT 'active',
  `sort_order` int(11) DEFAULT 0,
  `click_count` int(11) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_banners_position_status` (`position`,`status`,`sort_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert sample banners
INSERT IGNORE INTO `banners` (`id`, `title`, `image_url`, `link_url`, `position`, `status`, `sort_order`) VALUES
(1, 'Special Offer Banner', 'https://images.pexels.com/photos/3184360/pexels-photo-3184360.jpeg?auto=compress&cs=tinysrgb&w=800&h=200', 'https://example.com/offer', 'both', 'active', 1),
(2, 'New Products Banner', 'https://images.pexels.com/photos/3184338/pexels-photo-3184338.jpeg?auto=compress&cs=tinysrgb&w=800&h=200', 'https://example.com/products', 'both', 'active', 2),
(3, 'Contact Us Banner', 'https://images.pexels.com/photos/3184465/pexels-photo-3184465.jpeg?auto=compress&cs=tinysrgb&w=800&h=200', 'https://example.com/contact', 'both', 'active', 3);

-- Videos table
CREATE TABLE IF NOT EXISTS `videos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(200) NOT NULL,
  `description` text DEFAULT NULL,
  `youtube_url` varchar(500) NOT NULL,
  `embed_code` varchar(500) DEFAULT NULL,
  `thumbnail_url` varchar(500) DEFAULT NULL,
  `status` enum('active','inactive') DEFAULT 'active',
  `sort_order` int(11) DEFAULT 0,
  `view_count` int(11) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_videos_status_sort` (`status`,`sort_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert sample videos
INSERT IGNORE INTO `videos` (`id`, `title`, `description`, `youtube_url`, `embed_code`, `status`, `sort_order`) VALUES
(1, 'Company Introduction', 'Learn about our company and services', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', 'https://www.youtube.com/embed/dQw4w9WgXcQ', 'active', 1),
(2, 'Product Showcase', 'Showcase of our premium products and services', 'https://www.youtube.com/watch?v=jNQXAC9IVRw', 'https://www.youtube.com/embed/jNQXAC9IVRw', 'active', 2),
(3, 'Customer Testimonials', 'What our customers say about our services', 'https://www.youtube.com/watch?v=9bZkp7q19f0', 'https://www.youtube.com/embed/9bZkp7q19f0', 'active', 3);

-- PDFs table
CREATE TABLE IF NOT EXISTS `pdfs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(200) NOT NULL,
  `description` text DEFAULT NULL,
  `file_url` varchar(500) NOT NULL,
  `file_size` int(11) DEFAULT NULL,
  `status` enum('active','inactive') DEFAULT 'active',
  `sort_order` int(11) DEFAULT 0,
  `download_count` int(11) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_pdfs_status_sort` (`status`,`sort_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert sample PDFs
INSERT IGNORE INTO `pdfs` (`id`, `title`, `description`, `file_url`, `file_size`, `status`, `sort_order`) VALUES
(1, 'Company Brochure', 'Download our complete company brochure', 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 1024000, 'active', 1),
(2, 'Product Catalog', 'Complete catalog of all our products and services', 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 2048000, 'active', 2),
(3, 'Price List', 'Current pricing for all products and services', 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 512000, 'active', 3),
(4, 'Company Profile', 'Detailed company profile and credentials', 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 1536000, 'active', 4),
(5, 'Portfolio', 'Portfolio of our completed projects', 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 3072000, 'active', 5);

-- Gallery table
CREATE TABLE IF NOT EXISTS `gallery` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(200) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `image_url` varchar(500) NOT NULL,
  `thumbnail_url` varchar(500) DEFAULT NULL,
  `alt_text` varchar(200) DEFAULT NULL,
  `status` enum('active','inactive') DEFAULT 'active',
  `sort_order` int(11) DEFAULT 0,
  `upload_date` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_gallery_status_sort` (`status`,`sort_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert sample gallery images
INSERT IGNORE INTO `gallery` (`id`, `title`, `description`, `image_url`, `thumbnail_url`, `alt_text`, `status`, `sort_order`) VALUES
(1, 'Office Interior', 'Our modern office space', 'https://images.pexels.com/photos/3184360/pexels-photo-3184360.jpeg?auto=compress&cs=tinysrgb&w=600', 'https://images.pexels.com/photos/3184360/pexels-photo-3184360.jpeg?auto=compress&cs=tinysrgb&w=300', 'Modern office interior', 'active', 1),
(2, 'Team Meeting', 'Our professional team in action', 'https://images.pexels.com/photos/3184338/pexels-photo-3184338.jpeg?auto=compress&cs=tinysrgb&w=600', 'https://images.pexels.com/photos/3184338/pexels-photo-3184338.jpeg?auto=compress&cs=tinysrgb&w=300', 'Team meeting', 'active', 2),
(3, 'Product Display', 'Our premium products showcase', 'https://images.pexels.com/photos/3184465/pexels-photo-3184465.jpeg?auto=compress&cs=tinysrgb&w=600', 'https://images.pexels.com/photos/3184465/pexels-photo-3184465.jpeg?auto=compress&cs=tinysrgb&w=300', 'Product display', 'active', 3),
(4, 'Workshop', 'Behind the scenes of our production', 'https://images.pexels.com/photos/3184432/pexels-photo-3184432.jpeg?auto=compress&cs=tinysrgb&w=600', 'https://images.pexels.com/photos/3184432/pexels-photo-3184432.jpeg?auto=compress&cs=tinysrgb&w=300', 'Production workshop', 'active', 4);

-- Inquiries table
CREATE TABLE IF NOT EXISTS `inquiries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `user_name` varchar(100) NOT NULL,
  `user_phone` varchar(20) DEFAULT NULL,
  `user_email` varchar(100) DEFAULT NULL,
  `products` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`products`)),
  `message` text DEFAULT NULL,
  `status` enum('pending','contacted','completed') DEFAULT 'pending',
  `ip_address` varchar(45) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_inquiries_user_id` (`user_id`),
  CONSTRAINT `fk_inquiries_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Free website requests table
CREATE TABLE IF NOT EXISTS `free_website_requests` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `mobile` varchar(20) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `business_details` text DEFAULT NULL,
  `status` enum('pending','contacted','completed') DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Transactions table
CREATE TABLE IF NOT EXISTS `transactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) NOT NULL,
  `transaction_id` varchar(100) DEFAULT NULL,
  `upi_id` varchar(100) DEFAULT NULL,
  `amount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `status` enum('pending','success','failed','cancelled') DEFAULT 'pending',
  `payment_method` varchar(50) DEFAULT 'upi',
  `gateway_response` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`gateway_response`)),
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `transaction_id` (`transaction_id`),
  KEY `order_id` (`order_id`),
  CONSTRAINT `transactions_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Site settings table
CREATE TABLE IF NOT EXISTS `site_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `setting_key` varchar(100) NOT NULL,
  `setting_value` text DEFAULT NULL,
  `setting_type` enum('text','number','boolean','json') DEFAULT 'text',
  `description` text DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `setting_key` (`setting_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert default site settings
INSERT IGNORE INTO `site_settings` (`setting_key`, `setting_value`, `setting_type`, `description`) VALUES
('site_title', 'DEMO CARD', 'text', 'Website title'),
('company_name', 'DEMO CARD', 'text', 'Company name'),
('director_name', 'Vishal Rathod', 'text', 'Director name'),
('director_title', 'FOUNDER', 'text', 'Director title'),
('contact_phone1', '9765834383', 'text', 'Primary phone number'),
('contact_phone2', '9765834383', 'text', 'Secondary phone number'),
('contact_email', 'info@galaxytribes.in', 'text', 'Contact email'),
('contact_address', 'Nashik, Maharashtra, India', 'text', 'Business address'),
('whatsapp_number', '919765834383', 'text', 'WhatsApp number with country code'),
('website_url', 'https://galaxytribes.in', 'text', 'Website URL'),
('upi_id', 'demo@upi', 'text', 'UPI ID for payments'),
('meta_description', 'Professional digital visiting card and business services. Get your custom business card, logo design, and corporate branding solutions.', 'text', 'Meta description for SEO'),
('meta_keywords', 'visiting card, business card, digital card, logo design, branding, corporate identity', 'text', 'Meta keywords for SEO'),
('current_theme', 'blue-dark', 'text', 'Current website theme'),
('discount_text', 'DISCOUNT UPTO 50% Live Use FREE code', 'text', 'Discount popup text'),
('show_discount_popup', '1', 'boolean', 'Show discount popup'),
('show_pwa_prompt', '1', 'boolean', 'Show PWA install prompt'),
('social_facebook', 'https://facebook.com/demo', 'text', 'Facebook page URL'),
('social_youtube', 'https://youtube.com/demo', 'text', 'YouTube channel URL'),
('social_twitter', 'https://twitter.com/demo', 'text', 'Twitter profile URL'),
('social_instagram', 'https://instagram.com/demo', 'text', 'Instagram profile URL'),
('social_linkedin', 'https://linkedin.com/company/demo', 'text', 'LinkedIn page URL'),
('social_pinterest', 'https://pinterest.com/demo', 'text', 'Pinterest profile URL'),
('social_telegram', 'https://t.me/demo', 'text', 'Telegram channel URL'),
('social_zomato', 'https://zomato.com/demo', 'text', 'Zomato restaurant URL'),
('view_count', '1521', 'text', 'Website view counter');

-- Translations table
CREATE TABLE IF NOT EXISTS `translations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `language_code` varchar(5) NOT NULL,
  `translation_key` varchar(100) NOT NULL,
  `translation_value` text NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_translation` (`language_code`,`translation_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert sample translations
INSERT IGNORE INTO `translations` (`language_code`, `translation_key`, `translation_value`) VALUES
('en', 'welcome', 'Welcome'),
('en', 'home', 'Home'),
('en', 'about', 'About Us'),
('en', 'products', 'Products'),
('en', 'contact', 'Contact'),
('en', 'gallery', 'Gallery'),
('en', 'videos', 'Videos'),
('en', 'reviews', 'Reviews'),
('en', 'cart', 'Cart'),
('en', 'add_to_cart', 'Add to Cart'),
('en', 'inquiry', 'Inquiry'),
('hi', 'welcome', 'स्वागत'),
('hi', 'home', 'होम'),
('hi', 'about', 'हमारे बारे में'),
('hi', 'products', 'उत्पाद'),
('hi', 'contact', 'संपर्क'),
('hi', 'gallery', 'गैलरी'),
('hi', 'videos', 'वीडियो'),
('hi', 'reviews', 'समीक्षा'),
('hi', 'cart', 'कार्ट'),
('hi', 'add_to_cart', 'कार्ट में जोड़ें'),
('hi', 'inquiry', 'पूछताछ');

-- Visits table for analytics
CREATE TABLE IF NOT EXISTS `visits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `page` varchar(100) NOT NULL DEFAULT 'home',
  `ip_address` varchar(45) NOT NULL,
  `user_agent` text DEFAULT NULL,
  `referer` varchar(500) DEFAULT NULL,
  `visit_date` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert sample visits
INSERT IGNORE INTO `visits` (`page`, `ip_address`, `user_agent`) VALUES
('home', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'),
('home', '192.168.1.1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X)'),
('home', '10.0.0.1', 'Mozilla/5.0 (Android 10; Mobile; rv:81.0)');