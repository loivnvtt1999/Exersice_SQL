create database QuanLiBanHang
 ON PRIMARY 
 (   
	NAME = 'QuanlyBH',  
	FILENAME = 'T:\TruongMinhDuong_17067191\QLBH2_data.mdf',  
	SIZE = 10MB,  
	FILEGROWTH = 20%,  
	MAXSIZE = 50MB 
 ) 
 LOG ON 
 (  
	 NAME = 'QLBH_log',  
	 FILENAME = 'T:\TruongMinhDuong_17067191\QLBH2_log.ldf', 
	 SIZE = 10MB, 
	 FILEGROWTH = 10%, 
	 MAXSIZE = 20MB 
	 ) 
 select [CustomerID],[CompanyName],[Address],[City],[Phone],[Fax]
  into Khachhang
	from Northwind.dbo.Customers
  select [EmployeeID],[LastName],[FirstName],[BirthDate],[Address],[City] into Nhanvien
	from Northwind.dbo.Employees
 select [SupplierID],[CompanyName],[Address],[City],[Phone],[Fax] into Nhacungcap
	from Northwind.dbo.Suppliers
 select [CategoryID],[CategoryName],[Description]   into NhomSP
	from Northwind.dbo.Categories
  select [ProductID], [ProductName], [SupplierID], [CategoryID],[QuantityPerUnit], [UnitPrice]
   into Sanpham 
   from Northwind.dbo.Products
select [OrderID],[CustomerID],[EmployeeID],[OrderDate] 
into Hoadon 
from Northwind.dbo.Orders
 select [OrderID],[ProductID],[UnitPrice],[Quantity] 
 into Chitiethoadon
from  Northwind.dbo.[Order Details]

--Tao khoa

ALTER TABLE Nhanvien
	add constraint NV_PK primary key([EmployeeID])
ALTER TABLE [dbo].[Hoadon]
	add constraint HD_PK primary key([OrderID])
ALTER TABLE [dbo].[Hoadon]
	add constraint HD_FK1 foreign key ([EmployeeID]) references  Nhanvien([EmployeeID]) 
ALTER TABLE [dbo].[Hoadon]
	add constraint HD_FK2 foreign key ([CustomerID]) references  Khachhang([CustomerID]) 
ALTER TABLE [dbo].[Khachhang]
	add constraint KH_PK primary key([CustomerID])
ALTER TABLE [dbo].[Nhacungcap]
	add constraint Ncc_PK primary key([SupplierID])
ALTER TABLE [dbo].[Chitiethoadon]
	add constraint Cthd_PK primary key([OrderID],[ProductID])
ALTER TABLE [dbo].[Chitiethoadon]
	add constraint Cthd_FK1 foreign key ([ProductID]) references  [dbo].[Sanpham]([ProductID]) 
ALTER TABLE [dbo].[Chitiethoadon]
	add constraint Cthd_FK2 foreign key ([OrderID]) references  [dbo].[Hoadon]([OrderID]) 
ALTER TABLE [dbo].[Sanpham]
	add constraint Sp_PK primary key([ProductID])
ALTER TABLE [dbo].[Sanpham]
	add constraint Sp_FK foreign key ([CategoryID]) references  [dbo].[NhomSP]([CategoryID]) 
ALTER TABLE [dbo].[Sanpham]
	add constraint Sp_FK2 foreign key ([SupplierID]) references  [dbo].[Nhacungcap]([SupplierID]) 
ALTER TABLE [dbo].[NhomSP]
	add constraint Nsp_PK primary key([CategoryID])