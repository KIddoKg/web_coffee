-- Cập nhật bảng products để hỗ trợ tính năng ẩn sản phẩm và quản lý tồn kho

-- Thêm cột is_active nếu chưa có
ALTER TABLE products 
ADD COLUMN IF NOT EXISTS is_active BOOLEAN DEFAULT true;

-- Thêm cột stock_quantity để quản lý tồn kho (tùy chọn)
ALTER TABLE products 
ADD COLUMN IF NOT EXISTS stock_quantity INTEGER DEFAULT 0;

-- Thêm cột created_at và updated_at nếu chưa có
ALTER TABLE products 
ADD COLUMN IF NOT EXISTS created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW();

ALTER TABLE products 
ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW();

-- Cập nhật trigger cho updated_at (nếu chưa có)
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

DROP TRIGGER IF EXISTS update_products_updated_at ON products;
CREATE TRIGGER update_products_updated_at BEFORE UPDATE
    ON products FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Tạo index cho các trường mới
CREATE INDEX IF NOT EXISTS idx_products_is_active ON products(is_active);
CREATE INDEX IF NOT EXISTS idx_products_stock_quantity ON products(stock_quantity);
CREATE INDEX IF NOT EXISTS idx_products_created_at ON products(created_at);
CREATE INDEX IF NOT EXISTS idx_products_updated_at ON products(updated_at);

-- Cập nhật tất cả sản phẩm hiện tại thành active (nếu chưa có giá trị)
UPDATE products 
SET is_active = true 
WHERE is_active IS NULL;

-- Cập nhật created_at cho các sản phẩm cũ (nếu chưa có)
UPDATE products 
SET created_at = NOW() 
WHERE created_at IS NULL;

-- Cập nhật updated_at cho các sản phẩm cũ (nếu chưa có)
UPDATE products 
SET updated_at = NOW() 
WHERE updated_at IS NULL;

-- Tạo view để query sản phẩm active
CREATE OR REPLACE VIEW active_products AS
SELECT * FROM products 
WHERE is_active = true;

-- Tạo view để query sản phẩm hết hàng
CREATE OR REPLACE VIEW out_of_stock_products AS
SELECT * FROM products 
WHERE is_active = false OR stock_quantity = 0;

-- Tạo view sản phẩm với thông tin category
CREATE OR REPLACE VIEW products_with_category_info AS
SELECT 
    p.*,
    c.name as category_name,
    c.description as category_description,
    c.is_active as category_is_active
FROM products p
LEFT JOIN categories c ON p.category_id = c.id;

-- Function để tự động ẩn sản phẩm khi hết hàng
CREATE OR REPLACE FUNCTION auto_hide_out_of_stock()
RETURNS TRIGGER AS $$
BEGIN
    -- Nếu stock_quantity = 0, tự động set is_active = false
    IF NEW.stock_quantity IS NOT NULL AND NEW.stock_quantity <= 0 THEN
        NEW.is_active = false;
    -- Nếu stock_quantity > 0, có thể set is_active = true (tùy chọn)
    ELSIF NEW.stock_quantity IS NOT NULL AND NEW.stock_quantity > 0 AND OLD.stock_quantity <= 0 THEN
        NEW.is_active = true;
    END IF;
    
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Tạo trigger cho auto hide
DROP TRIGGER IF EXISTS trigger_auto_hide_out_of_stock ON products;
CREATE TRIGGER trigger_auto_hide_out_of_stock 
    BEFORE UPDATE OF stock_quantity ON products
    FOR EACH ROW EXECUTE FUNCTION auto_hide_out_of_stock();

-- Thêm comment cho các cột mới
COMMENT ON COLUMN products.is_active IS 'Trạng thái hiển thị sản phẩm (true = hiển thị, false = ẩn)';
COMMENT ON COLUMN products.stock_quantity IS 'Số lượng tồn kho (0 = hết hàng)';
COMMENT ON COLUMN products.created_at IS 'Thời gian tạo sản phẩm';
COMMENT ON COLUMN products.updated_at IS 'Thời gian cập nhật cuối cùng';

-- Thêm constraint để đảm bảo giá và số lượng không âm
ALTER TABLE products 
ADD CONSTRAINT check_price_positive 
CHECK (price >= 0);

ALTER TABLE products 
ADD CONSTRAINT check_stock_non_negative 
CHECK (stock_quantity >= 0);

-- Policy cho Row Level Security (nếu cần)
-- ALTER TABLE products ENABLE ROW LEVEL SECURITY;

-- DROP POLICY IF EXISTS "Enable read access for all users" ON products;
-- CREATE POLICY "Enable read access for all users" ON products
--     FOR SELECT USING (is_active = true);

-- DROP POLICY IF EXISTS "Enable all access for authenticated users" ON products;
-- CREATE POLICY "Enable all access for authenticated users" ON products
--     FOR ALL USING (auth.role() = 'authenticated');
