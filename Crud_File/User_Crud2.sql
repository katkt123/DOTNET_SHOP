USE [FoodieDB]
GO
/****** Object:  StoredProcedure [dbo].[User_Crud]    Script Date: 12/10/2024 10:45:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[User_Crud]  
    @Action VARCHAR(20),  
    @UserId INT = NULL,  
    @Name varchar(50) = null,  
    @Username varchar(50) = null,  
    @Mobile varchar(50) = null,  
    @Email varchar(50) = null,  
    @Address varchar(max) = null,  
    @PostCode varchar(50) = null,  
    @Password varchar(50) = null,  
    @ImageUrl varchar(max) = null  
AS  
BEGIN  
    SET NOCOUNT ON;  

    --SELECT FOR LOGIN  
    IF @Action = 'SELECTLOGIN'  
		BEGIN  
			SELECT * FROM dbo.Users WHERE Username = @Username and Password = @Password  
		END  

	IF @Action = 'UPDATE1'
		BEGIN
			UPDATE dbo.Users  
			SET Password = @Password  
			WHERE Email = @Email 
		END
				

    --SELECT FOR USER PROFILE  
    IF @Action = 'SELECT4PROFILE'  
		BEGIN  
			SELECT * FROM dbo.Users WHERE UserId = @UserId  
		END  

    -- Insert (REGISTRATION)  
    IF @Action = 'INSERT'  
		BEGIN  
			Insert into dbo.Users(Name,Username,Mobile,Email,Address,PostCode,Password,ImageUrl,CreatedDate)  
			values (@Name,@Username,@Mobile,@Email,@Address,@PostCode,@Password,@ImageUrl,GETDATE())  
		END  

	--UPDATE USER PROFILE  
	IF @Action = 'UPDATE'  
		BEGIN  
			DECLARE @UPDATE_IMAGE VARCHAR(20)  
			SELECT @UPDATE_IMAGE = (CASE WHEN @ImageUrl IS NULL THEN 'NO' ELSE 'YES' END)  
			IF @UPDATE_IMAGE = 'NO'  
			BEGIN  
				UPDATE dbo.Users  
				SET Name = @Name, Username = @Username, Mobile = @Mobile, Email = @Email, PostCode = @PostCode, Password = @Password  
				WHERE UserId = @UserId  
			END  
			ELSE  
			BEGIN  
				UPDATE dbo.Users  
				SET Name = @Name, Username = @Username, Mobile = @Mobile, Email = @Email, Address = @Address, PostCode = @PostCode, ImageUrl = @ImageUrl, Password = @Password   
				WHERE UserId = @UserId  
			END  
		END  

	--SELECT FOR ADMIN  
	IF @Action = 'SELECT4ADMIN'  
		BEGIN  
			SELECT ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS [SrNo], UserId, Name,  
				   Username,Password, Email, CreatedDate  
			FROM Users  
		END  

	--DELETE BY ADMIN  
	IF @Action = 'DELETE'  
		BEGIN  
			DELETE FROM dbo.Users WHERE UserId = @UserId  
		END
END  