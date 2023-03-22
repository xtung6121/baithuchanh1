use QuanLyDeAn2

create table PHONGBAN(
	MaPHG varchar(2) not null primary key,
	TenPhg nvarchar(20)
)

create table NHANVIEN(
	MaNV varchar(9) not null primary key,
	HoNV nvarchar(15),
	TenLot nvarchar(30),
	TenNV nvarchar(30),
	NgSinh smalldatetime,
	DiaChi nvarchar(150),
	Phai nvarchar(3),
	Luong numeric(18,0),
	Phong varchar(2) foreign key references PHONGBAN(MaPHG)
)

create table DEAN(
	MaDA varchar(2) not null primary key,
	TenDA nvarchar(50),
	DDiemDA varchar(20)
)

create table THANNHAN(
	MaNV varchar(9) foreign key references NHANVIEN(MaNV),
	TenTN varchar(20) not null primary key,
	NgaySinh smalldatetime,
	Phai varchar(3),
	QuanHe varchar(15)
)

create table PHANCONG(
	MaNV varchar(9) foreign key references NHANVIEN(MaNV),
	MaDA varchar(2) foreign key references DEAN(MaDA),
	ThoiGian numeric(18,0)
)
