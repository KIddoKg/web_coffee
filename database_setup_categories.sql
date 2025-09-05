-- Tạo bảng categories
CREATE TABLE IF NOT EXISTS categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    name_en VARCHAR(255), -- Tên tiếng Anh
    description TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tạo index cho tên và trạng thái
CREATE INDEX IF NOT EXISTS idx_categories_name ON categories(name);
CREATE INDEX IF NOT EXISTS idx_categories_name_en ON categories(name_en);
CREATE INDEX IF NOT EXISTS idx_categories_is_active ON categories(is_active);
CREATE INDEX IF NOT EXISTS idx_categories_created_at ON categories(created_at);

-- Tạo trigger để tự động cập nhật updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_categories_updated_at BEFORE UPDATE
    ON categories FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Thêm cột category_id vào bảng products (nếu chưa có)
ALTER TABLE products 
ADD COLUMN IF NOT EXISTS category_id INTEGER REFERENCES categories(id);

-- Tạo index cho category_id trong products
CREATE INDEX IF NOT EXISTS idx_products_category_id ON products(category_id);

-- Insert các danh mục mặc định
INSERT INTO categories (name, name_en, description, is_active) VALUES
('Đồ uống cà phê', 'Coffee Drinks', 'Các loại đồ uống từ cà phê', true),
('Trà sữa', 'Milk Tea', 'Các loại trà sữa và milk tea', true),
('Trà trái cây', 'Fruit Tea', 'Trà pha với trái cây tươi', true),
('Nước ép', 'Fresh Juice', 'Nước ép trái cây tươi', true),
('Sinh tố', 'Smoothie', 'Sinh tố trái cây và rau củ', true),
('Đá xay', 'Blended Ice', 'Các loại đá xay và smoothie', true),
('Yaourt & Soda', 'Yogurt & Soda', 'Đồ uống yaourt và soda', true),
('Bánh ngọt', 'Pastries', 'Các loại bánh ngọt và dessert', true),
('Món ăn nhẹ', 'Snacks', 'Snack và món ăn vặt', true)
ON CONFLICT (name) DO NOTHING;

-- Cập nhật dữ liệu products để liên kết với categories
-- (Tùy chọn: chạy script này để map dữ liệu cũ với categories mới)
UPDATE products 
SET category_id = (
    SELECT id FROM categories 
    WHERE categories.name = products.category
    LIMIT 1
)
WHERE category_id IS NULL 
AND category IS NOT NULL
AND EXISTS (
    SELECT 1 FROM categories 
    WHERE categories.name = products.category
);

-- Tạo view để query dễ dàng hơn
CREATE OR REPLACE VIEW products_with_category AS
SELECT 
    p.*,
    c.name as category_name,
    c.description as category_description,
    c.is_active as category_is_active
FROM products p
LEFT JOIN categories c ON p.category_id = c.id;

-- Comment cho các bảng và cột
COMMENT ON TABLE categories IS 'Bảng quản lý danh mục sản phẩm';
COMMENT ON COLUMN categories.id IS 'ID duy nhất của danh mục';
COMMENT ON COLUMN categories.name IS 'Tên danh mục tiếng Việt (không được trùng)';
COMMENT ON COLUMN categories.name_en IS 'Tên danh mục tiếng Anh';
COMMENT ON COLUMN categories.description IS 'Mô tả chi tiết về danh mục';
COMMENT ON COLUMN categories.is_active IS 'Trạng thái hoạt động của danh mục';
COMMENT ON COLUMN categories.created_at IS 'Thời gian tạo danh mục';
COMMENT ON COLUMN categories.updated_at IS 'Thời gian cập nhật cuối cùng';

COMMENT ON COLUMN products.category_id IS 'ID tham chiếu đến bảng categories';
