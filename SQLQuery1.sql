use QuanLyDeAn
Create	table NHANVIEN
(
	HONV	nvarchar(15),
	TENLOT	nvarchar(15),
	TENNV	nvarchar(15) not null,
	MANV	char	(9) not null,
	NGSINH	Datetime,
	DCHI	nvarchar(30),
	PHAI	nvarchar(3),
	LUONG	float,
	MA_NQL	char(9),
	PHG	int,
	constraint PK_NHANVIEN primary key(MANV),
	
)

Create	table PHONGBAN
(
	TENPHG	nvarchar(15),
	MAPHG	int not null,
	TRPHG	char(9),
	NG_NHANCHUC Datetime
	constraint PK_PHONGBAN primary key(MAPHG)
)


Create table DIADIEM_PHG
(
	MAPHG	int,
	DIADIEM nvarchar(50)
	constraint PK_DIADIEM_PHG primary key (MAPHG, DIADIEM)
)

Create table DEAN
(
	TENDA	nvarchar(15),
	MADA	int,
	DDIEM_DA nvarchar(50),
	PHONG	int,
	constraint PK_DEAN primary key(MADA)
)


Create table PHANCONG
(
	MA_NVIEN char(9),
	MADA	 int,
	THOIGIAN float,
	constraint PK_PHANCONG primary key (MA_NVIEN, MADA)
)

Create	table THANNHAN
(
	MA_NVIEN char(9),
	TENTN	 nvarchar(15),
	PHAI	 nvarchar(3),
	NGSINH	Datetime,
	QUANHE 	nvarchar(15),
	constraint PK_THANNHAN primary key (MA_NVIEN, TENTN) 
)

----------------------------------*tao khoa ngoai*---------------------------
--tao khoa ngoai cho bang NHANVIEN
alter table NHANVIEN
add 
constraint FK_NHANVIEN_NHANVIEN foreign key(MA_NQL) references NHANVIEN(MANV),
constraint FK_NHANVIEN_PHONGBAN foreign key(PHG) references PHONGBAN(MAPHG)
--tao khoa ngoai cho bang PHONGBAN
alter table PHONGBAN
add
constraint FK_PHONGBAN_NHANVIEN foreign key(TRPHG) references NHANVIEN(MANV)
--tao khoa ngoai cho bang DIADIEM_PHG
alter table DIADIEM_PHG
add
constraint FK_DIADIEMPHG_PHONGBAN foreign key(MAPHG) references PHONGBAN(MAPHG)
--tao khoa ngoai cho bang DEAN
alter table DEAN
add
constraint FK_DEAN_PHONGBAN foreign key(PHONG) references PHONGBAN(MAPHG)
--tao khoa ngoai cho CONGVIEC
/*alter table CONGVIEC
add
constraint FK_CONGVIEC_DEAN foreign key(MADA) references DEAN(MADA)
--tao khoa ngoai cho PHANCONG
alter table PHANCONG
add
constraint FK_PHANCONG_CONGVIEC foreign key(MADA, STT) references CONGVIEC(MADA, STT)
--tao khoa ngoai cho THANNHAN
alter table THANNHAN
add
*/
alter table PHANCONG
add
constraint FK_PHANCONG_DEAN foreign key(MADA) references DEAN(MADA),
constraint FK_PHANCONG_NHANVIEN foreign key(MA_NVIEN) references NHANVIEN(MANV)
alter table THANNHAN
add constraint FK_THANNHAN_NHANVIEN foreign key(MA_NVIEN) references NHANVIEN(MANV)
--------------------------Chen du lieu -------------------------------------------

insert into PHONGBAN
values('1', N'Quản Lý')
insert into PHONGBAN
values('4', N'Điều hành')
insert into PHONGBAN
values('5', N'Nghiên cứu')

go


insert into NHANVIEN
values ('123', N'Đinh', N'Bá ', N'Tiến', 27/02/1982, N'Mộ Đức', N'Nam', Null, '4')
insert into NHANVIEN
values ('234', N'Nguyễn', N'Thanh', N'Tùng', 12/08/1956,N'Sơn Tịnh', N'Nam', null, '5')
insert into NHANVIEN
values('345', N'Bùi', N'Thúy', N'Vũ', null, N'Tư Nghĩa', N'Nữ', null, '4')
insert into NHANVIEN
values('456', N'Lê',N'Thị', N'Nhàn', 12/07/1962, N'Mộ Đức', N'Nữ', null, '4')
insert into NHANVIEN
values ('567', N'Nguyễn', N'Mạnh', N'Hùng', 25/03/1967, N'Sơn Tịnh', N'Nam', null, '5')
insert into NHANVIEN
values('678', N'Trần', N'Hồng', N'Quang', null, N'Bình Sơn', N'Nam', null, '5')
insert into NHANVIEN
values('789', N'Trần', N'Thanh', N'Tam', 17/06/1972, N'tp.Quãng Ngãi', N'Nam', null, '5')
insert into NHANVIEN
values('890', N'Cao', N'Thanh', N'Huyền', null, N'Tư Nghĩa', N'Nữ', null, '1')
insert into NHANVIEN
values('901', N'Vương', N'Ngọc', N'Quyền', 12/12/1987, N'Mộ Đức', N'Nam', null, '1')
go

insert into PHANCONG
values('123', '1',33)
insert into PHANCONG
values('123', '2',33)
insert into PHANCONG
values('345', '10', 10)
insert into PHANCONG
values('345', '20', 10)
insert into PHANCONG
values('345', '3', 10)
insert into PHANCONG
values('456', '1', 20)
insert into PHANCONG
values('456', '2', 20)
go

insert into PHANCONG
values('678', '3', 40)
insert into PHANCONG
values('789', '10',35)
insert into PHANCONG
values('789', '20', 30)
insert into PHANCONG
values('789', '30', 5)
go

insert into THANNHAN
values('123', N'Châu', 30/10/2005, N'Nữ', N'Con Gái')
insert into THANNHAN
values('123', N'Duy', 25/10/2001, N'Nam', N'Con Trai')
insert into THANNHAN
values('123', N'Phương', 30/10/1980, N'Nữ', N'Vợ Chồng')
insert into THANNHAN
values('234', N'Thanh', 05/04/1980, N'Nữ', N'Con Gái')
insert into THANNHAN
values('345', N'Dương', 30/10/1956, N'Nam', N'Vợ Chồng')
insert into THANNHAN
values('345',N'Khang', 25/10/21985, N'Nam', N'Con Trai')
insert into THANNHAN
values('456', N'Hùng', 01/01/1987, N'Nam', N'Vợ Chồng')
go
insert into DEAN
values('1', N'nâng cao chất lượng muối', N'Sa Huỳnh')
insert into DEAN
values('10', N'Xây dựng nhà máy chế biến thủy sản', N'Dung Quất')
insert into DEAN
values('2', N'Phát triển hạ tầng', N'tp.Quãng Ngãi')
insert into DEAN
values('20', N'Truyền tải cáp quang', N'tp.Quãng Ngãi')
insert into DEAN
values('3', N'Tin học hóa trường học', N'ba Tre')
insert into DEAN
values('30', N'Đào tạo nhân lực', N'Tịnh Phong')
go
-- nhap du lieu cho PHONGBAN

insert into PHONGBAN values(N'Nghiên Cứu', 5, '005', '22/05/1987')
insert into PHONGBAN values(N'Điều Hành', 4, '008', '01/01/1985')
insert into PHONGBAN values(N'Kế Toán', 2, '002', '01/01/1985')
insert into PHONGBAN values(N'Quản Lý', 1, '006', '19/06/1971')
SELECT * FROM PHONGBAN


--cap nhat du lieu cho bang DIADIEM_PHG

insert into DIADIEM_PHG values(1, 'TP HCM')
insert into DIADIEM_PHG values(4, 'HA NOI')
insert into DIADIEM_PHG values(5, 'VUNG TAU')



--cap nhat du lieu cho bang DEAN
insert into DEAN values(N'Sản phẩm X', 1, 'VUNG TAU', 5)
insert into DEAN values(N'Sản phẩm Y', 2, 'NHA TRANG', 5)
insert into DEAN values(N'Sản phẩm Z', 3, 'TP HCM', 5)
insert into DEAN values(N'Tin học hóa', 10, 'HA NOI', 4)
insert into DEAN values(N'Cap Quang', 20, 'TP HCM', 1)
insert into DEAN values(N'Đào Tạo', 30, 'HA NOI', 4)



--cap nhat du lieu cho bang CONGVIEC

insert into CONGVIEC values(1, 1, N'Thiết kế sản phẩm X')
insert into CONGVIEC values(1, 2, N'Thử nghiệm sản phẩm X')
insert into CONGVIEC values(2, 1, N'Sản xuất sản phẩm Y')
insert into CONGVIEC values(2, 2, N'Quảng cáo sản phẩm Y')
insert into CONGVIEC values(3, 1, N'Khuyến mãi sản phẩm Z')
insert into CONGVIEC values(10, 1, N'Tin học hóa nhân sự tiền lương')
insert into CONGVIEC values(10, 2, N'Tin học hóa phòng kinh doanh')
insert into CONGVIEC values(20, 1, N'lắp đặt cáp quang')
insert into CONGVIEC values(30, 1, N'Đào tạo nhân viên maketing')
insert into CONGVIEC values(30, 2, N'Đào tạo chuyên viên thiết kế')



--cap nhat du lieu cho bang THANNHAN
insert into THANNHAN values('005', N'Quang', N'Nữ', '05/04/1976', N'Con gái')
insert into THANNHAN values('005', N'Khang', N'Nam', '25/10/1973', N'Con trai')
insert into THANNHAN values('005', N'Dương', N'Nữ', '03/05/1948', N'Vợ chồng')
insert into THANNHAN values('001', N'Đăng', N'Nam', '19/02/1932', N'Vợ chồng')
insert into THANNHAN values('009', N'Duy', N'Nam', '01/01/1978', N'Con trai')
insert into THANNHAN values('009', N'Châu', N'Nữ', '30/12/1978', N'Con gái')
insert into THANNHAN values('009', N'Phương', N'Nữ', '05/05/1957', N'Vợ chồng')



--chen du lieu cho bang PHANCONG
insert into PHANCONG values('009', 1, 32)
insert into PHANCONG values('009', 2, 8)
insert into PHANCONG values('004', 3, 40)
insert into PHANCONG values('003', 1, 20)
insert into PHANCONG values('003', 2, 20)
insert into PHANCONG values('008', 10,35)
insert into PHANCONG values('008', 30,5)
insert into PHANCONG values('001', 30,20)
insert into PHANCONG values('001', 20,15)
insert into PHANCONG values('006', 20,30)
insert into PHANCONG values('005', 3, 10)
insert into PHANCONG values('005', 10,10)
insert into PHANCONG values('005', 20,10)
insert into PHANCONG values('007', 30,30)
insert into PHANCONG values('007', 10,10)
