/abolish

-- Jorge Villarrubia y Javier Guzm�n

create table programadores(dni string primary key, nombre string, direcci�n string, tel�fono string);

create or replace table analistas(dni string primary key, nombre string, direcci�n string, tel�fono string);

create table distribuci�n(c�digopr string, dniemp string, horas int, primary key (c�digopr, dniemp));

create table proyectos(c�digo string primary key, descripci�n string, dnidir string);

insert into programadores(dni, nombre, direcci�n, tel�fono) values('1','Jacinto','Jazm�n 4','91-8888888');
insert into programadores(dni, nombre, direcci�n, tel�fono) values('2','Herminia','Rosa 4','91-7777777');
insert into programadores(dni, nombre, direcci�n, tel�fono) values('3','Calixto','Clavel 3','91-1231231');
insert into programadores(dni, nombre, direcci�n, tel�fono) values('4','Teodora','Petunia 3','91-6666666');

insert into analistas(dni, nombre, direcci�n, tel�fono) values('4','Teodora','Petunia 3','91-6666666');
insert into analistas(dni, nombre, direcci�n, tel�fono) values('5','Evaristo','Luna 1','91-1111111');
insert into analistas(dni, nombre, direcci�n, tel�fono) values('6','Luciana','J�piter 2','91-8888888');
insert into analistas(dni, nombre, direcci�n, tel�fono) values('7','Nicodemo','Plut�n 3',NULL);

-- Para crear una clave primaria de m�s de un atributo hay que a�adir al final como si fuese otro campo lo siguiente: primary key (c�digopr, dniemp)
insert into distribuci�n(c�digopr, dniemp, horas) values('P1','1',10);
insert into distribuci�n(c�digopr, dniemp, horas) values('P1','2',40);
insert into distribuci�n(c�digopr, dniemp, horas) values('P1','4',5);
insert into distribuci�n(c�digopr, dniemp, horas) values('P2','4',10);
insert into distribuci�n(c�digopr, dniemp, horas) values('P3','1',10);
insert into distribuci�n(c�digopr, dniemp, horas) values('P3','3',40);
insert into distribuci�n(c�digopr, dniemp, horas) values('P3','4',5);
insert into distribuci�n(c�digopr, dniemp, horas) values('P3','5',30);
insert into distribuci�n(c�digopr, dniemp, horas) values('P4','4',20);
insert into distribuci�n(c�digopr, dniemp, horas) values('P4','5',10);



insert into proyectos(c�digo, descripci�n, dnidir) values('P1','N�mina','4');
insert into proyectos(c�digo, descripci�n, dnidir) values('P2','Contabilidad','4');
insert into proyectos(c�digo, descripci�n, dnidir) values('P3','Producci�n','5');
insert into proyectos(c�digo, descripci�n, dnidir) values('P4','Clientes','5');
insert into proyectos(c�digo, descripci�n, dnidir) values('P5','Ventas','6');

create view empleados as select * from programadores union select * from analistas;


/duplicates on
/multiline on

-- Vista 1

create view vista1(dni) as select dni from programadores union select dni from analistas;



-- Vista 2

create view vista2(dni) as select dni from programadores intersect select dni from analistas;



-- Vista 3

create view vista3(dni) as select dni from vista1 except (select dniemp from distribuci�n union select dnidir from proyectos);



-- Vista 4

create view vista4(c�digo) as select c�digo from proyectos except select * from select c�digopr from analistas, distribuci�n where dni = dniemp;



-- Vista 5

create view vista5(dni) as select distinct dnidir from proyectos except select dni from programadores;



-- Vista 6


-- En vista 6 no hemos utilizado el distinct aunque pueda haber dos tuplas iguales, porque hacen referencia a proyectos o personas distintas con el mimso nombre (ej: dos personas diferentes (distinto dni) que se llamen Juan y trabajen ambas en P1 durante 10 horas)


create view vista6 (descripci�n, nombre, horas) as select descripci�n, nombre, horas from (programadores inner join distribuci�n on dni = dniemp) inner join proyectos on c�digopr = c�digo;



-- Vista 7

create view vista7(tel�fono) as select distinct e1.tel�fono from empleados e1, empleados e2 where e1.tel�fono = e2.tel�fono and e1.dni != e2.dni;



-- Vista 8

create view vista8(dni) as select * from (select dni from programadores) natural join (select dni from analistas);



-- Vista 9

create view vista9(dni, horas) as select dniemp, sum(horas) as suma from distribuci�n group by dniemp;



-- Vista 10

create view vista10(dni, nombre, proyecto) as select dniemp, nombre, c�digopr from (select dni as dniemp, nombre from empleados) natural left join distribuci�n;



-- Vista 11

create view vista11(dni, nombre) as select dni, nombre from empleados where tel�fono is null;



-- Vista 12

create view vista12(dni) as select dniemp from distribuci�n group by dniemp having sum(horas)/ count(c�digopr) < (select avg(cociente) from select sum(horas) / count(dniemp) as cociente from distribuci�n group by c�digopr);



-- Vista 13

create view vista13(dni) as select dniemp from ((select dniemp, c�digopr from distribuci�n) division (select c�digopr from distribuci�n where dniemp = (select dni from empleados where nombre = 'Evaristo')));



-- Vista 14

create view proyectosEvaristo as select c�digopr from distribuci�n d where d.dniemp = (select dni from empleados where nombre = 'Evaristo');

create view proyectosEvaristoCuenta as select count(c�digopr) cuenta from(proyectosEvaristo);


create view vista14 (dni) as select dniemp from (select dniemp, count(c�digopr) cuenta  from (select * from distribuci�n natural join proyectosEvaristo) group by dniemp) p, proyectosEvaristoCuenta e where p.cuenta = e.cuenta;




-- Vista 15


create view vista15(c�digoPr, dni, horas) as select c�digopr, dniemp, horas * 1.2 from distribuci�n natural join (select dniemp from distribuci�n except (select dniemp from distribuci�n d where exists (select * from proyectosEvaristo p where d.c�digopr = p.c�digopr)));




select * from vista1;
select * from vista2;
select * from vista3;
select * from vista4;
select * from vista5;
select * from vista6;
select * from vista7;
select * from vista8;
select * from vista9;
select * from vista10;
select * from vista11;
select * from vista12;
select * from vista13;
select * from vista14;
select * from vista15;



-- Vista 16



with depende(dnidir) as (

select * from 
select dniemp dnidir from distribuci�n natural join select c�digo c�digopr from proyectos natural join (select dni dnidir from empleados where nombre = 'Evaristo')
 
 union
 
select dniemp dnidir from distribuci�n natural join select c�digo c�digopr from proyectos natural join depende

)

select distinct nombre from empleados e, depende d where e.dni = d.dnidir and e.nombre != 'Evaristo';





