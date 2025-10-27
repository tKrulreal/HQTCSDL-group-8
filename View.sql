USE QL_PHONGHOP;
GO

-- 1. Danh sách phòng kèm loại và tòa nhà
CREATE OR ALTER VIEW V_DanhSachPhong AS
SELECT P.MaPhong, P.TenPhong, P.SucChua, 
       TN.TenToaNha, LP.TenLoai, TT.TenTrangThai
FROM PHONG P, TOA_NHA TN, LOAI_PHONG LP, TRANGTHAI_PHONG TT
WHERE P.MaToaNha = TN.MaToaNha 
  AND P.MaLoai = LP.MaLoai 
  AND P.MaTrangThai = TT.MaTrangThai;
GO

-- 2. Phòng trống trong ngày hiện tại
CREATE OR ALTER VIEW V_PhongTrongHomNay AS
SELECT MaPhong, TenPhong, SucChua
FROM PHONG
WHERE MaPhong NOT IN (
    SELECT DISTINCT MaPhong 
    FROM CHITIET_PHIEUDANGKY
    WHERE NgaySuDung = CAST(GETDATE() AS DATE)
);
GO

-- 3. Phòng kèm danh sách thiết bị
CREATE OR ALTER VIEW V_PhongVaThietBi AS
SELECT P.MaPhong, P.TenPhong, TB.TenTB, PTB.SoLuong
FROM PHONG P, PHONG_THIETBI PTB, THIETBI TB
WHERE P.MaPhong = PTB.MaPhong 
  AND PTB.MaTB = TB.MaTB;
GO

-- 4. Danh sách đăng ký phòng
CREATE OR ALTER VIEW V_DangKyPhong AS
SELECT PD.MaPDK, NV.HoTen, DV.TenDonVi, P.TenPhong,
       CT.NgaySuDung, CT.GioBatDau, CT.GioKetThuc, CT.MucDich
FROM PHIEUDANGKY PD, NHANVIEN NV, DONVI DV, CHITIET_PHIEUDANGKY CT, PHONG P
WHERE PD.MaNV = NV.MaNV
  AND NV.MaDonVi = DV.MaDonVi
  AND CT.MaPDK = PD.MaPDK
  AND CT.MaPhong = P.MaPhong;
GO

-- 5. Lịch bảo trì
CREATE OR ALTER VIEW V_LichBaoTri AS
SELECT BT.MaBaoTri, P.TenPhong, TB.TenTB, 
       BT.NgayBatDau, BT.NgayKetThuc, TBT.TenTrangThai
FROM LICH_BAO_TRI BT, PHONG P, THIETBI TB, TRANGTHAI_BAOTRI TBT
WHERE BT.MaPhong = P.MaPhong
  AND BT.MaTB = TB.MaTB
  AND BT.MaTrangThaiBT = TBT.MaTrangThaiBT;
GO

-- 6. Thông tin nhân viên kèm đơn vị
CREATE OR ALTER VIEW V_ThongTinNhanVien AS
SELECT NV.MaNV, NV.HoTen, NV.ChucVu, NV.Email, NV.SDT, DV.TenDonVi
FROM NHANVIEN NV, DONVI DV
WHERE NV.MaDonVi = DV.MaDonVi;
GO

-- 7. Tình trạng thiết bị
CREATE OR ALTER VIEW V_TinhTrangThietBi AS
SELECT MaTB, TenTB, DonViTinh, TinhTrang
FROM THIETBI
WHERE TinhTrang IS NOT NULL;
GO
--XEM VIEW
SELECT * FROM V_DanhSachPhong;
SELECT * FROM V_PhongTrongHomNay;
SELECT * FROM V_PhongVaThietBi;
SELECT * FROM V_DangKyPhong;
SELECT * FROM V_LichBaoTri;
SELECT * FROM V_ThongTinNhanVien;
SELECT * FROM V_TinhTrangThietBi;
