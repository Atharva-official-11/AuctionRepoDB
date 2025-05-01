USE AuctionManagementDB


CREATE TABLE tblTransactionTypes (
    TransactionTypeId INT PRIMARY KEY IDENTITY,
    TransactionTypeName VARCHAR(50) NOT NULL UNIQUE
);

-- Payment Method Enum Table
CREATE TABLE tblPaymentMethods (
    PaymentMethodId INT PRIMARY KEY IDENTITY,
    PaymentMethodName VARCHAR(50) NOT NULL UNIQUE
);

-- Card Type Enum Table
CREATE TABLE tblCardTypes (
    CardTypeId INT PRIMARY KEY IDENTITY,
    CardTypeName VARCHAR(50) NOT NULL UNIQUE
);

-- Status Enum Table
CREATE TABLE tblTransactionStatuses (
    StatusId INT PRIMARY KEY IDENTITY,
    StatusName VARCHAR(50) NOT NULL UNIQUE
);

-- Transactions Table
CREATE TABLE tblTransactions (
    TransactionId INT PRIMARY KEY IDENTITY,
    TransactionNumber VARCHAR(50) NOT NULL UNIQUE,
    Amount DECIMAL(18,2) NOT NULL,
    UserId INT NOT NULL,
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
    FOREIGN KEY (UserId) REFERENCES tblUsers(UserId),
    FOREIGN KEY (TransactionTypeId) REFERENCES tblTransactionTypes(TransactionTypeId),
    FOREIGN KEY (PaymentMethodId) REFERENCES tblPaymentMethods(PaymentMethodId),
    FOREIGN KEY (CardTypeId) REFERENCES tblCardTypes(CardTypeId),
    FOREIGN KEY (StatusId) REFERENCES tblTransactionStatuses(StatusId)
);

-- Transaction Documents Table (Bank Transfer Slips, PDFs)
CREATE TABLE tblTransactionDocuments (
    DocumentId INT PRIMARY KEY IDENTITY(1,1),
    TransactionId INT NOT NULL,
    DocumentType VARCHAR(50),
    FilePath VARCHAR(255) NOT NULL,
    UploadedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (TransactionId) REFERENCES tblTransactions(TransactionId)
);

-- TransactionAssets Table (Many-to-Many relation between Transactions & Assets)
CREATE TABLE tblTransactionAssets (
    TransactionAssetsId INT PRIMARY KEY IDENTITY,
    TransactionId INT NOT NULL,
    AssetId INT NOT NULL,
    BidPrice DECIMAL(18,2), -- Optional, as shown in UI
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (TransactionId) REFERENCES tblTransactions(TransactionId),
    FOREIGN KEY (AssetId) REFERENCES tblAssets(AssetId)
);



SELECT * FROM tblTransactionTypes;
SELECT * FROM tblPaymentMethods;
SELECT * FROM tblCardTypes;
SELECT * FROM tblTransactionStatuses;
SELECT * FROM tblUsers;
SELECT * FROM tblAssets;
SELECT * FROM tblTransactions;
SELECT * FROM tblTransactionDoc	uments;
SELECT * FROM tblTransactionAssets;
