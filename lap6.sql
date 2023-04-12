--câu 1--
CREATE FUNCTION GetSanPhamByTenSP(@TenSP NVARCHAR(20))
RETURNS TABLE
AS
RETURN
    SELECT *
    FROM SanPham
    WHERE tensp = @TenSP;
	go
SELECT * FROM GetSanPhamByTenSP('Galaxy Note 11');
go
--câu 2:
CREATE FUNCTION GetProductByDateRange (@FromDate DATE, @ToDate DATE)
RETURNS @resultTable TABLE (
    tensp NVARCHAR(20),
    mahangsx NCHAR(10)
)
AS BEGIN
    INSERT INTO @resultTable (tensp, mahangsx)
    SELECT SanPham.tensp, SanPham.mahangsx
    FROM Nhap
    JOIN SanPham ON Nhap.masp = SanPham.masp
    WHERE ngaynhap BETWEEN @FromDate AND @ToDate;
    RETURN;
END;
go
SELECT *
FROM GetProductByDateRange('2020-05-01', '2020-12-31');
go

--câu 3:
CREATE FUNCTION GetSanPhamByHangSXAndOption (@MaHangSX NCHAR(10), @Option BIT)
RETURNS @resultTable TABLE (
    masp NCHAR(10)
)
AS BEGIN
    IF @Option = 0
        INSERT INTO @resultTable (masp)
        SELECT masp
        FROM SanPham
        WHERE mahangsx = @MaHangSX AND soluong = 0;
    ELSE
        INSERT INTO @resultTable (masp)
        SELECT masp
        FROM SanPham
        WHERE mahangsx = @MaHangSX AND soluong > 0;
    RETURN;
END;
go

SELECT * FROM GetSanPhamByHangSXAndOption('Sony', 0);


SELECT * FROM GetSanPhamByHangSXAndOption('Samsung', 1);

--câu 4:
CREATE FUNCTION GetNhanVienByTenPhong (@TenPhong NVARCHAR(50))
RETURNS TABLE
AS
RETURN
    SELECT tennv
    FROM NhanVien
    WHERE maphong = (
        SELECT maphong
        FROM PhongBan
        WHERE tenphong = @TenPhong
    );
go
SELECT * FROM GetNhanVienByTenPhong('K? toán');
go
--câu 5:
CREATE FUNCTION GetHangSXByDiaChi (@DiaChi NVARCHAR(100))
RETURNS @resultTable TABLE (
    mahangsx NCHAR(10),
    tenhangsx NVARCHAR(50),
    diachi NVARCHAR(100)
)
AS BEGIN
    INSERT INTO @resultTable (mahangsx, tenhangsx, diachi)
    SELECT mahangsx, tenhangsx, diachi
    FROM HangSX
    WHERE diachi LIKE '%' + @DiaChi + '%'
    RETURN;
END;
go
SELECT * FROM GetHangSXByDiaChi('Hà N?i');
go

--câu 6:
CREATE FUNCTION GetSanPhamHangSXByNamXuatNhap (@NamXuatDau INT, @NamXuatCuoi INT)
RETURNS @resultTable TABLE (
    masp NCHAR(10),
    tensp NVARCHAR(50),
    mahangsx NCHAR(10),
    tenhangsx NVARCHAR(50),
    ngayxuat DATE
)
AS BEGIN
    INSERT INTO @resultTable (masp, tensp, mahangsx, tenhangsx, ngayxuat)
    SELECT sp.masp, sp.tensp, hsx.mahangsx, hsx.tenhangsx, px.ngayxuat
    FROM SanPham AS sp
        JOIN HangSX AS hsx ON sp.mahangsx = hsx.mahangsx
        JOIN PhieuXuat AS px ON sp.masp = px.masp
    WHERE YEAR(px.ngayxuat) BETWEEN @NamXuatDau AND @NamXuatCuoi;
    RETURN;
END;

go
SELECT * FROM GetSanPhamHangSXByNamXuatNhap(2019, 2021);

go
--câu 7--
CREATE FUNCTION GetSanPhamByHangSXAndNhapXuat (@MaHangSX NCHAR(10), @LuaChon INT)
RETURNS @resultTable TABLE (
    masp NCHAR(10),
    tensp NVARCHAR(50),
    dongia INT,
    ngaynhap DATE,
    ngayxuat DATE
)
AS BEGIN
    IF (@LuaChon = 0)
    BEGIN
        INSERT INTO @resultTable (masp, tensp, dongia, ngaynhap, ngayxuat)
SELECT sp.masp, sp.tensp, sp.dongia, pn.ngaynhap, NULL
        FROM SanPham AS sp
            JOIN PhieuNhap AS pn ON sp.masp = pn.masp
        WHERE sp.mahangsx = @MaHangSX;
    END
    ELSE IF (@LuaChon = 1)
    BEGIN
        INSERT INTO @resultTable (masp, tensp, dongia, ngaynhap, ngayxuat)
        SELECT sp.masp, sp.tensp, sp.dongia, NULL, px.ngayxuat
        FROM SanPham AS sp
            JOIN PhieuXuat AS px ON sp.masp = px.masp
        WHERE sp.mahangsx = @MaHangSX;
    END
    RETURN;
END;
go
SELECT * FROM GetSanPhamByHangSXAndNhapXuat('SP01', 1);
go
--câu 8:
CREATE FUNCTION GetNhanVienNhapHangByNgayNhap (@NgayNhap DATE)
RETURNS @resultTable TABLE (
    manv NCHAR(10),
    tennv NVARCHAR(50),
    ngaysinh DATE,
    diachi NVARCHAR(100),
    sodienthoai VARCHAR(20)
)
AS BEGIN
    INSERT INTO @resultTable (manv, tennv, ngaysinh, diachi, sodienthoai)
    SELECT nv.manv, nv.tennv, nv.ngaysinh, nv.diachi, nv.sodienthoai
    FROM NhanVien AS nv
        JOIN PhieuNhap AS pn ON nv.manv = pn.manv
    WHERE pn.ngaynhap = @NgayNhap;
    RETURN;
END;
go
SELECT * FROM GetNhanVienNhapHangByNgayNhap('2023-04-12');
go

--câu 9:
CREATE FUNCTION GetSanPhamByGiaAndHangSX (@GiaMin INT, @GiaMax INT, @MaHangSX NCHAR(10))
RETURNS @resultTable TABLE (
    masp NCHAR(10),
    tensp NVARCHAR(50),
    dongia INT,
    mahangsx NCHAR(10)
)
AS BEGIN
    INSERT INTO @resultTable (masp, tensp, dongia, mahangsx)
    SELECT sp.masp, sp.tensp, sp.dongia, sp.mahangsx
    FROM SanPham AS sp
        JOIN HangSX AS hsx ON sp.mahangsx = hsx.mahangsx
    WHERE sp.dongia BETWEEN @GiaMin AND @GiaMax AND hsx.mahangsx = @MaHangSX;
    RETURN;
END;
go
SELECT * FROM GetSanPhamByGiaAndHangSX(2000000, 4000000, 'H03');
go 
--câu 10:
CREATE FUNCTION GetSanPhamAndHangSX ()
RETURNS @resultTable TABLE (
    masp NCHAR(10),
    tensp NVARCHAR(50),
    dongia INT,
    mahangsx NCHAR(10),
    tenhangsx NVARCHAR(50)
)
AS BEGIN
    INSERT INTO @resultTable (masp, tensp, dongia, mahangsx, tenhangsx)
    SELECT sp.masp, sp.tensp, sp.dongia, sp.mahangsx, hsx.tenhangsx
    FROM SanPham AS sp
        JOIN HangSX AS hsx ON sp.mahangsx = hsx.mahangsx;
    RETURN;
END;
go
SELECT * FROM GetSanPhamAndHangSX();
go