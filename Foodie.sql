USE [master]
GO

-- Tạo cơ sở dữ liệu FoodieDB
CREATE DATABASE [FoodieDB]
GO

-- Các cài đặt khác cho cơ sở dữ liệu
ALTER DATABASE [FoodieDB] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [FoodieDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [FoodieDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [FoodieDB] SET RECOVERY FULL 
GO
ALTER DATABASE [FoodieDB] SET MULTI_USER 
GO
ALTER DATABASE [FoodieDB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [FoodieDB] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [FoodieDB] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [FoodieDB] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [FoodieDB] SET QUERY_STORE = ON
GO

-- Thiết lập tùy chọn QUERY_STORE trong các lệnh riêng biệt
ALTER DATABASE [FoodieDB] SET QUERY_STORE (OPERATION_MODE = READ_WRITE)
GO
ALTER DATABASE [FoodieDB] SET QUERY_STORE (CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30))
GO
ALTER DATABASE [FoodieDB] SET QUERY_STORE (DATA_FLUSH_INTERVAL_SECONDS = 900)
GO
ALTER DATABASE [FoodieDB] SET QUERY_STORE (INTERVAL_LENGTH_MINUTES = 60)
GO
ALTER DATABASE [FoodieDB] SET QUERY_STORE (MAX_STORAGE_SIZE_MB = 1000)
GO
ALTER DATABASE [FoodieDB] SET QUERY_STORE (QUERY_CAPTURE_MODE = AUTO)
GO
ALTER DATABASE [FoodieDB] SET QUERY_STORE (SIZE_BASED_CLEANUP_MODE = AUTO)
GO
ALTER DATABASE [FoodieDB] SET QUERY_STORE (MAX_PLANS_PER_QUERY = 200)
GO
ALTER DATABASE [FoodieDB] SET QUERY_STORE (WAIT_STATS_CAPTURE_MODE = ON)
GO

-- Chuyển sang sử dụng cơ sở dữ liệu FoodieDB
USE [FoodieDB]
GO
CREATE TABLE [dbo].[carts] (
    [CartId] INT IDENTITY(1,1) NOT NULL,
    [ProductId] INT NULL,
    [Quantity] INT NULL,
    [UserId] INT NULL,
    PRIMARY KEY CLUSTERED ([CartId] ASC)
);
GO

-- Tạo bảng 'categories'
CREATE TABLE [dbo].[categories] (
    [CategoryId] INT IDENTITY(1,1) NOT NULL,
    [Name] VARCHAR(50) NULL,
    [ImageUrl] VARCHAR(MAX) NULL,
    [IsActive] BIT NULL,
    [CreatedDate] DATETIME NULL,
    PRIMARY KEY CLUSTERED ([CategoryId] ASC)
) TEXTIMAGE_ON [PRIMARY];
GO

-- Tạo bảng 'Contact'
CREATE TABLE [dbo].[Contact] (
    [ContactId] INT IDENTITY(1,1) NOT NULL,
    [Name] VARCHAR(50) NULL,
    [Email] VARCHAR(50) NULL,
    [Subject] VARCHAR(200) NULL,
    [Message] VARCHAR(MAX) NULL,
    [CreatedDate] DATETIME NULL,
    PRIMARY KEY CLUSTERED ([ContactId] ASC)
) TEXTIMAGE_ON [PRIMARY];
GO

-- Tạo bảng 'Orders'
CREATE TABLE [dbo].[Orders] (
    [OrderDetailsId] INT IDENTITY(1,1) NOT NULL,
    [OrderNo] VARCHAR(MAX) NULL,
    [ProductId] INT NULL,
    [Quantity] INT NULL,
    [UserId] INT NULL,
    [Status] VARCHAR(50) NULL,
    [PaymentId] INT NULL,
    [OrderDate] DATETIME NULL,
    PRIMARY KEY CLUSTERED ([OrderDetailsId] ASC)
) TEXTIMAGE_ON [PRIMARY];
GO

-- Tạo bảng 'Payment'
CREATE TABLE [dbo].[Payment] (
    [PaymentId] INT IDENTITY(1,1) NOT NULL,
    [Name] VARCHAR(50) NULL,
    [CardNo] VARCHAR(50) NULL,
    [ExpiryDate] VARCHAR(50) NULL,
    [CvvNo] INT NULL,
    [Address] VARCHAR(MAX) NULL,
    [PaymentMode] VARCHAR(50) NULL,
    PRIMARY KEY CLUSTERED ([PaymentId] ASC)
) TEXTIMAGE_ON [PRIMARY];
GO

-- Tạo bảng 'Products'
CREATE TABLE [dbo].[Products] (
    [ProductId] INT IDENTITY(1,1) NOT NULL,
    [Name] VARCHAR(50) NULL,
    [Description] VARCHAR(MAX) NULL,
    [Price] DECIMAL(18, 2) NULL,
    [Quantity] INT NULL,
    [ImageUrl] VARCHAR(MAX) NULL,
    [CategoryId] INT NULL,
    [IsActive] BIT NULL,
    [CreatedDate] DATETIME NULL,
    PRIMARY KEY CLUSTERED ([ProductId] ASC)
) TEXTIMAGE_ON [PRIMARY];
GO

-- Tạo bảng 'Users'
CREATE TABLE [dbo].[Users] (
    [UserId] INT IDENTITY(1,1) NOT NULL,
    [Name] VARCHAR(50) NULL,
    [Username] VARCHAR(50) NULL,
    [Mobile] VARCHAR(50) NULL,
    [Email] VARCHAR(50) NULL,
    [Address] VARCHAR(MAX) NULL,
    [PostCode] VARCHAR(50) NULL,
    [Password] VARCHAR(50) NULL,
    [ImageUrl] VARCHAR(MAX) NULL,
    [CreatedDate] DATETIME NULL,
    PRIMARY KEY CLUSTERED ([UserId] ASC),
    UNIQUE NONCLUSTERED ([Username] ASC),
    UNIQUE NONCLUSTERED ([Email] ASC)
) TEXTIMAGE_ON [PRIMARY];
GO

-- Khóa ngoại và các bảng liên kết
ALTER TABLE [dbo].[carts]
ADD CONSTRAINT [FK_carts_Products] FOREIGN KEY([ProductId]) REFERENCES [dbo].[Products]([ProductId]) ON DELETE CASCADE;
GO

ALTER TABLE [dbo].[carts]
ADD CONSTRAINT [FK_carts_Users] FOREIGN KEY([UserId]) REFERENCES [dbo].[Users]([UserId]) ON DELETE CASCADE;
GO

ALTER TABLE [dbo].[Orders]
ADD CONSTRAINT [FK_Orders_Payment] FOREIGN KEY([PaymentId]) REFERENCES [dbo].[Payment]([PaymentId]) ON DELETE CASCADE;
GO

ALTER TABLE [dbo].[Orders]
ADD CONSTRAINT [FK_Orders_Products] FOREIGN KEY([ProductId]) REFERENCES [dbo].[Products]([ProductId]) ON DELETE CASCADE;
GO

ALTER TABLE [dbo].[Orders]
ADD CONSTRAINT [FK_Orders_Users] FOREIGN KEY([UserId]) REFERENCES [dbo].[Users]([UserId]) ON DELETE CASCADE;
GO

ALTER TABLE [dbo].[Products]
ADD CONSTRAINT [FK_Products_categories] FOREIGN KEY([CategoryId]) REFERENCES [dbo].[categories]([CategoryId]) ON DELETE CASCADE;
GO

-- Kích hoạt chế độ đọc ghi
USE [master];
GO
ALTER DATABASE [FoodieDB] SET READ_WRITE;
GO

-- Thêm dữ liệu vào bảng 'Products'
INSERT INTO [dbo].[Products] ([Name], [Description], [Price], [Quantity], [ImageUrl], [CategoryId], [IsActive], [CreatedDate])
VALUES 
('Burger', 'Delicious beef burger', 3.50, 50, 'burger.jpg', 1, 1, GETDATE()),
('Pizza', 'Cheese and pepperoni pizza', 8.00, 30, 'pizza.jpg', 1, 1, GETDATE()),
('Coke', 'Coca-Cola can 330ml', 1.20, 100, 'coke.jpg', 2, 1, GETDATE()),
('Chocolate Cake', 'Chocolate sponge cake', 4.50, 20, 'chocolate_cake.jpg', 3, 1, GETDATE());

INSERT INTO [dbo].[categories] ([Name], [ImageUrl], [IsActive], [CreatedDate])
VALUES 
('Fast Food', 'fast_food.jpg', 1, GETDATE()),
('Beverages', 'beverages.jpg', 1, GETDATE()),
('Desserts', 'desserts.jpg', 1, GETDATE());

INSERT INTO [dbo].[Users] ([Name], [Username], [Mobile], [Email], [Address], [PostCode], [Password], [ImageUrl], [CreatedDate])
VALUES 
('John Doe', 'johndoe', '123456789', 'johndoe@example.com', '123 Main St', '12345', 'password123', 'john_doe.jpg', GETDATE()),
('Jane Smith', 'janesmith', '987654321', 'janesmith@example.com', '456 Elm St', '67890', 'securepass', 'jane_smith.jpg', GETDATE());

INSERT INTO [dbo].[Payment] ([Name], [CardNo], [ExpiryDate], [CvvNo], [Address], [PaymentMode])
VALUES 
('John Doe', '4111111111111111', '12/25', 123, '123 Main St', 'Credit Card'),
('Jane Smith', '4222222222222222', '08/24', 456, '456 Elm St', 'Debit Card');

INSERT INTO [dbo].[Orders] ([OrderNo], [ProductId], [Quantity], [UserId], [Status], [PaymentId], [OrderDate])
VALUES 
('ORD123456', 1, 2, 1, 'Completed', 1, GETDATE()),
('ORD123457', 2, 1, 2, 'Pending', 2, GETDATE());

INSERT INTO [dbo].[carts] ([ProductId], [Quantity], [UserId])
VALUES 
(1, 1, 1),
(3, 2, 2);

INSERT INTO [dbo].[Contact] ([Name], [Email], [Subject], [Message], [CreatedDate])
VALUES 
('Customer A', 'customerA@example.com', 'Order Inquiry', 'I have a question about my order.', GETDATE()),
('Customer B', 'customerB@example.com', 'Feedback', 'Great service!', GETDATE());
