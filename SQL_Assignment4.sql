
CREATE DATABASE Manufacturer;
go


USE Manufacturer;
go


CREATE SCHEMA product;
go

CREATE SCHEMA supplier;
go

CREATE TABLE product.Product(
	prod_id INT IDENTITY PRIMARY KEY,
	prod_name VARCHAR(50),
	quantity INT
);

CREATE TABLE product.Component(
	comp_id INT IDENTITY PRIMARY KEY,
	comp_name VARCHAR(50),
	description VARCHAR(50),
	quantity_comp INT
);

CREATE TABLE supplier.Supplier(
	supp_id INT IDENTITY PRIMARY KEY,
	supp_name VARCHAR(50),
	supp_location VARCHAR(50),
	supp_country VARCHAR(50),
	is_active BIT
);

CREATE TABLE product.Prod_Comp(
	quantity_comp INT,
	prod_id INT,
	comp_id INT,
	FOREIGN KEY (prod_id) REFERENCES product.Product (prod_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (comp_id) REFERENCES product.Component (comp_id) ON DELETE CASCADE ON UPDATE CASCADE,
);

CREATE TABLE supplier.Comp_Supp(
	order_date DATE,
	quantity INT,
	supp_id INT,
	comp_id INT,
	FOREIGN KEY (supp_id) REFERENCES supplier.Supplier (supp_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (comp_id) REFERENCES product.Component (comp_id) ON DELETE CASCADE ON UPDATE CASCADE,
);