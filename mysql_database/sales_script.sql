# sql script for db_sales database
use db_sales;

# table company
insert into Company(serial_identification, name, adress, sector) values
	("AX00001", "Ozon", "Nevski Prospekt av 72", "e-commerce");

select * from company;

# table type-person
insert into TypePerson(description) values
	("manager"), ("supplier"), ("seller");

select * from TypePerson;

# table person
insert into Person(name, email, Company_id_company, TypePerson_id_type_person) values
	("Harvey", "harvey@gmail.com", 1, 1),
    ("Holger", "holtech94@gmail.com", 1, 2),
    ("Luis", "luis@gmail.com", 1, 2),
    ("Vasilisa", "vasilisa@gmail.com", 1, 2),
    ("Donna", "donna@gmail.com", 1, 3);

insert into Person(name, email, Company_id_company, TypePerson_id_type_person) values
	("Karina", "karina@gmail.com", 1, 2),
    ("Fernando", "fernando@gmail.com", 1, 2);

select * from Person;

# table supplier
insert into Supplier(Person_id_person, status, num_orders, acc_all_orders) values
	(6, "active supplier", 0, 0.0),
    (7, "active supplier", 0, 0.0);
    
select * from Supplier;

# table category
insert into Category(name) values
	("footwear"), ("clothes"), ("books");

select * from Category;

# table brand
insert into Brand(name, date_creation) values
	("nike", "1964-01-25"),
    ("havaianas", "1962-01-01"),
    ("packt pub", "2004-01-01");

select * from Brand;

# table product
insert into product(bar_code, name, description, unit_price, Category_id_category, Brand_id_brand) values
	("A00-1324-898", "nike black shoes", "footwear for man", 30.00, 1, 1),
    ("B01-7641-203", "pink havaianas", "footwear for women", 9.50, 1, 2),
    ("B02-6540-319", "brown boots", "footwear for man", 55.0, 1, 1),
    ("J01-2190-351", "black jacket", "clothes for man", 110.0, 2, 1),
    ("P01-2321-532", "full stack django and react", "packt pub book", 39.0, 3, 3),
    ("P01-6713-443", "deep learning with tensorflow and keras", "packt pub book", 29.0, 3, 3);

select * from product;

#			--- PROCEDURES AND TRIGGERS	---

# trigger to calculate subtotal in orderdetail
drop trigger if exists trg_calculate_subtotal;
delimiter $$
create trigger trg_calculate_subtotal
before insert on orderdetail
for each row
begin    
    # update subtotal in orderdetail
	set new.subtotal = new.quantity * (select p.unit_price
							from product p
                            where p.id_product = new.Product_id_product);
end $$
delimiter ;

# trigger to calculate total of orders
drop trigger if exists trg_calculate_total;
delimiter $$
create trigger trg_calculate_total
after insert on orderdetail
for each row 
begin
	update `order` ord
		set ord.total = (select vod.accumulate
			from vw_details_by_order vod
            where vod.id_order = new.Order_id_order)
	where ord.id_order = new.Order_id_order;
end  $$
delimiter ;

# trigger to calculate number of orders and accumulate
# of orders by each supplier
drop trigger if exists trg_all_ords_by_supplier;
delimiter $$
create trigger trg_all_ords_by_supplier
after update on `order`
for each row
begin    
    update supplier s
    inner join vw_ord_by_supplier obs
    on s.Person_id_person = obs.supplier_id
		set s.num_orders = obs.supplier_num_orders, 
			s.acc_all_orders = obs.supplier_acc_orders
	where s.Person_id_person = new.Supplier_Person_id_person;
end $$
delimiter ;

# procedure to accumulate orders by each supplier
delimiter $$
create procedure cur_orders_supplier()
begin
	-- declare cursor variables
	declare v_id varchar(8);
	declare v_total decimal(12, 2);
    declare v_supplier int;
    
    -- declare cursor procedure
	declare cursor_orders cursor for
		select id_order, total, Supplier_Person_id_person from `order`;        
        
	-- flag with end of data condition
    declare continue handler for not found set @done = TRUE;
    
    -- initializer flag
    set @done = FALSE;
		
	-- open cursor
    open cursor_orders;
    
    -- loop
    read_orders: LOOP
		-- fetch the next row into cursor variables
        fetch cursor_orders into v_id, v_total, v_supplier;
        
        -- check the flag
        if @done then
			leave read_orders;
		end if;
        
        -- logic to execute
        update supplier s
			set s.acc_all_orders = s.acc_all_orders + v_total
		where s.Person_id_person = v_supplier;
        
	end LOOP read_orders;
    
end $$
delimiter ;

# table Order and order detail
delimiter $$
create procedure sp_generate_orders()
begin	
	# insert table order
	insert into `order`(id_order, date_generated, total, Supplier_Person_id_person) values
		("A001", now(), 0.0, 6),
        ("A002", now(), 0.0, 7),
        ("A003", now(), 0.0, 6),
        ("A004", now(), 0.0, 7),
        ("A005", now(), 0.0, 7);
        
	# insert table orderdetail
	insert into orderdetail(Order_id_order, Product_id_product, quantity, subtotal) values
		("A001", 1, 10, 0.0),
        ("A001", 2, 2, 0.0),
        ("A001", 4, 1, 0.0),
        ("A002", 1, 2, 0.0),
        ("A002", 2, 3, 0.0),
        ("A002", 3, 10, 0.0),
        ("A003", 2, 5, 0.0),
        ("A004", 2, 2, 0.0),
        ("A004", 3 , 2, 0.0),
        ("A004", 6, 4, 0.0),
        ("A005", 3, 10, 0.0),
		("A005", 5, 2, 0.0);

end $$
delimiter ;

# generate orders and orderdetails
call sp_generate_orders();

# accumulate orders by supplier
# call cur_orders_supplier();

# checking the results
select * from person;
select * from category;
select * from product;
select * from supplier;
select * from `order`;
select * from orderdetail;

# calculate accumulate for all generated orders
select sum(total) from `order`;
select sum(acc_all_orders) from supplier;

# privileges for database
show grants for 'root'@'localhost';
grant all privileges on db_sales.* to 'root'@'localhost';
flush privileges;

# trigger to calculate total of orders
/*
drop trigger trg_calculate_total;
delimiter $$
create trigger trg_calculate_total
after update on orderdetail
for each row
begin
	update `order` ord    
		set ord.total = ord.total + new.subtotal			
	where ord.id_order = new.Order_id_order;    
end $$
delimiter ;
*/

# trigger to calculate number of orders by supplier
/*
drop trigger trg_count_orders;
delimiter $$
create trigger trg_count_orders
after insert on `order`
for each row
begin
	update supplier s 
		set s.num_orders = s.num_orders + 1			
	where s.Person_id_person = new.Supplier_Person_id_person;
end $$
delimiter ;
*/

# trigger to calculate accumulate orders by supplier
/*
drop trigger trg_acc_orders_by_supplier;
delimiter $$ 
create trigger trg_acc_orders_by_supplier
after update on `order`
for each row
begin
	if old.total != new.total then
		update supplier s 
			set s.acc_all_orders = s.acc_all_orders + new.total
		where s.Person_id_person = new.Supplier_Person_id_person;
    end if;
end $$
delimiter ;
*/
