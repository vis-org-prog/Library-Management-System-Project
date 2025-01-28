#Library Management System#

create database lms;

#creating tables#

create table branch(
branch_id varchar(20) primary key,
	manager_id varchar(20),	
    branch_address varchar(55),	
    contact_no varchar(30));
    
    alter table branch modify branch_id varchar(20),
    modify manager_id varchar(20),	
    modify branch_address varchar(55),	
    modify contact_no varchar(30);


create table books(
isbn varchar(20) primary key, 
book_title varchar(100), 
category varchar(50), 
rental_price float,
 status varchar(10),
 author varchar(50), 
 publisher varchar(100)
);

create table employees(
emp_id varchar(10) primary key,
 emp_name varchar(50), 
 position varchar(20), 
 salary int, 
 branch_id varchar(20)); -- fk--

create table issued_status(
issued_id varchar(10) primary key, 
issued_member_id varchar(10), -- fk -- 
issued_book_name varchar(20),
issued_date date, 
issued_book_isbn varchar(20), -- fk --
issued_emp_id varchar(20) -- fk --
);

alter table issued_status drop foreign key fk_members;
alter table issued_status drop foreign key fk_books;
alter table issued_status drop foreign key fk_employees;

alter table issued_status modify column issued_id varchar(50),
modify column issued_member_id varchar(50), -- fk -- 
modify column issued_book_name varchar(50),
modify column issued_date date, 
modify column issued_book_isbn varchar(50), -- fk --
modify column issued_emp_id varchar(50);


create table members(
member_id varchar(20) primary key,
 member_name varchar(20), 
 member_address varchar(20), 
 reg_date date
);

create table return_status(
return_id varchar(10) primary key, 
issued_id varchar(10), -- FK--
return_book_name varchar(10), 
return_date date, 
return_book_isbn varchar(10));

alter table return_status drop foreign key fk_issued_status;

alter table return_status modify return_id varchar(10), 
modify issued_id varchar(10), -- FK--
modify return_book_name varchar(10), 
modify return_date date, 
modify return_book_isbn varchar(10);
 
 alter table return_status modify issued_id varchar(50);
 #create Entity relationship diagram#
 
 #creating foreign key#
 alter table issued_status add constraint fk_members foreign key(issued_member_id) references members(member_id);
 
 alter table issued_status add constraint fk_books foreign key(issued_book_isbn) references books(isbn);
 
 alter table issued_status add constraint fk_employees foreign key(issued_emp_id) references employees(emp_id);
 
 alter table employees add constraint fk_branch foreign key(branch_id) references branch(branch_id);
 
 alter table return_status add constraint fk_issued_id foreign key (issued_id) references issued_status(issued_id);
 
 select * from books;
select * from branch; 
select * from employees;
select * from issued_status;
select * from members;
select * from return_status;

UPDATE return_status
SET issued_id = NULL
WHERE issued_id NOT IN (SELECT issued_id FROM issued_status);

#create a new book record - "978-1-60129-456-2' - "to kill a mockingbird" - "classic"- "6.00"- yes-"harper lee", "J.B lippincot & Co."#
insert into books (isbn ,  book_title ,  category,  rental_price , status, author ,  publisher )
values('978-1-60129-456-2', 'to kill a mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B lippincot & Co.');

#update an existing members address
update members set member_address = '125 Main St' where member_id = 'C101';

#delete a record from the issued_status table with issued_id = IS104
delete from issued_status where issued_id = 'IS104';

#retrieve all books issued by the employee with emp_id = E101
select issued_book_name from issued_status where issued_emp_id = 'E101';

#find members who issued more than one book -group by members
select issued_member_id, count(*) as total_books_issued from issued_status group by issued_member_id having count(*)>1;

#create summary tables- Use ctas to generate new tables based on query results- each book and total book_issued_count
create table book_cnts as select b.isbn, b.book_title, count(ist.issued_id) as no_issued from books as b 
join 
issued_status as ist on ist.issued_book_isbn = b.isbn group by b.isbn;

select * from book_cnts;

#retrieve all the books of clasic category
select * from books where category = 'Classic';

#find total rental price by each category
 select category, sum(rental_price) as total_rental_price from books group by category;
 
 #list members who registered in last 180 days
 select * from members;
 select member_name, reg_date from members where extract(day from reg_date) <=180;