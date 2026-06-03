-- ============================================================
-- LKS Provinsi Jawa Barat Tahun 2026
-- Web Technologies - Server Side Module
-- Database Dump: db_dump.sql for PintarMenabung
-- ============================================================

CREATE DATABASE IF NOT EXISTS `pintar_menabung`
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE `pintar_menabung`;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS `personal_access_tokens`;
DROP TABLE IF EXISTS `transactions`;
DROP TABLE IF EXISTS `wallets`;
DROP TABLE IF EXISTS `categories`;
DROP TABLE IF EXISTS `currencies`;
DROP TABLE IF EXISTS `users`;
SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================
-- Table: users
-- ============================================================
CREATE TABLE `users` (
  `id` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `email` VARCHAR(255) NOT NULL,
  `email_verified_at` TIMESTAMP NULL DEFAULT NULL,
  `password` VARCHAR(255) NOT NULL,
  `remember_token` VARCHAR(100) DEFAULT NULL,
  `created_at` TIMESTAMP NULL DEFAULT NULL,
  `updated_at` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- Table: currencies
-- ============================================================
CREATE TABLE `currencies` (
  `id` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `symbol` VARCHAR(50) NOT NULL,
  `code` VARCHAR(10) NOT NULL,
  `created_at` TIMESTAMP NULL DEFAULT NULL,
  `updated_at` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `currencies_code_unique` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- Table: categories
-- ============================================================
CREATE TABLE `categories` (
  `id` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `icon` VARCHAR(50) NOT NULL,
  `color` VARCHAR(50) NOT NULL,
  `type` ENUM('INCOME','EXPENSE') NOT NULL,
  `created_at` TIMESTAMP NULL DEFAULT NULL,
  `updated_at` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- Table: wallets
-- ============================================================
CREATE TABLE `wallets` (
  `id` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT(20) UNSIGNED NOT NULL,
  `name` VARCHAR(255) NOT NULL,
  `currency_code` VARCHAR(10) NOT NULL,
  `created_at` TIMESTAMP NULL DEFAULT NULL,
  `updated_at` TIMESTAMP NULL DEFAULT NULL,
  `deleted_at` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `wallets_user_id_foreign` (`user_id`),
  KEY `wallets_currency_code_foreign` (`currency_code`),
  CONSTRAINT `wallets_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `wallets_currency_code_foreign` FOREIGN KEY (`currency_code`) REFERENCES `currencies` (`code`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- Table: transactions
-- ============================================================
CREATE TABLE `transactions` (
  `id` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `wallet_id` BIGINT(20) UNSIGNED NOT NULL,
  `category_id` BIGINT(20) UNSIGNED NOT NULL,
  `amount` BIGINT(20) NOT NULL,
  `note` TEXT DEFAULT NULL,
  `date` DATE NOT NULL,
  `created_at` TIMESTAMP NULL DEFAULT NULL,
  `updated_at` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `transactions_wallet_id_foreign` (`wallet_id`),
  KEY `transactions_category_id_foreign` (`category_id`),
  CONSTRAINT `transactions_wallet_id_foreign` FOREIGN KEY (`wallet_id`) REFERENCES `wallets` (`id`) ON DELETE CASCADE,
  CONSTRAINT `transactions_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- Table: personal_access_tokens (Laravel Sanctum)
-- ============================================================
CREATE TABLE `personal_access_tokens` (
  `id` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `tokenable_type` VARCHAR(255) NOT NULL,
  `tokenable_id` BIGINT(20) UNSIGNED NOT NULL,
  `name` VARCHAR(255) NOT NULL,
  `token` VARCHAR(64) NOT NULL,
  `abilities` TEXT DEFAULT NULL,
  `last_used_at` TIMESTAMP NULL DEFAULT NULL,
  `expires_at` TIMESTAMP NULL DEFAULT NULL,
  `created_at` TIMESTAMP NULL DEFAULT NULL,
  `updated_at` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ============================================================
-- DUMMY DATA SEEDING
-- ============================================================

-- Currencies
INSERT INTO `currencies` (`id`, `name`, `symbol`, `code`, `created_at`, `updated_at`) VALUES
(1, 'US Dollar', '$', 'USD', '2025-07-11 16:01:37', '2025-07-11 16:01:37'),
(2, 'Indonesian Rupiah', 'Rp', 'IDR', '2025-07-11 16:01:37', '2025-07-11 16:01:37');

-- Categories
INSERT INTO `categories` (`id`, `name`, `icon`, `color`, `type`, `created_at`, `updated_at`) VALUES
(1, 'Outgoing Transfer', '⬆', '#FF7675', 'EXPENSE', '2025-07-11 16:01:38', '2025-07-11 16:01:38'),
(2, 'Incoming Transfer', '⬇', '#00B894', 'INCOME', '2025-07-28 02:37:46', '2025-07-28 02:37:46'),
(3, 'Food & Drinks', '🍔', '#FDCB6E', 'EXPENSE', '2025-07-11 16:01:38', '2025-07-11 16:01:38'),
(13, 'Groceries', '🛒', '#55EFC4', 'EXPENSE', '2025-07-28 02:37:46', '2025-07-28 02:37:46'),
(14, 'Salary', '💰', '#0984E3', 'INCOME', '2025-07-28 02:37:46', '2025-07-28 02:37:46'),
(15, 'Transport', '🚗', '#00CEC9', 'EXPENSE', '2025-07-28 02:37:46', '2025-07-28 02:37:46');

-- Users (password = "password" hashed using bcrypt)
-- Hash: $2y$12$TKh8H1.PFbuSpX6Z8.7T1OL3tBeFkO8lMb2wq.X9RKZGXf9RXbq7K
INSERT INTO `users` (`id`, `name`, `email`, `email_verified_at`, `password`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, 'Budi', 'budi@webtech.id', NULL, '$2y$12$TKh8H1.PFbuSpX6Z8.7T1OL3tBeFkO8lMb2wq.X9RKZGXf9RXbq7K', NULL, '2025-07-11 16:01:38', '2025-07-11 16:01:38'),
(2, 'Dedi', 'dedi@webtech.id', NULL, '$2y$12$TKh8H1.PFbuSpX6Z8.7T1OL3tBeFkO8lMb2wq.X9RKZGXf9RXbq7K', NULL, '2025-07-11 16:01:46', '2025-07-11 16:01:46');

-- Wallets
INSERT INTO `wallets` (`id`, `user_id`, `name`, `currency_code`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 1, 'Cash IDR', 'IDR', '2025-07-11 16:01:38', '2025-07-11 16:26:25', NULL),
(2, 1, 'Bank', 'IDR', '2025-07-11 16:01:38', '2025-07-11 16:01:38', NULL),
(3, 1, 'Savings', 'IDR', '2025-07-11 16:01:38', '2025-07-11 16:01:38', NULL);

-- Transactions
-- Wallet 1: Balance should be 4,865,000
-- +5,000,000 (Incoming Transfer)
-- -50,000 (Food & Drinks - Starbucks)
-- -50,000 (Groceries)
-- -35,000 (Food & Drinks - Lunch)
INSERT INTO `transactions` (`id`, `wallet_id`, `category_id`, `amount`, `note`, `date`, `created_at`, `updated_at`) VALUES
(1, 1, 2, 5000000, 'salary transfer', '2025-07-25', '2025-07-25 10:00:00', '2025-07-25 10:00:00'),
(842, 1, 3, 50000, 'starbucks', '2025-07-31', '2025-07-11 16:44:09', '2025-07-11 16:44:09'),
(843, 1, 13, 50000, 'groceries weekly', '2025-07-28', '2025-07-28 11:00:00', '2025-07-28 11:00:00'),
(844, 1, 3, 35000, 'lunch', '2025-07-15', '2025-07-15 12:30:00', '2025-07-15 12:30:00');

-- Wallet 2: Balance should be 12,250,000
-- +13,000,000 (Incoming Transfer)
-- -750,000 (Outgoing Transfer)
INSERT INTO `transactions` (`id`, `wallet_id`, `category_id`, `amount`, `note`, `date`, `created_at`, `updated_at`) VALUES
(5, 2, 2, 13000000, 'monthly bonus', '2025-07-20', '2025-07-20 09:00:00', '2025-07-20 09:00:00'),
(6, 2, 1, 750000, 'rent transfer', '2025-07-22', '2025-07-22 14:00:00', '2025-07-22 14:00:00');
