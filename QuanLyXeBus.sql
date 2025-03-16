-- Tạo cơ sở dữ liệu
CREATE DATABASE QuanLyXeBus;
GO
USE QuanLyXeBus;

-- Bảng Nhà xe
CREATE TABLE NhaXe (
    MaNhaXe INT PRIMARY KEY IDENTITY(1,1),
    TenNhaXe NVARCHAR(100) NOT NULL,
    DiaChi NVARCHAR(200),
    SoDienThoai NVARCHAR(15)
);
GO

-- Bảng Tuyến xe
CREATE TABLE TuyenXe (
    MaTuyen INT PRIMARY KEY IDENTITY(1,1),
    TenTuyen NVARCHAR(100) NOT NULL,
    DiemDau NVARCHAR(100),
    DiemCuoi NVARCHAR(100),
    KhoangCach FLOAT
);
GO

-- Bảng Xe
CREATE TABLE Xe (
    MaXe INT PRIMARY KEY IDENTITY(1,1),
    BienSo NVARCHAR(20) NOT NULL,
    MaNhaXe INT FOREIGN KEY REFERENCES NhaXe(MaNhaXe),
    MaTuyen INT FOREIGN KEY REFERENCES TuyenXe(MaTuyen),
    SoGhe INT
);
GO

-- Bảng Lái xe
CREATE TABLE LaiXe (
    MaLaiXe INT PRIMARY KEY IDENTITY(1,1),
    TenLaiXe NVARCHAR(100) NOT NULL,
    NgaySinh DATE,
    SoDienThoai NVARCHAR(15)
);
GO

-- Bảng Chuyến xe
CREATE TABLE ChuyenXe (
    MaChuyen INT PRIMARY KEY IDENTITY(1,1),
    MaXe INT FOREIGN KEY REFERENCES Xe(MaXe),
    MaLaiXe INT FOREIGN KEY REFERENCES LaiXe(MaLaiXe),
    NgayKhoiHanh DATETIME,
    NgayDen DATETIME
);
GO

-- Bảng Vé
CREATE TABLE Ve (
    MaVe INT PRIMARY KEY IDENTITY(1,1),
    MaChuyen INT FOREIGN KEY REFERENCES ChuyenXe(MaChuyen),
    GiaVe DECIMAL(18,2),
    SoGhe INT
);
GO

-- Nhập dữ liệu mẫu cho bảng Nhà xe
INSERT INTO NhaXe (TenNhaXe, DiaChi, SoDienThoai)
VALUES 
(N'Xe Khách Phương Trang', N'123 Đường Lê Lợi, TP.HCM', '0909123456'),
(N'Xe Limousine An Phú', N'456 Đường Nguyễn Huệ, Hà Nội', '0918123456');
GO

-- Nhập dữ liệu mẫu cho bảng Tuyến xe
INSERT INTO TuyenXe (TenTuyen, DiemDau, DiemCuoi, KhoangCach)
VALUES 
(N'TP.HCM - Đà Lạt', N'TP.HCM', N'Đà Lạt', 300),
(N'Hà Nội - Hải Phòng', N'Hà Nội', N'Hải Phòng', 120);
GO

-- Nhập dữ liệu mẫu cho bảng Xe
INSERT INTO Xe (BienSo, MaNhaXe, MaTuyen, SoGhe)
VALUES 
(N'51A-12345', 1, 1, 45),
(N'29B-67890', 2, 2, 30);
GO

-- Nhập dữ liệu mẫu cho bảng Lái xe
INSERT INTO LaiXe (TenLaiXe, NgaySinh, SoDienThoai)
VALUES 
(N'Cao Thái Sơn', '2005-07-31', '0909123456'),
(N'Tạ Công Thắng', '2005-01-17', '0918123456');
GO

-- Nhập dữ liệu mẫu cho bảng Chuyến xe
INSERT INTO ChuyenXe (MaXe, MaLaiXe, NgayKhoiHanh, NgayDen)
VALUES 
(1, 1, '2025-10-01 08:00:00', '2025-10-01 14:00:00'),
(2, 2, '2025-10-02 09:00:00', '2025-10-02 12:00:00');
GO

-- Nhập dữ liệu mẫu cho bảng Vé
INSERT INTO Ve (MaChuyen, GiaVe, SoGhe)
VALUES
(1, 200000, 10),
(2, 150000, 5);
GO

-- SELECT
SELECT * FROM NhaXe;
SELECT * FROM TuyenXe WHERE KhoangCach > 100;
GO

-- INSERT
INSERT INTO NhaXe (TenNhaXe, DiaChi, SoDienThoai)
VALUES (N'Xe Khách Mai Linh', N'789 Đường Trần Hưng Đạo, Đà Nẵng', '0908123456');
SELECT * FROM NhaXe WHERE TenNhaXe = N'Xe Khách Mai Linh';
GO

-- UPDATE
UPDATE Xe SET SoGhe = 40 WHERE MaXe = 1;
SELECT * FROM Xe WHERE MaXe = 1;
GO

-- DELETE
DELETE FROM Ve WHERE MaVe = 1;
SELECT * FROM Ve WHERE MaVe = 1; -- Kết quả sẽ không có dòng nào
GO

-- INNER JOIN
SELECT Xe.BienSo, NhaXe.TenNhaXe, TuyenXe.TenTuyen
FROM Xe
INNER JOIN NhaXe ON Xe.MaNhaXe = NhaXe.MaNhaXe
INNER JOIN TuyenXe ON Xe.MaTuyen = TuyenXe.MaTuyen;
GO

-- GROUP BY và HAVING
SELECT MaNhaXe, COUNT(*) AS SoLuongXe
FROM Xe
GROUP BY MaNhaXe
HAVING COUNT(*) > 1;
GO

-- SUBQUERY
SELECT TenLaiXe
FROM LaiXe
WHERE MaLaiXe IN (SELECT MaLaiXe FROM ChuyenXe WHERE MaXe = 1);
GO

-- View 1: Danh sách xe và nhà xe
CREATE VIEW View_Xe_NhaXe_Moi AS 
SELECT Xe.BienSo, NhaXe.TenNhaXe
FROM Xe
INNER JOIN NhaXe ON Xe.MaNhaXe = NhaXe.MaNhaXe;
GO

SELECT * FROM View_Xe_NhaXe_Moi;
GO

-- View 2: Danh sách chuyến xe và lái xe
CREATE VIEW View_ChuyenXe_LaiXe_Moi AS -- Đổi tên VIEW
SELECT ChuyenXe.MaChuyen, LaiXe.TenLaiXe
FROM ChuyenXe
INNER JOIN LaiXe ON ChuyenXe.MaLaiXe = LaiXe.MaLaiXe;
GO

SELECT * FROM View_ChuyenXe_LaiXe_Moi;
GO

-- View 3: Tổng số ghế của mỗi nhà xe
CREATE VIEW View_TongSoGhe_NhaXe AS
SELECT NhaXe.TenNhaXe, SUM(Xe.SoGhe) AS TongSoGhe
FROM Xe
INNER JOIN NhaXe ON Xe.MaNhaXe = NhaXe.MaNhaXe
GROUP BY NhaXe.TenNhaXe;
GO

SELECT * FROM View_TongSoGhe_NhaXe;
GO

-- View 4: Danh sách vé và giá vé
CREATE VIEW View_Ve_GiaVe AS
SELECT Ve.MaVe, Ve.GiaVe
FROM Ve;
GO

SELECT * FROM View_Ve_GiaVe;
GO

-- View 5: Danh sách tuyến xe và khoảng cách
CREATE VIEW View_TuyenXe_KhoangCach AS
SELECT TenTuyen, KhoangCach
FROM TuyenXe;
GO

SELECT * FROM View_TuyenXe_KhoangCach;
GO

-- View 6: Danh sách lái xe và số điện thoại
IF OBJECT_ID('View_LaiXe_SoDienThoai', 'V') IS NOT NULL
    DROP VIEW View_LaiXe_SoDienThoai;
GO
CREATE VIEW View_LaiXe_SoDienThoai AS
SELECT TenLaiXe, SoDienThoai
FROM LaiXe;
GO

SELECT * FROM View_LaiXe_SoDienThoai;
GO

-- View 7: Danh sách chuyến xe theo ngày
IF OBJECT_ID('View_ChuyenXe_TheoNgay', 'U') IS NOT NULL
BEGIN
    DROP TABLE View_ChuyenXe_TheoNgay;
END;
GO

CREATE TABLE View_ChuyenXe_TheoNgay (
    MaChuyen INT PRIMARY KEY IDENTITY(1,1),
    MaXe INT FOREIGN KEY REFERENCES Xe(MaXe),
    MaLaiXe INT FOREIGN KEY REFERENCES LaiXe(MaLaiXe),
    NgayKhoiHanh DATETIME,
    NgayDen DATETIME
);
GO

SELECT * FROM View_ChuyenXe_TheoNgay;
GO

-- 10 kiểu function 
--1 funcion
CREATE FUNCTION dbo.TongSoGheNhaXe (@MaNhaXe INT)
RETURNS INT
AS
BEGIN
    DECLARE @TongSoGhe INT;
    SELECT @TongSoGhe = SUM(SoGhe)
    FROM Xe
    WHERE MaNhaXe = @MaNhaXe;
    RETURN @TongSoGhe;
END;
GO
--2 funcion
CREATE FUNCTION dbo.TongDoanhThuChuyenXe (@MaChuyen INT)
RETURNS DECIMAL(18,2)
AS
BEGIN
    DECLARE @TongDoanhThu DECIMAL(18,2);
    SELECT @TongDoanhThu = SUM(GiaVe)
    FROM Ve
    WHERE MaChuyen = @MaChuyen;
    RETURN @TongDoanhThu;
END;
GO
--3 funcion
CREATE FUNCTION dbo.DanhSachChuyenXeTheoNgay (@Ngay DATE)
RETURNS TABLE
AS
RETURN (
    SELECT * 
    FROM ChuyenXe
    WHERE CAST(NgayKhoiHanh AS DATE) = @Ngay
);
GO
--4 funcion
CREATE FUNCTION dbo.DanhSachLaiXeNhaXe (@MaNhaXe INT)
RETURNS TABLE
AS
RETURN (
    SELECT DISTINCT LX.TenLaiXe, LX.SoDienThoai
    FROM LaiXe LX
    INNER JOIN ChuyenXe CX ON LX.MaLaiXe = CX.MaLaiXe
    INNER JOIN Xe X ON CX.MaXe = X.MaXe
    WHERE X.MaNhaXe = @MaNhaXe
);
GO
--5 funcion
CREATE FUNCTION dbo.KhoangCachTrungBinhTuyenXe ()
RETURNS FLOAT
AS
BEGIN
    DECLARE @KhoangCachTrungBinh FLOAT;
    SELECT @KhoangCachTrungBinh = AVG(KhoangCach)
    FROM TuyenXe;
    RETURN @KhoangCachTrungBinh;
END;
GO
--6 funcion
CREATE FUNCTION dbo.DanhSachVeChuyenXe (@MaChuyen INT)
RETURNS TABLE
AS
RETURN (
    SELECT * 
    FROM Ve
    WHERE MaChuyen = @MaChuyen
);
GO
--7 funcion
CREATE FUNCTION dbo.KiemTraLaiXeTrongChuyenXe (@MaLaiXe INT, @MaChuyen INT)
RETURNS BIT
AS
BEGIN
    DECLARE @KetQua BIT = 0;
    IF EXISTS (SELECT 1 FROM ChuyenXe WHERE MaLaiXe = @MaLaiXe AND MaChuyen = @MaChuyen)
        SET @KetQua = 1;
    RETURN @KetQua;
END;
GO
--8 funcion
CREATE FUNCTION dbo.SoLuongChuyenXeCuaLaiXe (@MaLaiXe INT)
RETURNS INT
AS
BEGIN
    DECLARE @SoLuongChuyen INT;
    SELECT @SoLuongChuyen = COUNT(*)
    FROM ChuyenXe
    WHERE MaLaiXe = @MaLaiXe;
    RETURN @SoLuongChuyen;
END;
GO
--9 funcion
CREATE FUNCTION dbo.DanhSachXeNhaXe (@MaNhaXe INT)
RETURNS TABLE
AS
RETURN (
    SELECT * 
    FROM Xe
    WHERE MaNhaXe = @MaNhaXe
);
GO
--10 funcion
CREATE FUNCTION dbo.TongSoVeDaBan (@MaChuyen INT)
RETURNS INT
AS
BEGIN
    DECLARE @TongSoVe INT;
    SELECT @TongSoVe = COUNT(*)
    FROM Ve
    WHERE MaChuyen = @MaChuyen;
    RETURN @TongSoVe;
END;
GO

--7 kiểu trigger
--1 trigger
CREATE TRIGGER trg_CheckSoGhe
ON Xe
FOR INSERT, UPDATE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE SoGhe <= 0 OR SoGhe > 100)
    BEGIN
        RAISERROR('Số ghế phải lớn hơn 0 và nhỏ hơn hoặc bằng 100.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO
--2 trigger
CREATE TRIGGER trg_CheckNgayChuyenXe
ON ChuyenXe
FOR INSERT, UPDATE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE NgayDen <= NgayKhoiHanh)
    BEGIN
        RAISERROR('Ngày đến phải lớn hơn ngày khởi hành.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO
--3 trigger
CREATE TRIGGER trg_CheckGiaVe
ON Ve
FOR INSERT, UPDATE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE GiaVe <= 0)
    BEGIN
        RAISERROR('Giá vé phải lớn hơn 0.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO
--4 trigger
CREATE TRIGGER trg_CheckSoDienThoaiNhaXe
ON NhaXe
FOR INSERT, UPDATE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE LEN(SoDienThoai) < 10 OR LEN(SoDienThoai) > 15)
    BEGIN
        RAISERROR('Số điện thoại phải có độ dài từ 10 đến 15 ký tự.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO
--5 trigger
CREATE TRIGGER trg_CheckKhoangCachTuyenXe
ON TuyenXe
FOR INSERT, UPDATE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE KhoangCach <= 0)
    BEGIN
        RAISERROR('Khoảng cách phải lớn hơn 0.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO
--6 trigger
CREATE TRIGGER trg_CheckTuoiLaiXe
ON LaiXe
FOR INSERT, UPDATE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE DATEDIFF(YEAR, NgaySinh, GETDATE()) < 18)
    BEGIN
        RAISERROR('Lái xe phải đủ 18 tuổi.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO
--7 trigger
CREATE TRIGGER trg_CheckSoGheVe
ON Ve
FOR INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN ChuyenXe cx ON i.MaChuyen = cx.MaChuyen
        INNER JOIN Xe x ON cx.MaXe = x.MaXe
        WHERE i.SoGhe > x.SoGhe
    )
    BEGIN
        RAISERROR('Số ghế đặt vé không được vượt quá số ghế của xe.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

--7 kiểu index
--index 1
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'idx_Xe_MaNhaXe' AND object_id = OBJECT_ID('Xe'))
BEGIN
    CREATE INDEX idx_Xe_MaNhaXe ON Xe(MaNhaXe);
END;
GO

--index 2
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'idx_Xe_MaTuyen' AND object_id = OBJECT_ID('Xe'))
BEGIN
    CREATE INDEX idx_Xe_MaTuyen ON Xe(MaTuyen);
END;
GO

--index 3
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'idx_ChuyenXe_MaXe' AND object_id = OBJECT_ID('ChuyenXe'))
BEGIN
    CREATE INDEX idx_ChuyenXe_MaXe ON ChuyenXe(MaXe);
END;
GO

--index 4
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'idx_ChuyenXe_MaLaiXe' AND object_id = OBJECT_ID('ChuyenXe'))
BEGIN
    CREATE INDEX idx_ChuyenXe_MaLaiXe ON ChuyenXe(MaLaiXe);
END;
GO

--index 5
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'idx_Ve_MaChuyen' AND object_id = OBJECT_ID('Ve'))
BEGIN
    CREATE INDEX idx_Ve_MaChuyen ON Ve(MaChuyen);
END;
GO

--index 6
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'idx_ChuyenXe_NgayKhoiHanh' AND object_id = OBJECT_ID('ChuyenXe'))
BEGIN
    CREATE INDEX idx_ChuyenXe_NgayKhoiHanh ON ChuyenXe(NgayKhoiHanh);
END;
GO

--index 7
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'idx_TuyenXe_TenTuyen' AND object_id = OBJECT_ID('TuyenXe'))
BEGIN
    CREATE INDEX idx_TuyenXe_TenTuyen ON TuyenXe(TenTuyen);
END;
GO

--10 kiểu Stored Procedure
--1 Stored Procedure
IF OBJECT_ID('GetAllNhaXe', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE GetAllNhaXe;
END;
GO
--2 Stored Procedure
CREATE PROCEDURE GetAllNhaXe
AS
BEGIN
    SELECT * FROM NhaXe;
END;
GO
--3 Stored Procedure
IF OBJECT_ID('GetXeByBienSo', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE GetXeByBienSo;
END;
GO
CREATE PROCEDURE GetXeByBienSo
    @BienSo NVARCHAR(20)
AS
BEGIN
    SELECT * FROM Xe WHERE BienSo = @BienSo;
END;
GO
-- Gọi stored procedure và truyền giá trị cho @BienSo
EXEC GetXeByBienSo @BienSo = N'51A-12345';
go
--4 Stored Procedure
IF OBJECT_ID('GetLaiXeByTen', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE GetLaiXeByTen;
END;
GO
CREATE PROCEDURE GetLaiXeByTen
    @TenLaiXe NVARCHAR(100)
AS
BEGIN
    SELECT * FROM LaiXe WHERE TenLaiXe = @TenLaiXe;
END;
GO
-- Gọi stored procedure và truyền giá trị cho @TenLaiXe
EXEC GetLaiXeByTen @TenLaiXe = N'Nguyễn Văn Anh';
go
--5 Stored Procedure
IF OBJECT_ID('GetAllChuyenXe', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE GetAllChuyenXe;
END;
GO
CREATE PROCEDURE GetAllChuyenXe
AS
BEGIN
    SELECT * FROM ChuyenXe;
END;
GO
--6 Stored Procedure
IF OBJECT_ID('GetAllVe', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE GetAllVe;
END;
GO
CREATE PROCEDURE GetAllVe
AS
BEGIN
    SELECT * FROM Ve;
END;
GO
--7 Stored Procedure
IF OBJECT_ID('UpdateSoGheXe', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE UpdateSoGheXe;
END;
GO
CREATE PROCEDURE UpdateSoGheXe
    @MaXe INT,
    @SoGhe INT
AS
BEGIN
    UPDATE Xe SET SoGhe = @SoGhe WHERE MaXe = @MaXe;
END;
GO
-- Gọi stored procedure và truyền giá trị cho @MaXe
EXEC UpdateSoGheXe @MaXe = 1, @SoGhe = 40;
go
--8 Stored Procedure
IF OBJECT_ID('GetTongGiaVeByChuyen', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE GetTongGiaVeByChuyen;
END;
GO
CREATE PROCEDURE GetTongGiaVeByChuyen
    @MaChuyen INT,
    @TongGiaVe DECIMAL(18,2) OUTPUT
AS
BEGIN
    SELECT @TongGiaVe = SUM(GiaVe) FROM Ve WHERE MaChuyen = @MaChuyen;
END;
GO
-- Khai báo biến để nhận giá trị đầu ra
DECLARE @TongGiaVe DECIMAL(18,2);

-- Gọi stored procedure và truyền giá trị cho @MaChuyen
EXEC GetTongGiaVeByChuyen @MaChuyen = 1, @TongGiaVe = @TongGiaVe OUTPUT;

-- Hiển thị giá trị của @TongGiaVe
PRINT @TongGiaVe;
go
--9 Stored Procedure
IF OBJECT_ID('UpdateSoGheXe', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE UpdateSoGheXe;
END;
GO
CREATE PROCEDURE UpdateSoGheXe
    @MaXe INT,
    @SoGhe INT
AS
BEGIN
    UPDATE Xe SET SoGhe = @SoGhe WHERE MaXe = @MaXe;
END;
GO
-- Gọi stored procedure và truyền giá trị cho @MaXe và @SoGhe
EXEC UpdateSoGheXe @MaXe = 1, @SoGhe = 40;

--10 Stored Procedure
IF OBJECT_ID('DeleteChuyenXe', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE DeleteChuyenXe;
END;
GO
CREATE PROCEDURE DeleteChuyenXe
    @MaChuyen INT
AS
BEGIN
    -- Xóa các bản ghi liên quan trong bảng Ve trước
    DELETE FROM Ve WHERE MaChuyen = @MaChuyen;

    -- Sau đó xóa bản ghi trong bảng ChuyenXe
    DELETE FROM ChuyenXe WHERE MaChuyen = @MaChuyen;

    PRINT 'Xóa thành công.';
END;
GO
-- Gọi stored procedure để xóa chuyến xe có MaChuyen = 1
EXEC DeleteChuyenXe @MaChuyen = 1;
go
-- Tạo người dùng
-- Tạo tài khoản đăng nhập
CREATE LOGIN new_user WITH PASSWORD = 'password';

-- Tạo người dùng trong cơ sở dữ liệu
USE QuanLyXeBus;
CREATE USER new_user FOR LOGIN new_user;

--Cấp quyền ở mức cơ sở dữ liệu:
USE QuanLyXeBus;
ALTER ROLE db_datareader ADD MEMBER user_name;  -- Chỉ đọc dữ liệu
ALTER ROLE db_datawriter ADD MEMBER user_name;  -- Chỉ ghi dữ liệu

-- Cấp quyền trên bảng cụ thể
GRANT SELECT, INSERT, UPDATE ON dbo.table_name TO new_user;

--Sao lưu dữ liệu
BACKUP DATABASE database_name TO DISK = 'C:\backup\QuanLyXeBus.bak';

--Phục hồi dữ liệu
RESTORE DATABASE database_name FROM DISK = 'C:\backup\QuanLyXeBus	.bak' WITH REPLACE;
