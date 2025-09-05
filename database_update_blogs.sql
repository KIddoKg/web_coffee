-- Script để update bảng blogs hiện có, thêm các cột tiếng Anh
-- Chạy script này nếu bảng blogs đã tồn tại và cần thêm hỗ trợ tiếng Anh

-- Thêm các cột tiếng Anh nếu chưa có
DO $$ 
BEGIN 
    -- Thêm cột title_en
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                   WHERE table_name = 'blogs' AND column_name = 'title_en') THEN
        ALTER TABLE blogs ADD COLUMN title_en TEXT;
    END IF;
    
    -- Thêm cột main_detail_en
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                   WHERE table_name = 'blogs' AND column_name = 'main_detail_en') THEN
        ALTER TABLE blogs ADD COLUMN main_detail_en TEXT;
    END IF;
    
    -- Thêm cột sub_detail_en
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                   WHERE table_name = 'blogs' AND column_name = 'sub_detail_en') THEN
        ALTER TABLE blogs ADD COLUMN sub_detail_en TEXT;
    END IF;
    
    -- Thêm cột updated_at nếu chưa có
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                   WHERE table_name = 'blogs' AND column_name = 'updated_at') THEN
        ALTER TABLE blogs ADD COLUMN updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW();
    END IF;
END $$;

-- Tạo index cho các cột tiếng Anh nếu chưa có
CREATE INDEX IF NOT EXISTS idx_blogs_title_en ON blogs(title_en);

-- Tạo hoặc thay thế trigger để tự động update updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Drop trigger cũ nếu có và tạo lại
DROP TRIGGER IF EXISTS update_blogs_updated_at ON blogs;
CREATE TRIGGER update_blogs_updated_at 
    BEFORE UPDATE ON blogs 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

-- Update comment cho bảng
COMMENT ON TABLE blogs IS 'Bảng lưu trữ bài viết blog với hỗ trợ đa ngôn ngữ (Việt/Anh)';
COMMENT ON COLUMN blogs.title_en IS 'Tiêu đề bài viết (tiếng Anh)';
COMMENT ON COLUMN blogs.main_detail_en IS 'Nội dung chính (tiếng Anh)';
COMMENT ON COLUMN blogs.sub_detail_en IS 'Nội dung phụ/mô tả ngắn (tiếng Anh)';

-- Hiển thị thông tin bảng sau khi update
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_name = 'blogs' 
ORDER BY ordinal_position;
