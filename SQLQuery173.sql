SELECT TOP (1000) [CategoryId]
      ,[CategoryName]
      ,[Subcategory]
      ,[DepositPercentage]
      ,[Details]
      ,[AdminFees]
      ,[AuctionFees]
      ,[BuyerCommission]
      ,[RegistrationDeadline]
      ,[Icon]
      ,[VATPercentage]
      ,[StatusId]
      ,[CreatedAt]
      ,[UpdatedAt]
      ,[VATId]
  FROM [AuctionManagementDB].[AuctionM_dbuser].[tblAssetCategories]



  CREATE TABLE TblAssetCategoryPaymentMethod (
    CategoryId INT NOT NULL,
    PaymentMethodId INT NOT NULL,
    PRIMARY KEY (CategoryId, PaymentMethodId),
    FOREIGN KEY (CategoryId) REFERENCES tblAssetCategories(CategoryId) ON DELETE CASCADE,
    FOREIGN KEY (PaymentMethodId) REFERENCES TblAssetPaymentMethod(Id) ON DELETE CASCADE
);

