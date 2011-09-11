-- Drop all indexes
DROP INDEX content_type_idx;

-- Create indexes
CREATE INDEX content_type_idx ON content (type);

