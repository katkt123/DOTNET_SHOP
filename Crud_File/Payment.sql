CREATE PROCEDURE [dbo].[Save_Orders] @tblOrders OrderDetails READONLY
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Orders (OrderNo, ProductId, Quantity, UserId, Status, PaymentId, OrderDate)
    SELECT OrderNo, ProductId, Quantity, UserId, Status, PaymentId, OrderDate FROM @tblOrders
END

ALTER PROCEDURE [dbo].[Save_Payment]
    @Name VARCHAR(100) NULL,
    @CardNo VARCHAR(50) NULL,
    @ExpiryDate VARCHAR(50) NULL,
    @CVV INT NULL,
    @Address VARCHAR(MAX) NULL,
    @PaymentMode VARCHAR(30) = 'card',
    @InsertedId INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    -- Phần thân của thủ tục lưu trữ thanh toán
    BEGIN
        INSERT INTO dbo.Payment(Name, CardNo, ExpiryDate, CvvNo, Address, PaymentMode)
        VALUES (@Name, @CardNo, @ExpiryDate, @CVV, @Address, @PaymentMode)

        SELECT @InsertedId = SCOPE_IDENTITY();
    END
END