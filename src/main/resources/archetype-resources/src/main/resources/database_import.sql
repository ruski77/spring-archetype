delete from account;
delete from account_role;

insert into account(user_name, first_name, last_name, password, email, enabled, invalid_login_count, login_count, comment_count, news_count, blog_count, registered_date, date_of_birth, update_password, gender) 
values ('SUPPORT', 'Russell', 'Adcock', '9bc34549d565d9505b287de0cd20ac77be1d3f2c', 'adcowebsolutions@gmail.com', true, 0, 0 ,0 ,0, 0, '2011-03-10 21:00:00', '1977-11-25', 'N', 'M');


insert into account_role(role_id, user_name, role_name) values (1, 'SUPPORT', 'ADMIN');
commit;	
--set update password to Y

insert into content (type, title, detail, content_order, created_date, updated_date, status, email_sent, user_id) 
values ('FAQ', 'test title', 'this is some test detail', 1, '2011-03-10 21:00:00', '2011-03-10 21:00:00', 'A', 'N', 'SUPPORT')
