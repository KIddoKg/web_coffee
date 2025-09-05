-- Thêm cột is_active vào bảng qrcodes nếu chưa có
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'qrcodes' AND column_name = 'is_active'
    ) THEN
        ALTER TABLE qrcodes ADD COLUMN is_active BOOLEAN DEFAULT true;
        
        -- Cập nhật tất cả records hiện tại thành active
        UPDATE qrcodes SET is_active = true WHERE is_active IS NULL;
        
        RAISE NOTICE 'Added is_active column to qrcodes table';
    ELSE
        RAISE NOTICE 'Column is_active already exists in qrcodes table';
    END IF;
END $$;
