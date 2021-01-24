create database QLBH
 ON PRIMARY 
 (   
	NAME = 'QuanlyBH',  
	FILENAME = 'D:\CSDL\TruongMinhDuong_17067191\QLBH_data.mdf',  
	SIZE = 10MB,  
	FILEGROWTH = 20%,  
	MAXSIZE = 50MB 
 ) 
 LOG ON 
 (  
	 NAME = 'QLBH_log',  
	 FILENAME = 'D:\CSDL\TruongMinhDuong_17067191\QLBH_log.ldf', 
	 SIZE = 10MB, 
	 FILEGROWTH = 10%, 
	 MAXSIZE = 20MB 
	 ) 
create table NhomSanPham   
(
	MaNhom  int Not null,
	TenNhom nvarchar(15)  
)
ALTER TABLE NhomSanPham
	add constraint NSP_PK primary key(MaNhom)
create table SanPham    
(
	 MaSp int  Not null, 
	 TenSp nvarchar(40) Not null,
	 MaNCC Int,  
	 MoTa nvarchar(50),   
	 MaNhom int, 
	 Đonvitinh nvarchar(20),  
	 GiaGoc  Money, 
	 SLTON Int 
)
ALTER TABLE SanPham
	add constraint SP_PK primary key(MaSp)
ALTER TABLE SanPham
	add constraint SP_FK1 foreign key (MaNCC) references  NhaCungCap(MaNCC) 
ALTER TABLE SanPham
	add constraint SP_FK2 foreign key (MaNhom) references  NhomSanPham(MaNhom) 
create table HoaDon 
(
	 MaHD Int Not null, 
	 NgayLapHD DateTime,   
	 NgayGiao DateTime, 
     Noichuyen NVarchar(60) Not Null,
	 MaNV Nchar(5),  
	 MaKh Nchar(5)  
)
ALTER TABLE HoaDon
	add constraint HD_PK primary key(MaHD)
ALTER TABLE HoaDon
	add constraint HD_FK1 foreign key (MaKh) references  KhachHang(MaKh)  
ALTER TABLE HoaDon
	add constraint HD_FK2 foreign key (MaNV) references  Nhanvien(MaNV) 
 create table CT_HoaDon    
 ( 
	MaHD Int Not null,
	MaSp int  Not null, 
	Soluong SmallInt,
	Dongia Money,  
	ChietKhau Money
)
ALTER TABLE CT_HoaDon
	add constraint CTHD_PK primary key(MaHD,MaSp)
ALTER TABLE CT_HoaDon
	add constraint CTHD_FK1 foreign key (MaHD) references   HoaDon(MaHD) 
ALTER TABLE CT_HoaDon
	add constraint CTHD_FK2 foreign key (MaSp) references   SanPham(MaSp) 
create table NhaCungCap   
( 
	MaNCC Int Not null, 
	TenNcc Nvarchar(40) Not Null,
	Diachi Nvarchar(60),  
	Phone NVarchar(24),  
	SoFax NVarchar(24), 
	DCMail NVarchar(50)
)
ALTER TABLE NhaCungCap
	add constraint NCC_PK primary key(MaNCC)
create table KhachHang  
(  
	MaKh NChar(5) Not null, 
	TenKh Nvarchar(40) Not null,
	LoaiKh Nvarchar(3),   
	DiaChi Nvarchar(60),   
	Phone NVarchar(24) 
)
ALTER TABLE KhachHang
	add constraint KH_PK primary key(MaKh)
create table Nhanvien     
(
	MaNV NChar(5) Not null,
	TenNV Nvarchar(40) Not null,
	DiaChi Nvarchar(60),  
	Dienthoai NVarchar(24)
)
ALTER TABLE Nhanvien
	add constraint NV_PK primary key(MaNV)
ALTER TABLE HoaDon
	add constraint CK_ngay_lap_HD CHECK (NgayLapHD>='2017-09-09')
ALTER TABLE HoaDon 
	ADD CONSTRAINT DF_ngay_hien_hanh default getdate() for NgayLapHD
ALTER TABLE SanPham
	add constraint CK_gia_goc CHECK (GiaGoc>0)
ALTER TABLE SanPham
	add constraint CK_SLTong CHECK (SLTON>0)
ALTER TABLE KhachHang
	add constraint CK_loaiKH CHECK (LoaiKh ='VIP' or LoaiKh ='TV' or LoaiKh ='VL')