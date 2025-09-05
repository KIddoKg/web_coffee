-- ==============================
-- BLOG TABLE
-- ==============================

-- Tạo table blog (nếu chưa có)
CREATE TABLE IF NOT EXISTS blog (
  id SERIAL PRIMARY KEY,
  title TEXT NOT NULL,
  main_detail TEXT NOT NULL,
  sub_detail TEXT,
  link_img TEXT,
  "order" INTEGER DEFAULT 0,

  -- English version fields
  title_en TEXT,
  main_detail_en TEXT,
  sub_detail_en TEXT,

  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Comments (metadata)
COMMENT ON TABLE blog IS 'Bảng lưu trữ bài viết blog với hỗ trợ đa ngôn ngữ (Việt/Anh)';
COMMENT ON COLUMN blog.id IS 'ID tự động tăng của bài viết';
COMMENT ON COLUMN blog.title IS 'Tiêu đề bài viết (tiếng Việt)';
COMMENT ON COLUMN blog.main_detail IS 'Nội dung chính (tiếng Việt)';
COMMENT ON COLUMN blog.sub_detail IS 'Nội dung phụ/mô tả ngắn (tiếng Việt)';
COMMENT ON COLUMN blog.link_img IS 'Link ảnh minh họa';
COMMENT ON COLUMN blog."order" IS 'Thứ tự sắp xếp bài viết';
COMMENT ON COLUMN blog.title_en IS 'Tiêu đề bài viết (tiếng Anh)';
COMMENT ON COLUMN blog.main_detail_en IS 'Nội dung chính (tiếng Anh)';
COMMENT ON COLUMN blog.sub_detail_en IS 'Nội dung phụ/mô tả ngắn (tiếng Anh)';

