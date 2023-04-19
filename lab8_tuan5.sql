--câu 1
CREATE PROCEDURE sp_ThemMoiNhanVien
    @manv nchar(10),
    @tennv nvarchar(20),
    @gioitinh nchar(10),
    @diachi nvarchar(30),
    @sodt nvarchar(20),
    @email nvarchar(30),
    @phong nvarchar(30),
    @flag bit
AS
BEGIN
    IF(@gioitinh != 'Nam' AND @gioitinh != 'Nữ')
    BEGIN
        RETURN 1
    END

    IF(@flag = 0)
    BEGIN
        INSERT INTO NhanVien VALUES(@manv, @tennv, @gioitinh, @diachi, @sodt, @email, @phong)
    END
    ELSE
    BEGIN
        UPDATE NhanVien SET 
            tennv = @tennv,
            gioitinh = @gioitinh,
            diachi = @diachi,
            sodienthoai = @sodt,
            email = @email,
            phong = @phong
        WHERE manv = @manv
    END
    RETURN 0 
END

--câu 2
CREATE PROCEDURE sp_ThemMoiSanPham
    @masp nchar(10),
    @tenhang nvarchar(20),
    @tensp nvarchar(20),
    @soluong int,
    @mausac nvarchar(20),
    @giaban money,
    @donvitinh nchar(10),
    @mota nvarchar(max),
    @flag bit
AS
BEGIN
    DECLARE @mahangsx nchar(10)
    
    SELECT @mahangsx = mahangsx FROM HangSanXuat WHERE tenhang = @tenhang
    
    IF (@mahangsx IS NULL)
    BEGIN
        RETURN 1
    END

    IF (@flag = 0)
    BEGIN
        INSERT INTO SanPham 
        VALUES (@masp, @mahangsx, @tensp, @soluong, @mausac, @giaban, @donvitinh, @mota)
    END
    ELSE
    BEGIN
        UPDATE SanPham SET 
            mahangsx = @mahangsx,
            tensp = @tensp,
            soluong = @soluong,
            mausac = @mausac,
            giaban = @giaban,
            donvitinh = @donvitinh,
            mota = @mota
        WHERE masp = @masp
    END

    RETURN 0 
END

--câu 3
CREATE PROCEDURE sp_XoaNhanVien
    @manv nchar(10)
AS
BEGIN
    DECLARE @nhanvien_count int;
  
    SELECT @nhanvien_count = COUNT(*) FROM NhanVien WHERE manv = @manv;
    
    IF (@nhanvien_count = 0)
    BEGIN
        RETURN 1 
    END

    BEGIN TRY
        BEGIN TRANSACTION
           
            DELETE FROM Nhap WHERE manv = @manv
            
           
            DELETE FROM Xuat WHERE manv = @manv
            
          
            DELETE FROM NhanVien WHERE manv = @manv
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        RETURN 2
    END CATCH

    RETURN 0 
END
--câu 4
CREATE PROCEDURE sp_XoaSanPham
    @masp nchar(10)
AS
BEGIN
    DECLARE @sanpham_count int;

  
    SELECT @sanpham_count = COUNT(*) FROM SanPham WHERE masp = @masp;
    
    IF (@sanpham_count = 0)
    BEGIN
        RETURN 1 
    END

    BEGIN TRY
        BEGIN TRANSACTION
           
            DELETE FROM Nhap WHERE masp = @masp
            
           
            DELETE FROM Xuat WHERE masp = @masp
            
            --
            DELETE FROM SanPham WHERE masp = @masp
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        RETURN 2 
    END CATCH

    RETURN 0 
END
--câu 5
CREATE PROCEDURE sp_NhapHangSX
    @mahangsx nchar(10),
    @tenhang nvarchar(50),
    @diachi nvarchar(50),
    @sodt nvarchar(20),
    @email nvarchar(50)
AS
BEGIN
    DECLARE @hangsx_count int;
    
    SELECT @hangsx_count = COUNT(*) FROM HangSX WHERE mahangsx = @mahangsx;
    

    IF (@hangsx_count > 0)
    BEGIN
        RETURN 1;
    END
    

    BEGIN TRY
        BEGIN TRANSACTION
            INSERT INTO HangSX (mahangsx, tenhang, diachi, sodt, email) 
            VALUES (@mahangsx, @tenhang, @diachi, @sodt, @email)
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        RETURN 2; 
    END CATCH

    RETURN 0 
END
--câu 6
CREATE PROCEDURE sp_NhapDuLieuNhap
    @sohdn nvarchar(10),
    @masp nchar(10),
    @manv nchar(10),
    @ngaynhap date,
    @soluongN int,
    @soluongX int,
    @dongiaN money
AS
BEGIN
    DECLARE @sanpham_count int, @nhanvien_count int, @nhap_count int;
    
    
    SELECT @sanpham_count = COUNT(*) FROM SanPham WHERE masp = @masp;
    
    IF (@sanpham_count = 0)
    BEGIN
        RETURN 1
    END
    
    
    SELECT @nhanvien_count = COUNT(*) FROM NhanVien WHERE manv = @manv;
    
    IF (@nhanvien_count = 0)
    BEGIN
        RETURN 2 
    END
    
   
    SELECT @nhap_count = COUNT(*) FROM Nhap WHERE sohdn = @sohdn;
    
    BEGIN TRY
        BEGIN TRANSACTION
        IF (@nhap_count > 0)
        BEGIN
           
            UPDATE Nhap SET masp = @masp, manv = @manv, ngaynhap = @ngaynhap, soluongN = @soluongN, soluongX = @soluongX, dongiaN = @dongiaN WHERE sohdn = @sohdn
        END
        ELSE
        BEGIN
           
            INSERT INTO Nhap (sohdn, masp, manv, ngaynhap, soluongN, soluongX, dongiaN) VALUES (@sohdn, @masp, @manv, @ngaynhap, @soluongN, @soluongX, @dongiaN)
        END 
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        RETURN 3 
    END CATCH

    RETURN 0
END
 --câu 7
 CREATE PROCEDURE sp_NhapDuLieuXuat
    @sohdX nvarchar(10),
    @masp nchar(10),
    @manv nchar(10),
    @ngayxuat date,
    @soluongX int
AS
BEGIN
    DECLARE @sanpham_count int, @nhanvien_count int, @xuat_count int, @soluongN int
    
    
    SELECT @sanpham_count = COUNT(*) FROM SanPham WHERE masp = @masp;
    
    IF (@sanpham_count = 0)
    BEGIN
        RETURN 1 
    END
    

    SELECT @nhanvien_count = COUNT(*) FROM NhanVien WHERE manv = @manv;
    
    IF (@nhanvien_count = 0)
    BEGIN
        RETURN 2 
    END
    

    SELECT @soluongN = SUM(soluongN) FROM Nhap WHERE masp = @masp
    
    
    SELECT @xuat_count = SUM(soluongX) FROM Xuat WHERE masp = @masp;
    
    IF (@soluongX > (@soluongN - @xuat_count))
    BEGIN
        RETURN 3 
    END
    

    SELECT @xuat_count = COUNT(*) FROM Xuat WHERE sohdX = @sohdX;
    
    BEGIN TRAN
    BEGIN TRY
        IF (@xuat_count > 0)
        BEGIN
     
            UPDATE Xuat SET masp = @masp, manv = @manv, ngayxuat = @ngayxuat, soluongX = @soluongX WHERE sohdX = @sohdX
        END
        ELSE
        BEGIN
   
            INSERT INTO Xuat (sohdX, masp, manv, ngayxuat, soluongX) VALUES (@sohdX, @masp, @manv, @ngayxuat, @soluongX)
        END
        COMMIT TRAN
    END TRY
    BEGIN CATCH
        ROLLBACK TRAN
        RETURN 4 -- Lỗi mã 4: Lỗi hệ thống
    END CATCH

    RETURN 0 
END
