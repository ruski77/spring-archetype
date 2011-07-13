-- Drop all sequences
DROP SEQUENCE user_role_seq;
DROP SEQUENCE faq_faq_id_seq;
DROP SEQUENCE content_content_id_seq;
DROP SEQUENCE image_image_id_seq;

-- Create sequences
CREATE SEQUENCE user_role_seq START 1;
CREATE SEQUENCE faq_faq_id_seq START 1;
CREATE SEQUENCE content_content_id_seq START 1;
CREATE SEQUENCE image_image_id_seq START 1;
