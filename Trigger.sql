USE QL_PHONGHOP;
GO

CREATE OR ALTER TRIGGER TRG_KiemTraTrungLichPhong
    ON CHITIET_PHIEUDANGKY
    INSTEAD OF INSERT
    AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Conflict INT;

    -- Kiểm tra trùng giờ với các bản ghi đã có
    SELECT @Conflict = COUNT(*)
    FROM INSERTED I
    WHERE EXISTS (
        SELECT 1
        FROM CHITIET_PHIEUDANGKY C
        WHERE C.MaPhong = I.MaPhong
          AND C.NgaySuDung = I.NgaySuDung
          AND (I.GioBatDau < C.GioKetThuc AND I.GioKetThuc > C.GioBatDau)
    );

    IF @Conflict > 0
        BEGIN
            RAISERROR (N'❌ Phòng này đã được đăng ký trùng giờ. Vui lòng chọn khung giờ khác.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
    ELSE
        BEGIN
            -- Nếu không trùng thì cho phép thêm dữ liệu
            INSERT INTO CHITIET_PHIEUDANGKY (MaPDK, MaPhong, NgaySuDung, GioBatDau, GioKetThuc, NguoiSuDung, MucDich)
            SELECT MaPDK, MaPhong, NgaySuDung, GioBatDau, GioKetThuc, NguoiSuDung, MucDich
            FROM INSERTED;
        END
END;
GO


CREATE OR ALTER TRIGGER TRG_CapNhatTrangThaiPhong_SuDung
    ON CHITIET_PHIEUDANGKY
    AFTER INSERT
    AS
BEGIN
    UPDATE PHONG
    SET MaTrangThai = 'TT003'  -- “Đang có người sử dụng”
    FROM PHONG P, INSERTED I
    WHERE P.MaPhong = I.MaPhong;
END;
GO

CREATE OR ALTER TRIGGER TRG_TraPhongSauSuDung
    ON CHITIET_PHIEUDANGKY
    AFTER DELETE
    AS
BEGIN
    UPDATE PHONG
    SET MaTrangThai = 'TT001'  -- “Sẵn sàng sử dụng”
    FROM PHONG P, DELETED D
    WHERE P.MaPhong = D.MaPhong;
END;
GO

CREATE OR ALTER TRIGGER TRG_XoaPhongCascade
    ON PHONG
    INSTEAD OF DELETE
    AS
BEGIN
    DELETE FROM PHONG_THIETBI
    WHERE MaPhong IN (SELECT MaPhong FROM DELETED);

    DELETE FROM CHITIET_PHIEUDANGKY
    WHERE MaPhong IN (SELECT MaPhong FROM DELETED);

    DELETE FROM LICH_BAO_TRI
    WHERE MaPhong IN (SELECT MaPhong FROM DELETED);

    UPDATE PHONG
    SET MaTrangThai = 'TT004' -- “không KHẢ dụng”
    WHERE MaPhong IN (SELECT MaPhong FROM DELETED);
END;
GO

CREATE OR ALTER TRIGGER TRG_CapNhatTrangThaiPhong_BaoTri
    ON LICH_BAO_TRI
    AFTER INSERT, UPDATE, DELETE
    AS
BEGIN
    SET NOCOUNT ON;

    -- Trường hợp thêm hoặc cập nhật lịch bảo trì (đang có bảo trì)
    UPDATE PHONG
    SET MaTrangThai = 'TT002'  -- “Đang bảo trì”
    FROM PHONG P, INSERTED I
    WHERE P.MaPhong = I.MaPhong
      AND EXISTS (SELECT 1 FROM INSERTED);

    -- Trường hợp xóa lịch bảo trì hoặc lịch đã kết thúc => trả phòng về trạng thái sẵn sàng
    UPDATE PHONG
    SET MaTrangThai = 'TT001'  -- “Sẵn sàng sử dụng”
    FROM PHONG P
    WHERE P.MaPhong IN (
        SELECT D.MaPhong FROM DELETED D
        WHERE NOT EXISTS (
            SELECT 1 FROM LICH_BAO_TRI B
            WHERE B.MaPhong = D.MaPhong
              AND B.NgayKetThuc >= GETDATE()
        )
    );
END;
GO

