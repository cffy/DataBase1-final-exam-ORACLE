ALTER SESSION SET nls_date_format='ddmmyyyy';

/*
PARTICIPANTES: 
FREDDY CASCANTE FERNANDEZ
*/

--------------------------------------MONTAJE--------------------------------------
ALTER SESSION SET nls_date_format='ddmmyyyy';

create table cliente(
   cedula int not null,
   nombre varchar(30) not null,
   apellido_1 varchar(30) not null,
   apellido_2 varchar(30) not null,
   direccion varchar(50),
   e_mail varchar(30),
   fecha_inscripcion date not null,
   constraint pkcliente primary key (cedula)
);

create table instructores(
    cod_instructor int not null,
    nombre varchar(30) not null,
    apellido_1 varchar(30) not null,
    apellido_2 varchar(30) not null,
    direccion varchar(50),
    e_mail varchar(30),
    tel_cel int not null,
    tel_habitacion int not null,
    fecha_contratacion date not null,
    constraint pkinstructores primary key (cod_instructor)
);

create table cursos(
    id_curso int not null,
    descripcion varchar(50) not null,
    constraint pkcursos primary key (id_curso)
);

create table maquinas(
    id_maquina int not null,
    descripcion varchar(50) not null,
    constraint pkmaquinas primary key (id_maquina)
);

create table rutinas(
    id_rutina int not null,
    cliente int not null,
    instructor int not null,
    maquina int not null,
    fecha date not null,
    horas int not null,
    constraint pkrutinas primary key (id_rutina)
);

create table historial_curso(
    id_historial int not null,
    cliente int not null,
    instructor int not null,
    curso int not null,
    fecha date not null,
    horas int not null,
    constraint pkhistorial_curso primary key (id_historial),
    constraint fk1historial_curso foreign key (cliente) references cliente (cedula),
    constraint fk2historial_curso foreign key (instructor) references instructores (cod_instructor),
    constraint fk3historial_curso foreign key (curso) references cursos (id_curso)
);

alter table cliente add celular int not null;
alter table cliente add tel_habitacion int not null;
alter table maquinas add estado varchar(15);
alter table cliente modify direccion default 'n/a';
alter table instructores modify direccion default 'n/a';
alter table cliente modify e_mail default '*@*.com';
alter table instructores modify e_mail  default '*@*.com';

alter table rutinas add constraint fkrutina_cliente foreign key (cliente) references cliente (cedula);
alter table rutinas add constraint fk2rutina_instructor foreign key (instructor) references instructores (cod_instructor);

COMMIT;

---limpiar tablas
delete from historial_curso;
delete from rutinas;
delete from maquinas;
delete from instructores;
delete from cliente;
delete from cursos;
COMMIT;
--------------------------------------MONTAJE--------------------------------------
--------------------------------------PUNTO 1--------------------------------------
--TRIGGER CLIENTE
SET SERVEROUTPUT ON;
CREATE OR REPLACE TRIGGER T_INSERTAR_CLIENTE
BEFORE INSERT ON CLIENTE FOR EACH ROW
DECLARE
    ced_busca number;
BEGIN
    select count(cedula)
    into ced_busca from cliente where cedula = :new.cedula;
    if ced_busca > 0 then
        RAISE_APPLICATION_ERROR(-20000, 'Cedula cliente existente, proceso terminado.');
    else
        DBMS_OUTPUT.PUT_LINE('Cliente registrado con exito');
    end if;
END T_INSERTAR_CLIENTE;
/

----------------------------------------------------------------------
--TRIGGER intructores
SET SERVEROUTPUT ON;
CREATE OR REPLACE TRIGGER T_INSERTAR_INSTRUCTOR
BEFORE INSERT ON INSTRUCTORES FOR EACH ROW
DECLARE
    cod_busca number;
BEGIN
    select count(cod_instructor)
    into cod_busca from INSTRUCTORES where cod_instructor = :new.cod_instructor;
    if cod_busca > 0 then
        RAISE_APPLICATION_ERROR(-20000, 'Codigo de instructor existente, proceso terminado.');
    else
        DBMS_OUTPUT.PUT_LINE('Instructor registrado con exito');
    end if;
END T_INSERTAR_INSTRUCTOR;
/

----------------------------------------------------------------------
--TRIGGER cursos
SET SERVEROUTPUT ON;
CREATE OR REPLACE TRIGGER T_INSERTAR_CURSO
BEFORE INSERT ON CURSOS FOR EACH ROW
DECLARE
    id_busca number;
BEGIN
    select count(id_curso)
    into id_busca from CURSOS where id_curso = :new.id_curso;
    if id_busca > 0 then
        RAISE_APPLICATION_ERROR(-20000, 'Id de curso existente, proceso terminado.');
    else
        DBMS_OUTPUT.PUT_LINE('Curso registrado con exito');
    end if;
END T_INSERTAR_CURSO;
/

----------------------------------------------------------------------
--TRIGGER MAQUINAS
SET SERVEROUTPUT ON;
CREATE OR REPLACE TRIGGER T_INSERTAR_MAQUINAS
BEFORE INSERT ON MAQUINAS FOR EACH ROW
DECLARE
    id_busca number;
BEGIN
    select count(id_maquina)
    into id_busca from MAQUINAS where id_maquina = :new.id_maquina;
    if id_busca > 0 then
        RAISE_APPLICATION_ERROR(-20000, 'Id de maquina existente, proceso terminado.');
    else
        DBMS_OUTPUT.PUT_LINE('Maquina registrado con exito');
    end if;
END T_INSERTAR_MAQUINAS;
/

----------------------------------------------------------------------
--TRIGGER HISTORIAL_CURSO
SET SERVEROUTPUT ON;
CREATE OR REPLACE TRIGGER T_INSERTAR_HISTORIAL_CURSO
BEFORE INSERT ON historial_curso FOR EACH ROW
DECLARE
    id_historial_d number;
    cliente_d number;
    instructor_d number;
    curso_d number;
    
BEGIN
    select count(id_historial)
    into id_historial_d from historial_curso where id_historial = :new.id_historial;
    
    select count(cedula)
    into cliente_d from cliente where cedula = :new.cliente;
    
    select count(cod_instructor)
    into instructor_d from instructores where cod_instructor = :new.instructor;
    
    select count(id_curso)
    into curso_d from cursos where id_curso = :new.curso;
    
    if id_historial_d > 0 then
        RAISE_APPLICATION_ERROR(-20000, 'Id de historial de curso existente, proceso terminado.');
    elsif cliente_d = 0 then
        RAISE_APPLICATION_ERROR(-20001, 'El cliente no esta registrado, proceso terminado.');
    elsif instructor_d = 0 then
        RAISE_APPLICATION_ERROR(-20002, 'El instructor no esta registrado, proceso terminado.');
    elsif curso_d = 0 then
        RAISE_APPLICATION_ERROR(-20003, 'El curso no esta registrado, proceso terminado.');
    else
        DBMS_OUTPUT.PUT_LINE('Historial de curso registrado con exito');
    end if;
END T_INSERTAR_HISTORIAL_CURSO;
/

----------------------------------------------------------------------
--TRIGGER HISTORIAL_RUTINAS
SET SERVEROUTPUT ON;
CREATE OR REPLACE TRIGGER T_INSERTAR_HISTORIAL_RUTINAS
BEFORE INSERT ON RUTINAS FOR EACH ROW
DECLARE
    id_rutina_d number;
    cliente_d number;
    instructor_d number;
    maquina_d number;
    
BEGIN
    select count(id_rutina)
    into id_rutina_d from rutinas where id_rutina = :new.id_rutina;
    
    select count(cedula)
    into cliente_d from cliente where cedula = :new.cliente;
    
    select count(cod_instructor)
    into instructor_d from instructores where cod_instructor = :new.instructor;
    
    select count(id_maquina)
    into maquina_d from maquinas where id_maquina = :new.maquina;
    
    if id_rutina_d > 0 then
        RAISE_APPLICATION_ERROR(-20020, 'Id de rutina existente, proceso terminado.');
    elsif cliente_d = 0 then
        RAISE_APPLICATION_ERROR(-20021, 'El cliente no esta registrado, proceso terminado.');
    elsif instructor_d = 0 then
        RAISE_APPLICATION_ERROR(-20022, 'El instructor no esta registrado, proceso terminado.');
    elsif maquina_d = 0 then
        RAISE_APPLICATION_ERROR(-20023, 'La maquina no esta registrada, proceso terminado.');
    else
        DBMS_OUTPUT.PUT_LINE('Rutina registrada con exito');
    end if;
END T_INSERTAR_HISTORIAL_RUTINAS;
/

/******************************************************* TABLA CLIENTE**************************************************************/
/* ************************a.	No se debe actualizar el campo de llave primaria o foránea (en el caso de las tablas hijas).****************** */
set SERVEROUTPUT ON
create or replace trigger restriccion_actualiza_llave
before update of cedula on cliente
for EACH ROW
declare
    keyError EXCEPTION;
    PRAGMA AUTONOMOUS_TRANSACTION;
begin
IF updating then
    RAISE KeyError;
end if;

EXCEPTION WHEN KeyError THEN 
    raise_application_error (-20001,'No se puede actualizar la cedula del cliente');
end;
/

/* ******************************Avisar que se modifico un cliente********************************** */
set SERVEROUTPUT ON
create or replace trigger actualiza_cliente
before update on cliente
for EACH ROW
begin
    DBMS_OUTPUT.put_line('Cliente actualizado satisfactoriamente');
end;
/
/******************************************************* TABLA INSTRUCTORES**************************************************************/

/* ************************a.	No se debe actualizar el campo de llave primaria o foránea (en el caso de las tablas hijas).****************** */
set SERVEROUTPUT ON
create or replace trigger restracteprima_instru
before update of cod_instructor on instructores
for EACH ROW
declare
    keyError EXCEPTION;
    PRAGMA AUTONOMOUS_TRANSACTION;
begin
IF updating then
    RAISE KeyError;
end if;

EXCEPTION WHEN KeyError THEN 
    raise_application_error (-20001,'No se puede actualizar el codigo del instructor');
end;
/

/* ******************************C. Avisar que se modifico un instructor********************************** */
set SERVEROUTPUT ON;
create or replace trigger actualiza_instructor
before update on instructores
for EACH ROW
begin
    DBMS_OUTPUT.put_line('Instructor actualizado satisfactoriamente');
end;
/

/******************************************************* TABLA CURSOS**************************************************************/
/* ************************a.	No se debe actualizar el campo de llave primaria o foránea (en el caso de las tablas hijas).****************** */
set SERVEROUTPUT ON
create or replace trigger restracteprima_curso
before update of id_curso on cursos
for EACH ROW
declare
    keyError EXCEPTION;
    PRAGMA AUTONOMOUS_TRANSACTION;
begin
IF updating then
    RAISE KeyError;
end if;

EXCEPTION WHEN KeyError THEN 
    raise_application_error (-20001,'No se puede actualizar el id del curso');
end;
/

/* ******************************C. Avisar que se modifico un curso********************************** */
set SERVEROUTPUT ON;
create or replace trigger actualiza_curso
before update on cursos
for EACH ROW
begin
    DBMS_OUTPUT.put_line('Curso actualizado satisfactoriamente');
end;
/
/***************************************************************/

/******************************************************* TABLA MAQUINAS**************************************************************/
/* ************************a.	No se debe actualizar el campo de llave primaria o foránea (en el caso de las tablas hijas).****************** */
set SERVEROUTPUT ON
create or replace trigger restracteprima_maquina
before update of id_maquina on maquinas
for EACH ROW
declare
    keyError EXCEPTION;
    PRAGMA AUTONOMOUS_TRANSACTION;
begin
IF updating then
    RAISE KeyError;
end if;

EXCEPTION WHEN KeyError THEN 
    raise_application_error (-20001,'No se puede actualizar el id de la maquina');
end;
/

/* ******************************C. Avisar que se modifico una maquina********************************** */
set SERVEROUTPUT ON;
create or replace trigger actualiza_maquina
before update on maquinas
for EACH ROW
begin
    DBMS_OUTPUT.put_line('Maquina actualizado satisfactoriamente');
end;
/
/******************************************************* TABLA RUTINAS**************************************************************/
/* ************************a.	No se debe actualizar el campo de llave primaria o foránea (en el caso de las tablas hijas).****************** */
set SERVEROUTPUT ON
create or replace trigger restracteprima_rutina
before update of ID_RUTINA on rutinas
for EACH ROW
declare
    keyError EXCEPTION;
    PRAGMA AUTONOMOUS_TRANSACTION;
begin
IF updating then
    RAISE KeyError;
end if;

EXCEPTION WHEN KeyError THEN 
    raise_application_error (-20001,'No se puede actualizar el id de la rutina');
end;
/

set SERVEROUTPUT ON
create or replace trigger restractefora1_rutina
before update of CLIENTE on rutinas
for EACH ROW
declare
    keyError EXCEPTION;
    PRAGMA AUTONOMOUS_TRANSACTION;
begin
IF updating then
    RAISE KeyError;
end if;

EXCEPTION WHEN KeyError THEN 
    raise_application_error (-20001,'No se puede actualizar el cliente, ya que es una llave foranea');
end;
/

set SERVEROUTPUT ON
create or replace trigger restractefora2_rutina
before update of INSTRUCTOR on rutinas
for EACH ROW
declare
    keyError EXCEPTION;
    PRAGMA AUTONOMOUS_TRANSACTION;
begin
IF updating then
    RAISE KeyError;
end if;

EXCEPTION WHEN KeyError THEN 
    raise_application_error (-20001,'No se puede actualizar el instructor, ya que es una llave foranea');
end;
/

set SERVEROUTPUT ON
create or replace trigger restractefora3_rutina
before update of MAQUINA on rutinas
for EACH ROW
declare
    keyError EXCEPTION;
    PRAGMA AUTONOMOUS_TRANSACTION;
begin
IF updating then
    RAISE KeyError;
end if;

EXCEPTION WHEN KeyError THEN 
    raise_application_error (-20001,'No se puede actualizar la maquina, ya que es una llave foranea');
end;
/

/* ******************************C. Avisar que se modifico una rutinas********************************** */
set SERVEROUTPUT ON;
create or replace trigger actualiza_rutina
before update on rutinas
for EACH ROW
begin
    DBMS_OUTPUT.put_line('Rutina actualizada satisfactoriamente');
end;
/

/******************************************************* TABLA HISTORIAL_CURSO**************************************************************/
/* ************************a.	No se debe actualizar el campo de llave primaria o foránea (en el caso de las tablas hijas).****************** */
set SERVEROUTPUT ON
create or replace trigger restracteprima_hiscurso
before update of ID_HISTORIAL on HISTORIAL_CURSO
for EACH ROW
declare
    keyError EXCEPTION;
    PRAGMA AUTONOMOUS_TRANSACTION;
begin
IF updating then
    RAISE KeyError;
end if;

EXCEPTION WHEN KeyError THEN 
    raise_application_error (-20001,'No se puede actualizar el id del historial del curso');
end;
/

set SERVEROUTPUT ON
create or replace trigger restractefora1_hiscurso
before update of CLIENTE on HISTORIAL_CURSO
for EACH ROW
declare
    keyError EXCEPTION;
    PRAGMA AUTONOMOUS_TRANSACTION;
begin
IF updating then
    RAISE KeyError;
end if;

EXCEPTION WHEN KeyError THEN 
    raise_application_error (-20001,'No se puede actualizar el cliente, ya que es una llave foranea');
end;
/

set SERVEROUTPUT ON
create or replace trigger restractefora2_hiscurso
before update of INSTRUCTOR on HISTORIAL_CURSO  
for EACH ROW
declare
    keyError EXCEPTION;
    PRAGMA AUTONOMOUS_TRANSACTION;
begin
IF updating then
    RAISE KeyError;
end if;

EXCEPTION WHEN KeyError THEN 
    raise_application_error (-20001,'No se puede actualizar el instructor, ya que es una llave foranea');
end;
/

set SERVEROUTPUT ON
create or replace trigger restractefora3_hiscurso
before update of CURSO on HISTORIAL_CURSO
for EACH ROW
declare
    keyError EXCEPTION;
    PRAGMA AUTONOMOUS_TRANSACTION;
begin
IF updating then
    RAISE KeyError;
end if;

EXCEPTION WHEN KeyError THEN 
    raise_application_error (-20001,'No se puede actualizar el curso, ya que es una llave foranea');
end;
/

/* ******************************C. Avisar que se modifico una historial de cursos********************************** */
set SERVEROUTPUT ON;
create or replace trigger actualiza_hiscurso
before update on HISTORIAL_CURSO
for EACH ROW
begin
    DBMS_OUTPUT.put_line('HISTORIAL de CURSO actualizado satisfactoriamente');
end;
/

/*---------------------------------BORRADOO------------------------------------------*/

/*-----------------------------TABLA CLIENTE-------------------------------------------------*/
/*-------------------------VALIDACION*/
set SERVEROUTPUT ON;
create or replace trigger vali_borrado_PK_cliente
before delete on cliente
FOR EACH ROW
declare
    conta_rutinas numeric:=0;
    conta_histocursos numeric:=0;
    exc_hs exception;
    exc_ru exception;
    PRAGMA AUTONOMOUS_TRANSACTION;    
begin
    select count(hc.CLIENTE) into conta_histocursos
    from HISTORIAL_CURSO hc
    where hc.CLIENTE = :old.cedula;
    
    select count(r.CLIENTE) into conta_rutinas
    from rutinas r
    where r.CLIENTE = :old.cedula;

    if(conta_histocursos>= 1) then
       raise exc_hs;
       rollback;
    end if;
    if(conta_rutinas>= 1) then
       raise exc_ru;
       rollback;
    end if;
    DBMS_OUTPUT.put_line('Cliente eliminado satisfactoriamente');
EXCEPTION
when exc_hs then
    raise_application_error (-20001,'No se puede eliminar el cliente ya que se esta usando en Historial de cursos');
when exc_ru then
    raise_application_error (-20001,'No se puede eliminar el cliente ya que se esta usando en rutinas');
end;
/

/* ---------------------------------------------INSTRUCTORES------------------------- */
set SERVEROUTPUT ON;
create or replace trigger vali_borrado_PK_instru
before delete on instructores
FOR EACH ROW
declare
    conta_rutinas numeric:=0;
    conta_histocursos numeric:=0;
    exc_hs exception;
    exc_ru exception;
    PRAGMA AUTONOMOUS_TRANSACTION;    
begin
    select count(hc.INSTRUCTOR) into conta_histocursos
    from HISTORIAL_CURSO hc
    where hc.INSTRUCTOR = :old.COD_INSTRUCTOR;
    
    select count(r.INSTRUCTOR) into conta_rutinas
    from rutinas r
    where r.INSTRUCTOR = :old.COD_INSTRUCTOR;
        
    if(conta_histocursos>= 1) then
       raise exc_hs;
       rollback;
    end if;
    if(conta_rutinas>= 1) then
       raise exc_ru;
       rollback;
    end if;
    DBMS_OUTPUT.put_line('Instructor eliminado satisfactoriamente');
EXCEPTION
when exc_hs then
    raise_application_error (-20001,'No se puede eliminar el instructor ya que se esta usando en Historial de cursos');
when exc_ru then
    raise_application_error (-20001,'No se puede eliminar el instructor ya que se esta usando en rutinas');
end;
/

/*---------------------------------------------------Cursos--------------------------------- */
set SERVEROUTPUT ON;
create or replace trigger vali_borrado_PK_cursos
before delete on cursos
FOR EACH ROW
declare
    
    conta_histocursos numeric:=0;
    exc_hs exception;
    PRAGMA AUTONOMOUS_TRANSACTION;    
begin
    select count(hc.CURSO) into conta_histocursos
    from HISTORIAL_CURSO hc
    where hc.CURSO = :old.ID_CURSO;
    
    if(conta_histocursos>= 1) then
       raise exc_hs;
       rollback;
    end if;

    DBMS_OUTPUT.put_line('Curso eliminado satisfactoriamente');
EXCEPTION
when exc_hs then
    raise_application_error (-20001,'No se puede eliminar el curso ya que se esta usando en Historial de cursos');
end;
/

/* ----------------------------------------maquinas ---------------------------------*/

set SERVEROUTPUT ON;
create or replace trigger vali_borrado_PK_maquinas
before delete on maquinas
FOR EACH ROW
declare
    conta_rutinas numeric:=0;
    exc_ru exception;
    PRAGMA AUTONOMOUS_TRANSACTION;    
begin
    
    select count(r.maquina) into conta_rutinas
    from rutinas r
    where r.maquina = :old.ID_MAQUINA;
    
    if(conta_rutinas>= 1) then
       raise exc_ru;
       rollback;
    end if;
    DBMS_OUTPUT.put_line('Maquina eliminada satisfactoriamente');
EXCEPTION
when exc_ru then
    raise_application_error (-20001,'No se puede eliminar la maquina ya que se esta usando en rutinas');
end;
/

/* -------------------------- Rutinas -------------------------------*/
set SERVEROUTPUT ON;
create or replace trigger vali_borrado_Rutinas
before delete on rutinas
FOR EACH ROW  
begin
    DBMS_OUTPUT.put_line('Rutina eliminada satisfactoriamente');
end;
/

/*----------------------------- Historial de cursos ---------------------------*/
set SERVEROUTPUT ON;
create or replace trigger vali_borrado_hiscurso
before delete on historial_curso
FOR EACH ROW  
begin
    DBMS_OUTPUT.put_line('Historial de curso eliminado satisfactoriamente');
end;
/

------------------------------------Punto 4------------------------------------
---------------------------------------A---------------------------------------
SET SERVEROUTPUT ON
CREATE OR REPLACE PROCEDURE GET_INFO_CLIENTE_BY_ID(i_ced in cliente.cedula%TYPE) AS
    CURSOR cursor_cliente
    IS SELECT * FROM cliente 
    WHERE cedula = i_ced;
    clientes_lista cursor_cliente%rowtype;
    CURSOR cursos_c 
    IS 
    SELECT cu.descripcion, i.nombre 
    FROM historial_curso hc 
    INNER JOIN instructores i ON instructor = i.cod_instructor 
    INNER JOIN cursos cu ON curso = cu.id_curso 
    WHERE hc.cliente = i_ced;
    
    cursos_lista cursos_c%rowtype;    
    CURSOR rutinas_cursor 
    IS 
    SELECT R.id_rutina, I.nombre 
    FROM rutinas R 
    INNER JOIN instructores I ON instructor = I.cod_instructor  
    WHERE R.cliente = i_ced;
    rutinas_lista rutinas_cursor%rowtype;
BEGIN
    DBMS_OUTPUT.PUT_LINE('---------------Cliente----------------');
    DBMS_OUTPUT.PUT_LINE('CEDULA, NOMBRE, APELLIDO_1, APELLIDO_2');
    FOR clientes_lista IN cursor_cliente
    LOOP  
    DBMS_OUTPUT.PUT_LINE(clientes_lista.Cedula ||', '|| clientes_lista.nombre||', '|| clientes_lista.apellido_1||', '|| clientes_lista.apellido_2);
        DBMS_OUTPUT.PUT_LINE('Direccion: ' || clientes_lista.direccion);
        DBMS_OUTPUT.PUT_LINE('E_mail: ' || clientes_lista.e_mail);
        DBMS_OUTPUT.PUT_LINE('Fecha_inscripcion: ' || clientes_lista.Fecha_Inscripcion);
        DBMS_OUTPUT.PUT_LINE('Celular: ' || clientes_lista.celular);
        DBMS_OUTPUT.PUT_LINE('Telefono_habitacion: ' ||  clientes_lista.tel_habitacion);
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('---------CURSOS E INSTRUCTORES---------');
    DBMS_OUTPUT.PUT_LINE('Curso, Instructor');
    FOR cursos_lista IN cursos_c
    LOOP
    DBMS_OUTPUT.PUT_LINE(cursos_lista.DESCRIPCION||', '|| cursos_lista.NOMBRE);
        
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('---------RUTINAS E INSTRUCTORES--------');
    DBMS_OUTPUT.PUT_LINE('Id_Rutina, instructor');
    FOR rutinas_lista IN rutinas_cursor
    LOOP
        DBMS_OUTPUT.PUT_LINE(rutinas_lista.id_rutina||', '|| rutinas_lista.nombre);
    END LOOP;
    EXCEPTION 
    when value_error then
    DBMS_OUTPUT.PUT_LINE('Ha ocurrido un error al realizar la consulta, verifique el formato ingresado');
    --RAISE_APPLICATION_ERROR(-20501, 'Ha ocurrido un error al realizar la consulta, verifique el formato ingresado');
     
    WHEN OTHERS then
    DBMS_OUTPUT.PUT_LINE('Ha ocurrido un error al realizar la consulta, verifique el formato ingresado');
END GET_INFO_CLIENTE_BY_ID;
/

------------------------------------Punto 4------------------------------------
---------------------------------------B---------------------------------------
CREATE OR REPLACE FUNCTION GET_ANNOS_PROFESOR(fecha_inicio IN instructores.fecha_contratacion%TYPE) RETURN INT IS
    total_trabajado INT;
BEGIN
    total_trabajado := EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM fecha_inicio);
    RETURN total_trabajado;
END;
/

CREATE OR REPLACE PROCEDURE GET_INFO_INSTRUCTOR(nombre_p IN instructores.nombre%type) 
AS
    CURSOR rutinas_x_curso 
    IS SELECT * FROM rutinas WHERE instructor IN ( 
    SELECT cod_instructor 
    FROM instructores 
    WHERE nombre = nombre_p);
    lista_cursos_rutinas rutinas_x_curso%rowtype;
    id_rutina NUMBER;
    
    CURSOR c_curso_historial 
    IS SELECT * 
    FROM historial_curso 
    WHERE instructor IN (
    SELECT cod_instructor FROM instructores WHERE nombre = nombre_p);
    lista_curso_historial c_curso_historial%rowtype;----
    descripcion_curso VARCHAR(50);
    codigo NUMBER;
    nombre VARCHAR(30);
    apellido_1 VARCHAR(30);
    apellido_2 VARCHAR(30);
    direccion VARCHAR(50);
    email VARCHAR(30);
    celular NUMBER;
    telefono NUMBER;
    fecha_contratacion DATE;
    annios_t INT;
BEGIN
    SELECT cod_instructor, nombre, apellido_1, apellido_2, direccion, e_mail, tel_cel, tel_habitacion, fecha_contratacion,
    GET_ANNOS_PROFESOR(fecha_contratacion)
    INTO codigo, nombre, apellido_1, apellido_2, direccion, email, celular, telefono, fecha_contratacion, annios_t
    FROM instructores WHERE nombre = nombre_p;
    DBMS_OUTPUT.PUT_LINE('--------------INFORMACION------------'); 
    DBMS_OUTPUT.PUT_LINE('CODIGO INSTRUCTOR, NOMBRE COMPLETO');
    DBMS_OUTPUT.PUT_LINE(codigo||', '||nombre||' '||apellido_1||' '||apellido_2);
    DBMS_OUTPUT.PUT_LINE('E_mail: ' || email );
    DBMS_OUTPUT.PUT_LINE('Celular: ' || celular);
    DBMS_OUTPUT.PUT_LINE('Tel_habitacion: ' || telefono);
    DBMS_OUTPUT.PUT_LINE('Fecha_ingreso:  ' || fecha_contratacion);
    DBMS_OUTPUT.PUT_LINE('AÑOS TRABAJADOS:  ' || annios_t);
    DBMS_OUTPUT.PUT_LINE(''); 
    DBMS_OUTPUT.PUT_LINE('----------CURSOS QUE IMPARTE---------'); 
    DBMS_OUTPUT.PUT_LINE('CODIGO, DESCRIPCION');
    FOR lista_curso_historial IN c_curso_historial------
    
    LOOP
        SELECT descripcion INTO descripcion_curso FROM cursos WHERE id_curso = lista_curso_historial.curso;
       
       DBMS_OUTPUT.PUT_LINE(lista_curso_historial.curso||', '||descripcion_curso);
        --DBMS_OUTPUT.PUT_LINE('CODIGO: ' || lista_curso_historial.curso);
        --DBMS_OUTPUT.PUT_LINE('DESCRIPCION: ' || descripcion_curso);
    END LOOP; 
    DBMS_OUTPUT.PUT_LINE(''); 
    DBMS_OUTPUT.PUT_LINE('----------------RUTINAS---------------');
    FOR lista_cursos_rutinas IN rutinas_x_curso
    LOOP
        DBMS_OUTPUT.PUT_LINE('ID DE LA RUTINA: ' || lista_cursos_rutinas.id_rutina);
    END LOOP; EXCEPTION
    WHEN no_data_found THEN DBMS_OUTPUT.PUT_LINE('EL INSTURCTOR NO EXISTE'); 
END GET_INFO_INSTRUCTOR;
/

commit;

-----------------------------------INSERTAR INFORMACION--------------------------------

insert into cliente (cedula, nombre, apellido_1, apellido_2, direccion, fecha_inscripcion, celular, tel_habitacion) values (200,'maria','ruiz','ruiz','barva','01011995',11111111,22222222);
insert into cliente (cedula, nombre, apellido_1, apellido_2, direccion, e_mail, fecha_inscripcion, celular, tel_habitacion) values (201,'juan','paz','arias','alajuela','juan@hotmail.com','01011995',22222222,11111111);
insert into cliente (cedula, nombre, apellido_1, apellido_2, fecha_inscripcion, celular, tel_habitacion) values (202,'pedro','perez','perez','20041998',33333333,33333335);
insert into cliente (cedula, nombre, apellido_1, apellido_2, direccion, e_mail, fecha_inscripcion, celular, tel_habitacion) values (203,'jose','castro','ruiz','santo domingo','jruiz@gmail.com','20061998',44444444,55555555);
insert into cliente (cedula, nombre, apellido_1, apellido_2, direccion, e_mail, fecha_inscripcion, celular, tel_habitacion) values (204,'martha','diaz','ruiz','pavas','mdiaz@yahoo.es','02012000',22222229,33333333);
insert into cliente (cedula, nombre, apellido_1, apellido_2, e_mail, fecha_inscripcion, celular, tel_habitacion) values (205,'xiomara','diaz','diaz','xdiaz@hotmail.com','03022000',55555555,11111119);
insert into cliente (cedula, nombre, apellido_1, apellido_2, direccion, fecha_inscripcion, celular, tel_habitacion) values (206,'pablo','arias','arias','san jose','20042001',55555556,11111112);
insert into cliente (cedula, nombre, apellido_1, apellido_2, direccion, e_mail, fecha_inscripcion, celular, tel_habitacion) values (207,'ana','arias','arias','san pedro','arias@gmail.com','25042001',55555556,11111115);
insert into cliente (cedula, nombre, apellido_1, apellido_2, direccion, fecha_inscripcion, celular, tel_habitacion) values (208,'carmen','paz','arias','san jose','20042002',55555556,11111115);
insert into cliente (cedula, nombre, apellido_1, apellido_2, fecha_inscripcion, celular, tel_habitacion) values (209,'miguel','orias','arias','20082002',55555557,11111114);

insert into cliente (cedula, nombre, apellido_1, apellido_2, direccion, fecha_inscripcion, celular, tel_habitacion) values (210,'julia','arias','cruz','san rafael','20042003',55555559,11111119);
insert into cliente (cedula, nombre, apellido_1, apellido_2, fecha_inscripcion, celular, tel_habitacion) values (211,'paula','castillo','reyes','15052003',66666666,77777777);
insert into cliente (cedula, nombre, apellido_1, apellido_2, direccion, e_mail, fecha_inscripcion, celular, tel_habitacion) values (212,'david','arias','arias','san jose','darias@gmail.com','20102005',88888888,99999999);
insert into cliente (cedula, nombre, apellido_1, apellido_2, direccion, e_mail, fecha_inscripcion, celular, tel_habitacion) values (213,'andres','aguilar','rios','guadalupe','aaguilar@yahoo.com','10122007',99999999,88888888);
insert into cliente (cedula, nombre, apellido_1, apellido_2, direccion, e_mail, fecha_inscripcion, celular, tel_habitacion) values (214,'maria jose','villalta','paz','heredia','mjvillalta@gmail.com','20042011',77777777,66666666);
insert into cliente (cedula, nombre, apellido_1, apellido_2, direccion, fecha_inscripcion, celular, tel_habitacion) values (215,'pablo jose','castillo','arias','san jose','20042011',33333333,66666666);


--tabla instructores
insert into instructores (cod_instructor,nombre,apellido_1,apellido_2,direccion,tel_cel,tel_habitacion,fecha_contratacion)values(100, 'matio','jhoson','ruiz','san jose',11111111,22222222,'01011995');
insert into instructores (cod_instructor,nombre,apellido_1,apellido_2,direccion,e_mail,tel_cel,tel_habitacion,fecha_contratacion)values(101, 'juliana','blackz','arias','alajuela','jul@hotmail.com',22222222,11111111,'01011995');
insert into instructores (cod_instructor,nombre,apellido_1,apellido_2,tel_cel,tel_habitacion,fecha_contratacion)values(102, 'maria','perez','perez',33333333,33333335,'20041998');
insert into instructores (cod_instructor,nombre,apellido_1,apellido_2,direccion,e_mail,tel_cel,tel_habitacion,fecha_contratacion)values(103, 'cristian','castro','ruiz','alajuela','cruiz@gmail.com',44444444,55555555,'20061998');
insert into instructores (cod_instructor,nombre,apellido_1,apellido_2,direccion,e_mail,tel_cel,tel_habitacion,fecha_contratacion)values(104, 'margarita','mata','ruiz','pavas','mmata@yahoo.es',11111112,22222228,'20012000');
insert into instructores (cod_instructor,nombre,apellido_1,apellido_2,e_mail,tel_cel,tel_habitacion,fecha_contratacion)values(105, 'shirley','ruiz','diaz','sruiz@hotmail.com',22222229,33333333,'03022000');
insert into instructores (cod_instructor,nombre,apellido_1,apellido_2,tel_cel,tel_habitacion,fecha_contratacion)values(106, 'cameron','rojas','rojas',88888889,77777777,'20072010');
insert into instructores (cod_instructor,nombre,apellido_1,apellido_2,e_mail,tel_cel,tel_habitacion,fecha_contratacion)values(107, 'patrick','ruiz','diaz','pactrick@hotmail.com',10101010,98989898,'15122011');
insert into instructores (cod_instructor,nombre,apellido_1,apellido_2,tel_cel,tel_habitacion,fecha_contratacion)values(110, 'sharlotte','castillo','paz',99999999,22222233,'03052010');



--tabla cursos
insert into cursos values (1,'yoga');
insert into cursos values (2,'defensa personal');
insert into cursos values (3,'kinboxing');
insert into cursos values (4,'spinnig');
insert into cursos values (5,'taebo');
insert into cursos values (6,'zumba');



--tabla maquinas

insert into maquinas values (50,'pesas','bueno');
insert into maquinas values (51,'mancuernas','excelente');
insert into maquinas values (52,'caminadora','regular');
insert into maquinas values (53,'bicicleta estacionaria','excelente');
insert into maquinas values (54,'bicicleta spinning','bueno');
insert into maquinas values (55,'press de banca','regular');
insert into maquinas values (56,'press de pecho','bueno');

--tabla historial_curso
insert into historial_curso values(1,200,110,6,'20022000',2);
insert into historial_curso values(2,200,101,1,'20022000',2);
insert into historial_curso values(3,205,105,2,'20022000',3);
insert into historial_curso values(4,206,102,3,'03052000',2);
insert into historial_curso values(5,201,101,4,'20072000',4);
insert into historial_curso values(6,208,110,3,'18082000',3);
insert into historial_curso values(7,208,110,1,'18082000',2);
insert into historial_curso values(8,201,110,6,'18082000',1);
insert into historial_curso values(9,210,102,1,'15042007',1);
insert into historial_curso values(10,210,101,4,'15042007',2);
insert into historial_curso values(11,210,105,3,'15042007',1);
insert into historial_curso values(12,212,105,1,'10052008',2);
insert into historial_curso values(13,213,105,2,'10052008',2);
insert into historial_curso values(14,210,105,3,'10052008',2);
insert into historial_curso values(15,201,105,4,'10052008',2);
insert into historial_curso values(16,202,105,5,'10052008',2);

--tabla rutinas
insert into rutinas values(1,209,110,50,'20022000',2);
insert into rutinas values(3,209,101,50,'20022000',2);
insert into rutinas values(5,205,105,55,'20022000',3);
insert into rutinas values(7,215,102,53,'03052000',2);
insert into rutinas values(9,215,101,55,'20072000',4);
insert into rutinas values(11,208,110,56,'18082000',3);
insert into rutinas values(13,208,110,52,'18082000',2);
insert into rutinas values(15,201,110,53,'18082000',1);
insert into rutinas values(17,210,102,55,'15042007',1);
insert into rutinas values(19,210,101,50,'15042007',2);
insert into rutinas values(21,210,107,50,'15042007',1);
insert into rutinas values(23,212,107,51,'10052008',2);
insert into rutinas values(25,213,107,52,'10052008',2);
insert into rutinas values(27,210,107,53,'10052008',2);
insert into rutinas values(29,201,107,54,'10052008',2);
insert into rutinas values(31,202,105,55,'10052008',2);

COMMIT;










