--câu 2:
CREATE TRIGGER tg_Xuat_Insert
ON Xuat
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON

    IF NOT EXISTS (SELECT * FROM inserted i JOIN SanPham s ON i.masp = s.masp)
    BEGIN
        RAISERROR('Mã sản phẩm không tồn tại trong bảng SanPham!', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END

    IF NOT EXISTS (SELECT * FROM inserted i JOIN NhanVien n ON i.manv = n.manv)
    BEGIN
        RAISERROR('Mã nhân viên không tồn tại trong bảng NhanVien!', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END

    IF EXISTS (SELECT * FROM inserted i JOIN SanPham s ON i.masp = s.masp WHERE i.soluongX > s.soluong)
    BEGIN
        RAISERROR('Số lượng xuất vượt quá số lượng tồn kho!', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END

    BEGIN TRANSACTION

    UPDATE SanPham
    SET soluong = soluong - i.soluongX
    FROM SanPham s JOIN inserted i ON s.masp = i.masp

    INSERT INTO Xuat (sohdX, masp, manv, ngayxuat, soluongX)
    SELECT sohdX, masp, manv, ngayxuat, soluongX
    FROM inserted

    COMMIT TRANSACTION
END
go
INSERT INTO Xuat (sohdX, masp, manv, ngayxuat, soluongX)
VALUES ('X06', 'SP01', 'NV01', '2022-02-28', 5)

go

--câu 3
CREATE TRIGGER tg_Xuat_Delete
ON Xuat
FOR DELETE
AS
BEGIN
    SET NOCOUNT ON

    DECLARE @sohdX nchar(10), @masp nchar(10), @manv nchar(10), @ngayxuat date, @soluongX int
    SELECT @sohdX = sohdX, @masp = masp, @manv = manv, @ngayxuat = ngayxuat, @soluongX = soluongX FROM deleted

    UPDATE SanPham 
    SET soluong = soluong + @soluongX 
    WHERE masp = @masp

    SELECT 'Đã xóa phiếu xuất ' + @sohdX + ' và cập nhật số lượng sản phẩm trong kho.'

END
go
--câu 4
CREATE TRIGGER tg_Xuat_Update
ON Xuat
INSTEAD OF UPDATE
AS
BEGIN
    SET NOCOUNT ON

    DECLARE @count int
    SELECT @count = COUNT(*) FROM inserted
    IF @count > 1
    BEGIN
        RAISERROR('Không được phép thay đổi nhiều bản ghi cùng lúc!', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END

    DECLARE @sohdX nchar(10), @masp nchar(10), @manv nchar(10), @ngayxuat date, @soluongX_old int, @soluongX_new int
    SELECT @sohdX = i.sohdX, @masp = i.masp, @manv = i.manv, @ngayxuat = i.ngayxuat, @soluongX_old = d.soluongX, @soluongX_new = i.soluongX FROM deleted d JOIN inserted i ON d.sohdX = i.sohdX

    IF @soluongX_new < @soluongX_old
    BEGIN
        RAISERROR('Số lượng xuất không được giảm!', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END

    UPDATE SanPham 
    SET soluong = soluong + (@soluongX_old - @soluongX_new) 
    WHERE masp = @masp

    UPDATE Xuat 
    SET soluongX = @soluongX_new 
    WHERE sohdX = @sohdX

    SELECT 'Đã cập nhật số lượng xuất trong phiếu xuất ' + @sohdX + ' và số lượng sản phẩm trong kho.'

END
go
--câu 5
CREATE TRIGGER tg_Nhap_Update
ON Nhap
INSTEAD OF UPDATE
AS
BEGIN
    SET NOCOUNT ON

    DECLARE @count int
    SELECT @count = COUNT(*) FROM inserted
    IF @count > 1
    BEGIN
        RAISERROR('Không được phép thay đổi nhiều bản ghi cùng lúc!', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END

    DECLARE @sohdN nvarchar(10), @masp nvarchar(10), @manv nvarchar(10), @soluongN_old int, @soluongN_new int
    SELECT @sohdN = i.sohdN, @masp = i.masp, @manv = i.manv, @soluongN_old = d.soluongN, @soluongN_new = i.soluongN FROM deleted d JOIN inserted i ON d.sohdN = i.sohdN

    UPDATE SanPham 
    SET soluong = soluong - (@soluongN_old - @soluongN_new) 
    WHERE masp = @masp

    UPDATE Nhap 
    SET soluongN = @soluongN_new 
    WHERE sohdN = @sohdN

    SELECT 'Đã cập nhật số lượng nhập trong phiếu nhập ' + @sohdN + ' và số lượng sản phẩm trong kho.'

END
go
--câu 6
CREATE TRIGGER tg_Nhap_Delete
ON Nhap
FOR DELETE
AS
BEGIN
    SET NOCOUNT ON

    DECLARE @sohdN nvarchar(10), @masp nvarchar(10), @manv nvarchar(10), @soluongN int
    SELECT @sohdN = sohdN, @masp = masp, @manv = manv, @soluongN = soluongN FROM deleted

    UPDATE SanPham 
    SET soluong = soluong - @soluongN 
    WHERE masp = @masp

    SELECT 'Đã xóa phiếu nhập ' + @sohdN + ' và cập nhật số lượng sản phẩm trong kho.'

END

go