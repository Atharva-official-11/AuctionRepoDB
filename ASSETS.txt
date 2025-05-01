create database trailAssests;
---DROP DATABASE trailAssests;
use trailAssests;

SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE';
--DEMO USER

CREATE TABLE tblUsers(
UserId INT PRIMARY KEY ,
);

CREATE TABLE tblSellers(
	SellerId INT PRIMARY KEY IDENTITY,
	UserId INT FOREIGN KEY REFERENCES tblUsers(UserId)
);

CREATE TABLE tblAssetCategories (
    CategoryId INT PRIMARY KEY IDENTITY,
    CategoryName NVARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE tblAssetStatus (
    StatusId INT PRIMARY KEY IDENTITY,
    StatusName NVARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE tblVATOptions (
    VATId INT PRIMARY KEY IDENTITY,
    VATType NVARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE tblWinnerAwardingOptions (
    AwardingId INT PRIMARY KEY IDENTITY,
    AwardingMethod NVARCHAR(50) NOT NULL UNIQUE
);

-- Main Asset Table
CREATE TABLE tblAssets (
    AssetId INT PRIMARY KEY IDENTITY,
    Title NVARCHAR(255) NOT NULL,
    CategoryId INT FOREIGN KEY REFERENCES tblAssetCategories(CategoryId),
    Deposit DECIMAL(5,2) CHECK (Deposit BETWEEN 1 AND 100),
    SellerId INT NOT NULL FOREIGN KEY REFERENCES tblSellers(SellerId), 
    Commission DECIMAL(5,2) CHECK (Commission BETWEEN 1 AND 100),
    StartingPrice DECIMAL(18,2) NOT NULL,
    ReserveAmount DECIMAL(18,2),
    IncrementalTime INT,
    MinIncrement DECIMAL(18,2),
    MakeOffer BIT DEFAULT 0,
    Featured BIT DEFAULT 0,
    AwardingId INT FOREIGN KEY REFERENCES tblWinnerAwardingOptions(AwardingId),
    StatusId INT FOREIGN KEY REFERENCES tblAssetStatus(StatusId),
    VATId INT FOREIGN KEY REFERENCES tblVATOptions(VATId),
    VATPercent DECIMAL(5,2) CHECK (VATPercent BETWEEN 1 AND 100),
    CourtCaseNumber NVARCHAR(100),
    RegistrationDeadline INT,
    Description NVARCHAR(MAX),
    MapLatitude DECIMAL(9,6),
    MapLongitude DECIMAL(9,6),
    AdminFees DECIMAL(18,2),
    AuctionFees DECIMAL(18,2),
    BuyerCommission DECIMAL(18,2),
    WinnerId INT, -- FK to Users
    SalesNotes NVARCHAR(MAX),
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE()
);



-- Asset Media
CREATE TABLE tblAssetGallery (
    GalleryId INT PRIMARY KEY IDENTITY,
    AssetId INT FOREIGN KEY REFERENCES tblAssets(AssetId),
    MediaType NVARCHAR(10), -- 'Image' or 'Video'
    FilePath NVARCHAR(MAX),
    SortOrder INT
);

-- Asset Documents
CREATE TABLE tblAssetDocuments (
    DocumentId INT PRIMARY KEY IDENTITY,
    AssetId INT FOREIGN KEY REFERENCES tblAssets(AssetId),
    DocumentType NVARCHAR(100),
    FilePath NVARCHAR(MAX)
);

-- Dynamic Attributes
CREATE TABLE tblAssetDetails (
    DetailId INT PRIMARY KEY IDENTITY,
    AssetId INT FOREIGN KEY REFERENCES tblAssets(AssetId),
    AttributeName NVARCHAR(100),
    AttributeValue NVARCHAR(255)
);

-- Asset Winner
CREATE TABLE tblAssetWinners (
    WinnerId INT PRIMARY KEY IDENTITY,
    AssetId INT FOREIGN KEY REFERENCES tblAssets(AssetId),
    UserId INT  FOREIGN KEY REFERENCES tblUsers(UserId), -- FK to Users
    AwardedPrice DECIMAL(18,2),
    Reason NVARCHAR(255),
    Note NVARCHAR(MAX),
    Approved BIT DEFAULT 0,
    CreatedAt DATETIME DEFAULT GETDATE()
);

-- Winner Documents
CREATE TABLE tblWinnerDocuments (
    WinnerDocumentId INT PRIMARY KEY IDENTITY,
    WinnerId INT FOREIGN KEY REFERENCES tblAssetWinners(WinnerId),
    DocumentType NVARCHAR(100),
    FilePath NVARCHAR(MAX),
    UploadedAt DATETIME DEFAULT GETDATE()
);


-- Asset Categories
INSERT INTO tblAssetCategories (CategoryName) VALUES 
('Auction'), ('Fixed Price'), ('Instant Buy');

-- Asset Statuses
INSERT INTO tblAssetStatus (StatusName) VALUES 
('Draft'), ('Published'), ('Auctioned'), ('Archived'),
('Pending'), ('Approval'), ('Payment'), ('Registration'),
('Transferred'), ('Closed');

-- VAT Options
INSERT INTO tblVATOptions (VATType) VALUES 
('Exclusive'), ('Inclusive'), ('Not Applicable');

-- Winner Awarding
INSERT INTO tblWinnerAwardingOptions (AwardingMethod) VALUES 
('Automatic'), ('Manual');









-- Add a new user
INSERT INTO tblUsers (UserId) VALUES (10);

-- Add a new seller (linked to new user)
INSERT INTO tblSellers (UserId) VALUES (10);

-- Add a new asset using valid enum references
-- Add a new asset with corrected VATPercent value
INSERT INTO tblAssets (
    Title, CategoryId, Deposit, SellerId, Commission, 
    StartingPrice, ReserveAmount, IncrementalTime, MinIncrement, 
    MakeOffer, Featured, AwardingId, StatusId, VATId, VATPercent, 
    CourtCaseNumber, RegistrationDeadline, Description, 
    MapLatitude, MapLongitude, AdminFees, AuctionFees, 
    BuyerCommission, WinnerId, SalesNotes
) VALUES (
    'Commercial Warehouse', 
    2,                 -- Fixed Price
    7.50, 
    2,                 -- Assuming sellerId 2 exists (or you can use SCOPE_IDENTITY() if dynamic)
    3.00, 
    500000.00, 
    550000.00, 
    30, 
    10000.00, 
    0, 1,              -- MakeOffer: false, Featured: true
    2,                 -- Manual awarding
    1,                 -- Draft status
    3,                 -- Not Applicable VAT
    NULL,              -- VATPercent set to NULL since VAT is Not Applicable
    'CCN-WH-0099', 
    15, 
    'Large commercial warehouse near industrial area',
    26.204102, 
    50.571680, 
    2000.00, 
    3500.00, 
    5000.00, 
    10,                -- WinnerId (same as UserId inserted)
    'Strategically located near shipping terminal'
);


-- Add media to the new asset (assuming AssetId = 2)
INSERT INTO tblAssetGallery (AssetId, MediaType, FilePath, SortOrder) VALUES
(2, 'Image', '/assets/warehouse_front.jpg', 1),
(2, 'Image', '/assets/warehouse_inside.jpg', 2);

-- Add documents to the asset
INSERT INTO tblAssetDocuments (AssetId, DocumentType, FilePath) VALUES
(2, 'Title Deed', '/docs/warehouse_title.pdf'),
(2, 'Inspection Report', '/docs/warehouse_inspection.pdf');

-- Add dynamic details
INSERT INTO tblAssetDetails (AssetId, AttributeName, AttributeValue) VALUES
(2, 'Total Area', '9000 sqft'),
(2, 'Construction Year', '2015'),
(2, 'Parking Slots', '10');

-- Add winner (UserId 10)
INSERT INTO tblAssetWinners (AssetId, UserId, AwardedPrice, Reason, Note, Approved) VALUES
(2, 10, 520000.00, 'Only bidder', 'Payment received in full', 1);

-- Add winner document
INSERT INTO tblWinnerDocuments (WinnerId, DocumentType, FilePath) VALUES
(2, 'Contract Agreement', '/docs/warehouse_contract.pdf');


SELECT * FROM tblUsers;
SELECT * FROM tblAssetCategories;
SELECT * FROM tblAssetStatus;
SELECT * FROM tblVATOptions;
SELECT * FROM tblWinnerAwardingOptions;
SELECT * FROM tblAssets;
SELECT * FROM tblAssetGallery;
SELECT * FROM tblAssetDetails;
SELECT * FROM tblAssetDocuments;
SELECT * FROM tblAssetWinners;
SELECT * FROM tblWinnerDocuments;
