create database ecommerce;
use ecommerce;

create table clients(
	idClient int auto_increment primary key,
    Address varchar(30),
    contact char(11)
);


create table clienteFisico(
	idFisico int auto_increment primary key,
    idClient int not null,
    Fname varchar(10),
    Minit char(3),
    Lname varchar(20),
    CPF char(11) not null,
    dataNascimento date,
    constraint fk_client_fisico foreign key (idClient) references clients(idClient),
    constraint unique_cpf_client unique (CPF)
);

create table clienteJuridico(
	idJuridico int auto_increment primary key,
	idClient int not null,
    RazaoSocial varchar(20),
    CNPJ char(15) not null,
    dataAbertura date,
    constraint fk_client_juridico foreign key (idClient) references clients(idClient),
	constraint unique_cnpj_client unique (CNPJ),
    constraint unique_razao_client unique (RazaoSocial)
);

create table product(
	idProduct int auto_increment primary key,
    idSupplier int,
    Pname varchar (10) not null,
    classification_kids bool default false,
    category enum('Eletrônico','Vestimenta','Brinquedos','Alimentos','Móveis')not null,
    avaliação float default 0,
    size varchar(10),
    constraint fk_supplier_product foreign key (idSupplier) references supplier(idSupplier)
);

create table payments(
	idClient int,
    idPayment int,
    typePayment enum('Boleto','Cartão','Dois cartões'),
    limitAvailable float,
    primary key(idClient,idPayment),
    constraint fk_client_payments foreign key (idClient) references clients(idClient)
);

create table orders(
	idOrder int auto_increment primary key,
    idOrderClient int,
    orderStatus enum('Cancelado','Confirmado','Em processamento') default 'Em processamento',
    orderDescription varchar (255),
    sendValue float default 10,
    paymentCash bool default false,
    constraint fk_orders_client foreign key (idOrderClient) references clients(idClient)    
);


create table productStorage(
	idProdStorage int auto_increment primary key,
    idProduct int,
    storageLocation varchar(255),
    quantity int default 0,
    constraint fk_storage_product foreign key (idProduct) references product(idProduct)
);

create table supplier(
	idSupplier int auto_increment primary key,
    SocialName varchar(255) not null,
    CNPJ char(15) not null,
    contact char(11) not null,
    constraint unique_supplier unique (CNPJ)
);

create table seller(
	idSeller int auto_increment primary key,
    SocialName varchar(255) not null,
    AbstName varchar(255),
    CNPJ char(15),
    CPF char(9),
    location varchar(255),
    contact char(11) not null,
    constraint unique_cnpj_seller unique (CNPJ),
    constraint unique_cpf_seller unique (CPF)
);

create table productSeller(
	idPseller int,
    idProduct int,
    prodQuantity int default 1,
    primary key (idPseller,idProduct),
    constraint fk_product_seller foreign key (idPseller) references seller(idSeller),
    constraint fk_productSeller_product foreign key (idProduct) references product(idProduct)
);

create table productOrder(
	idPOproduct int,
    idPOoder int,
    poQuantity int default 1,
    poStatus enum('Disponível','Sem estoque') default 'Disponível',
    primary key (idPOproduct,idPOoder),
    constraint fk_product_order foreign key (idPOproduct) references product(idProduct),
    constraint fk_productOrder_product foreign key (idPOoder) references orders(idOrder)
);

create table storageLocation(
	idLproduct int,
    idLstorage int,
    location varchar(255) not null,
    primary key (idLproduct,idLstorage),
    constraint fk_product_storageL foreign key (idLproduct ) references product(idProduct),
    constraint fk_Orders_Lstorage foreign key (idLstorage) references productStorage(idProdStorage)
);

create table delivery(
	idDelivery int auto_increment primary key,
    status enum ('Preparando','À caminho','Entregue') default 'Preparando',
    codRastreamento varchar(13),
    constraint fk_order_delivery foreign key (idDelivery) references orders(idOrder)
);

insert into clienteFisico (idClient,Fname,Minit,Lname,CPF,dataNascimento) values (1,'LISA','L','ROSE','11199977788','1987-02-23'),
(3,'LILIA','F','SMIIT','11199977888','1988-01-23'),(4,'RENATA','M','SILVA','18569997778','1997-05-13'),(6,'KELLY','R','SOUZA','65783773596','2000-09-07');

insert into clienteJuridico (idClient,RazaoSocial,CNPJ,dataAbertura) values (2,'RAINBOW','11199977788125','1987-02-23'),
(5,'CIA','11199966788125','1988-02-23'),(7,'RAIN','11199977788130','1997-06-30'),(8,'SUMMER','11195547788125','1999-03-14');

INSERT INTO clients(Address,contact) values ('RUA A','55948010106'),('RUA B','55948010106'),('RUA C','55945610106'),('RUA A','57648010106'),
('RUA C','55948015510'),('RUA D','57748010106'),('RUA B','55948016906'),('RUA A','55946980106');

select * FROM clienteFisico;
select * FROM clienteJuridico;
select * FROM clients;
select * FROM orders;
desc orders;

insert into orders( idOrderClient,orderStatus,orderDescription,sendValue,paymentCash) values (1,default,'roupas',default,default),
(2,'Cancelado','copo',20,default),(8,default,'cadeira',default,default),(1,'Confirmado','sofá',1000,default);
 
 -- Quantos pedidos foram feitos por cada cliente?
 select concat(cf.Fname, ' ',cf.Lname) as Nome_razao, count(*) as pedidos,orderStatus from orders o
 inner join clients c on o.idOrderClient = c.idClient
 inner join clienteFisico cf on c.idClient = cf.idClient
 union
 select RazaoSocial as Nome_razao, count(*) as pedidos,orderStatus from orders o
 inner join clients c on o.idOrderClient = c.idClient
 inner join clienteJuridico cj on c.idClient = cj.idClient
 group by(Nome_razao)
 having count(*) >= 1
 order by Nome_razao asc;
 
insert into seller ( SocialName,AbstName,CNPJ,CPF,location,contact) values ('RENATA','SILVA',null,'185699978','RUA A','55948010106'),
('KELLY','SOUZA',null,'657837796','RUA D','577480106'),('COMPANIA','CIA','11196666788125',null,'RUA A','55948010106'),
('IS RAIN?','RAIN','11199977788130',null,'RUA B','55948010106');

insert into supplier(SocialName,CNPJ,contact) values ('COMPANIA','11196666788125','55948010106'),
 ('IS RAIN?','11199977788130','55948010106'), ('FORCE','111968886788125','55948010106'), ('NEXY','11196666759125','55948010106');
 
 -- Algum vendedor também é fornecedor?
select sp.SocialName, sl.CNPJ from seller sl
inner join supplier sp on sp.CNPJ = sl.CNPJ; 


insert into product(idSupplier,Pname,classification_kids,category,avaliação,size) values (1, 'SOFÁ',default,'Móveis',default,'3x20x4'),
(2, 'CAMISETA',default,'Vestimenta',default,'M'),(3, 'BARBIE',default,'Brinquedos',true,'20cm');

insert into productStorage(idProduct,storageLocation,quantity) values (1,'A1',10),(2,'B1',500),(3,'C2',200);
 -- Relação de produtos fornecedores e estoques
 select pName as produto,SocialName,quantity,category,size,storageLocation from product p
 inner join productStorage ps on p.idProduct = ps.idProduct
 inner join supplier s on s.idSupplier = p.idSupplier
 order by produto asc;
 
 -- Relação de nomes dos fornecedores e nomes dos produtos
 select SocialName as Fornecedor, pName as produto from product p
 inner join productStorage ps on p.idProduct = ps.idProduct
 inner join supplier s on s.idSupplier = p.idSupplier
  order by Fornecedor asc;
 
 
 
 