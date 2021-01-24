
use Northwind
--1. Xem thông tin về nhà cung cấp cung cấp nhiều sản phẩm nhất trong năm 1998, thông
--tin gồm [SupplierID], [CompanyName], [City]
select [CompanyName],[City],s.[SupplierID],count(p.ProductID)
from Products p join Suppliers s on p.SupplierID=s.SupplierID join [Order Details] od on p.ProductID=od.ProductID join Orders o on o.OrderID=od.OrderID
where year(OrderDate)=1998
group by [CompanyName],[City],s.[SupplierID] 
having count(p.ProductID)>=all(select	count(p.ProductID)
							from Products p join Suppliers s on p.SupplierID=s.SupplierID join [Order Details] od on p.ProductID=od.ProductID join Orders o on o.OrderID=od.OrderID
							where year(OrderDate)=1998
							group by [CompanyName]
							)
--2. Xem thông tin mặt hàng có nơi chuyển đến (ShipCity) là Lyon, có số lượng chuyển
--cao nhất trong năm 1998 thông tin gồm [ProductID] [ProductName]
select p.ProductID,p.ProductName,sum(Quantity)
from Products p join [Order Details] od on p.ProductID=od.ProductID join Orders o on o.OrderID=od.OrderID
where ShipCity like 'Lyon' and YEAR(OrderDate)=1998
group by p.ProductID,p.ProductName
having sum(Quantity) >=all(select sum(Quantity)
							from Products p join [Order Details] od on p.ProductID=od.ProductID join Orders o on o.OrderID=od.OrderID
							where ShipCity like 'Lyon' and YEAR(OrderDate)=1998
							group by p.ProductID
)
--3. Liệt kê các nhân viên có tổng doanh thu cao hơn bất kỳ doanh thu của nhân viên nào
--trong năm 1998, thông tin gồm EmployeeID, LastName, SumofTotal
select e.EmployeeID, e.LastName, sum(Quantity*UnitPrice) as SumofToTal
from [Order Details] od join Orders o on o.OrderID=od.OrderID join Employees e on e.EmployeeID=o.EmployeeID
where YEAR(OrderDate)=1998
group by e.EmployeeID, e.LastName
having sum(Quantity*UnitPrice) >= all (select sum(Quantity*UnitPrice)
								from [Order Details] od join Orders o on o.OrderID=od.OrderID join Employees e on e.EmployeeID=o.EmployeeID
								where YEAR(OrderDate)=1998
								group by e.EmployeeID)
--4. Xem thông tin của các khách hàng có tổng số hóa đơn cao hơn bất kỳ số hóa đơn
--của khách hàng trong năm 1997. Thông tin gồm [CustomerID], [CompanyName],
--countofOrder
select c.CustomerID,c.CompanyName, count(o.OrderID) as countofOrder
from [Order Details] od join Orders o on o.OrderID=od.OrderID join Customers c on o.CustomerID=c.CustomerID
where YEAR(OrderDate)=1997
group by c.CustomerID,c.CompanyName
having count(o.OrderID) >=all(select count(o.OrderID) as countofOrder
							from [Order Details] od join Orders o on o.OrderID=od.OrderID join Customers c on o.CustomerID=c.CustomerID
							where YEAR(OrderDate)=1997
							group by c.CustomerID)
--5. Liệt kê các khách hàng có các hóa đơn với tổng trị giá cao hơn bất kỳ trị giá của các
--hóa đơn của khách hàng thuộc Mexico
select c.CustomerID,c.CompanyName, sum(Quantity*UnitPrice) as sumtofOrder
from [Order Details] od join Orders o on o.OrderID=od.OrderID join Customers c on o.CustomerID=c.CustomerID
where Country like 'Mexico'
group by c.CustomerID,c.CompanyName
having sum(Quantity*UnitPrice) >=all (select sum(Quantity*UnitPrice)
							from [Order Details] od join Orders o on o.OrderID=od.OrderID join Customers c on o.CustomerID=c.CustomerID
							where Country like 'Mexico'
							group by c.CustomerID)
--6. Liệt kê danh sách các sản phẩm có đơn giá cao hơn đơn giá trung bình cùa các sản
--phẩm
select *
from Products
where UnitPrice >=all (select avg (UnitPrice)
					from Products )
--7. Liệt kê các hóa đơn có tổng trị giá cao hơn trị giá trung bình của các hóa đơn lập trong
--năm 1998

select od.OrderID, od.ProductID,sum(UnitPrice*Quantity)
from [Order Details] od  join Orders o on od.OrderID=o.OrderID
where year(o.OrderDate)=1998
group by od.OrderID, od.ProductID
having sum(UnitPrice*Quantity) >= all (select avg(UnitPrice*Quantity)
										from [Order Details] od  join Orders o on od.OrderID=o.OrderID
										where year(o.OrderDate)=1998
										)

--8. Liệt kê các công ty vận chuyển (Shipper) vận chuyển tổng số lượng hàng nhiều hơn
--tất cả tổng số lượng vận chuyển của các công ty trong năm 1998

select ShipperID,s.CompanyName,sum(od.Quantity)
from Products p join [Order Details] od on p.ProductID=od.ProductID join Orders o on o.OrderID=od.OrderID join Shippers s on o.ShipVia=s.ShipperID
where year(o.OrderDate)=1998
group by s.CompanyName,ShipperID
having sum(od.Quantity) >=all(select sum(od.Quantity)
							from Products p join [Order Details] od on p.ProductID=od.ProductID join Orders o on o.OrderID=od.OrderID join Shippers s on o.ShipVia=s.ShipperID
							where year(o.OrderDate)=1998
							group by s.CompanyName)
--9. Liệt kê các quốc gia (ShipCountry) có số lượng hàng chuyển đến nhiều nhất trong
--năm 1998
 
select ShipCountry,sum(od.Quantity)
from Products p join [Order Details] od on p.ProductID=od.ProductID join Orders o on o.OrderID=od.OrderID
where year(o.OrderDate)=1998
group by ShipCountry 
having sum(Quantity) >=all(select sum(od.Quantity)
						from Products p join [Order Details] od on p.ProductID=od.ProductID join Orders o on o.OrderID=od.OrderID
						where year(o.OrderDate)=1998
						group by ShipCountry )
--10.Xem thông tin của nhóm hàng có số lượng hàng chuyển đến Brazil nhiều nhất trong
--năm 1998

select c.CategoryID,c.CategoryName,sum(od.Quantity)
from Products p join [Order Details] od on p.ProductID=od.ProductID join Orders o on o.OrderID=od.OrderID join Categories c on p.CategoryID=c.CategoryID
where year(o.OrderDate)=1998
group by c.CategoryID,c.CategoryName
having sum(od.Quantity) >=all(select sum(od.Quantity)
								from Products p join [Order Details] od on p.ProductID=od.ProductID join Orders o on o.OrderID=od.OrderID join Categories c on p.CategoryID=c.CategoryID
								where year(o.OrderDate)=1998
								group by c.CategoryID)
--Tuan 8
--1. Liệt kê các khách hàng có đơn hàng chuyển đến các quốc gia ([ShipCountry]) là
--'Germany' và 'USA' trong quý 1 năm 1998, do công ty vận chuyển (CompanyName)
--Speedy Express thực hiện, thông tin gồm [CustomerID], [CompanyName] (tên khách
--hàng), tổng tiền.

select c.CustomerID,s.CompanyName,o.ShipCountry,sum(Quantity*UnitPrice)
from  Orders o join Shippers s on o.ShipVia=s.ShipperID join Customers c on c.CustomerID=o.CustomerID join [Order Details] od on o.OrderID=od.OrderID
where (ShipCountry like 'Germany' or ShipCountry like 'USA') and DATEPART(QUARTER,o.OrderDate)=1 and s.CompanyName like 'Speedy Express' and YEAR(o.OrderDate)=1998
group by c.CustomerID,s.CompanyName,o.ShipCountry
--2. Cho xem thông tin của công ty vận chuyển có nhiều đơn hàng nhất trong năm 1998,
--thông tin gồm ShipperID, CompanyName, số đơn hàng.

select s.ShipperID, s.CompanyName, count(o.OrderID)
from Orders o join Shippers s on o.ShipVia=s.ShipperID
where YEAR(o.OrderDate)=1998
group by s.ShipperID, s.CompanyName
having count(o.OrderID) >=all(select count(o.OrderID)
								from Orders o join Shippers s on o.ShipVia=s.ShipperID
								where YEAR(o.OrderDate)=1998
								group by s.ShipperID)

--3. Cho xem thông tin của công ty vận chuyển có nhiều đơn hàng đến Brazil nhất trong
--năm 1998, thông tin gồm ShipperID, CompanyName, số đơn hàng
	
select s.ShipperID, s.CompanyName, count(o.OrderID)
from Orders o join Shippers s on o.ShipVia=s.ShipperID
where YEAR(o.OrderDate)=1998 and o.ShipCountry like 'Brazil'
group by s.ShipperID, s.CompanyName
having count(o.OrderID) >=all(select count(o.OrderID)
								from Orders o join Shippers s on o.ShipVia=s.ShipperID
								where YEAR(o.OrderDate)=1998 and o.ShipCountry like 'Brazil'
								group by s.ShipperID)
								
--4. Liệt kê các mặt hàng chuyển đến France có số lượng cao nhất, thông tin gồm
--ProductID, ProductName.

select p.ProductID,p.ProductName,sum(Quantity)
from Products p join [Order Details] od on p.ProductID=od.ProductID join Orders o on o.OrderID=od.OrderID
where o.ShipCountry like 'France'	
group by p.ProductID,p.ProductName
having 	sum(Quantity) >=all(select sum(Quantity)
							from Products p join [Order Details] od on p.ProductID=od.ProductID join Orders o on o.OrderID=od.OrderID
							where o.ShipCountry like 'France'	
							group by p.ProductID)

--5. Liệt kê các công ty vận chuyển có số đơn hàng trong năm 1997 cao hơn tất cả số
--đơn hàng của các công ty vận chuyển trong năm 1998.
 	
select s.ShipperID, s.CompanyName, count(o.OrderID)
from Orders o join Shippers s on o.ShipVia=s.ShipperID
where YEAR(o.OrderDate)=1997
group by s.ShipperID, s.CompanyName
having count(o.OrderID) >=all(select count(o.OrderID)
								from Orders o join Shippers s on o.ShipVia=s.ShipperID
								where YEAR(o.OrderDate)=1998
								group by s.ShipperID)

--6. Liệt kê các nhà cung cấp cung cấp các mặt hàng chuyển đến Mexico có số lượng cao
--nhất năm 1998	
select c.CategoryID,c.CategoryName,sum(od.Quantity)
from Products p join [Order Details] od on p.ProductID=od.ProductID join Orders o on o.OrderID=od.OrderID join Categories c on p.CategoryID=c.CategoryID
where year(o.OrderDate)=1998 and o.ShipCountry like 'Mexico'
group by c.CategoryID,c.CategoryName
having sum(od.Quantity) >=all(select sum(od.Quantity)
								from Products p join [Order Details] od on p.ProductID=od.ProductID join Orders o on o.OrderID=od.OrderID join Categories c on p.CategoryID=c.CategoryID
								where year(o.OrderDate)=1998 and o.ShipCountry like 'Mexico'
								group by c.CategoryID)		 