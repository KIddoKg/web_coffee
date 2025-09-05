-- Thêm cột name_en vào bảng categories nếu chưa có
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'categories' AND column_name = 'name_en'
    ) THEN
        ALTER TABLE categories ADD COLUMN name_en VARCHAR(255);
        
        RAISE NOTICE 'Added name_en column to categories table';
    ELSE
        RAISE NOTICE 'Column name_en already exists in categories table';
    END IF;
END $$;
