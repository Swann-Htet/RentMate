# RentMate Full Database Schema

To deploy to Google Cloud Run with Google Cloud SQL, you'll want to initialize your database manually. You can run all these combined SQL statements directly in your Cloud SQL interface (like through MySQL Workbench, DBeaver, or the GCP Web UI). 

These queries merge your base table creation scripts and all the later migration scripts (like adding payment workflow columns into `rentals`) to give you a pristine database setup all at once.

```sql
CREATE DATABASE IF NOT EXISTS rentmate;
USE rentmate;

-- 1. Create users table
CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  phone VARCHAR(20),
  location VARCHAR(255),
  passport_no VARCHAR(50),
  passport_image VARCHAR(500),
  role ENUM('user', 'admin') DEFAULT 'user',
  user_type ENUM('borrower', 'lender', 'both') DEFAULT 'borrower',
  verification_status ENUM('unverified', 'pending', 'verified', 'rejected') DEFAULT 'unverified',
  verification_date TIMESTAMP NULL,
  rating DECIMAL(2,1) DEFAULT 0.0,
  total_ratings INT DEFAULT 0,
  is_verified BOOLEAN DEFAULT false,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 2. Create items table
CREATE TABLE IF NOT EXISTS items (
  id INT AUTO_INCREMENT PRIMARY KEY,
  item_id VARCHAR(20) UNIQUE NOT NULL,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  category VARCHAR(100),
  price DECIMAL(10,2) NOT NULL,
  deposit DECIMAL(10,2) DEFAULT 0,
  condition_status ENUM('new', 'like-new', 'good', 'fair') DEFAULT 'good',
  location VARCHAR(255),
  owner_id INT NOT NULL,
  images JSON,
  available BOOLEAN DEFAULT true,
  rating DECIMAL(2,1) DEFAULT 0.0,
  total_ratings INT DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (owner_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_owner (owner_id),
  INDEX idx_category (category),
  INDEX idx_available (available)
);

-- 3. Create rentals table (including all workflow and payment columns added in migrations)
CREATE TABLE IF NOT EXISTS rentals (
  id INT AUTO_INCREMENT PRIMARY KEY,
  item_id INT NOT NULL,
  borrower_id INT NOT NULL,
  lender_id INT NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  total_price DECIMAL(10,2) NOT NULL,
  status ENUM('pending', 'active', 'completed', 'cancelled') DEFAULT 'pending',
  
  -- Workflow additions 
  payment_amount DECIMAL(10,2) DEFAULT 0,
  deposit_amount DECIMAL(10,2) DEFAULT 0,
  payment_status ENUM('pending', 'paid', 'approved', 'transferred', 'refunded') DEFAULT 'pending',
  payment_date DATETIME NULL,
  admin_approved_at DATETIME NULL,
  admin_approved_by INT NULL,
  lender_paid_at DATETIME NULL,
  item_returned_at DATETIME NULL,
  return_confirmed_by_lender TINYINT(1) DEFAULT 0,
  deposit_refunded_at DATETIME NULL,
  workflow_status ENUM('payment_pending', 'payment_made', 'admin_review', 'approved', 'active', 'return_pending', 'completed', 'cancelled') DEFAULT 'payment_pending',
  lender_transfer_photo LONGTEXT NULL,
  borrower_receive_photo LONGTEXT NULL,
  admin_reject_refund_slip LONGTEXT NULL,

  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (item_id) REFERENCES items(id) ON DELETE CASCADE,
  FOREIGN KEY (borrower_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (lender_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_item (item_id),
  INDEX idx_borrower (borrower_id),
  INDEX idx_lender (lender_id),
  INDEX idx_status (status)
);

-- 4. Create reviews table
CREATE TABLE IF NOT EXISTS reviews (
  id INT AUTO_INCREMENT PRIMARY KEY,
  rental_id INT NOT NULL,
  reviewer_id INT NOT NULL,
  reviewee_id INT NOT NULL,
  rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
  comment TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (rental_id) REFERENCES rentals(id) ON DELETE CASCADE,
  FOREIGN KEY (reviewer_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (reviewee_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_rental (rental_id),
  INDEX idx_reviewee (reviewee_id)
);

-- 5. Create payments table
CREATE TABLE IF NOT EXISTS payments (
  id INT AUTO_INCREMENT PRIMARY KEY,
  rental_id INT NOT NULL,
  user_id INT NOT NULL,
  amount DECIMAL(10,2) NOT NULL,
  payment_type ENUM('rental', 'deposit', 'refund') NOT NULL,
  payment_method VARCHAR(50) DEFAULT 'card',
  transaction_id VARCHAR(255) NULL,
  status ENUM('pending', 'completed', 'failed', 'refunded') DEFAULT 'pending',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  completed_at DATETIME NULL,
  FOREIGN KEY (rental_id) REFERENCES rentals(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 6. Create chat_messages table
CREATE TABLE IF NOT EXISTS chat_messages (
  id INT AUTO_INCREMENT PRIMARY KEY,
  rental_id INT NOT NULL,
  sender_id INT NOT NULL,
  receiver_id INT NOT NULL,
  message_type ENUM('text', 'image') DEFAULT 'text',
  message_text TEXT NULL,
  image_url VARCHAR(500) NULL,
  is_read TINYINT(1) DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (rental_id) REFERENCES rentals(id) ON DELETE CASCADE,
  FOREIGN KEY (sender_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (receiver_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 7. Create rental_progress table
CREATE TABLE IF NOT EXISTS rental_progress (
  id INT AUTO_INCREMENT PRIMARY KEY,
  rental_id INT NOT NULL,
  status_type VARCHAR(100) NOT NULL,
  description TEXT NOT NULL,
  created_by INT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (rental_id) REFERENCES rentals(id) ON DELETE CASCADE,
  FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL
);

-- 8. Create notifications table
CREATE TABLE IF NOT EXISTS notifications (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  rental_id INT NULL,
  type VARCHAR(50) NOT NULL,
  title VARCHAR(255) NOT NULL,
  message TEXT NOT NULL,
  is_read TINYINT(1) DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (rental_id) REFERENCES rentals(id) ON DELETE CASCADE
);

-- 9. Create banking table
CREATE TABLE IF NOT EXISTS banking (
  id INT AUTO_INCREMENT PRIMARY KEY,
  bank_name VARCHAR(100) NOT NULL,
  bank_number VARCHAR(50) NOT NULL,
  account_holder_name VARCHAR(100) NOT NULL,
  account_type ENUM('savings', 'checking', 'business') DEFAULT 'savings',
  branch_name VARCHAR(100),
  swift_code VARCHAR(20),
  photo_scan TEXT,
  is_active BOOLEAN DEFAULT true,
  purpose VARCHAR(200) DEFAULT 'Payment processing',
  notes TEXT,
  created_by INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
  UNIQUE KEY unique_bank_number (bank_number)
);

-- 10. Create final_payments table
CREATE TABLE IF NOT EXISTS final_payments (
  id INT PRIMARY KEY AUTO_INCREMENT,
  rental_id INT NOT NULL,
  lender_fee_amount DECIMAL(10,2) NULL,
  lender_payment_slip LONGTEXT NULL,
  refund_amount DECIMAL(10,2) NULL,
  refund_slip LONGTEXT NULL,
  processed_by INT NOT NULL,
  processed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (rental_id) REFERENCES rentals(id) ON DELETE CASCADE,
  FOREIGN KEY (processed_by) REFERENCES users(id) ON DELETE RESTRICT,
  INDEX idx_rental_id (rental_id)
);
```