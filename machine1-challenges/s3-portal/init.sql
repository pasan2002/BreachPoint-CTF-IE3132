CREATE DATABASE IF NOT EXISTS novaportal
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE novaportal;

CREATE TABLE IF NOT EXISTS users (
    id       INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(64)  NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email    VARCHAR(128) NOT NULL,
    role     VARCHAR(32)  NOT NULL DEFAULT 'user',
    created  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO users (username, password, email, role) VALUES
  ('admin',  'N0v4T3ch@dm1n', 'admin@novatech.lk',  'administrator'),
  ('deploy', 'D3pl0y#S3cur3!','deploy@novatech.lk', 'deployment');