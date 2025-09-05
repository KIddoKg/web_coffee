-- Create feedback table (using existing table name)
CREATE TABLE IF NOT EXISTS feedback (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    reviewer VARCHAR(255) NOT NULL,
    date VARCHAR(50) NOT NULL,
    comment TEXT,
    rating DECIMAL(2,1) NOT NULL CHECK (rating >= 0 AND rating <= 5),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Add missing columns if they don't exist
ALTER TABLE feedback ADD COLUMN IF NOT EXISTS is_active BOOLEAN DEFAULT true;
ALTER TABLE feedback ADD COLUMN IF NOT EXISTS created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE feedback ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

-- Create index for better performance
CREATE INDEX IF NOT EXISTS idx_feedback_rating ON feedback(rating);
CREATE INDEX IF NOT EXISTS idx_feedback_is_active ON feedback(is_active);
CREATE INDEX IF NOT EXISTS idx_feedback_created_at ON feedback(created_at);

-- Insert sample data (only if table is empty)
INSERT INTO feedback (title, reviewer, date, comment, rating, is_active) 
SELECT * FROM (VALUES
    ('AWESOME COFFEE', 'MICHAEL T', '03/10', 'fantastic, solid coffee! 10/10. highly recommend. this coffee is the best around', 5.0, true),
    ('GREAT EXPERIENCE', 'SARAH L', '15/09', 'Amazing atmosphere and delicious coffee. The staff is very friendly and professional.', 4.8, true),
    ('BEST COFFEE IN TOWN', 'JOHN D', '22/08', 'I have been coming here for months and the quality is always consistent. Highly recommended!', 4.9, true),
    ('PERFECT PLACE', 'EMILY R', '01/11', 'Perfect place to work and enjoy great coffee. The wifi is fast and the environment is quiet.', 4.7, true),
    ('EXCELLENT SERVICE', 'DAVID K', '18/10', 'The baristas know their craft well. Every cup is made with care and attention to detail.', 4.6, true)
) AS new_data(title, reviewer, date, comment, rating, is_active)
WHERE NOT EXISTS (SELECT 1 FROM feedback LIMIT 1);

-- Update trigger for updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

DROP TRIGGER IF EXISTS update_feedback_updated_at ON feedback;
CREATE TRIGGER update_feedback_updated_at 
    BEFORE UPDATE ON feedback 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();
