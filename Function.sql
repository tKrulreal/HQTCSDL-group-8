USE QL_PHONGHOP;
GO

-- 1. Tổng giờ sử dụng phòng trong 1 ngày
CREATE OR ALTER FUNCTION F_TongGioSuDung(@MaPhong CHAR(10), @Ngay DATE)
    RETURNS INT
AS
BEGIN
    DECLARE @Tong INT;
    SELECT @Tong = SUM(DATEDIFF(HOUR, GioBatDau, GioKetThuc))
    FROM CHITIET_PHIEUDANGKY
    WHERE MaPhong = @MaPhong AND NgaySuDung = @Ngay;
    RETURN ISNULL(@Tong, 0);
END;
GO

-- 2. Số lần sử dụng phòng trong 1 tháng
CREATE OR ALTER FUNCTION F_SoLanSuDungPhong(@MaPhong CHAR(10), @Thang INT)
    RETURNS INT
AS
BEGIN
    DECLARE @SoLan INT;
    SELECT @SoLan = COUNT(*)
    FROM CHITIET_PHIEUDANGKY
    WHERE MaPhong = @MaPhong
      AND MONTH(NgaySuDung) = @Thang;
    RETURN ISNULL(@SoLan, 0);
END;
GO

-- 3. Tổng số phòng trong một tòa nhà
CREATE OR ALTER FUNCTION F_TongSoPhongTrongToa(@MaToa CHAR(10))
    RETURNS INT
AS
BEGIN
    DECLARE @SL INT;
    SELECT @SL = COUNT(*) FROM PHONG WHERE MaToaNha = @MaToa;
    RETURN ISNULL(@SL, 0);
END;
GO

-- 4. Số thiết bị hư hỏng
CREATE OR ALTER FUNCTION F_SoTBHu()
    RETURNS INT
AS
BEGIN
    DECLARE @So INT;
    SELECT @So = COUNT(*) FROM THIETBI WHERE TinhTrang LIKE N'%hư%';
    RETURN ISNULL(@So, 0);
END;
GO

-- 5. Số nhân viên trong đơn vị
CREATE OR ALTER FUNCTION F_SoNVTrongDonVi(@MaDonVi CHAR(10))
    RETURNS INT
AS
BEGIN
    DECLARE @SL INT;
    SELECT @SL = COUNT(*) FROM NHANVIEN WHERE MaDonVi = @MaDonVi;
    RETURN ISNULL(@SL, 0);
END;
GO

