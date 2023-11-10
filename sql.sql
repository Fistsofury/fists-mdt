CREATE TABLE IF NOT EXISTS `mdt_data` (
    `id` INT AUTO_INCREMENT,
    `case_number` VARCHAR(255) NOT NULL,
    `surname` VARCHAR(255) NOT NULL,
    `first_name` VARCHAR(255) NOT NULL,
    `crime_category` VARCHAR(255) NOT NULL,
    `specific_crime` VARCHAR(255) NOT NULL,
    `description` TEXT NOT NULL,
    `officers_notes` TEXT NOT NULL,
    `suggested_fine` DECIMAL(10, 2) NOT NULL,
    `suggested_sentence` INT NOT NULL,
    `status` ENUM('open', 'closed', 'cancelled') NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


