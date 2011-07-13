delete from users;
delete from user_role;

insert into users(user_id, first_name, last_name, password, email, status, invalid_login_count, login_count, comment_count, news_count, blog_count, registered_date, dob, update_password, gender) 
values ('SUPPORT', 'Russell', 'Adcock', '9bc34549d565d9505b287de0cd20ac77be1d3f2c', 'adcowebsolutions@gmail.com', 'A', 0, 0 ,0 ,0, 0, '2011-03-10 21:00:00', '1977-11-25', 'N', 'M');

insert into user_role(role_id, user_id, role_name) values (1, 'SUPPORT', 'ADMIN');
commit;	
--set update password to Y

insert into content (type, title, detail, content_order, created_date, updated_date, status, email_sent, user_id) 
values ('FAQ', 'test title', 'this is some test detail', 1, '2011-03-10 21:00:00', '2011-03-10 21:00:00', 'A', 'N', 'SUPPORT')
