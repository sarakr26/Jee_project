-- Clubs and Federation schema
CREATE TABLE IF NOT EXISTS Federation (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  nom VARCHAR(255) NOT NULL,
  pays VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS Club (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  nom VARCHAR(255) NOT NULL,
  adresse VARCHAR(255),
  telephone VARCHAR(50),
  email VARCHAR(255),
  description TEXT,
  federation_id BIGINT,
  FOREIGN KEY (federation_id) REFERENCES Federation(id) ON DELETE SET NULL
);
