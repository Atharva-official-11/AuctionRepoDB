USE AuctionManagementDB;
DROP TABLE tblAssetDocuments;
DROP TABLE tblAssetDetails;
DROP TABLE tblAssetWinners;
DROP TABLE tblAssets_old;
EXEC SP_RENAME 'tblAssets_New' ,'tblAssets' 
EXEC SP_RENAME 'tblAssets' ,'tblAssets_old' 

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



SELECT 
    f.name AS ForeignKeyName,
    COL_NAME(fc.parent_object_id, fc.parent_column_id) AS ColumnName,
    OBJECT_NAME(f.referenced_object_id) AS ReferencedTable,
    OBJECT_NAME(f.parent_object_id) AS TableWithFK
FROM 
    sys.foreign_keys AS f
INNER JOIN 
    sys.foreign_key_columns AS fc 
    ON f.object_id = fc.constraint_object_id
WHERE 
    OBJECT_NAME(f.parent_object_id) = 'tblAuctionAssets';


ALTER TABLE tblAuctionAssets 
DROP CONSTRAINT FK__tblAuctio__Asset__6754599E;

ALTER TABLE tblAuctionAssets
ADD CONSTRAINT FK_tblAuctionAssets_AssetId
FOREIGN KEY (AssetId) REFERENCES tblAssets(AssetId);
