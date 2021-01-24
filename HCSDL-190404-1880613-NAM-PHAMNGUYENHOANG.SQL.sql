--TEN, HO VA CHU LOT: NAM, PHAM NGUYEN HOANG
--MSSV:	1880316
--2019-04-04, H5.01-STT
--TEN TAP TIN: HCSDL-190404-1880613-NAM-PHAMNGUYENHOANG.SQL

--1.Danh sách các orders ứng với tổng tiền của từng hóa đơn. Thông tin bao
--gồm OrdersId, OrderDate, TotalAccount. Trong đó TotalAccount là Sum
--của Quantity * Unitprice, kết nhóm theo OrderId.
select O.OrderId,OrderDate,Totalaccount=sum(Quantity*UnitPrice)
from Orders O,Customers C,[Order Details] OD
where O.CustomerID=C.CustomerID and OD.OrderID=O.OrderID
group by O.OrderId,OrderDate


--2. Danh sách các orders ứng với tổng tiền của từng hóa đơn có Shipcity là
--‘Madrid’. Thông tin bao gồm OrdersId, OrderDate, TotalAccount. Trong đó
--TotalAccount là Sum của Quantity * Unitprice, kết nhóm theo OrderId.

select OrderDate,ShipCity,totalaccount=sum(Od.UnitPrice*od.Quantity)
from [Order Details] OD,Orders O,Customers C
where Od.OrderID=O.OrderID and C.CustomerID=O.CustomerID and o.ShipCity='Madrid'
group by O.OrderDate,o.OrderID,o.ShipCity
--3. Danh sách các products có tổng số lượng lập hóa đơn lớn nhất.
select  top 1 p.ProductID, sl=count(OrderID)
from Products p, [Order Details] od
where od.ProductID=p.ProductID
group by p.ProductID
order by sl desc

--4. Cho biết mỗi customers đã lập bao nhiêu hóa đơn. Thông tin gồm
--CustomerID, CompanyName, CountOfOrder. Trong đó CountOfOrder (tổng
--số hóa đơn) được đếm (Count) theo từng Customers.
select CompanyName,c.CustomerID,countoforder=count(o.OrderID)
from Customers c,Orders o,[Order Details] od
where c.CustomerID=o.CustomerID and o.OrderID=od.OrderID
group by c.CustomerID,CompanyName
--5. Cho biết mỗi Employee đã lập được bao nhiêu hóa đơn, ứng với tổng tiền.
select *
from Employees e, [Order Details] od,Orders o,
where o.EmployeeID=e.EmployeeID and o.OrderID=od.OrderID
group by o.
--6. Danh sách các customer ứng với tổng tiền các hoá đơn được lập từ
--31/12/1996 đến 1/1/1998.
select tt=sum(od.Quantity*od.UnitPrice),o.CustomerID
from Orders o, [Order Details] od
where o.OrderID=od.OrderID and YEAR(o.OrderDate)='1997'
group by o.CustomerID


--7. Danh sách các customer ứng với tổng tiền các hoá đơn, mà các hóa đơn
--được lập từ 31/12/1996 đến 1/1/1998 và tổng tiền các hóa đơn >20000.

--8. Danh sách các customer ứng với tổng số hoá đơn, tổng tiền các hoá đơn,
--mà các hóa đơn được lập từ 31/12/1996 đến 1/1/1998 và tổng tiền các
--hóa đơn >20000. Thông tin được sắp xếp theo CustomerID, cùng mã thì
--sắp xếp theo tổng tiền giảm dần.
SET DATEFORMAT DMY
SELECT O.[CustomerID],[CompanyName],[Address],[Phone],TONGTIEN=SUM([UnitPrice]*[Quantity])
FROM Customers C JOIN [dbo].[Orders] O ON C.CustomerID=O.CustomerID JOIN [dbo].[Order Details] OD ON O.OrderID=OD.OrderID
WHERE ORDERDATE BETWEEN '31/12/1996' AND '1/1/1998'
GROUP BY O.[CustomerID],[CompanyName],[Address],[Phone]
HAVING SUM([UnitPrice]*[Quantity])>20000
ORDER BY O.CustomerID,TONGTIEN DESC 
--9. Danh sách các Category có tổng số lượng tồn (UnitsInStock) lớn hơn 300,
--đơn giá trung bình nhỏ hơn 25. Thông tin kết quả bao gồm CategoryID,
--CategoryName, Total_UnitsInStock, Average_Unitprice.
select C.CategoryID,C.CategoryName, Total_UnitsInStock=sum(p.UnitsInStock), Average_Unitprice=(sum(p.UnitPrice)/COUNT(p.UnitPrice)),AVG(UnitPrice)
from Categories C,Products P
where  p.CategoryID=c.CategoryID 
group by c.CategoryID,c.CategoryName
having (sum(p.UnitPrice)/COUNT(p.UnitPrice))>25

--10.Danh sách các Category có tổng số product lớn hớn 10. Thông tin kết quả
--bao gồm CategoryID, CategoryName, Total_UnitsInStock.

--11.Danh sách các product theo từng CategoryName, thông tin bao gồm:
--Productname, CategoryName, Unitprice, tổng số lượng tồn (sum of
--UnitsinStock) theo từng CategoryName.

--12.Danh sách các Customer ứng với tổng tiền của các hóa đơn ở từng tháng.
--Thông tin bao gồm CustomerID, CompanyName, Month_Year, Total. Trong
--đó Month_year là tháng và năm lập hóa đơn, Total là tổng của Unitprice*
--Quantity, có thống kế tổng của total theo từng Customer và Month_Year .

--13.Cho biết Employees nào bán được nhiều tiền nhất trong 7 của năm 1997

--14.Danh sách 3 khách có nhiều đơn hàng nhất của năm 1996.

--15.Cho biết khách hàng nào có số lần mua hàng lớn hơn 10 trong năm 1997.