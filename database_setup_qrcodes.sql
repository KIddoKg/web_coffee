-- Tạo bảng qrcodes
CREATE TABLE qrcodes (
    id SERIAL PRIMARY KEY,          -- id tự tăng
    color VARCHAR(20),              -- mã màu (hex hoặc tên màu)
    image_url TEXT,                 -- link ảnh QR code
    link_url TEXT NOT NULL,         -- link mà QR code trỏ tới
    is_active BOOLEAN DEFAULT true, -- trạng thái hoạt động
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tạo trigger để tự động cập nhật updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_qrcodes_updated_at
    BEFORE UPDATE ON qrcodes
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Insert một số dữ liệu mẫu (tuỳ chọn)
INSERT INTO qrcodes (color, image_url, link_url, is_active) VALUES
('#FF0000', '', 'https://www.google.com', true),
('#00FF00', '', 'https://www.facebook.com', true),
('#0000FF', '', 'https://www.youtube.com', false);
