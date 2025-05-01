CREATE DATABASE TransactionTrail

USE TransactionTrail

-- 1. Users Table
CREATE TABLE Users (
    UserId BIGINT PRIMARY KEY IDENTITY(1,1),
    Username VARCHAR(100) NOT NULL,
    Email VARCHAR(150),
    CreatedAt DATETIME DEFAULT GETDATE()
);

-- 2. Assets Table
CREATE TABLE Assets (
    AssetId BIGINT PRIMARY KEY IDENTITY(1,1),
    AssetNumber VARCHAR(50) NOT NULL UNIQUE,
    Title VARCHAR(255) NOT NULL,
    BidPrice DECIMAL(18,2),
    Category VARCHAR(100),
    EndTime DATETIME,
    ImagePath VARCHAR(255),
    CreatedAt DATETIME DEFAULT GETDATE()
);

-- 3. Lookup Tables for Enum Values

-- Transaction Type Enum Table
CREATE TABLE TransactionTypes (
    TransactionTypeId INT PRIMARY KEY IDENTITY(1,1),
    TransactionTypeName VARCHAR(50) NOT NULL UNIQUE
);

-- Payment Method Enum Table
CREATE TABLE PaymentMethods (
    PaymentMethodId INT PRIMARY KEY IDENTITY(1,1),
    PaymentMethodName VARCHAR(50) NOT NULL UNIQUE
);

-- Card Type Enum Table
CREATE TABLE CardTypes (
    CardTypeId INT PRIMARY KEY IDENTITY(1,1),
    CardTypeName VARCHAR(50) NOT NULL UNIQUE
);

-- Status Enum Table
CREATE TABLE TransactionStatuses (
    StatusId INT PRIMARY KEY IDENTITY(1,1),
    StatusName VARCHAR(50) NOT NULL UNIQUE
);

-- 4. Transactions Table
CREATE TABLE Transactions (
    TransactionId BIGINT PRIMARY KEY IDENTITY(1,1),
    TransactionNumber VARCHAR(50) NOT NULL UNIQUE,
    Amount DECIMAL(18,2) NOT NULL,
    UserId BIGINT NOT NULL,
    TransactionTypeId INT NOT NULL,
    PaymentMethodId INT NOT NULL,
    CardTypeId INT,
    MerchantTransactionId VARCHAR(100),
    TransactionDateTime DATETIME NOT NULL,
    StatusId INT NOT NULL,
    Notes TEXT NULL,
    DocumentPath VARCHAR(255) NULL,
    CreatedByAdminID BIGINT NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserId) REFERENCES Users(UserId),
    FOREIGN KEY (TransactionTypeId) REFERENCES TransactionTypes(TransactionTypeId),
    FOREIGN KEY (PaymentMethodId) REFERENCES PaymentMethods(PaymentMethodId),
    FOREIGN KEY (CardTypeId) REFERENCES CardTypes(CardTypeId),
    FOREIGN KEY (StatusId) REFERENCES TransactionStatuses(StatusId)
);

-- 5. Transaction Documents Table (Bank Transfer Slips, PDFs)
CREATE TABLE TransactionDocuments (
    DocumentId BIGINT PRIMARY KEY IDENTITY(1,1),
    TransactionId BIGINT NOT NULL,
    DocumentType VARCHAR(50),
    FilePath VARCHAR(255) NOT NULL,
    UploadedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (TransactionId) REFERENCES Transactions(TransactionId)
);

-- 6. TransactionAssets Table (Many-to-Many relation between Transactions & Assets)
CREATE TABLE TransactionAssets (
    Id BIGINT PRIMARY KEY IDENTITY(1,1),
    TransactionId BIGINT NOT NULL,
    AssetId BIGINT NOT NULL,
    BidPrice DECIMAL(18,2), -- Optional, as shown in UI
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (TransactionId) REFERENCES Transactions(TransactionId),
    FOREIGN KEY (AssetId) REFERENCES Assets(AssetId)
);


-- INSERT INTO TransactionTypes
INSERT INTO TransactionTypes (TransactionTypeName) VALUES 
('Receipt'),
('Deposit'),
('Refund'),
('Invoice');

-- INSERT INTO PaymentMethods
INSERT INTO PaymentMethods (PaymentMethodName) VALUES 
('Credit Card'),
('Debit Card'),
('Benefit Pay'),
('Bank Transfer'),
('Cash');

-- INSERT INTO CardTypes
INSERT INTO CardTypes (CardTypeName) VALUES 
('VISA'),
('MasterCard'),
('Debit');

-- INSERT INTO TransactionStatuses
INSERT INTO TransactionStatuses (StatusName) VALUES 
('Pending'),
('Done'),
('Failed'),
('Cancelled');

-- INSERT INTO Users
INSERT INTO Users (Username, Email) VALUES 
('john_doe', 'john@example.com'),
('sara_smith', 'sara@example.com');

-- INSERT INTO Assets
INSERT INTO Assets (AssetNumber, Title, BidPrice, Category, EndTime, ImagePath) VALUES
('AS001', 'Audi Q5', 18000.00, 'Vehicle', '2025-05-10 17:00', '/images/audi_q5.jpg'),
('AS002', 'Beachside Apartment', 350000.00, 'Real Estate', '2025-06-01 14:00', '/images/beach_apartment.jpg');

-- INSERT INTO Transactions
INSERT INTO Transactions (
    TransactionNumber, Amount, UserId, TransactionTypeId, 
    PaymentMethodId, CardTypeId, MerchantTransactionId, 
    TransactionDateTime, StatusId, Notes, DocumentPath, CreatedByAdminID
) VALUES
('#TXN1001', 18000.00, 1, 1, 
 3, 1, 'BNFT20250420001', 
 GETDATE(), 2, 'Benefit Pay successful', '/docs/txn1001.pdf', NULL);

-- INSERT INTO TransactionDocuments
INSERT INTO TransactionDocuments (TransactionId, DocumentType, FilePath) VALUES
(1, 'Bank Transfer Slip', '/docs/txn1001.pdf');

-- INSERT INTO TransactionAssets
INSERT INTO TransactionAssets (TransactionId, AssetId, BidPrice) VALUES
(1, 1, 18000.00);


-- 1. Select all rows from TransactionTypes table
SELECT * FROM TransactionTypes;

-- 2. Select all rows from PaymentMethods table
SELECT * FROM PaymentMethods;

-- 3. Select all rows from CardTypes table
SELECT * FROM CardTypes;

-- 4. Select all rows from TransactionStatuses table
SELECT * FROM TransactionStatuses;

-- 5. Select all rows from Users table (Optional, if you want to check Users)
SELECT * FROM Users;

-- 6. Select all rows from Assets table (Optional, if you want to check Assets)
SELECT * FROM Assets;

-- 7. Select all rows from Transactions table (Optional, if you want to check Transactions)
SELECT * FROM Transactions;

-- 8. Select all rows from TransactionDocuments table (Optional, if you want to check Documents)
SELECT * FROM TransactionDocuments;

-- 9. Select all rows from TransactionAssets table (Optional, if you want to check Asset-Transaction relationships)
SELECT * FROM TransactionAssets;
