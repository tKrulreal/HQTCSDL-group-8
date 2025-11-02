USE QL_PHONGHOP;
GO

CREATE OR ALTER TRIGGER TRG_KiemTraTrungLichPhong
    ON CHITIET_PHIEUDANGKY
    AFTER INSERT, UPDATE
    AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Conflict INT;

    -- Kiểm tra trùng giờ với các bản ghi khác
    SELECT @Conflict = COUNT(*)
    FROM CHITIET_PHIEUDANGKY C, INSERTED I
    WHERE C.MaPhong = I.MaPhong
      AND C.NgaySuDung = I.NgaySuDung
      AND (C.GioBatDau < I.GioKetThuc AND C.GioKetThuc > I.GioBatDau)
      -- Loại trừ chính bản ghi đang được UPDATE
      AND NOT (C.MaPDK = I.MaPDK AND C.MaPhong = I.MaPhong AND C.NgaySuDung = I.NgaySuDung);

    IF (@Conflict > 0)
        BEGIN
            RAISERROR (N'❌ Phòng này đã được đăng ký trùng giờ. Vui lòng chọn khung giờ khác.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
END;
GO

CREATE OR ALTER TRIGGER TRG_CapNhatTrangThaiPhong_SuDung
    ON CHITIET_PHIEUDANGKY
    AFTER INSERT
    AS
BEGIN
    SET NOCOUNT ON;

    UPDATE P
    SET MaTrangThai = 'TT003'  -- \`Đang có người sử dụng\`
    FROM PHONG P, INSERTED I
    WHERE P.MaPhong = I.MaPhong
      AND GETDATE() BETWEEN
        CONVERT(datetime, CONVERT(varchar(10), I.NgaySuDung, 23) + ' ' + CONVERT(varchar(8), I.GioBatDau, 108))
        AND
        CONVERT(datetime, CONVERT(varchar(10), I.NgaySuDung, 23) + ' ' + CONVERT(varchar(8), I.GioKetThuc, 108));
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
    UPDATE PHONG
    SET MaTrangThai = 'TT002'  -- "Đang bảo trì"
    WHERE MaPhong IN (
        SELECT MaPhong
        FROM INSERTED
        WHERE NgayBatDau <= GETDATE()
          AND NgayKetThuc >= GETDATE()
    );

    UPDATE PHONG
    SET MaTrangThai = 'TT001'  -- "Sẵn sàng sử dụng"
    WHERE MaPhong IN (
        SELECT D.MaPhong FROM DELETED D
        WHERE NOT EXISTS (
            SELECT 1 FROM LICH_BAO_TRI B
            WHERE B.MaPhong = D.MaPhong
              AND B.NgayBatDau <= GETDATE()
              AND B.NgayKetThuc >= GETDATE()
        )
    );
END;
GO

