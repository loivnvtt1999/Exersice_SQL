use Northwind
--1. Tạo một view chứa thông tin khách hàng ở Mexico và Brazil, thông tin gồm
--[CustomerID], [CompanyName], Country.

create view Mexico_Brazil
as
(
	select c.CustomerID, c.CompanyName, c.Country
	from Customers c
	where c.Country like 'Mexico' or c.Country like 'Brazil'
)

select * from Mexico_Brazil
--2. Tạo view chứa danh sách các sản phẩm có QuantityPerUnit thuộc nhóm boxes và
--có đơn giá > 16, thông tin gồm ProductID, ProductName, UnitPrice, QuantityPerUnit,
--COUNTofOrderID
create view dssp 
as
(
	select p.ProductID, p.ProductName, p.UnitPrice,p.QuantityPerUnit
	from Products p
	where QuantityPerUnit like '%boxes' and UnitPrice >16
)
select * from dssp
select * from Products
--3. Tạo view hiển thị tổng tiền bán được từ mỗi khách hàng theo tháng và theo năm.
--Thông tin gồm CustomerID, YEAR (OrderDate) AS OrderYear, MONTH (OrderDate)
--AS OrderMonth, SUM (UnitPrice*Quantity). Viết câu lệnh xem lại cú pháp câu lệnh
--tạo view này.
create view tong_tien_ban 
as
(
	select c.CustomerID,YEAR(o.OrderDate) as OrderYear, MONTH(o.OrderDate) as OrderMonth, Sum(od.UnitPrice*od.Quantity) as Tong_Tien
	from Customers c join Orders o on c.CustomerID=o.CustomerID join [Order Details] od on o.OrderID=od.OrderID
	group by c.CustomerID,YEAR(o.OrderDate),MONTH(o.OrderDate)
)
select *from Customers
select *from tong_tien_ban
exec sp_helptext tong_tien_ban
--4. Tạo view chứa danh sách các khách hàng có trên 5 hóa đơn đặt hàng từ năm 1997
--đến 1998, thông tin gồm mã khách (CustomerID) , họ tên (CompanyName), tổng số
--hóa đơn (CountOfOrders).
create view danh_sach_khach_hang
as
(
	select c.CustomerID, c.CompanyName,count(o.OrderID) as Tong_Hoa_Don
	from Customers c join Orders o on c.CustomerID=o.CustomerID join [Order Details] od on o.OrderID=od.OrderID
	where YEAR(o.OrderDate)=1997 or YEAR(o.OrderDate)=1998
	group by c.CustomerID, c.CompanyName
	having count(o.OrderID)>5
)
select * from danh_sach_khach_hang
--5. Tạo view chứa danh sách những sản phẩm nhóm Beverages và Seafood có tổng số
--lượng bán trong mỗi năm trên 30 sản phẩm, thông tin gồm CategoryName,
--ProductName, Year, SumOfOrderQuantity.
create view dsBaverages_Seafood
as
(
	select c.CategoryName, p.ProductName, YEAR(o.OrderDate) as YearOrder, sum(od.Quantity) as SumOfOrderQuantity
	from Products p join Categories c on p.CategoryID=c.CategoryID join [Order Details] od on p.ProductID=od.ProductID join Orders o on od.OrderID=o.OrderID
	where c.CategoryName like'Beverages' or c.CategoryName like'Seafood'
	group by c.CategoryName, p.ProductName,YEAR(o.OrderDate)
	having sum(od.Quantity)>30
)
drop view dsBaverages_Seafood
select *from Categories
select *from dsBaverages_Seafood
--6. Tạo view với từ khóa WITH ENCRYPTION gồm OrderYear (năm của ngày lập hóa
--đơn), OrderMonth (tháng của ngày lập hóa đơn), OrderTotal (tổng tiền,
--=UnitPrice*Quantity). Sau đó xem thông tin và trợ giúp về mã lệnh của view này
create view with_encryption with encryption
as(
	select YEAR(o.OrderDate) as 'year', MONTH(o.OrderDate) as 'month', sum(od.Quantity*od.UnitPrice) as OrderTotal
	from Orders o join [Order Details] od on o.OrderID=od.OrderID
	group by YEAR(o.OrderDate), MONTH(o.OrderDate)
)
select * from with_encryption
exec sp_helptext with_encryption
--7. Tạo view với từ khóa WITH SCHEMABINDING gồm ProductID, ProductName,
--Discount. Xem thông tin của View. Xóa cột Discount. Có xóa được không? Vì sao?
create view ws_Product WITH SCHEMABINDING 
as(
	select p.ProductID, p.ProductName,od.Discount
	from dbo.Products p join dbo.[Order Details] od on p.ProductID=od.ProductID
)
select *from ws_Product
--8. Tạo view với với từ khóa WITH CHECK OPTION chỉ chứa các khách hàng ở thành
--phố London và Madrid, thông tin gồm: CustomerID, CompanyName, City.
create view wco_KhachHang
as
	select c.CustomerID, c.CompanyName, c.City
	from Customers c
	where c.City like 'London' or c.City like'Madrid'
	WITH CHECK OPTION
select * from wco_KhachHang
--9. Chèn thêm một khách hàng mới không ở thành phố London và Madrid thông qua view
--vừa tạo. Có chèn được không? Giải thích.
insert into wco_KhachHang values ('ABCX','John Henry','Vietnam')
--Khong tao duoc vi nam ngoai dieu kien o London va Madrid
--10.Chèn thêm một khách hàng mới ở thành phố London và một khách hàng mới ở thành
--phố Madrid. Dùng câu lệnh select trên bảng Customers để xem kết quả.
insert into wco_KhachHang values ('ABC','John Henry','London')
