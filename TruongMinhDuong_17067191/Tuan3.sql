--1. Liệt kê danh sách khách hàng ở GV, thông tin gồm MaKH, TenKH, Điachỉ.
select [MaKh],[TenKh],[DiaChi]
from [KhachHang]
where DiaChi like N'%GV'
--2. Tạo query cho xem danh sách nhân viên tên Nam ở GV, thông tin gồm MaNV, TenNV,
--Địa chỉ
select [MaNV],[TenNV],[DiaChi]
from [dbo].[Nhanvien]
where DiaChi like N'%GV'
--3. Liệt kê các hóa đơn lập trong tháng 12, thông tin gồm MaHD, NgayLapHD, MaNV,
--MaKH
select [MaHD],[NgayLapHD],[MaNV],[MaKh]
from [dbo].[HoaDon]
where MONTH(NgayLapHD) = 12
--4. Liệt kê các nhà cung cấp ở quận 1 hoặc những nhà cung cấp không có Email
select [Diachi],[DCMail]
from [dbo].[NhaCungCap]
where Diachi like N'%Q1' or DCMail is null
--5. Liệt kê các sản phẩm thuộc nhóm 1
select [MaNhom],[TenSp]
from [dbo].[SanPham]
where MaNhom =1
--6. Liệt kê các khách hàng lập hóa đơn trong tháng 11, thông tin gồm MaKH, TenKH,
--Diachi.
select kh.MaKh,kh.TenKh,kh.DiaChi
from [dbo].[HoaDon] hd join [dbo].[KhachHang] kh on kh.MaKh=hd.MaKh 
where month(hd.NgayLapHD)=11
--7. Liệt kê các sản phẩm bán trong tháng 11 và 12 có số lượng >20, thông tin gồm MaSP,
--TenSP, NgayLapHD, Soluong.
select sp.MaSp,sp.TenSp,hd.NgayLapHD,ct.Soluong
from [dbo].[CT_HoaDon] ct join [dbo].[HoaDon]  hd on ct.MaHD=hd.MaHD   join  [dbo].[SanPham] sp
on sp.MaSp=ct.MaSp
where (MONTH(NgayLapHD)=11 or MONTH(NgayLapHD) =12) and ct.Soluong > 20
--8. Liệt kê các sản phẩm thuộc nhóm ‘Thiết bị mạng’, thông tin gồm MaSP, TenSp.
select sp.MaSp,sp.TenSp
from [dbo].[SanPham] sp join [dbo].[NhomSanPham] nsp on sp.MaNhom=nsp.MaNhom
where TenNhom like N'Thiết bị mạng'
--9. Liệt kê các nhà cung cấp đã cung cáp các sản phẩm thuộc nhóm ‘Máy tính xách tay’,
--thông tin gồm MaNCC, TenNCC, TenSP.
select sp.TenSp,ncc.TenNcc,ncc.MaNCC
from [dbo].[SanPham] sp inner join [dbo].[NhomSanPham] nsp on sp.MaNhom=nsp.MaNhom join [dbo].[NhaCungCap] ncc
on ncc.MaNCC=sp.MaNCC
where TenNhom like N'Máy tính xách tay'
--10.Liệt kê các nhân viên lập hóa đơn cho Khách hàng ở Quận GV, loại bỏ những record
--trùng lắp, thông tin gồm MaNV, TenNV, TenKH.
select nv.MaNV,nv.TenNV,kh.TenKh
from [dbo].[KhachHang] kh join [dbo].[HoaDon] hd on kh.[MaKh]=hd.MaKh join [Nhanvien] nv on hd.MaNV=nv.MaNV 
where kh.DiaChi like N'%GV'
--11.Liệt kê danh sách các khách hàng mua các sản phẩm của nhà cung cấp ‘Chính Nhân’
--và ‘Minhh Châu’, với số lượng >20, thông tin gồm MaKH, TenKH, TenSP, Soluong.
select kh.MaKh,kh.TenKh,sp.TenSp,cthd.Soluong
from [dbo].[SanPham] sp join [dbo].[NhaCungCap] ncc on sp.MaNCC=ncc.MaNCC join [dbo].[CT_HoaDon] cthd
on cthd.MaSp=sp.MaSp join [dbo].[HoaDon] hd on hd.MaHD=cthd.MaHD join [dbo].[KhachHang] kh on
kh.MaKh=hd.MaKh
where (ncc.TenNcc like N'Chính Nhân' or ncc.TenNcc like N'Minh Châu') and cthd.Soluong > 20
--12.Tạo query tính tiền cho các hóa đơn của khách hàng mua sản phẩm thuộc nhóm ‘Máy
--tính để bàn’ trong tháng 11, thông tin gồm MaHD, NgayLapHD, TenSP, Soluong,
--DonGia, ThanhTien
select hd.MaHD, sum(Soluong*Dongia) as 'Thanh tien'
from [dbo].[SanPham] sp join [dbo].[NhomSanPham] nsp on nsp.MaNhom=sp.MaNhom join [dbo].[CT_HoaDon] ct on
ct.MaSp=sp.MaSp join [dbo].[HoaDon] hd on hd.MaHD=ct.MaHD
where MONTH(NgayLapHD)=11 and TenNhom like N'Máy tính xách tay'
group by hd.MaHD

--13.Tạo query cho xem các khách hàng có trị giá hóa đơn >10000000 (10 triệu), thông tin
--gồm MaKH, MaHD, TenSP, SoLuong, ThanhTien, với Thanhtien=Soluong*DonGia.
select hd.MaHD, sum(Soluong*Dongia) as 'Thanh tien'
from [dbo].[SanPham] sp join [dbo].[NhomSanPham] nsp on nsp.MaNhom=sp.MaNhom join [dbo].[CT_HoaDon] ct on
ct.MaSp=sp.MaSp join [dbo].[HoaDon] hd on hd.MaHD=ct.MaHD
where MONTH(NgayLapHD)=11 and TenNhom like N'Máy tính xách tay'
group by hd.MaHD
having  sum(Soluong*Dongia)>10000000
--14.Liệt kê các nhà cung cấp không cung cấp sản phẩm nào, thông tin gồm MaNCC,
--tenNCC, DiaChi.
select
from
where
--15.Liệt kê các nhân viên không lập hóa đơn, thông tin gồm MaNV, TenNV, DiaChi,
--DienThoai.
select
from
where
--16.Liệt kê các sản phẩm chưa bán lần nào, thông tin gồm: MaSP, TenSP, SoLuong,
--Giagoc.
select
from
where