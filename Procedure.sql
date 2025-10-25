--1 Bảng TOA_NHA
CREATE OR ALTER PROC SP_THEM_TOANHA
    @MaToaNha CHAR(10),
    @TenToaNha NVARCHAR(100),
    @DiaChi NVARCHAR(200)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM TOA_NHA WHERE MaToaNha = @MaToaNha)
        PRINT N'Mã tòa nhà đã tồn tại.';
    ELSE
        INSERT INTO TOA_NHA VALUES (@MaToaNha, @TenToaNha, @DiaChi);
END
GO

CREATE OR ALTER PROC SP_SUA_TOANHA
    @MaToaNha CHAR(10),
    @TenToaNha NVARCHAR(100),
    @DiaChi NVARCHAR(200)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM TOA_NHA WHERE MaToaNha = @MaToaNha)
        PRINT N'Không tìm thấy tòa nhà.';
    ELSE
        UPDATE TOA_NHA
        SET TenToaNha = @TenToaNha,
            DiaChi = @DiaChi
        WHERE MaToaNha = @MaToaNha;
END
GO

CREATE OR ALTER PROC SP_XOA_TOANHA
    @MaToaNha CHAR(10)
AS
BEGIN
	IF NOT EXISTS (SELECT 1 FROM TOA_NHA WHERE MaToaNha = @MaToaNha)
	BEGIN
        PRINT N'Không tìm thấy tòa nhà.';
		RETURN
	END
    IF EXISTS (SELECT 1 FROM PHONG WHERE MaToaNha = @MaToaNha)
	BEGIN
        PRINT N'Không thể xóa – còn phòng thuộc tòa này.';
		RETURN
	END
    
	DELETE FROM TOA_NHA WHERE MaToaNha = @MaToaNha;
END
GO

--2 Bảng LOAI_PHONG
CREATE OR ALTER PROC SP_THEM_LOAIPHONG
    @MaLoai CHAR(10),
    @TenLoai NVARCHAR(50),
    @MoTa NVARCHAR(200)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM LOAI_PHONG WHERE MaLoai = @MaLoai)
        PRINT N'Mã loại phòng đã tồn tại.';
    ELSE
        INSERT INTO LOAI_PHONG VALUES (@MaLoai, @TenLoai, @MoTa);
END
GO

CREATE OR ALTER PROC SP_SUA_LOAIPHONG
    @MaLoai CHAR(10),
    @TenLoai NVARCHAR(50) = NULL,
    @MoTa NVARCHAR(200) = NULL
AS
BEGIN
	IF NOT EXISTS (SELECT 1 FROM LOAI_PHONG WHERE MaLoai =@MaLoai)
		PRINT N'Mã loại phòng không tồn tại.'
	ELSE
		UPDATE LOAI_PHONG
		SET TenLoai = ISNULL(@TenLoai, TenLoai),
			MoTa = ISNULL(@MoTa, MoTa)
		WHERE MaLoai = @MaLoai;
END
GO

CREATE OR ALTER PROC SP_XOA_LOAIPHONG
    @MaLoai CHAR(10)
AS
BEGIN
	IF NOT EXISTS (SELECT 1 FROM LOAI_PHONG WHERE MaLoai =@MaLoai)
	BEGIN
		PRINT N'Mã loại phòng không tồn tại.'
		RETURN
	END
    IF EXISTS (SELECT 1 FROM PHONG WHERE MaLoai = @MaLoai)
	BEGIN
        PRINT N'Không thể xóa – còn phòng thuộc loại này.';
		RETURN
	END
    
	DELETE FROM LOAI_PHONG WHERE MaLoai = @MaLoai;
END
GO

--2.5 Bảng TRANGTHAI_PHONG
CREATE PROC SP_THEM_TRANGTHAI_PHONG
    @MaTrangThai CHAR(10),
    @TenTrangThai NVARCHAR(50)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM TRANGTHAI_PHONG WHERE MaTrangThai = @MaTrangThai)
    BEGIN
        PRINT N'Mã trạng thái đã tồn tại.';
        RETURN;
    END;

    INSERT INTO TRANGTHAI_PHONG(MaTrangThai, TenTrangThai)
    VALUES (@MaTrangThai, @TenTrangThai);
END;
GO

CREATE PROC SP_SUA_TRANGTHAI_PHONG
    @MaTrangThai CHAR(10),
    @TenTrangThai NVARCHAR(50) = NULL
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM TRANGTHAI_PHONG WHERE MaTrangThai = @MaTrangThai)
    BEGIN
        PRINT N'Mã trạng thái không tồn tại.';
        RETURN;
    END;

    UPDATE TRANGTHAI_PHONG
    SET TenTrangThai = ISNULL(@TenTrangThai, TenTrangThai)
    WHERE MaTrangThai = @MaTrangThai;
END;
GO

CREATE PROC SP_XOA_TRANGTHAI_PHONG
    @MaTrangThai CHAR(10)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM TRANGTHAI_PHONG WHERE MaTrangThai = @MaTrangThai)
    BEGIN
        PRINT N'Mã trạng thái không tồn tại.';
        RETURN;
    END;
    IF EXISTS (SELECT 1 FROM PHONG WHERE MaTrangThai = @MaTrangThai)
    BEGIN
        PRINT N'Không thể xóa - có phòng đang sử dụng trạng thái này.';
        RETURN;
    END;

    DELETE FROM TRANGTHAI_PHONG WHERE MaTrangThai = @MaTrangThai;
END;
GO

--3 Bảng PHONG
CREATE OR ALTER PROC SP_THEM_PHONG
    @MaPhong CHAR(10),
    @TenPhong NVARCHAR(100),
    @MaToaNha CHAR(10),
    @MaLoai CHAR(10),
    @SucChua INT,
    @MaTrangThai CHAR(10),
    @GhiChu NVARCHAR(200)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM PHONG WHERE MaPhong = @MaPhong)
    BEGIN
        PRINT N'Mã phòng đã tồn tại.';
        RETURN;
    END;
    IF NOT EXISTS (SELECT 1 FROM TOA_NHA WHERE MaToaNha = @MaToaNha)
    BEGIN
        PRINT N'Mã tòa nhà không tồn tại.';
        RETURN;
    END;
    IF NOT EXISTS (SELECT 1 FROM LOAI_PHONG WHERE MaLoai = @MaLoai)
    BEGIN
        PRINT N'Mã loại phòng không tồn tại.';
        RETURN;
    END;
    IF NOT EXISTS (SELECT 1 FROM TRANGTHAI_PHONG WHERE MaTrangThai = @MaTrangThai)
    BEGIN
        PRINT N'Mã trạng thái phòng không tồn tại.';
        RETURN;
    END;

    INSERT INTO PHONG (MaPhong, TenPhong, MaToaNha, MaLoai, SucChua, MaTrangThai, GhiChu)
    VALUES (@MaPhong, @TenPhong, @MaToaNha, @MaLoai, @SucChua, @MaTrangThai, @GhiChu);
END;
GO

CREATE OR ALTER PROC SP_SUA_PHONG
    @MaPhong CHAR(10),
    @TenPhong NVARCHAR(100) = NULL,
    @MaToaNha CHAR(10) = NULL,
    @MaLoai CHAR(10) = NULL,
    @SucChua INT = NULL,
    @MaTrangThai CHAR(10) = NULL,
    @GhiChu NVARCHAR(200) = NULL
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM PHONG WHERE MaPhong = @MaPhong)
    BEGIN
        PRINT N'Mã phòng không tồn tại.';
        RETURN;
    END;
    IF @MaToaNha IS NOT NULL AND NOT EXISTS (SELECT 1 FROM TOA_NHA WHERE MaToaNha = @MaToaNha)
    BEGIN
        PRINT N'Mã tòa nhà không tồn tại.';
        RETURN;
    END;
    IF @MaLoai IS NOT NULL AND NOT EXISTS (SELECT 1 FROM LOAI_PHONG WHERE MaLoai = @MaLoai)
    BEGIN
        PRINT N'Mã loại phòng không tồn tại.';
        RETURN;
    END;
    IF @MaTrangThai IS NOT NULL AND NOT EXISTS (SELECT 1 FROM TRANGTHAI_PHONG WHERE MaTrangThai = @MaTrangThai)
    BEGIN
        PRINT N'Mã trạng thái phòng không tồn tại.';
        RETURN;
    END;

    UPDATE PHONG
    SET
        TenPhong = ISNULL(@TenPhong, TenPhong),
        MaToaNha = ISNULL(@MaToaNha, MaToaNha),
        MaLoai = ISNULL(@MaLoai, MaLoai),
        SucChua = ISNULL(@SucChua, SucChua),
        MaTrangThai = ISNULL(@MaTrangThai, MaTrangThai),
        GhiChu = ISNULL(@GhiChu, GhiChu)
    WHERE MaPhong = @MaPhong;
END;
GO

CREATE OR ALTER PROC SP_XOA_PHONG
    @MaPhong CHAR(10)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM PHONG WHERE MaPhong = @MaPhong)
    BEGIN
        PRINT N'Mã phòng không tồn tại.';
        RETURN;
    END;
    IF EXISTS (SELECT 1 FROM CHITIET_PHIEUDANGKY WHERE MaPhong = @MaPhong)
    BEGIN
        PRINT N'Không thể xóa vì phòng đang có lịch đăng ký (bảng CHITIET_PHIEUDANGKY).';
        RETURN;
    END;
    IF EXISTS (SELECT 1 FROM PHONG_THIETBI WHERE MaPhong = @MaPhong)
    BEGIN
        PRINT N'Không thể xóa vì phòng đang chứa thiết bị (bảng PHONG_THIETBI).';
        RETURN;
    END;
    IF EXISTS (SELECT 1 FROM LICH_BAO_TRI WHERE MaPhong = @MaPhong)
    BEGIN
        PRINT N'Không thể xóa vì phòng đang có lịch bảo trì (bảng LICH_BAO_TRI).';
        RETURN;
    END;
	
	DELETE FROM PHONG WHERE MaPhong = @MaPhong;
END;
GO

--4 Bảng THIETBI
CREATE OR ALTER PROC SP_THEM_THIETBI
    @MaTB CHAR(10),
    @TenTB NVARCHAR(100),
    @DonViTinh NVARCHAR(20),
    @TinhTrang NVARCHAR(50)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM THIETBI WHERE MaTB = @MaTB)
        PRINT N'Mã thiết bị đã tồn tại.';
	ELSE
    INSERT INTO THIETBI (MaTB, TenTB, DonViTinh, TinhTrang)
    VALUES (@MaTB, @TenTB, @DonViTinh, @TinhTrang);
END;
GO

CREATE OR ALTER PROC SP_SUA_THIETBI
    @MaTB CHAR(10),
    @TenTB NVARCHAR(100) = NULL,
    @DonViTinh NVARCHAR(20) = NULL,
    @TinhTrang NVARCHAR(50) = NULL
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM THIETBI WHERE MaTB = @MaTB)
        PRINT N'Mã thiết bị không tồn tại.';
	ELSE
		UPDATE THIETBI
		SET
			TenTB = ISNULL(@TenTB, TenTB),
			DonViTinh = ISNULL(@DonViTinh, DonViTinh),
			TinhTrang = ISNULL(@TinhTrang, TinhTrang)
		WHERE MaTB = @MaTB;
END;
GO

CREATE OR ALTER PROC SP_XOA_THIETBI
    @MaTB CHAR(10)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM THIETBI WHERE MaTB = @MaTB)
    BEGIN
        PRINT N'Mã thiết bị không tồn tại.';
        RETURN;
    END;
    IF EXISTS (SELECT 1 FROM PHONG_THIETBI WHERE MaTB = @MaTB)
    BEGIN
        PRINT N'Không thể xóa vì thiết bị đang được gán cho phòng (PHONG_THIETBI).';
        RETURN;
    END;
    IF EXISTS (SELECT 1 FROM LICH_BAO_TRI WHERE MaTB = @MaTB)
    BEGIN
        PRINT N'Không thể xóa vì thiết bị đang được sử dụng trong lịch bảo trì (LICH_BAO_TRI).';
        RETURN;
    END;

    DELETE FROM THIETBI WHERE MaTB = @MaTB;
END;
GO

--5 Bảng PHONG_THIETBI
CREATE OR ALTER PROC SP_THEM_PHONG_THIETBI
    @MaPhong CHAR(10),
    @MaTB CHAR(10),
    @SoLuong INT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM PHONG_THIETBI WHERE MaPhong = @MaPhong AND MaTB = @MaTB)
    BEGIN
        PRINT N'Cặp Mã phòng và Mã thiết bị đã tồn tại.';
        RETURN;
    END;
    IF NOT EXISTS (SELECT 1 FROM PHONG WHERE MaPhong = @MaPhong)
    BEGIN
        PRINT N'Mã phòng không tồn tại.';
        RETURN;
    END;
    IF NOT EXISTS (SELECT 1 FROM THIETBI WHERE MaTB = @MaTB)
    BEGIN
        PRINT N'Mã thiết bị không tồn tại.';
        RETURN;
    END;
    IF @SoLuong < 0
    BEGIN
        PRINT N'Số lượng không hợp lệ (phải >= 0).';
        RETURN;
    END;

    INSERT INTO PHONG_THIETBI (MaPhong, MaTB, SoLuong)
    VALUES (@MaPhong, @MaTB, @SoLuong);
END;
GO


CREATE OR ALTER PROC SP_SUA_PHONG_THIETBI
    @MaPhong CHAR(10),
    @MaTB CHAR(10),
    @SoLuong INT = NULL
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM PHONG_THIETBI WHERE MaPhong = @MaPhong AND MaTB = @MaTB)
    BEGIN
        PRINT N'Cặp Mã phòng và Mã thiết bị không tồn tại.';
        RETURN;
    END;
    IF @SoLuong IS NOT NULL AND @SoLuong < 0
    BEGIN
        PRINT N'Số lượng không hợp lệ (phải >= 0).';
        RETURN;
    END;

    UPDATE PHONG_THIETBI
    SET SoLuong = ISNULL(@SoLuong, SoLuong)
    WHERE MaPhong = @MaPhong AND MaTB = @MaTB;
END;
GO

CREATE OR ALTER PROC SP_XOA_PHONG_THIETBI
    @MaPhong CHAR(10),
    @MaTB CHAR(10)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM PHONG_THIETBI WHERE MaPhong = @MaPhong AND MaTB = @MaTB)
    BEGIN
        PRINT N'Cặp Mã phòng và Mã thiết bị không tồn tại.';
        RETURN;
    END;

    DELETE FROM PHONG_THIETBI WHERE MaPhong = @MaPhong AND MaTB = @MaTB;
END;
GO

--6 Bảng DONVI
CREATE OR ALTER PROC SP_THEM_DONVI
    @MaDonVi CHAR(10),
    @TenDonVi NVARCHAR(100),
    @DiaChi NVARCHAR(200),
    @SDT VARCHAR(15)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM DONVI WHERE MaDonVi = @MaDonVi)
        PRINT N'Mã đơn vị đã tồn tại.';
    ELSE
        INSERT INTO DONVI VALUES (@MaDonVi, @TenDonVi, @DiaChi, @SDT);
END
GO

CREATE OR ALTER PROC SP_SUA_DONVI
    @MaDonVi CHAR(10),
    @TenDonVi NVARCHAR(100) = NULL,
    @DiaChi NVARCHAR(200) = NULL,
    @SDT VARCHAR(15) = NULL
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM DONVI WHERE MaDonVi = @MaDonVi)
    BEGIN
        PRINT N'Mã đơn vị không tồn tại.';
        RETURN;
    END;

    UPDATE DONVI
    SET
        TenDonVi = ISNULL(@TenDonVi, TenDonVi),
        DiaChi   = ISNULL(@DiaChi, DiaChi),
        SDT      = ISNULL(@SDT, SDT)
    WHERE MaDonVi = @MaDonVi;
END;
GO

CREATE OR ALTER PROC SP_XOA_DONVI
    @MaDonVi CHAR(10)
AS
BEGIN
	IF NOT EXISTS (SELECT 1 FROM DONVI WHERE MaDonVi = @MaDonVi)
	BEGIN
		PRINT N'Mã đơn vị không tồn tại.'
		RETURN
	END
    IF EXISTS (SELECT 1 FROM NHANVIEN WHERE MaDonVi = @MaDonVi)
	BEGIN
        PRINT N'Không thể xóa – đơn vị đang có nhân viên.';
		RETURN
	END
    
	DELETE FROM DONVI WHERE MaDonVi = @MaDonVi;
END
GO

--7 Bảng NHANVIEN
CREATE OR ALTER PROC SP_THEM_NHANVIEN
    @MaNV CHAR(10),
    @HoTen NVARCHAR(100),
    @ChucVu NVARCHAR(50),
    @Email NVARCHAR(100),
    @SDT VARCHAR(15),
    @MaDonVi CHAR(10)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM NHANVIEN WHERE MaNV = @MaNV)
    BEGIN
        PRINT N'Mã nhân viên đã tồn tại.';
        RETURN;
    END;
    IF NOT EXISTS (SELECT 1 FROM DONVI WHERE MaDonVi = @MaDonVi)
    BEGIN
        PRINT N'Mã đơn vị không tồn tại.';
        RETURN;
    END;

    INSERT INTO NHANVIEN (MaNV, HoTen, ChucVu, Email, SDT, MaDonVi)
    VALUES (@MaNV, @HoTen, @ChucVu, @Email, @SDT, @MaDonVi);
END;
GO

CREATE OR ALTER PROC SP_SUA_NHANVIEN
    @MaNV CHAR(10),
    @HoTen NVARCHAR(100) = NULL,
    @ChucVu NVARCHAR(50) = NULL,
    @Email NVARCHAR(100) = NULL,
    @SDT VARCHAR(15) = NULL,
    @MaDonVi CHAR(10) = NULL
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM NHANVIEN WHERE MaNV = @MaNV)
    BEGIN
        PRINT N'Mã nhân viên không tồn tại.';
        RETURN;
    END;
    IF @MaDonVi IS NOT NULL AND NOT EXISTS (SELECT 1 FROM DONVI WHERE MaDonVi = @MaDonVi)
    BEGIN
        PRINT N'Mã đơn vị không tồn tại.';
        RETURN;
    END;

    UPDATE NHANVIEN
    SET
        HoTen   = ISNULL(@HoTen, HoTen),
        ChucVu  = ISNULL(@ChucVu, ChucVu),
        Email   = ISNULL(@Email, Email),
        SDT     = ISNULL(@SDT, SDT),
        MaDonVi = ISNULL(@MaDonVi, MaDonVi)
    WHERE MaNV = @MaNV;
END;
GO

CREATE OR ALTER PROC SP_XOA_NHANVIEN
    @MaNV CHAR(10)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM NHANVIEN WHERE MaNV = @MaNV)
    BEGIN
        PRINT N'Mã nhân viên không tồn tại.';
        RETURN;
    END;
    IF EXISTS (SELECT 1 FROM PHIEUDANGKY WHERE MaNV = @MaNV)
	BEGIN
        PRINT N'Không thể xóa – nhân viên đã có phiếu đăng ký.';
		RETURN
	END
	IF EXISTS (SELECT 1 FROM NGUOIDUNG WHERE MaNV = @MaNV)
    BEGIN
        PRINT N'Không thể xóa - nhân viên đang được liên kết với tài khoản người dùng.';
        RETURN;
    END;

    DELETE FROM NHANVIEN WHERE MaNV = @MaNV;
END;
GO

--8 Bảng NGUOIDUNG
CREATE OR ALTER PROC SP_THEM_NGUOIDUNG
    @TenDangNhap VARCHAR(50),
    @MatKhau VARCHAR(50),
    @Quyen NVARCHAR(50),
    @MaNV CHAR(10)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM NGUOIDUNG WHERE TenDangNhap = @TenDangNhap)
    BEGIN
        PRINT N'Tên đăng nhập đã tồn tại.';
        RETURN;
    END;
    IF NOT EXISTS (SELECT 1 FROM NHANVIEN WHERE MaNV = @MaNV)
    BEGIN
        PRINT N'Mã nhân viên không tồn tại.';
        RETURN;
    END;

    INSERT INTO NGUOIDUNG (TenDangNhap, MatKhau, Quyen, MaNV)
    VALUES (@TenDangNhap, @MatKhau, @Quyen, @MaNV);
END;
GO

CREATE OR ALTER PROC SP_SUA_NGUOIDUNG
    @TenDangNhap VARCHAR(50),
    @MatKhau VARCHAR(50) = NULL,
    @Quyen NVARCHAR(50) = NULL,
    @MaNV CHAR(10) = NULL
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM NGUOIDUNG WHERE TenDangNhap = @TenDangNhap)
    BEGIN
        PRINT N'Tên đăng nhập không tồn tại.';
        RETURN;
    END;
    IF @MaNV IS NOT NULL AND NOT EXISTS (SELECT 1 FROM NHANVIEN WHERE MaNV = @MaNV)
    BEGIN
        PRINT N'Mã nhân viên không tồn tại.';
        RETURN;
    END;

    UPDATE NGUOIDUNG
    SET 
        MatKhau = ISNULL(@MatKhau, MatKhau),
        Quyen   = ISNULL(@Quyen, Quyen),
        MaNV    = ISNULL(@MaNV, MaNV)
    WHERE TenDangNhap = @TenDangNhap;
END;
GO

CREATE OR ALTER PROC SP_XOA_NGUOIDUNG
    @TenDangNhap VARCHAR(50)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM NGUOIDUNG WHERE TenDangNhap = @TenDangNhap)
    BEGIN
        PRINT N'Tên đăng nhập không tồn tại.';
        RETURN;
    END;

    DELETE FROM NGUOIDUNG WHERE TenDangNhap = @TenDangNhap;
END;
GO

--9 Bảng PHIEUDANGKY
CREATE OR ALTER PROC SP_THEM_PHIEUDANGKY
    @MaPDK CHAR(10),
    @NgayDangKy DATE,
    @MaNV CHAR(10),
    @GhiChu NVARCHAR(200)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM PHIEUDANGKY WHERE MaPDK = @MaPDK)
    BEGIN
        PRINT N'Mã phiếu đăng ký đã tồn tại.';
        RETURN;
    END;
    IF NOT EXISTS (SELECT 1 FROM NHANVIEN WHERE MaNV = @MaNV)
    BEGIN
        PRINT N'Mã nhân viên không tồn tại.';
        RETURN;
    END;

    INSERT INTO PHIEUDANGKY (MaPDK, NgayDangKy, MaNV, GhiChu)
    VALUES (@MaPDK, @NgayDangKy, @MaNV, @GhiChu);
END;
GO

CREATE OR ALTER PROC SP_SUA_PHIEUDANGKY
    @MaPDK CHAR(10),
    @NgayDangKy DATE = NULL,
    @MaNV CHAR(10) = NULL,
    @GhiChu NVARCHAR(200) = NULL
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM PHIEUDANGKY WHERE MaPDK = @MaPDK)
    BEGIN
        PRINT N'Mã phiếu đăng ký không tồn tại.';
        RETURN;
    END;
    IF @MaNV IS NOT NULL AND NOT EXISTS (SELECT 1 FROM NHANVIEN WHERE MaNV = @MaNV)
    BEGIN
        PRINT N'Mã nhân viên không tồn tại.';
        RETURN;
    END;

    UPDATE PHIEUDANGKY
    SET 
        NgayDangKy = ISNULL(@NgayDangKy, NgayDangKy),
        MaNV = ISNULL(@MaNV, MaNV),
        GhiChu = ISNULL(@GhiChu, GhiChu)
    WHERE MaPDK = @MaPDK;
END;
GO

CREATE OR ALTER PROC SP_XOA_PHIEUDANGKY
    @MaPDK CHAR(10)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM PHIEUDANGKY WHERE MaPDK = @MaPDK)
    BEGIN
        PRINT N'Mã phiếu đăng ký không tồn tại.';
        RETURN;
    END;
    IF EXISTS (SELECT 1 FROM CHITIET_PHIEUDANGKY WHERE MaPDK = @MaPDK)
    BEGIN
        PRINT N'Không thể xóa vì phiếu này có chi tiết đăng ký phòng.';
        RETURN;
    END;

    DELETE FROM PHIEUDANGKY WHERE MaPDK = @MaPDK;
END;
GO

--10 Bảng CHITIET_PHIEUDANGKY
CREATE OR ALTER PROC SP_THEM_CHITIET_PHIEUDANGKY
    @MaPDK CHAR(10),
    @MaPhong CHAR(10),
    @NgaySuDung DATE,
    @GioBatDau TIME,
    @GioKetThuc TIME,
    @NguoiSuDung NVARCHAR(50),
    @MucDich NVARCHAR(200)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM CHITIET_PHIEUDANGKY WHERE MaPDK = @MaPDK AND MaPhong = @MaPhong AND NgaySuDung = @NgaySuDung)
    BEGIN
        PRINT N'Chi tiết phiếu đăng ký này đã tồn tại.';
        RETURN;
    END;
    IF NOT EXISTS (SELECT 1 FROM PHIEUDANGKY WHERE MaPDK = @MaPDK)
    BEGIN
        PRINT N'Mã phiếu đăng ký không tồn tại.';
        RETURN;
    END;
    IF NOT EXISTS (SELECT 1 FROM PHONG WHERE MaPhong = @MaPhong)
    BEGIN
        PRINT N'Mã phòng không tồn tại.';
        RETURN;
    END;
    IF @GioBatDau >= @GioKetThuc
    BEGIN
        PRINT N'Giờ bắt đầu phải nhỏ hơn giờ kết thúc.';
        RETURN;
    END;

    INSERT INTO CHITIET_PHIEUDANGKY (MaPDK, MaPhong, NgaySuDung, GioBatDau, GioKetThuc, NguoiSuDung, MucDich)
    VALUES (@MaPDK, @MaPhong, @NgaySuDung, @GioBatDau, @GioKetThuc, @NguoiSuDung, @MucDich);
END;
GO

CREATE OR ALTER PROC SP_SUA_CHITIET_PHIEUDANGKY
    @MaPDK CHAR(10),
    @MaPhong CHAR(10),
    @NgaySuDung DATE,
    @GioBatDau TIME = NULL,
    @GioKetThuc TIME = NULL,
    @NguoiSuDung NVARCHAR(50) = NULL,
    @MucDich NVARCHAR(200) = NULL
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM CHITIET_PHIEUDANGKY WHERE MaPDK = @MaPDK AND MaPhong = @MaPhong AND NgaySuDung = @NgaySuDung)
    BEGIN
        PRINT N'Chi tiết phiếu đăng ký không tồn tại.';
        RETURN;
    END;
	IF @MaPDK IS NOT NULL AND NOT EXISTS (SELECT 1 FROM PHIEUDANGKY WHERE MaPDK = @MaPDK)
    BEGIN
        PRINT N'Mã phiếu đăng ký không tồn tại.';
        RETURN;
    END;
    IF @MaPhong IS NOT NULL AND NOT EXISTS (SELECT 1 FROM PHONG WHERE MaPhong = @MaPhong)
    BEGIN
        PRINT N'Mã phòng không tồn tại.';
        RETURN;
    END;
    IF @GioBatDau IS NOT NULL AND @GioKetThuc IS NOT NULL AND @GioBatDau >= @GioKetThuc
    BEGIN
        PRINT N'Giờ bắt đầu phải nhỏ hơn giờ kết thúc.';
        RETURN;
    END;

    UPDATE CHITIET_PHIEUDANGKY
    SET 
        GioBatDau = ISNULL(@GioBatDau, GioBatDau),
        GioKetThuc = ISNULL(@GioKetThuc, GioKetThuc),
        NguoiSuDung = ISNULL(@NguoiSuDung, NguoiSuDung),
        MucDich = ISNULL(@MucDich, MucDich)
    WHERE MaPDK = @MaPDK AND MaPhong = @MaPhong AND NgaySuDung = @NgaySuDung;
END;
GO

CREATE OR ALTER PROC SP_XOA_CHITIET_PHIEUDANGKY
    @MaPDK CHAR(10),
    @MaPhong CHAR(10),
    @NgaySuDung DATE
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM CHITIET_PHIEUDANGKY WHERE MaPDK = @MaPDK AND MaPhong = @MaPhong AND NgaySuDung = @NgaySuDung)
    BEGIN
        PRINT N'Chi tiết phiếu đăng ký không tồn tại.';
        RETURN;
    END;

    DELETE FROM CHITIET_PHIEUDANGKY
    WHERE MaPDK = @MaPDK AND MaPhong = @MaPhong AND NgaySuDung = @NgaySuDung;
END;
GO

--11 Bảng TRANGTHAI_BAOTRI
CREATE OR ALTER PROC SP_THEM_TRANGTHAI_BAOTRI
    @MaTrangThaiBT CHAR(10),
    @TenTrangThai NVARCHAR(50)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM TRANGTHAI_BAOTRI WHERE MaTrangThaiBT = @MaTrangThaiBT)
    BEGIN
        PRINT N'Mã trạng thái bảo trì đã tồn tại!';
        RETURN;
    END;

    INSERT INTO TRANGTHAI_BAOTRI (MaTrangThaiBT, TenTrangThai)
    VALUES (@MaTrangThaiBT, @TenTrangThai);
END;
GO

CREATE OR ALTER PROC SP_SUA_TRANGTHAI_BAOTRI
    @MaTrangThaiBT CHAR(10),
    @TenTrangThai NVARCHAR(50)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM TRANGTHAI_BAOTRI WHERE MaTrangThaiBT = @MaTrangThaiBT)
    BEGIN
        PRINT N'Không tồn tại mã trạng thái bảo trì này!';
        RETURN;
    END;

    UPDATE TRANGTHAI_BAOTRI
    SET TenTrangThai = @TenTrangThai
    WHERE MaTrangThaiBT = @MaTrangThaiBT;
END;
GO

CREATE OR ALTER PROC SP_XOA_TRANGTHAI_BAOTRI
    @MaTrangThaiBT CHAR(10)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM TRANGTHAI_BAOTRI WHERE MaTrangThaiBT = @MaTrangThaiBT)
    BEGIN
        PRINT N'Không tồn tại mã trạng thái bảo trì này!';
        RETURN;
    END;

    IF EXISTS (SELECT 1 FROM LICH_BAO_TRI WHERE MaTrangThaiBT = @MaTrangThaiBT)
    BEGIN
        PRINT N'Trạng thái bảo trì này đang được sử dụng trong lịch bảo trì, không thể xóa!';
        RETURN;
    END;

    DELETE FROM TRANGTHAI_BAOTRI WHERE MaTrangThaiBT = @MaTrangThaiBT;
END;
GO

--12 Bảng LICH_BAO_TRI
CREATE OR ALTER PROC SP_THEM_LICH_BAO_TRI
    @MaBaoTri CHAR(10),
    @MaPhong CHAR(10),
    @MaTB CHAR(10) = NULL,
    @NgayBatDau DATE,
    @NgayKetThuc DATE,
    @NoiDung NVARCHAR(200),
    @MaTrangThaiBT CHAR(10)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM LICH_BAO_TRI WHERE MaBaoTri = @MaBaoTri)
    BEGIN
        PRINT N'Mã bảo trì đã tồn tại!';
        RETURN;
    END;
    IF NOT EXISTS (SELECT 1 FROM PHONG WHERE MaPhong = @MaPhong)
    BEGIN
        PRINT N'Mã phòng không tồn tại!';
        RETURN;
    END;
    IF @MaTB IS NOT NULL AND NOT EXISTS (SELECT 1 FROM THIETBI WHERE MaTB = @MaTB)
    BEGIN
        PRINT N'Mã thiết bị không tồn tại!';
        RETURN;
    END;
    IF NOT EXISTS (SELECT 1 FROM TRANGTHAI_BAOTRI WHERE MaTrangThaiBT = @MaTrangThaiBT)
    BEGIN
        PRINT N'Mã trạng thái bảo trì không tồn tại!';
        RETURN;
    END;

    -- Kiểm tra logic thời gian
    IF @NgayKetThuc < @NgayBatDau
    BEGIN
        PRINT N'Ngày kết thúc không được nhỏ hơn ngày bắt đầu!';
        RETURN;
    END;

    -- Kiểm tra trùng lịch bảo trì cho cùng phòng
    IF EXISTS (
        SELECT 1 FROM LICH_BAO_TRI
		WHERE MaPhong = @MaPhong
          AND (
                (@NgayBatDau BETWEEN NgayBatDau AND NgayKetThuc)
                OR (@NgayKetThuc BETWEEN NgayBatDau AND NgayKetThuc)
                OR (NgayBatDau BETWEEN @NgayBatDau AND @NgayKetThuc)
                OR (NgayKetThuc BETWEEN @NgayBatDau AND @NgayKetThuc)
              )
    )
    BEGIN
        PRINT N'Khoảng thời gian bảo trì bị trùng với lịch bảo trì khác của phòng này!';
        RETURN;
    END;

    INSERT INTO LICH_BAO_TRI (MaBaoTri, MaPhong, MaTB, NgayBatDau, NgayKetThuc, NoiDung, MaTrangThaiBT)
    VALUES (@MaBaoTri, @MaPhong, @MaTB, @NgayBatDau, @NgayKetThuc, @NoiDung, @MaTrangThaiBT);
END;
GO

CREATE OR ALTER PROC SP_SUA_LICH_BAO_TRI
    @MaBaoTri CHAR(10),
    @MaPhong CHAR(10),
    @MaTB CHAR(10) = NULL,
    @NgayBatDau DATE,
    @NgayKetThuc DATE,
    @NoiDung NVARCHAR(200),
    @MaTrangThaiBT CHAR(10)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM LICH_BAO_TRI WHERE MaBaoTri = @MaBaoTri)
    BEGIN
        PRINT N'Không tồn tại mã bảo trì này!';
        RETURN;
    END;
    IF NOT EXISTS (SELECT 1 FROM PHONG WHERE MaPhong = @MaPhong)
    BEGIN
        PRINT N'Mã phòng không tồn tại!';
        RETURN;
    END;
    IF @MaTB IS NOT NULL AND NOT EXISTS (SELECT 1 FROM THIETBI WHERE MaTB = @MaTB)
    BEGIN
        PRINT N'Mã thiết bị không tồn tại!';
        RETURN;
    END;
    IF NOT EXISTS (SELECT 1 FROM TRANGTHAI_BAOTRI WHERE MaTrangThaiBT = @MaTrangThaiBT)
    BEGIN
        PRINT N'Mã trạng thái bảo trì không tồn tại!';
        RETURN;
    END;
    -- Kiểm tra logic thời gian
    IF @NgayKetThuc < @NgayBatDau
    BEGIN
        PRINT N'Ngày kết thúc không được nhỏ hơn ngày bắt đầu!';
        RETURN;
    END;

    -- Kiểm tra trùng lịch khác (bỏ qua chính lịch đang sửa)
    IF EXISTS (
        SELECT 1 FROM LICH_BAO_TRI
        WHERE MaPhong = @MaPhong
          AND MaBaoTri <> @MaBaoTri
          AND (
                (@NgayBatDau BETWEEN NgayBatDau AND NgayKetThuc)
                OR (@NgayKetThuc BETWEEN NgayBatDau AND NgayKetThuc)
                OR (NgayBatDau BETWEEN @NgayBatDau AND @NgayKetThuc)
                OR (NgayKetThuc BETWEEN @NgayBatDau AND @NgayKetThuc)
              )
    )
    BEGIN
        PRINT N'Khoảng thời gian bảo trì bị trùng với lịch bảo trì khác của phòng này!';
        RETURN;
    END;

    UPDATE LICH_BAO_TRI
    SET MaPhong = @MaPhong,
        MaTB = @MaTB,
        NgayBatDau = @NgayBatDau,
        NgayKetThuc = @NgayKetThuc,
        NoiDung = @NoiDung,
        MaTrangThaiBT = @MaTrangThaiBT
    WHERE MaBaoTri = @MaBaoTri;
END;
GO

CREATE OR ALTER PROC SP_XOA_LICH_BAO_TRI
    @MaBaoTri CHAR(10)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM LICH_BAO_TRI WHERE MaBaoTri = @MaBaoTri)
    BEGIN
        PRINT N'Không tồn tại mã bảo trì này!';
        RETURN;
    END;

    DELETE FROM LICH_BAO_TRI WHERE MaBaoTri = @MaBaoTri;
END;
GO