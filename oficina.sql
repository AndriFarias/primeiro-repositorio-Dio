create database oficina;
use oficina;

create table cliente(
	idCliente int auto_increment primary key,
    Fname varchar(10),
    Minit char(3),
    Lname varchar(20),
    CPF char(11) not null,
    dataNascimento date,
    endereco varchar(30),
    contact char(11),
    constraint unique_cpf_cliente unique (CPF)
);

create table mecanico (
	idMecanico int auto_increment primary key,
    Fname varchar(10),
    Minit char(3),
    Lname varchar(20),
    CPF char(11) not null,
    dataNascimento date,
    endereco varchar(30),
    contact char(11),
    especialidade varchar(20),
    constraint unique_cpf_mecanico unique (CPF)
);

create table os(
	idOs int auto_increment primary key,
    dataEmissão date,
    status enum('AGUARDANDO','EM EXECUÇÃO','CONCLUÍDO') not null,
    dataConclusao date
);

create table maoObra(
	idMaoobra int auto_increment primary key,
    valor float,
    idOs int,
    constraint fk_os_maoobra foreign key (idOs) references os(idOs)
);

create table equipe(
	idEquipe int auto_increment primary key,
    idOs int,
    servico enum('AVALIAR','EXECULTAR') not null,
    constraint fk_os_equipe foreign key (idOs) references os(idOs)
);

create table servico(
	idServico int auto_increment primary key,
    servico enum ('CONSERTAR','REVISÃO') not null,
    idCliente int,
    idEquipe int,
    constraint fk_cliente_servico foreign key (idCliente) references cliente(idCliente),
    constraint fk_mecanico_servico foreign key (idEquipe) references equipe(idEquipe)
);

create table veiculo(
	idVeiculo int auto_increment primary key,
    idCliente int,
    modelo varchar(20),
    cor enum('BRANCO','CINZA','VERMELHO','PRETO'),
    marca varchar(20),
    placa char(7) not null,
    constraint fk_cliente_veiculo foreign key (idCliente) references cliente(idCliente)
);


create table peca(
	idPeca int auto_increment primary key,
    Pname varchar(20),
    valor float
);

create table pecaOs(
	idOs int,
    idPeca int,
    primary key(idOs,IdPeca),
    constraint fk_os_pecaOs foreign key (idOs) references os(idOs),
    constraint fk_peca_pecaOs foreign key (idPeca) references peca(idPeca)
);



create table membros(
	idEquipe int,
    idMecanico int,
    primary key(idEquipe,idMecanico),
    constraint fk_equipe_membros foreign key (idEquipe) references equipe(idEquipe),
    constraint fk_mecanico_membros foreign key (idMecanico) references mecanico(idMecanico)
);

insert into cliente (Fname,Minit,Lname,CPF,dataNascimento,endereco,contact) values 
('LISA','L','ROSE','11199977788','1987-02-23','RUA A','55948010106'),
('LILIA','F','SMIIT','11199977888','1988-01-23','RUA B','55948010106'),
('RENATA','M','SILVA','18569997778','1997-05-13','RUA C','55945610106'),
('KELLY','R','SOUZA','65783773596','2000-09-07','RUA D','57748010106');


insert into mecanico (Fname,Minit,Lname,CPF,dataNascimento,endereco,contact,especialidade) values 
('LUCAS','P','RORSE','11199977788','1987-02-23','RUA A','55948010106','CARROS'),
('LEANDRO','F','SMINT','11199977888','1988-01-23','RUA B','55948010106','CAMINHÕES'),
('RENATO','M','SILVA','18569997778','1997-05-13','RUA C','55945610106','CARROS'),
('CAMILA','R','FERNANDES','65783773596','2000-09-07','RUA D','57748010106','MOTOS');

insert into os(dataEmissão,status,dataConclusao) values ('2022-09-21','AGUARDANDO',null),('2022-09-20','EM EXECUÇÃO',null);
insert into equipe (idOs,servico) values ('1','EXECULTAR'),('1','AVALIAR');
insert into membros(idEquipe,idMecanico) values (1,1),(1,2),(2,3);
insert into servico(servico,idCliente,idEquipe) values ('CONSERTAR','1','1'),('REVISÃO','2','2');

-- Qual equipe os mecânicos estão e o  tipo serviços que estão fazendo
 select e.idEquipe as Equipe, concat(Fname,' ',Lname) as Mecanico,e.servico from membros mb
 inner join mecanico mc using (idMecanico)
 inner join equipe e on e.idEquipe = mb.idEquipe
 order by Mecanico asc;    

-- Quantos membros tem na equipe?
 select e.idEquipe as Equipe,e.servico,count(*) as Membros from membros mb
 inner join mecanico mc using (idMecanico)
 inner join equipe e on e.idEquipe = mb.idEquipe
 group by (e.idEquipe)
 having count(*) >=1
 order by Equipe asc;
 
 -- Qual equipe vai execultar um serviço
select distinct e.idEquipe as Equipe,e.servico from membros mb
 inner join equipe e on e.idEquipe = mb.idEquipe
 where servico = 'EXECULTAR';