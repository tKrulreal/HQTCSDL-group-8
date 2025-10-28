---------------------
--THỦ TỤC NGHIỆP VỤ--
---------------------
CREATE OR ALTER PROCEDURE SP_TinhGioSuDungTheoNV
    @MaNV CHAR(10)
AS
BEGIN
    SELECT 
        NV.MaNV,
        NV.HoTen,
        --SUM(DATEDIFF(HOUR, CT.GioBatDau, CT.GioKetThuc)) AS TongGioSuDung --theo giờ (đã làm tròn xuống)
        SUM(DATEDIFF(MINUTE, CT.GioBatDau, CT.GioKetThuc)) / 60.0 AS TongGioSuDung --theo giờ (số thực)
    FROM 
        NHANVIEN NV, 
        PHIEUDANGKY PDK, 
        CHITIET_PHIEUDANGKY CT
    WHERE 
        NV.MaNV = PDK.MaNV 
        AND PDK.MaPDK = CT.MaPDK
        AND NV.MaNV = @MaNV
    GROUP BY 
        NV.MaNV, 
        NV.HoTen;
END;
GO

CREATE OR ALTER PROCEDURE SP_TinhSoLanSuDungTheoDonVi
    @MaDonVi CHAR(10),
    @Thang INT,
    @Nam INT
AS
BEGIN
    SELECT 
        DV.MaDonVi,
        DV.TenDonVi,
        COUNT(*) AS SoLanSuDung
    FROM 
        DONVI DV, 
        NHANVIEN NV, 
        PHIEUDANGKY PDK, 
        CHITIET_PHIEUDANGKY CT
    WHERE 
        DV.MaDonVi = NV.MaDonVi
        AND NV.MaNV = PDK.MaNV
        AND PDK.MaPDK = CT.MaPDK
        AND MONTH(CT.NgaySuDung) = @Thang 
        AND YEAR(CT.NgaySuDung) = @Nam
        AND DV.MaDonVi = @MaDonVi
    GROUP BY 
        DV.MaDonVi, 
        DV.TenDonVi;
END;
GO

CREATE OR ALTER PROCEDURE SP_TinhThietBiTrongPhong
AS
BEGIN
    SELECT 
        P.MaPhong,
        P.TenPhong,
        SUM(PTB.SoLuong) AS TongThietBi
    FROM 
        PHONG P, 
        PHONG_THIETBI PTB
    WHERE 
        P.MaPhong = PTB.MaPhong
    GROUP BY 
        P.MaPhong, 
        P.TenPhong;
END;
GO

---------------------
--THỦ TỤC THỐNG KÊ--
---------------------
CREATE OR ALTER PROCEDURE SP_ThongKePhongSuDungTheoThang
    @Thang INT,
    @Nam INT
AS
BEGIN
    SELECT 
        P.MaPhong,
        P.TenPhong,
        COUNT(*) AS SoLanSuDung
    FROM 
        PHONG P, 
        CHITIET_PHIEUDANGKY CT
    WHERE 
        P.MaPhong = CT.MaPhong
        AND MONTH(CT.NgaySuDung) = @Thang
        AND YEAR(CT.NgaySuDung) = @Nam
    GROUP BY 
        P.MaPhong, 
        P.TenPhong
    ORDER BY 
        SoLanSuDung DESC;
END;
GO

CREATE OR ALTER PROCEDURE SP_ThongKeBaoTri
    @TuNgay DATE,
    @DenNgay DATE
AS
BEGIN
    SELECT 
        BT.MaBaoTri,
        P.TenPhong,
        TB.TenTB,
        BT.NgayBatDau,
        BT.NgayKetThuc,
        BT.NoiDung,
        TTB.TenTrangThai AS TrangThaiBaoTri
	--dùng JOIN (INNER JOIN) THIETBI, thì những bản ghi không có MaTB (nullable) sẽ không hiển thị.
	--dùng LEFT JOIN mới hiển thị lịch bảo trì không có MaTB.
    FROM LICH_BAO_TRI BT
    LEFT JOIN PHONG P ON BT.MaPhong = P.MaPhong
    LEFT JOIN THIETBI TB ON BT.MaTB = TB.MaTB
    LEFT JOIN TRANGTHAI_BAOTRI TTB ON BT.MaTrangThaiBT = TTB.MaTrangThaiBT
    WHERE BT.NgayBatDau >= @TuNgay AND BT.NgayKetThuc <= @DenNgay
    ORDER BY BT.NgayBatDau;
END;
GO

CREATE OR ALTER PROCEDURE SP_ThongKeTheoDonVi
AS
BEGIN
    SELECT 
        DV.MaDonVi,
        DV.TenDonVi,
        COUNT(CT.MaPhong) AS TongSoLanSuDung
    FROM 
        DONVI DV, 
        NHANVIEN NV, 
        PHIEUDANGKY PDK, 
        CHITIET_PHIEUDANGKY CT
    WHERE 
        DV.MaDonVi = NV.MaDonVi
        AND NV.MaNV = PDK.MaNV
        AND PDK.MaPDK = CT.MaPDK
    GROUP BY 
        DV.MaDonVi, 
        DV.TenDonVi
    ORDER BY 
        TongSoLanSuDung DESC;
END;
GO

CREATE OR ALTER PROCEDURE SP_ThongKeTrangThaiPhong
AS
BEGIN
    SELECT 
        TT.TenTrangThai,
        COUNT(P.MaPhong) AS SoPhong,
        COUNT(P.MaPhong) * 100 / (SELECT COUNT(*) FROM PHONG) AS TyLePhanTram
	--Nếu dùng JOIN các trạng thái không có phòng nào sẽ ko hiển thị.
    FROM TRANGTHAI_PHONG TT
    LEFT JOIN PHONG P ON TT.MaTrangThai = P.MaTrangThai
    GROUP BY TT.TenTrangThai;
END;
GO

CREATE OR ALTER PROCEDURE SP_TongKetSuDungNam
    @Nam INT
AS
BEGIN
    SELECT 
        DATEPART(QUARTER, CT.NgaySuDung) AS Quy,  -- Tách quý từ cột NgaySuDung
        COUNT(*) AS TongSoLanSuDung
    FROM 
        CHITIET_PHIEUDANGKY CT
    WHERE 
        YEAR(CT.NgaySuDung) = @Nam
    GROUP BY 
        DATEPART(QUARTER, CT.NgaySuDung)
    ORDER BY 
        Quy;
END;
GO

--------------------
--THỦ TỤC KIỂM TRA--
--------------------
CREATE  OR ALTER PROCEDURE SP_KiemTraTrungLichPhong
    @MaPhong CHAR(10),
    @NgaySuDung DATE,
    @GioBatDau TIME,
    @GioKetThuc TIME
AS
BEGIN
    IF EXISTS (SELECT 1 FROM CHITIET_PHIEUDANGKY
				WHERE MaPhong = @MaPhong
				AND NgaySuDung = @NgaySuDung
				AND (GioBatDau < @GioKetThuc AND GioKetThuc > @GioBatDau)
				)
    BEGIN
        PRINT N'Phòng này đã có người đăng ký trùng giờ.';
        SELECT 'TrungLich' AS KetQua;
    END
    ELSE
    BEGIN
        PRINT N'Phòng này còn trống trong khung giờ yêu cầu.';
        SELECT 'KhongTrung' AS KetQua;
    END
END;
GO

CREATE OR ALTER PROCEDURE SP_TimPhongTrong
    @NgaySuDung DATE,
    @GioBatDau TIME,
    @GioKetThuc TIME,
    @SoNguoi INT = NULL
AS
BEGIN
    SELECT 
        P.MaPhong,
        P.TenPhong,
        P.SucChua,
        T.TenTrangThai
    FROM 
        PHONG P, 
        TRANGTHAI_PHONG T
    WHERE 
        P.MaTrangThai = T.MaTrangThai
        -- Chỉ lấy phòng có trạng thái "Trống"
        AND T.MaTrangThai = 'TT001'
        -- Nếu có yêu cầu về sức chứa thì lọc thêm
        AND (@SoNguoi IS NULL OR P.SucChua >= @SoNguoi)
        -- Loại bỏ các phòng bị trùng lịch trong ngày
        AND P.MaPhong NOT IN (
            SELECT MaPhong
            FROM CHITIET_PHIEUDANGKY
            WHERE NgaySuDung = @NgaySuDung
            AND (GioBatDau < @GioKetThuc AND GioKetThuc > @GioBatDau)
        )
    ORDER BY 
        P.SucChua ASC;
END;
GO

--EXEC--
EXEC SP_TinhGioSuDungTheoNV 'NV001'
EXEC SP_TinhSoLanSuDungTheoDonVi 'DV02' , 10, 2025
EXEC SP_TinhThietBiTrongPhong

EXEC SP_ThongKePhongSuDungTheoThang 11, 2025
EXEC SP_ThongKeBaoTri '2025-01-01', '2026-01-01'
EXEC SP_ThongKeTheoDonVi
EXEC SP_ThongKeTrangThaiPhong
EXEC SP_TongKetSuDungNam '2025'

EXEC SP_KiemTraTrungLichPhong
     @MaPhong = 'P001',
     @NgaySuDung = '2025-10-20',
     @GioBatDau = '08:00',
     @GioKetThuc = '10:00';
EXEC SP_TimPhongTrong
     @NgaySuDung = '2025-01-01',
     @GioBatDau = '09:00',
     @GioKetThuc = '11:00',
     @SoNguoi = 20;