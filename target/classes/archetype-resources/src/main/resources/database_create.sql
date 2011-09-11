-- Database creation and insert scripts for PostGreSQL
-- Update the name of the target database below:
drop database ${artifactId}_db;

drop table file_upload;
drop table blog_comment;
drop table blog_data;
drop table blog_entry;
drop table blog;
drop table system_config;
drop table news_data;
drop table news;
drop table content_data;
drop table content;
drop table mailing_list;
drop table account_role;
drop table account;

create table account (
	user_name varchar(10) not null,
	password varchar(256) not null,
	email varchar(256) not null,
	enabled boolean,
	first_name varchar(32) not null,
	last_name varchar(32),
	registered_date timestamp,
	last_login_date timestamp null default null,
	date_of_birth date,	
	invalid_login_count integer,
	login_count integer,
	comment_count integer,
	news_count integer,
	blog_count integer,
	update_password char(1),
	gender char(1),
	avatar_mime_type varchar(64),
	avatar blob,
	constraint account_unique_1 unique (email),
	primary key (user_name)
);

create table account_role (
	role_id serial primary key,
	user_name varchar(10) not null,
	role_name varchar(32),
	constraint account_role_fk_1 foreign key (user_name) references account on update cascade on delete cascade
);

create table mailing_list (
	email varchar(128) primary key,
	first_name varchar(32) not null,
	created_date timestamp not null
);

create table content_data (
	data_id serial primary key,
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
	modified_date timestamp not null,
	status char(1) not null,
    	email_sent char(1) not null,
	url varchar (256), 
	modified_by varchar(32) references account(account_id) on update cascade on delete no action
);

create table news_data (
	data_id serial primary key,
	data blob not null,
	thumb_data blob,
	file_name varchar(256),
	mime_type varchar(64) not null,
	caption varchar(128),
	description varchar(1024),
	news_id int4 references news(news_id) on update cascade on delete cascade
);

create table news (
	news_id serial primary key, 
	title varchar(1024),
	detail text, 
	created_date timestamp not null,
	modified_date timestamp not null,
	status char(1) not null,
    	hits integer not null,
	email_sent char(1),
	url varchar (256), 
	modified_by varchar(32) references account(account_id) on update cascade on delete no action
);

create table system_config (
	config_type varchar(128) not null,
  	config_data_type varchar(32) not null,
  	config_data_value varchar(32) not null,
  	created_date timestamp not null,
	modified_date timestamp not null,
	modified_by varchar(32) references account(account_id) on update cascade on delete no action,
  	primary key (config_type, config_data_type)
);

create table blog (
	name varchar(128) primary key,
	description varchar(256),
	modified_by varchar(32) references account(account_id) on update cascade on delete no action,
	created_date timestamp not null,
	modified_date timestamp not null,
	visibile char(1),
	status char(1) not null
);

create table blog_entry (
	entry_id serial  primary key,
	title varchar(128) not null,
	content text not null,
	modified_by varchar(32) references account(account_id) on update cascade on delete no action,
	created_date timestamp not null,
	modified_date timestamp not null,
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
	account_id varchar(32) references account(account_id) on update cascade on delete cascade,
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

create table file_upload (
	file_name varchar(256) primary key,
	modified_by varchar(32) references account(account_id) on update cascade on delete no action,
	created_date timestamp not null,
	modified_date timestamp not null,
	file_data blob,
	download_count integer,
	mime_type varchar(64)
);


