USE chess_club_db;

-- Add podium winner columns to evenement table
ALTER TABLE `evenement` 
    ADD COLUMN `premier_id` BIGINT(20) DEFAULT NULL COMMENT 'ID du premier place (1ere position)',
    ADD COLUMN `deuxieme_id` BIGINT(20) DEFAULT NULL COMMENT 'ID du deuxieme place (2eme position)',
    ADD COLUMN `troisieme_id` BIGINT(20) DEFAULT NULL COMMENT 'ID du troisieme place (3eme position)';

-- Add foreign key constraints to ensure podium winners are valid users
ALTER TABLE `evenement`
    ADD CONSTRAINT `fk_evenement_premier` 
        FOREIGN KEY (`premier_id`) REFERENCES `utilisateur`(`id`) 
        ON DELETE SET NULL ON UPDATE CASCADE,
    ADD CONSTRAINT `fk_evenement_deuxieme` 
        FOREIGN KEY (`deuxieme_id`) REFERENCES `utilisateur`(`id`) 
        ON DELETE SET NULL ON UPDATE CASCADE,
    ADD CONSTRAINT `fk_evenement_troisieme` 
        FOREIGN KEY (`troisieme_id`) REFERENCES `utilisateur`(`id`) 
        ON DELETE SET NULL ON UPDATE CASCADE;

-- Add indexes for better query performance
CREATE INDEX `idx_evenement_premier` ON `evenement`(`premier_id`);
CREATE INDEX `idx_evenement_deuxieme` ON `evenement`(`deuxieme_id`);
CREATE INDEX `idx_evenement_troisieme` ON `evenement`(`troisieme_id`);

-- Optional: Add index on statut for filtering finished events
CREATE INDEX `idx_evenement_statut` ON `evenement`(`statut`);

-- Verify the changes
SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    IS_NULLABLE, 
    COLUMN_DEFAULT,
    COLUMN_COMMENT
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = 'chess_club_db' 
    AND TABLE_NAME = 'evenement'
    AND COLUMN_NAME IN ('premier_id', 'deuxieme_id', 'troisieme_id');