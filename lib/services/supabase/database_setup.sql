-- Script cập nhật bảng products với đầy đủ các trường cần thiết
-- Chạy script này để đảm bảo bảng products có cấu trúc đúng

-- 0. Tạo bảng categories trước nếu chưa có
CREATE TABLE IF NOT EXISTS categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Thêm một số categories mặc định nếu bảng trống
INSERT INTO categories (name, description) VALUES
    ('Đồ uống cà phê', 'Các loại cà phê truyền thống và hiện đại'),
    ('Trà sữa', 'Các loại trà sữa và bubble tea'),
    ('Trà trái cây', 'Trà pha chế với trái cây tươi'),
    ('Nước ép', 'Nước ép trái cây tươi nguyên chất'),
    ('Sinh tố', 'Sinh tố trái cây và rau củ'),
    ('Đá xay', 'Đồ uống đá xay mát lạnh'),
    ('Yaourt & Soda', 'Yaourt và các loại soda')
ON CONFLICT (name) DO NOTHING;

-- 1. Kiểm tra và tạo bảng products nếu chưa có
CREATE TABLE IF NOT EXISTS products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    country VARCHAR(100) NOT NULL DEFAULT 'Vietnam',
    price NUMERIC(10,2) NOT NULL CHECK (price >= 0),
    image_url TEXT,
    image_path TEXT,
    category VARCHAR(100) NOT NULL,
    category_id INTEGER REFERENCES categories(id) ON DELETE SET NULL,
    is_best_seller BOOLEAN DEFAULT false,
    is_active BOOLEAN DEFAULT true,
    stock_quantity INTEGER DEFAULT 0 CHECK (stock_quantity >= 0),
    amount INTEGER DEFAULT 1,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. Thêm các cột mới nếu chưa có (cho trường hợp bảng đã tồn tại)

-- Thêm cột id nếu chưa có (auto increment primary key)
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns
                   WHERE table_name = 'products' AND column_name = 'id') THEN
        ALTER TABLE products ADD COLUMN id SERIAL PRIMARY KEY;
    END IF;
END $$;

-- Thêm cột category_id nếu chưa có (chỉ khi bảng categories đã tồn tại)
DO $$
BEGIN
    -- Kiểm tra bảng categories có tồn tại không
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'categories') THEN
        -- Nếu có bảng categories, thêm foreign key
        IF NOT EXISTS (SELECT 1 FROM information_schema.columns
                       WHERE table_name = 'products' AND column_name = 'category_id') THEN
            ALTER TABLE products ADD COLUMN category_id INTEGER REFERENCES categories(id) ON DELETE SET NULL;
        END IF;
    ELSE
        -- Nếu chưa có bảng categories, chỉ thêm cột không có foreign key
        IF NOT EXISTS (SELECT 1 FROM information_schema.columns
                       WHERE table_name = 'products' AND column_name = 'category_id') THEN
            ALTER TABLE products ADD COLUMN category_id INTEGER;
        END IF;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        -- Nếu có lỗi, thêm cột không có foreign key
        IF NOT EXISTS (SELECT 1 FROM information_schema.columns
                       WHERE table_name = 'products' AND column_name = 'category_id') THEN
            ALTER TABLE products ADD COLUMN category_id INTEGER;
        END IF;
END $$;

-- Thêm cột is_best_seller nếu chưa có
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns
                   WHERE table_name = 'products' AND column_name = 'is_best_seller') THEN
        ALTER TABLE products ADD COLUMN is_best_seller BOOLEAN DEFAULT false;
    END IF;
END $$;

-- Thêm cột is_active nếu chưa có
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns
                   WHERE table_name = 'products' AND column_name = 'is_active') THEN
        ALTER TABLE products ADD COLUMN is_active BOOLEAN DEFAULT true;
    END IF;
END $$;

-- Thêm cột stock_quantity nếu chưa có
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns
                   WHERE table_name = 'products' AND column_name = 'stock_quantity') THEN
        ALTER TABLE products ADD COLUMN stock_quantity INTEGER DEFAULT 0;
    END IF;
END $$;

-- Thêm cột amount nếu chưa có
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns
                   WHERE table_name = 'products' AND column_name = 'amount') THEN
        ALTER TABLE products ADD COLUMN amount INTEGER DEFAULT 1;
    END IF;
END $$;

-- Thêm cột created_at nếu chưa có
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns
                   WHERE table_name = 'products' AND column_name = 'created_at') THEN
        ALTER TABLE products ADD COLUMN created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW();
    END IF;
END $$;

-- Thêm cột updated_at nếu chưa có
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns
                   WHERE table_name = 'products' AND column_name = 'updated_at') THEN
        ALTER TABLE products ADD COLUMN updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW();
    END IF;
END $$;

-- Thêm cột image_url nếu chưa có (thay thế cho image)
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns
                   WHERE table_name = 'products' AND column_name = 'image_url') THEN
        ALTER TABLE products ADD COLUMN image_url TEXT;
    END IF;
END $$;

-- Thêm cột image_path nếu chưa có
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns
                   WHERE table_name = 'products' AND column_name = 'image_path') THEN
        ALTER TABLE products ADD COLUMN image_path TEXT;
    END IF;
END $$;

-- Migration: Copy data từ cột image sang image_url (nếu có)
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.columns
               WHERE table_name = 'products' AND column_name = 'image') THEN
        -- Copy dữ liệu từ image sang image_url
        UPDATE products
        SET image_url = image
        WHERE image_url IS NULL AND image IS NOT NULL AND image != '';
    END IF;
END $$;

-- 3. Tạo function và trigger cho updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

DROP TRIGGER IF EXISTS update_products_updated_at ON products;
CREATE TRIGGER update_products_updated_at
    BEFORE UPDATE ON products
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- 4. Tạo function tự động ẩn sản phẩm hết hàng
CREATE OR REPLACE FUNCTION auto_hide_out_of_stock()
RETURNS TRIGGER AS $$
BEGIN
    -- Nếu stock_quantity = 0, tự động set is_active = false
    IF NEW.stock_quantity IS NOT NULL AND NEW.stock_quantity <= 0 THEN
        NEW.is_active = false;
    -- Nếu stock_quantity > 0 và trước đó = 0, có thể set is_active = true
    ELSIF NEW.stock_quantity IS NOT NULL AND NEW.stock_quantity > 0
          AND OLD.stock_quantity IS NOT NULL AND OLD.stock_quantity <= 0 THEN
        -- Chỉ tự động show lại nếu không bị ẩn thủ công
        -- Có thể thêm logic phức tạp hơn ở đây
        NEW.is_active = true;
    END IF;

    RETURN NEW;
END;
$$ language 'plpgsql';

DROP TRIGGER IF EXISTS trigger_auto_hide_out_of_stock ON products;
CREATE TRIGGER trigger_auto_hide_out_of_stock
    BEFORE UPDATE OF stock_quantity ON products
    FOR EACH ROW EXECUTE FUNCTION auto_hide_out_of_stock();

-- 5. Tạo indexes để tối ưu performance
CREATE INDEX IF NOT EXISTS idx_products_is_active ON products(is_active);
CREATE INDEX IF NOT EXISTS idx_products_category ON products(category);
CREATE INDEX IF NOT EXISTS idx_products_category_id ON products(category_id);
CREATE INDEX IF NOT EXISTS idx_products_is_best_seller ON products(is_best_seller);
CREATE INDEX IF NOT EXISTS idx_products_stock_quantity ON products(stock_quantity);
CREATE INDEX IF NOT EXISTS idx_products_created_at ON products(created_at);
CREATE INDEX IF NOT EXISTS idx_products_price ON products(price);
CREATE INDEX IF NOT EXISTS idx_products_image_url ON products(image_url);
CREATE INDEX IF NOT EXISTS idx_products_image_path ON products(image_path);

-- 6. Thêm constraints (sử dụng DO block để tránh lỗi nếu constraint đã tồn tại)
DO $$
BEGIN
    -- Thêm constraint kiểm tra giá không âm
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints
                   WHERE table_name = 'products' AND constraint_name = 'check_price_positive') THEN
        ALTER TABLE products ADD CONSTRAINT check_price_positive CHECK (price >= 0);
    END IF;
EXCEPTION
    WHEN OTHERS THEN NULL; -- Bỏ qua lỗi nếu constraint đã tồn tại
END $$;

DO $$
BEGIN
    -- Thêm constraint kiểm tra stock không âm
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints
                   WHERE table_name = 'products' AND constraint_name = 'check_stock_non_negative') THEN
        ALTER TABLE products ADD CONSTRAINT check_stock_non_negative CHECK (stock_quantity >= 0);
    END IF;
EXCEPTION
    WHEN OTHERS THEN NULL;
END $$;

DO $$
BEGIN
    -- Thêm constraint kiểm tra amount dương
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints
                   WHERE table_name = 'products' AND constraint_name = 'check_amount_positive') THEN
        ALTER TABLE products ADD CONSTRAINT check_amount_positive CHECK (amount > 0);
    END IF;
EXCEPTION
    WHEN OTHERS THEN NULL;
END $$;

-- 7. Xóa constraint và cột key cũ nếu có + thêm name_english

DO $$
BEGIN
    -- Drop constraint unique cho key nếu tồn tại
    IF EXISTS (SELECT 1 FROM information_schema.table_constraints
               WHERE table_name = 'products' AND constraint_name = 'products_key_unique') THEN
        ALTER TABLE products DROP CONSTRAINT products_key_unique;
    END IF;

    -- Drop cột key nếu tồn tại (migration từ version cũ)
    IF EXISTS (SELECT 1 FROM information_schema.columns
               WHERE table_name = 'products' AND column_name = 'key') THEN
        ALTER TABLE products DROP COLUMN key;
    END IF;

    -- Thêm cột name_english nếu chưa có
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns
                   WHERE table_name = 'products' AND column_name = 'name_english') THEN
        ALTER TABLE products ADD COLUMN name_english VARCHAR(255);
    END IF;
END $$;

-- 8. Cập nhật dữ liệu cho các sản phẩm hiện có

-- Set default values cho các cột mới
UPDATE products
SET is_active = true
WHERE is_active IS NULL;

UPDATE products
SET is_best_seller = false
WHERE is_best_seller IS NULL;

UPDATE products
SET stock_quantity = 0
WHERE stock_quantity IS NULL;

UPDATE products
SET amount = 1
WHERE amount IS NULL OR amount <= 0;

UPDATE products
SET created_at = NOW()
WHERE created_at IS NULL;

UPDATE products
SET updated_at = NOW()
WHERE updated_at IS NULL;

UPDATE products
SET country = 'Vietnam'
WHERE country IS NULL OR country = '';

-- Cập nhật category_id từ category name (nếu có bảng categories)
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'categories') THEN
        -- Cập nhật category_id dựa trên category name
        UPDATE products
        SET category_id = c.id
        FROM categories c
        WHERE products.category = c.name
        AND products.category_id IS NULL;
    END IF;
END $$;

-- 9. Tạo views hữu ích

-- Drop các views cũ trước khi tạo lại (để tránh conflict)
DROP VIEW IF EXISTS active_products CASCADE;
DROP VIEW IF EXISTS out_of_stock_products CASCADE;
DROP VIEW IF EXISTS best_seller_products CASCADE;
DROP VIEW IF EXISTS products_with_category_info CASCADE;

-- View sản phẩm đang active
CREATE OR REPLACE VIEW active_products AS
SELECT * FROM products
WHERE is_active = true
ORDER BY created_at DESC;

-- View sản phẩm hết hàng
CREATE OR REPLACE VIEW out_of_stock_products AS
SELECT * FROM products
WHERE is_active = false OR stock_quantity = 0
ORDER BY updated_at DESC;

-- View sản phẩm best seller
CREATE OR REPLACE VIEW best_seller_products AS
SELECT * FROM products
WHERE is_best_seller = true AND is_active = true
ORDER BY created_at DESC;

-- View sản phẩm với thông tin category
CREATE OR REPLACE VIEW products_with_category_info AS
SELECT
    p.*,
    c.name as category_name,
    c.description as category_description,
    c.is_active as category_is_active
FROM products p
LEFT JOIN categories c ON p.category_id = c.id
ORDER BY p.created_at DESC;

-- 10. Thêm comments cho documentation
COMMENT ON TABLE products IS 'Bảng lưu trữ thông tin sản phẩm cà phê';
COMMENT ON COLUMN products.id IS 'ID tự động tăng (primary key)';
COMMENT ON COLUMN products.name IS 'Tên sản phẩm';
COMMENT ON COLUMN products.name_english IS 'Tên sản phẩm bằng tiếng Anh (phục vụ đa ngôn ngữ)';
COMMENT ON COLUMN products.country IS 'Quốc gia xuất xứ';
COMMENT ON COLUMN products.price IS 'Giá sản phẩm (VNĐ)';
COMMENT ON COLUMN products.image_url IS 'URL hình ảnh sản phẩm (public URL)';
COMMENT ON COLUMN products.image_path IS 'Đường dẫn file hình ảnh trong storage';
COMMENT ON COLUMN products.category IS 'Tên danh mục (legacy)';
COMMENT ON COLUMN products.category_id IS 'ID tham chiếu đến bảng categories';
COMMENT ON COLUMN products.is_best_seller IS 'Đánh dấu sản phẩm bán chạy';
COMMENT ON COLUMN products.is_active IS 'Trạng thái hiển thị (true = hiển thị, false = ẩn)';
COMMENT ON COLUMN products.stock_quantity IS 'Số lượng tồn kho';
COMMENT ON COLUMN products.amount IS 'Số lượng mặc định khi thêm vào giỏ hàng';
COMMENT ON COLUMN products.created_at IS 'Thời gian tạo';
COMMENT ON COLUMN products.updated_at IS 'Thời gian cập nhật cuối';

-- Hoàn thành script cập nhật
SELECT 'Cập nhật bảng products thành công!' as message;
CREATE TABLE feedback (
    id SERIAL PRIMARY KEY,           -- ID tự động tăng
    title TEXT NOT NULL,             -- Tiêu đề feedback
    reviewer TEXT NOT NULL,          -- Người review
    date TIMESTAMP NOT NULL,         -- Ngày review
    comment TEXT,                    -- Nội dung comment
    rating NUMERIC(3,2) NOT NULL     -- Điểm đánh giá (ví dụ 4.50)
);
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

CREATE TABLE qrcodes (
    id SERIAL PRIMARY KEY,          -- id tự tăng
    color VARCHAR(20),              -- mã màu (hex hoặc tên màu)
    image_url TEXT,                 -- link ảnh QR code
    link_url TEXT NOT NULL,         -- link mà QR code trỏ tới
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
