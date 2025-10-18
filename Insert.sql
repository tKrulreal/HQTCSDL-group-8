-- 1. TRANGTHAI_PHONG
INSERT INTO TRANGTHAI_PHONG (MaTrangThai, TenTrangThai) VALUES
('TT001', N'Sẵn sàng sử dụng'),
('TT002', N'Đang bảo trì'),
('TT003', N'Đang có người sử dụng'),
('TT004', N'Không khả dụng');

-- 2. TOA_NHA
INSERT INTO TOA_NHA (MaToaNha, TenToaNha, DiaChi) VALUES
('TN01', N'Tòa Nhà A', N'Số 1, Phố Vọng, Hà Nội'),
('TN02', N'Tòa Nhà B', N'Số 2, Phố Vọng, Hà Nội'),
('TN03', N'Giảng Đường E', N'Số 3, Phố Vọng, Hà Nội');

-- 3. LOAI_PHONG
INSERT INTO LOAI_PHONG (MaLoai, TenLoai, MoTa) VALUES
('LP01', N'Phòng Họp Nhỏ', N'Phòng họp cho 5-10 người'),
('LP02', N'Phòng Họp Lớn', N'Phòng họp cho 20-50 người'),
('LP03', N'Giảng Đường', N'Phòng học lớn, sức chứa trên 100 người'),
('LP04', N'Phòng Đào Tạo', N'Phòng cho các buổi tập huấn, có máy tính');

-- 4. DONVI
INSERT INTO DONVI (MaDonVi, TenDonVi, DiaChi, SDT) VALUES
('DV01', N'Phòng Công Nghệ Thông Tin', N'Tòa Nhà A, Tầng 5', '0912345678'),
('DV02', N'Phòng Hành Chính', N'Tòa Nhà B, Tầng 1', '0987654321'),
('DV03', N'Ban Giám Đốc', N'Tòa Nhà A, Tầng 10', '0901112223');

-- 5. NHANVIEN
INSERT INTO NHANVIEN (MaNV, HoTen, ChucVu, Email, SDT, MaDonVi) VALUES
('NV001', N'Nguyễn Văn A', N'Trưởng phòng', 'anv@congty.com', '0900111222', 'DV01'),
('NV002', N'Trần Thị B', N'Nhân viên', 'btt@congty.com', '0900333444', 'DV02'),
('NV003', N'Lê Văn C', N'Thư ký', 'clv@congty.com', '0900555666', 'DV03');

-- 6. THIETBI
INSERT INTO THIETBI (MaTB, TenTB, DonViTinh, TinhTrang) VALUES
('TB01', N'Máy Chiếu (Projector)', N'Cái', N'Tốt'),
('TB02', N'Màn Chiếu', N'Cái', N'Tốt'),
('TB03', N'Bảng Tương Tác', N'Cái', N'Tốt'),
('TB04', N'Hệ Thống Video Conference', N'Bộ', N'Tốt'),
('TB05', N'Micrô Không Dây', N'Bộ', N'Cần sửa chữa');

-- 7. TRANGTHAI_BAOTRI
INSERT INTO TRANGTHAI_BAOTRI (MaTrangThaiBT, TenTrangThai) VALUES
('BTT01', N'Đã lên lịch'),
('BTT02', N'Đang thực hiện'),
('BTT03', N'Đã hoàn thành'),
('BTT04', N'Đã hủy');

-- 8. NGUOIDUNG
INSERT INTO NGUOIDUNG (TenDangNhap, MatKhau, Quyen, MaNV) VALUES
('adminA', '123456', N'Quản trị hệ thống', 'NV001'),
('userB', '123456', N'Người dùng', 'NV002');

-- 9. PHONG
INSERT INTO PHONG (MaPhong, TenPhong, MaToaNha, MaLoai, SucChua, MaTrangThai, GhiChu) VALUES
('P001', N'Phòng Họp 1.1', 'TN01', 'LP01', 8, 'TT001', N'Gần thang máy'),
('P002', N'Phòng Họp 1.2', 'TN01', 'LP01', 10, 'TT001', N'Yên tĩnh, có cửa sổ'),
('P003', N'Phòng Họp Lớn A3', 'TN01', 'LP02', 30, 'TT001', N'Có Video Conference'),
('P004', N'Phòng Đào Tạo A4', 'TN01', 'LP04', 25, 'TT001', N'Phòng máy tính'),
('P005', N'Phòng Họp 2.1', 'TN02', 'LP01', 6, 'TT001', N'Phòng đơn giản'),
('P006', N'Phòng Họp Lớn B2', 'TN02', 'LP02', 40, 'TT003', NULL),
('P007', N'Giảng Đường E101', 'TN03', 'LP03', 150, 'TT001', N'Giảng đường chính'),
('P008', N'Giảng Đường E202', 'TN03', 'LP03', 120, 'TT002', N'Đang bảo trì hệ thống âm thanh'),
('P009', N'Phòng Đào Tạo A5', 'TN01', 'LP04', 20, 'TT001', N'Có bảng tương tác'),
('P010', N'Phòng Hội Thảo B3', 'TN02', 'LP02', 50, 'TT001', N'Sức chứa lớn nhất tòa B');

-- 10. PHONG_THIETBI
INSERT INTO PHONG_THIETBI (MaPhong, MaTB, SoLuong) VALUES
('P001', 'TB01', 1),
('P001', 'TB02', 1),
('P003', 'TB01', 1),
('P003', 'TB04', 1),
('P007', 'TB01', 2),
('P007', 'TB05', 5);

-- 11. PHIEUDANGKY
INSERT INTO PHIEUDANGKY (MaPDK, NgayDangKy, MaNV, MaDonVi, GhiChu) VALUES
('PDK001', GETDATE(), 'NV002', 'DV02', N'Đăng ký họp nội bộ'),
('PDK002', '2025-10-15', 'NV001', 'DV01', N'Đăng ký đào tạo phần mềm mới'),
('PDK003', '2025-10-18', 'NV002', 'DV02', N'Họp Ban Giám Đốc');

-- 12. CHITIET_PHIEUDANGKY
INSERT INTO CHITIET_PHIEUDANGKY (MaPDK, MaPhong, NgaySuDung, GioBatDau, GioKetThuc, NguoiSuDung, MucDich) VALUES
('PDK001', 'P001', '2025-10-20', '09:00:00', '11:00:00', N'Trần Thị B', N'Họp team Hành Chính'),
('PDK002', 'P004', '2025-11-05', '14:00:00', '16:30:00', N'Nguyễn Văn A', N'Tập huấn CNTT'),
('PDK003', 'P006', '2025-10-20', '13:30:00', '16:00:00', N'Lê Văn C', N'Họp chiến lược');

-- 13. LICH_BAO_TRI
INSERT INTO LICH_BAO_TRI (MaBaoTri, MaPhong, MaTB, NgayBatDau, NgayKetThuc, NoiDung, MaTrangThaiBT) VALUES
('BT001', 'P008', 'TB05', '2025-10-16', '2025-10-25', N'Bảo trì hệ thống Micrô', 'BTT02');