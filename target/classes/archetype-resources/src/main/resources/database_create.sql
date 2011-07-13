-- Database creation and insert scripts for PostGreSQL
-- Update the name of the target database below:
drop database ${artifactId}_db;

drop table blog_comment;
drop table blog_data;
drop table blog_entry;
drop table blog;
drop table system_config;
drop table image;
drop table content;
drop table mailing_list;
drop table user_role;
drop table users;

create table users (
	user_id varchar(10) primary key, 
    first_name varchar(32) not null,
	last_name varchar(32),
    password varchar(128) not null,
	email varchar(128) not null,
    status char(1),
	last_login_date timestamp,
	registered_date timestamp,
	dob date,	
	invalid_login_count integer,
	login_count integer,
	comment_count integer,
	news_count integer,
	blog_count integer,
	update_password char(1),
	gender char(1),
	avatar_mime_type varchar(64),
	avatar blob
);

create table user_role (
	role_id serial primary key, 
	user_id varchar(10),
   	role_name varchar(32)
);

create table mailing_list (
	email varchar(128) primary key,
	first_name varchar(32) not null,
	created_date timestamp not null
);

create table image (
	image_id serial primary key,
	data blob not null,
	thumb_data blob,
	file_name varchar(256),
	mime_type varchar(64) not null,
	caption varchar(128),
	description varchar(1024),
	content_id int4 references content(content_id) on update cascade on delete cascade
);

create table content (
	content_id serial primary key, 
	type varchar(32) not null,
	title varchar(1024),
	detail text, 
	content_order integer,
	created_date timestamp not null,
	updated_date timestamp not null,
	status char(1) not null,
    email_sent char(1) not null,
	url varchar (256), 
	user_id varchar(10) references users (user_id) on update cascade on delete no action
);

create table system_config (
	config_type varchar(128) not null,
  	config_data_type varchar(32) not null,
  	config_data_value varchar(32) not null,
  	created_date timestamp not null,
  	user_id character varying(10) references users (user_id) on update cascade on delete no action,
  	primary key (config_type, config_data_type)
);

create table blog (
	name varchar(128) primary key,
	description varchar(256),
	user_id varchar(10) references users (user_id) on update cascade on delete no action,
	created_date timestamp not null,
	visibility char(1),
	status char(1) not null
);

create table blog_entry (
	entry_id serial  primary key,
	title varchar(128) not null,
	content text not null,
	user_id varchar(10) references users (user_id) on update cascade on delete no action,
	created_date timestamp not null,
	status char(1) not null,
	hits integer not null,
	email_sent char(1),
	blog_name varchar(128),
	foreign key (blog_name) references blog (name) on update cascade on delete cascade
);

create table blog_comment (
	id serial primary key, 
    content varchar(5120),
	created_date timestamp,
	user_id varchar(10) references users (user_id) on update cascade on delete cascade,
	entry_id integer not null,
	foreign key (entry_id) references blog_entry (entry_id) on update cascade on delete cascade
);

create table blog_data (
	id serial primary key,
	data blob,
	thumb_data blob,
	file_name varchar(256),
	mime_type varchar(64),
	description varchar(1024),
	caption varchar(128),
	data_order integer,
	entry_id integer not null,
	foreign key (entry_id) references blog_entry (entry_id) on update cascade on delete cascade
);

----------------- Unimplemented tables -----------------------

--drop table flavour;
--drop table category;
--drop table flavour_category_xref;
--drop table file;

create table flavour (
	flv_id serial primary key,
	flv_type varchar(64),
	flv_name varchar(64),
	flv_desc varchar (1024), 
	flv_price_single numeric, 
	flv_price_dozen numeric, 
	flv_rating_count integer,
	flv_rated integer,
	flv_order integer,
	flv_image_id int4 references blob(blob_id) on update cascade on delete no action,
	flv_updated_date timestamp,
	flv_active char(1),
	flv_gluten_free char(1),
	flv_nut_free char(1),
	flv_email_sent char(1),
	flv_user_id varchar(10) references users (user_id) on update cascade on delete no action
);

create table category (
	cat_id serial primary key,
	cat_name varchar(64)
);

create table flavour_category_xref (
	flv_id int4,
	cat_id int4,
	primary key (flv_id, cat_id)
);

create table file (
	file_name varchar(128) primary key,
	file_user_id varchar(10) references users (user_id) on update cascade on delete no action,
	file_date timestamp,
	file_data bytea,
	file_type varchar(32),
	file_download_count integer,
	file_mime_type varchar(64),
	file_public char(1)
);

commit;	
