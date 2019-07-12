/abolish

-- Jorge Villarrubia y Javier Guzmán

create table programadores(dni string primary key, nombre string, dirección string, teléfono string);

create or replace table analistas(dni string primary key, nombre string, dirección string, teléfono string);

create table distribución(códigopr string, dniemp string, horas int, primary key (códigopr, dniemp));

create table proyectos(código string primary key, descripción string, dnidir string);

insert into programadores(dni, nombre, dirección, teléfono) values('1','Jacinto','Jazmín 4','91-8888888');
insert into programadores(dni, nombre, dirección, teléfono) values('2','Herminia','Rosa 4','91-7777777');
insert into programadores(dni, nombre, dirección, teléfono) values('3','Calixto','Clavel 3','91-1231231');
insert into programadores(dni, nombre, dirección, teléfono) values('4','Teodora','Petunia 3','91-6666666');

insert into analistas(dni, nombre, dirección, teléfono) values('4','Teodora','Petunia 3','91-6666666');
insert into analistas(dni, nombre, dirección, teléfono) values('5','Evaristo','Luna 1','91-1111111');
insert into analistas(dni, nombre, dirección, teléfono) values('6','Luciana','Júpiter 2','91-8888888');
insert into analistas(dni, nombre, dirección, teléfono) values('7','Nicodemo','Plutón 3',NULL);

-- Para crear una clave primaria de más de un atributo hay que añadir al final como si fuese otro campo lo siguiente: primary key (códigopr, dniemp)
insert into distribución(códigopr, dniemp, horas) values('P1','1',10);
insert into distribución(códigopr, dniemp, horas) values('P1','2',40);
insert into distribución(códigopr, dniemp, horas) values('P1','4',5);
insert into distribución(códigopr, dniemp, horas) values('P2','4',10);
insert into distribución(códigopr, dniemp, horas) values('P3','1',10);
insert into distribución(códigopr, dniemp, horas) values('P3','3',40);
insert into distribución(códigopr, dniemp, horas) values('P3','4',5);
insert into distribución(códigopr, dniemp, horas) values('P3','5',30);
insert into distribución(códigopr, dniemp, horas) values('P4','4',20);
insert into distribución(códigopr, dniemp, horas) values('P4','5',10);



insert into proyectos(código, descripción, dnidir) values('P1','Nómina','4');
insert into proyectos(código, descripción, dnidir) values('P2','Contabilidad','4');
insert into proyectos(código, descripción, dnidir) values('P3','Producción','5');
insert into proyectos(código, descripción, dnidir) values('P4','Clientes','5');
insert into proyectos(código, descripción, dnidir) values('P5','Ventas','6');

create view empleados as select * from programadores union select * from analistas;


/duplicates on
/multiline on

-- Vista 1

create view vista1(dni) as select dni from programadores union select dni from analistas;



-- Vista 2

create view vista2(dni) as select dni from programadores intersect select dni from analistas;



-- Vista 3

create view vista3(dni) as select dni from vista1 except (select dniemp from distribución union select dnidir from proyectos);



-- Vista 4

create view vista4(código) as select código from proyectos except select * from select códigopr from analistas, distribución where dni = dniemp;



-- Vista 5

create view vista5(dni) as select distinct dnidir from proyectos except select dni from programadores;



-- Vista 6


-- En vista 6 no hemos utilizado el distinct aunque pueda haber dos tuplas iguales, porque hacen referencia a proyectos o personas distintas con el mimso nombre (ej: dos personas diferentes (distinto dni) que se llamen Juan y trabajen ambas en P1 durante 10 horas)


create view vista6 (descripción, nombre, horas) as select descripción, nombre, horas from (programadores inner join distribución on dni = dniemp) inner join proyectos on códigopr = código;



-- Vista 7

create view vista7(teléfono) as select distinct e1.teléfono from empleados e1, empleados e2 where e1.teléfono = e2.teléfono and e1.dni != e2.dni;



-- Vista 8

create view vista8(dni) as select * from (select dni from programadores) natural join (select dni from analistas);



-- Vista 9

create view vista9(dni, horas) as select dniemp, sum(horas) as suma from distribución group by dniemp;



-- Vista 10

create view vista10(dni, nombre, proyecto) as select dniemp, nombre, códigopr from (select dni as dniemp, nombre from empleados) natural left join distribución;



-- Vista 11

create view vista11(dni, nombre) as select dni, nombre from empleados where teléfono is null;



-- Vista 12

create view vista12(dni) as select dniemp from distribución group by dniemp having sum(horas)/ count(códigopr) < (select avg(cociente) from select sum(horas) / count(dniemp) as cociente from distribución group by códigopr);



-- Vista 13

create view vista13(dni) as select dniemp from ((select dniemp, códigopr from distribución) division (select códigopr from distribución where dniemp = (select dni from empleados where nombre = 'Evaristo')));



-- Vista 14

create view proyectosEvaristo as select códigopr from distribución d where d.dniemp = (select dni from empleados where nombre = 'Evaristo');

create view proyectosEvaristoCuenta as select count(códigopr) cuenta from(proyectosEvaristo);


create view vista14 (dni) as select dniemp from (select dniemp, count(códigopr) cuenta  from (select * from distribución natural join proyectosEvaristo) group by dniemp) p, proyectosEvaristoCuenta e where p.cuenta = e.cuenta;




-- Vista 15


create view vista15(códigoPr, dni, horas) as select códigopr, dniemp, horas * 1.2 from distribución natural join (select dniemp from distribución except (select dniemp from distribución d where exists (select * from proyectosEvaristo p where d.códigopr = p.códigopr)));




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
select dniemp dnidir from distribución natural join select código códigopr from proyectos natural join (select dni dnidir from empleados where nombre = 'Evaristo')
 
 union
 
select dniemp dnidir from distribución natural join select código códigopr from proyectos natural join depende

)

select distinct nombre from empleados e, depende d where e.dni = d.dnidir and e.nombre != 'Evaristo';





