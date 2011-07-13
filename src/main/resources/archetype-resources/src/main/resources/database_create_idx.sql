-- Drop all indexes
DROP INDEX ur_userid_idx;
DROP INDEX content_type_idx;

-- Create indexes
CREATE INDEX ur_userid_idx ON user_role (user_id);
CREATE INDEX content_type_idx ON content (type);

