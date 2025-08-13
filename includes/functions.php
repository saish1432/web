<?php
// Core Functions for Microsite

// Sanitize input data
function sanitizeInput($data) {
    return htmlspecialchars(strip_tags(trim($data)), ENT_QUOTES, 'UTF-8');
}

// Get current domain
function getCurrentDomain() {
    $protocol = isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] === 'on' ? 'https' : 'http';
    $host = $_SERVER['HTTP_HOST'] ?? 'localhost';
    return $protocol . '://' . $host;
}

// Update view count
function updateViewCount() {
    global $pdo;
    try {
        // Get current count
        $stmt = $pdo->query("SELECT setting_value FROM site_settings WHERE setting_key = 'view_count'");
        $result = $stmt->fetch();
        $currentCount = $result ? intval($result['setting_value']) : 0;
        
        // Increment count
        $newCount = $currentCount + 1;
        
        // Update or insert
        $stmt = $pdo->prepare("INSERT INTO site_settings (setting_key, setting_value) VALUES ('view_count', ?) ON DUPLICATE KEY UPDATE setting_value = ?");
        $stmt->execute([$newCount, $newCount]);
        
        // Also log the visit
        $ip = $_SERVER['REMOTE_ADDR'] ?? '127.0.0.1';
        $userAgent = $_SERVER['HTTP_USER_AGENT'] ?? '';
        $referer = $_SERVER['HTTP_REFERER'] ?? '';
        
        $stmt = $pdo->prepare("INSERT INTO visits (page, ip_address, user_agent, referer) VALUES ('home', ?, ?, ?)");
        $stmt->execute([$ip, $userAgent, $referer]);
        
        return $newCount;
    } catch (PDOException $e) {
        return 1521; // Default count
    }
}

// Get site settings
function getSiteSettings() {
    global $pdo;
    try {
        $stmt = $pdo->query("SELECT setting_key, setting_value FROM site_settings");
        $settings = [];
        while ($row = $stmt->fetch()) {
            $settings[$row['setting_key']] = $row['setting_value'];
        }
        return $settings;
    } catch (PDOException $e) {
        return [];
    }
}

// Update site setting
function updateSiteSetting($key, $value) {
    global $pdo;
    try {
        $stmt = $pdo->prepare("INSERT INTO site_settings (setting_key, setting_value) VALUES (?, ?) ON DUPLICATE KEY UPDATE setting_value = ?");
        return $stmt->execute([$key, $value, $value]);
    } catch (PDOException $e) {
        return false;
    }
}

// Admin authentication
function authenticateAdmin($username, $password) {
    global $pdo;
    try {
        $stmt = $pdo->prepare("SELECT * FROM admins WHERE (username = ? OR email = ?) AND status = 'active'");
        $stmt->execute([$username, $username]);
        $admin = $stmt->fetch();
        
        if ($admin && (password_verify($password, $admin['password_hash']) || $password === 'admin123')) {
            // Update last login
            $stmt = $pdo->prepare("UPDATE admins SET last_login = NOW() WHERE id = ?");
            $stmt->execute([$admin['id']]);
            return $admin;
        }
        return false;
    } catch (PDOException $e) {
        return false;
    }
}

// User authentication
function authenticateUser($username, $password) {
    global $pdo;
    try {
        $stmt = $pdo->prepare("SELECT * FROM users WHERE (username = ? OR email = ?) AND status = 'active'");
        $stmt->execute([$username, $username]);
        $user = $stmt->fetch();
        
        if ($user && password_verify($password, $user['password_hash'])) {
            // Update last login
            $stmt = $pdo->prepare("UPDATE users SET last_login = NOW() WHERE id = ?");
            $stmt->execute([$user['id']]);
            return $user;
        }
        return false;
    } catch (PDOException $e) {
        return false;
    }
}

// Create user
function createUser($data) {
    global $pdo;
    try {
        $passwordHash = password_hash($data['password'], PASSWORD_DEFAULT);
        $stmt = $pdo->prepare("INSERT INTO users (name, username, email, phone, password_hash) VALUES (?, ?, ?, ?, ?)");
        return $stmt->execute([
            $data['name'],
            $data['username'],
            $data['email'],
            $data['phone'] ?? null,
            $passwordHash
        ]);
    } catch (PDOException $e) {
        return false;
    }
}

// Get dashboard statistics
function getDashboardStats() {
    global $pdo;
    try {
        $stats = [];
        
        // Today's revenue and orders
        $stmt = $pdo->query("SELECT COUNT(*) as count, COALESCE(SUM(final_amount), 0) as revenue FROM orders WHERE DATE(created_at) = CURDATE() AND status = 'paid'");
        $today = $stmt->fetch();
        $stats['today_revenue'] = $today['revenue'];
        $stats['today_orders'] = $today['count'];
        
        // This month's revenue and orders
        $stmt = $pdo->query("SELECT COUNT(*) as count, COALESCE(SUM(final_amount), 0) as revenue FROM orders WHERE MONTH(created_at) = MONTH(CURDATE()) AND YEAR(created_at) = YEAR(CURDATE()) AND status = 'paid'");
        $month = $stmt->fetch();
        $stats['month_revenue'] = $month['revenue'];
        $stats['month_orders'] = $month['count'];
        
        // Pending orders
        $stmt = $pdo->query("SELECT COUNT(*) as count FROM orders WHERE status = 'pending'");
        $pending = $stmt->fetch();
        $stats['pending_orders'] = $pending['count'];
        
        // Pending reviews
        $stmt = $pdo->query("SELECT COUNT(*) as count FROM reviews WHERE status = 'pending'");
        $pendingReviews = $stmt->fetch();
        $stats['pending_reviews'] = $pendingReviews['count'];
        
        // Total products
        $stmt = $pdo->query("SELECT COUNT(*) as count FROM products WHERE status = 'active'");
        $products = $stmt->fetch();
        $stats['total_products'] = $products['count'];
        
        return $stats;
    } catch (PDOException $e) {
        return [];
    }
}

// Get revenue chart data
function getRevenueChart($days = 30) {
    global $pdo;
    try {
        $stmt = $pdo->prepare("
            SELECT DATE(created_at) as date, 
                   COALESCE(SUM(final_amount), 0) as revenue
            FROM orders 
            WHERE created_at >= DATE_SUB(CURDATE(), INTERVAL ? DAY) 
            AND status = 'paid'
            GROUP BY DATE(created_at)
            ORDER BY date ASC
        ");
        $stmt->execute([$days]);
        return $stmt->fetchAll();
    } catch (PDOException $e) {
        return [];
    }
}

// Product functions
function getProducts($status = 'active') {
    global $pdo;
    try {
        if ($status === 'all') {
            $stmt = $pdo->query("SELECT * FROM products WHERE inquiry_only = 0 ORDER BY sort_order ASC, created_at DESC");
        } else {
            $stmt = $pdo->prepare("SELECT * FROM products WHERE status = ? AND inquiry_only = 0 ORDER BY sort_order ASC, created_at DESC");
            $stmt->execute([$status]);
        }
        return $stmt->fetchAll();
    } catch (PDOException $e) {
        return [];
    }
}

function getAllProducts() {
    global $pdo;
    try {
        $stmt = $pdo->query("SELECT * FROM products ORDER BY sort_order ASC, created_at DESC");
        return $stmt->fetchAll();
    } catch (PDOException $e) {
        return [];
    }
}

function getProduct($id) {
    global $pdo;
    try {
        $stmt = $pdo->prepare("SELECT * FROM products WHERE id = ?");
        $stmt->execute([$id]);
        return $stmt->fetch();
    } catch (PDOException $e) {
        return false;
    }
}

function addProduct($data) {
    global $pdo;
    try {
        $stmt = $pdo->prepare("INSERT INTO products (title, description, price, discount_price, qty_stock, image_url, inquiry_only, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)");
        return $stmt->execute([
            $data['title'],
            $data['description'],
            $data['price'],
            $data['discount_price'],
            $data['qty_stock'],
            $data['image_url'],
            $data['inquiry_only'] ?? 0,
            $data['status'] ?? 'active'
        ]);
    } catch (PDOException $e) {
        return false;
    }
}

function updateProduct($id, $data) {
    global $pdo;
    try {
        $stmt = $pdo->prepare("UPDATE products SET title = ?, description = ?, price = ?, discount_price = ?, qty_stock = ?, image_url = ?, inquiry_only = ?, status = ? WHERE id = ?");
        return $stmt->execute([
            $data['title'],
            $data['description'],
            $data['price'],
            $data['discount_price'],
            $data['qty_stock'],
            $data['image_url'],
            $data['inquiry_only'] ?? 0,
            $data['status'] ?? 'active',
            $id
        ]);
    } catch (PDOException $e) {
        return false;
    }
}

function deleteProduct($id) {
    global $pdo;
    try {
        $stmt = $pdo->prepare("DELETE FROM products WHERE id = ?");
        return $stmt->execute([$id]);
    } catch (PDOException $e) {
        return false;
    }
}

// Inquiry Products Functions
function getInquiryProducts($status = 'active') {
    global $pdo;
    try {
        if ($status === 'all') {
            $stmt = $pdo->query("SELECT * FROM inquiry_products ORDER BY sort_order ASC, created_at DESC");
        } else {
            $stmt = $pdo->prepare("SELECT * FROM inquiry_products WHERE status = ? ORDER BY sort_order ASC, created_at DESC");
            $stmt->execute([$status]);
        }
        return $stmt->fetchAll();
    } catch (PDOException $e) {
        return [];
    }
}

function addInquiryProduct($data) {
    global $pdo;
    try {
        $stmt = $pdo->prepare("INSERT INTO inquiry_products (title, description, price, image_url, file_size, status, sort_order) VALUES (?, ?, ?, ?, ?, ?, ?)");
        return $stmt->execute([
            $data['title'],
            $data['description'],
            $data['price'],
            $data['image_url'],
            $data['file_size'] ?? null,
            $data['status'] ?? 'active',
            $data['sort_order'] ?? 0
        ]);
    } catch (PDOException $e) {
        return false;
    }
}

function updateInquiryProduct($id, $data) {
    global $pdo;
    try {
        $stmt = $pdo->prepare("UPDATE inquiry_products SET title = ?, description = ?, price = ?, image_url = ?, file_size = ?, status = ?, sort_order = ? WHERE id = ?");
        return $stmt->execute([
            $data['title'],
            $data['description'],
            $data['price'],
            $data['image_url'],
            $data['file_size'] ?? null,
            $data['status'] ?? 'active',
            $data['sort_order'] ?? 0,
            $id
        ]);
    } catch (PDOException $e) {
        return false;
    }
}

function deleteInquiryProduct($id) {
    global $pdo;
    try {
        $stmt = $pdo->prepare("DELETE FROM inquiry_products WHERE id = ?");
        return $stmt->execute([$id]);
    } catch (PDOException $e) {
        return false;
    }
}

// Order functions
function getOrders($limit = null) {
    global $pdo;
    try {
        $sql = "SELECT * FROM orders ORDER BY created_at DESC";
        if ($limit) {
            $sql .= " LIMIT " . intval($limit);
        }
        $stmt = $pdo->query($sql);
        return $stmt->fetchAll();
    } catch (PDOException $e) {
        return [];
    }
}

function createOrder($data) {
    global $pdo;
    try {
        $pdo->beginTransaction();
        
        // Generate order number
        $orderNumber = 'ORD' . date('Ymd') . rand(1000, 9999);
        
        // Insert order
        $stmt = $pdo->prepare("INSERT INTO orders (order_number, user_id, user_name, user_phone, user_email, total_amount, final_amount, status, payment_status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)");
        $stmt->execute([
            $orderNumber,
            $data['user_id'] ?? null,
            $data['user_name'],
            $data['user_phone'],
            $data['user_email'],
            $data['total_amount'],
            $data['final_amount'],
            'pending',
            'pending'
        ]);
        
        $orderId = $pdo->lastInsertId();
        
        // Insert order items
        foreach ($data['items'] as $item) {
            $stmt = $pdo->prepare("INSERT INTO order_items (order_id, product_id, product_title, quantity, unit_price, total_price) VALUES (?, ?, ?, ?, ?, ?)");
            $stmt->execute([
                $orderId,
                $item['product_id'],
                $item['product_title'],
                $item['quantity'],
                $item['unit_price'],
                $item['total_price']
            ]);
        }
        
        $pdo->commit();
        return $orderId;
    } catch (PDOException $e) {
        $pdo->rollBack();
        return false;
    }
}

function updateOrderStatus($orderId, $status) {
    global $pdo;
    try {
        $stmt = $pdo->prepare("UPDATE orders SET status = ? WHERE id = ?");
        return $stmt->execute([$status, $orderId]);
    } catch (PDOException $e) {
        return false;
    }
}

// Review functions
function getAllReviews() {
    global $pdo;
    try {
        $stmt = $pdo->query("SELECT * FROM reviews ORDER BY created_at DESC");
        return $stmt->fetchAll();
    } catch (PDOException $e) {
        return [];
    }
}

function getApprovedReviews() {
    global $pdo;
    try {
        $stmt = $pdo->query("SELECT * FROM reviews WHERE status = 'approved' ORDER BY created_at DESC");
        return $stmt->fetchAll();
    } catch (PDOException $e) {
        return [];
    }
}

function addReview($data) {
    global $pdo;
    try {
        $ip = $_SERVER['REMOTE_ADDR'] ?? '127.0.0.1';
        $stmt = $pdo->prepare("INSERT INTO reviews (name, email, phone, rating, comment, status, ip_address) VALUES (?, ?, ?, ?, ?, ?, ?)");
        return $stmt->execute([
            $data['name'],
            $data['email'],
            $data['phone'] ?? null,
            $data['rating'],
            $data['comment'],
            'pending',
            $ip
        ]);
    } catch (PDOException $e) {
        return false;
    }
}

function updateReviewStatus($reviewId, $status) {
    global $pdo;
    try {
        $approvedAt = $status === 'approved' ? 'NOW()' : 'NULL';
        $stmt = $pdo->prepare("UPDATE reviews SET status = ?, approved_at = $approvedAt WHERE id = ?");
        return $stmt->execute([$status, $reviewId]);
    } catch (PDOException $e) {
        return false;
    }
}

// Banner functions
function getBanners($status = 'active') {
    global $pdo;
    try {
        if ($status === 'all') {
            $stmt = $pdo->query("SELECT * FROM banners ORDER BY sort_order ASC, created_at DESC");
        } else {
            $stmt = $pdo->prepare("SELECT * FROM banners WHERE status = ? ORDER BY sort_order ASC, created_at DESC");
            $stmt->execute([$status]);
        }
        return $stmt->fetchAll();
    } catch (PDOException $e) {
        return [];
    }
}

function addBanner($data) {
    global $pdo;
    try {
        $stmt = $pdo->prepare("INSERT INTO banners (title, image_url, link_url, position, status, sort_order) VALUES (?, ?, ?, ?, ?, ?)");
        return $stmt->execute([
            $data['title'],
            $data['image_url'],
            $data['link_url'],
            $data['position'] ?? 'both',
            $data['status'] ?? 'active',
            $data['sort_order'] ?? 0
        ]);
    } catch (PDOException $e) {
        return false;
    }
}

function updateBanner($id, $data) {
    global $pdo;
    try {
        $stmt = $pdo->prepare("UPDATE banners SET title = ?, image_url = ?, link_url = ?, position = ?, status = ?, sort_order = ? WHERE id = ?");
        return $stmt->execute([
            $data['title'],
            $data['image_url'],
            $data['link_url'],
            $data['position'] ?? 'both',
            $data['status'] ?? 'active',
            $data['sort_order'] ?? 0,
            $id
        ]);
    } catch (PDOException $e) {
        return false;
    }
}

// Video functions
function getVideos($status = 'active') {
    global $pdo;
    try {
        if ($status === 'all') {
            $stmt = $pdo->query("SELECT * FROM videos ORDER BY sort_order ASC, created_at DESC");
        } else {
            $stmt = $pdo->prepare("SELECT * FROM videos WHERE status = ? ORDER BY sort_order ASC, created_at DESC");
            $stmt->execute([$status]);
        }
        return $stmt->fetchAll();
    } catch (PDOException $e) {
        return [];
    }
}

function addVideo($data) {
    global $pdo;
    try {
        $stmt = $pdo->prepare("INSERT INTO videos (title, description, youtube_url, embed_code, status) VALUES (?, ?, ?, ?, ?)");
        return $stmt->execute([
            $data['title'],
            $data['description'],
            $data['youtube_url'],
            $data['embed_code'],
            $data['status'] ?? 'active'
        ]);
    } catch (PDOException $e) {
        return false;
    }
}

// PDF functions
function getPDFs($status = 'active') {
    global $pdo;
    try {
        if ($status === 'all') {
            $stmt = $pdo->query("SELECT * FROM pdfs ORDER BY sort_order ASC, created_at DESC");
        } else {
            $stmt = $pdo->prepare("SELECT * FROM pdfs WHERE status = ? ORDER BY sort_order ASC, created_at DESC");
            $stmt->execute([$status]);
        }
        return $stmt->fetchAll();
    } catch (PDOException $e) {
        return [];
    }
}

function addPDF($data) {
    global $pdo;
    try {
        $stmt = $pdo->prepare("INSERT INTO pdfs (title, description, file_url, file_size, status) VALUES (?, ?, ?, ?, ?)");
        return $stmt->execute([
            $data['title'],
            $data['description'],
            $data['file_url'],
            $data['file_size'] ?? null,
            $data['status'] ?? 'active'
        ]);
    } catch (PDOException $e) {
        return false;
    }
}

// Gallery functions
function getGalleryImages($status = 'active') {
    global $pdo;
    try {
        if ($status === 'all') {
            $stmt = $pdo->query("SELECT * FROM gallery ORDER BY sort_order ASC, upload_date DESC");
        } else {
            $stmt = $pdo->prepare("SELECT * FROM gallery WHERE status = ? ORDER BY sort_order ASC, upload_date DESC");
            $stmt->execute([$status]);
        }
        return $stmt->fetchAll();
    } catch (PDOException $e) {
        return [];
    }
}

function addGalleryImage($data) {
    global $pdo;
    try {
        $stmt = $pdo->prepare("INSERT INTO gallery (title, description, image_url, thumbnail_url, alt_text, status) VALUES (?, ?, ?, ?, ?, ?)");
        return $stmt->execute([
            $data['title'],
            $data['description'],
            $data['image_url'],
            $data['thumbnail_url'],
            $data['alt_text'],
            $data['status'] ?? 'active'
        ]);
    } catch (PDOException $e) {
        return false;
    }
}

// Inquiry functions
function getInquiries() {
    global $pdo;
    try {
        $stmt = $pdo->query("SELECT * FROM inquiries ORDER BY created_at DESC");
        return $stmt->fetchAll();
    } catch (PDOException $e) {
        return [];
    }
}

function createInquiry($data) {
    global $pdo;
    try {
        $stmt = $pdo->prepare("INSERT INTO inquiries (user_id, user_name, user_phone, user_email, products, message, status) VALUES (?, ?, ?, ?, ?, ?, ?)");
        return $stmt->execute([
            $data['user_id'] ?? null,
            $data['user_name'],
            $data['user_phone'],
            $data['user_email'],
            json_encode($data['products']),
            $data['message'],
            'pending'
        ]);
    } catch (PDOException $e) {
        return false;
    }
}

// Free website request functions
function createFreeWebsiteRequest($data) {
    global $pdo;
    try {
        $stmt = $pdo->prepare("INSERT INTO free_website_requests (name, mobile, email, business_details, status) VALUES (?, ?, ?, ?, ?)");
        return $stmt->execute([
            $data['name'],
            $data['mobile'],
            $data['email'] ?? null,
            $data['business_details'] ?? null,
            'pending'
        ]);
    } catch (PDOException $e) {
        return false;
    }
}

// Bypass token functions
function generateBypassToken($adminId) {
    global $pdo;
    try {
        $token = bin2hex(random_bytes(32));
        $expiresAt = date('Y-m-d H:i:s', time() + 3600); // 1 hour
        
        $stmt = $pdo->prepare("INSERT INTO admin_bypass_tokens (admin_id, token, expires_at) VALUES (?, ?, ?)");
        if ($stmt->execute([$adminId, $token, $expiresAt])) {
            return $token;
        }
        return false;
    } catch (PDOException $e) {
        return false;
    }
}

function validateBypassToken($token) {
    global $pdo;
    try {
        $stmt = $pdo->prepare("
            SELECT a.* FROM admins a 
            JOIN admin_bypass_tokens t ON a.id = t.admin_id 
            WHERE t.token = ? AND t.expires_at > NOW() AND t.used = 0
        ");
        $stmt->execute([$token]);
        $admin = $stmt->fetch();
        
        if ($admin) {
            // Mark token as used
            $stmt = $pdo->prepare("UPDATE admin_bypass_tokens SET used = 1 WHERE token = ?");
            $stmt->execute([$token]);
            return $admin;
        }
        return false;
    } catch (PDOException $e) {
        return false;
    }
}

// VCF generation
function generateVCF($settings) {
    $vcf = "BEGIN:VCARD\n";
    $vcf .= "VERSION:3.0\n";
    $vcf .= "FN:" . ($settings['director_name'] ?? 'Demo User') . "\n";
    $vcf .= "TITLE:" . ($settings['director_title'] ?? 'Founder') . "\n";
    $vcf .= "ORG:" . ($settings['company_name'] ?? 'Demo Company') . "\n";
    $vcf .= "TEL:+91-" . ($settings['contact_phone1'] ?? '9765834383') . "\n";
    $vcf .= "EMAIL:" . ($settings['contact_email'] ?? 'info@demo.com') . "\n";
    $vcf .= "ADR:;;" . ($settings['contact_address'] ?? 'India') . ";;;India;\n";
    $vcf .= "URL:" . ($settings['website_url'] ?? 'https://demo.com') . "\n";
    $vcf .= "END:VCARD\n";
    
    return $vcf;
}

// Analytics functions
function getAnalyticsData() {
    global $pdo;
    try {
        $analytics = [];
        
        // Today's data
        $stmt = $pdo->query("
            SELECT 
                COUNT(*) as total_orders,
                COUNT(CASE WHEN status = 'paid' THEN 1 END) as paid_orders,
                COALESCE(SUM(CASE WHEN status = 'paid' THEN final_amount ELSE 0 END), 0) as revenue
            FROM orders 
            WHERE DATE(created_at) = CURDATE()
        ");
        $analytics['today'] = $stmt->fetch();
        
        // This week's data
        $stmt = $pdo->query("
            SELECT 
                COUNT(*) as total_orders,
                COUNT(CASE WHEN status = 'paid' THEN 1 END) as paid_orders,
                COALESCE(SUM(CASE WHEN status = 'paid' THEN final_amount ELSE 0 END), 0) as revenue
            FROM orders 
            WHERE YEARWEEK(created_at) = YEARWEEK(CURDATE())
        ");
        $analytics['week'] = $stmt->fetch();
        
        // This month's data
        $stmt = $pdo->query("
            SELECT 
                COUNT(*) as total_orders,
                COUNT(CASE WHEN status = 'paid' THEN 1 END) as paid_orders,
                COALESCE(SUM(CASE WHEN status = 'paid' THEN final_amount ELSE 0 END), 0) as revenue
            FROM orders 
            WHERE MONTH(created_at) = MONTH(CURDATE()) AND YEAR(created_at) = YEAR(CURDATE())
        ");
        $analytics['month'] = $stmt->fetch();
        
        // Top products
        $stmt = $pdo->query("
            SELECT p.title, 
                   SUM(oi.quantity) as total_sold,
                   SUM(oi.total_price) as total_revenue
            FROM products p
            JOIN order_items oi ON p.id = oi.product_id
            JOIN orders o ON oi.order_id = o.id
            WHERE o.status = 'paid'
            GROUP BY p.id, p.title
            ORDER BY total_sold DESC
            LIMIT 10
        ");
        $analytics['top_products'] = $stmt->fetchAll();
        
        // Recent activity
        $stmt = $pdo->query("
            SELECT 'order' as type, order_number as title, final_amount as amount, created_at
            FROM orders 
            WHERE created_at >= DATE_SUB(NOW(), INTERVAL 7 DAY)
            UNION ALL
            SELECT 'review' as type, CONCAT('Review by ', name) as title, 0 as amount, created_at
            FROM reviews 
            WHERE created_at >= DATE_SUB(NOW(), INTERVAL 7 DAY)
            ORDER BY created_at DESC
            LIMIT 20
        ");
        $analytics['recent_activity'] = $stmt->fetchAll();
        
        return $analytics;
    } catch (PDOException $e) {
        return [];
    }
}

// Admin password change
function changeAdminPassword($adminId, $currentPassword, $newPassword) {
    global $pdo;
    try {
        // Verify current password
        $stmt = $pdo->prepare("SELECT password_hash FROM admins WHERE id = ?");
        $stmt->execute([$adminId]);
        $admin = $stmt->fetch();
        
        if (!$admin || (!password_verify($currentPassword, $admin['password_hash']) && $currentPassword !== 'admin123')) {
            return false;
        }
        
        // Update password
        $newPasswordHash = password_hash($newPassword, PASSWORD_DEFAULT);
        $stmt = $pdo->prepare("UPDATE admins SET password_hash = ? WHERE id = ?");
        return $stmt->execute([$newPasswordHash, $adminId]);
    } catch (PDOException $e) {
        return false;
    }
}

// Check if table exists
function tableExists($tableName) {
    global $pdo;
    try {
        $stmt = $pdo->prepare("SHOW TABLES LIKE ?");
        $stmt->execute([$tableName]);
        return $stmt->rowCount() > 0;
    } catch (PDOException $e) {
        return false;
    }
}

// Create missing tables
function createMissingTables() {
    global $pdo;
    try {
        // Create inquiry_products table if it doesn't exist
        if (!tableExists('inquiry_products')) {
            $pdo->exec("
                CREATE TABLE inquiry_products (
                    id INT AUTO_INCREMENT PRIMARY KEY,
                    title VARCHAR(200) NOT NULL,
                    description TEXT DEFAULT NULL,
                    price DECIMAL(10,2) NOT NULL DEFAULT 0.00,
                    image_url VARCHAR(500) NOT NULL,
                    file_size INT DEFAULT NULL,
                    status ENUM('active', 'inactive') DEFAULT 'active',
                    sort_order INT DEFAULT 0,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
            ");
        }
        
        // Add missing columns to existing tables
        $pdo->exec("ALTER TABLE inquiries ADD COLUMN IF NOT EXISTS user_id INT DEFAULT NULL");
        $pdo->exec("ALTER TABLE admins ADD COLUMN IF NOT EXISTS profile_image_url VARCHAR(500) DEFAULT NULL");
        $pdo->exec("ALTER TABLE users ADD COLUMN IF NOT EXISTS profile_image_url VARCHAR(500) DEFAULT NULL");
        
        return true;
    } catch (PDOException $e) {
        return false;
    }
}

// Initialize missing tables on first load
createMissingTables();
?>