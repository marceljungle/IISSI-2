--Proyecto ZeUS

--Este script contiene las tablas, restricciones, secuencias y triggers asociados a la gestión de secuencias
------------------------------------DROP_TABLES------------------------------------   
      	    DROP TABLE Altavoz;
            DROP TABLE Microfono;
            DROP TABLE otrosItems;
            
            DROP TABLE Transporte;
            DROP TABLE Alojamiento;
            DROP TABLE Envios;
            DROP TABLE Devoluciones;
            DROP TABLE itemAlquilado;
            DROP TABLE materialNecesario;
            
            DROP TABLE Mantenimiento;
            DROP TABLE Inventario;
            DROP TABLE personal;
            DROP TABLE ParteEquipo;
            DROP TABLE Evento;
            DROP TABLE hoteles;
            

------------------------------------TABLAS------------------------------------

            create table Evento (
            eid number(7) primary key,
            precioTotal number(10),
            lugar varchar2(40),
            fechaInicio date,
            fechaFin date,
            constraint fechas check(fechaInicio < fechaFin),
            descripcionCliente varchar2(140),
            estadoEvento varchar2(15) check (estadoEvento in ('Realizado','porRealizar','enPreparacion'))
            );
            
            create table Alojamiento(
            ciudad varchar2(20),
            direccion varchar2(50) primary key,
            fechaInicio date default SYSDATE,
            fechaFin date,
            constraint FECHAALOJ check(fechaInicio < fechaFin),
            hotel varchar2(40),
            numPersonas number(4),
            eid number(7) unique,
            foreign key (eid) references evento
            );
            
            create table parteEquipo(
            peid number(7) primary key,
            eid number(7),
            foreign key(eid) references evento
            );
            
            CREATE TABLE Personal(
            pid number(7) primary key,
            departamento varchar2(10) check(departamento in('Tecnico','Produccion','Almacen','Externo')),
            nombre varchar2(20),
            cargo varchar2(20),
            sueldo number(10) check (sueldo>30),
            dni varchar2(9) unique,
            telefono number(9),
            email varchar2(35) unique,
            pass varchar2(30),
            estado varchar2(7)check (estado in('Libre','Ocupado')),
            eid number(7),
            peid number(7),
            foreign key(eid) references evento,
            foreign key(peid) references parteEquipo
            );

            create table Transporte(
            tid number(7) primary key,
            medioUtilizado varchar2(10),
            numPersonas number(4),
            eid number(7),
            foreign key(eid) references evento
            );

            create table Envios(
            enid number(7) primary key,
            direccion varchar2(30),
            fechaEntrada date,
            fechaSalida date, 
            pid number(7),
            peid number(7) unique,
            constraint FECHAENV check(fechaEntrada > fechaSalida),
            estadoEnvio varchar2(11) check (estadoEnvio in ('porRealizar','enEvento','recibido')),
            foreign key(pid) references personal,
            foreign key (peid) references parteEquipo
            );
            
	    create table materialnecesario(
            mid number(4) primary key,
            nombre varchar2(40),
            tipo varchar2(40),
            cantidad NUMBER(4),
            peid NUMBER(7) REFERENCES parteequipo
            );
					    
            create table itemAlquilado(
            IA number(4),
            tipo varchar2(10),
            nombre varchar2(10),
            Empresa varchar2(10),
            fechaLlegada date default sysdate,
            fechaDevolucion date ,
            constraint FECHAALQ check(fechaLlegada <= fechaDevolucion),
            cantidad number(5),
            precio number(5) check (precio >=0),
            pid number(7),
            peid number(7),
	    mid number(4),
            estado varchar2(11) check (estado in ('porUsar','porDevolver')),
	    foreign key(mid) references materialnecesario,
            foreign key(peid) references parteEquipo
            );
					   
	    create table Devoluciones(
            did number(7) primary key,
            direccion varchar2(30),
            empresa varchar2(30),
            ia number(4) unique,
            pid number(7),
            estadoDevolucion varchar2(11) check (estadoDevolucion in ('porDevolver', 'Devuelto')),
            foreign key(pid) references personal,
            foreign key (ia) references itemAlquilado
            );
            
            create table Inventario(
            referencia number(10) primary key, 
            nombre varchar2(30),
            estadoItem varchar2(20) check (estadoItem in ('Disponible','enEvento','enMantenimiento','porReparar')),
            precio number(20) check (precio>=0),
            peid number(7),
            foreign key(peid) references parteEquipo
            );
            
           create table Altavoz(
            referencia number(10) primary key,
            nombre varchar2(30),
            precio number(20) check (precio>=0),
            potencia number(4),
            pulgadas number(2),
            foreign key(referencia) references inventario on delete cascade
            );
            
            create table Microfono(
            referencia number(10) primary key,
            nombre varchar2(30),
            precio number(20) check (precio>=0),
            alimentacion varchar2(10),
            tipoSujeccion varchar2(10),
            foreign key(referencia) references inventario on delete cascade
            );
            
            create table otrosItems(
            referencia number(10) primary key,
            nombre varchar2(30),
            precio number(20) check (precio>=0),
            foreign key(referencia) references inventario on delete cascade
            );
            
            create table Mantenimiento(
            fechaInicio date,
            pid number(7),
            referencia number(10) unique,
            foreign key(pid) references personal,
            foreign key(referencia) references inventario
            );
            
             create table HOTELES (
             hotel varchar2(40),
             indexHotel number(6),
             primary key (hotel)
             );
            

	     create table HOTELES (
             hotel varchar2(40),
             indexHotel number(6),
             primary key (hotel)
             );





            
------------------------------------Secuencias----------------------------------
--Secuencias para generar los ID de cada empleado según su departamento
--Secuencia para generar la referencia de los ítems
create SEQUENCE sec_item minvalue 1 maxvalue 4999999999 increment by 1 start with 1;
--Secuencia para generar los ID de los envíos
create SEQUENCE sec_envio minvalue 1 maxvalue 9999999 increment by 1 start with 1;
--Secuencia para generar un ID de evento
create SEQUENCE sec_evento minvalue 1 maxvalue 9999999 increment by 1 start with 1;
--Secuencia para generar un ID de parte de equipo
create SEQUENCE sec_parteequipo minvalue 1 maxvalue 9999999 increment by 1 start with 1;
--Secuencia para generar un ID de transporte
create SEQUENCE sec_transporte minvalue 1 maxvalue 999999 increment by 1 start with 1;
--Secuencia para generar un ID de alojamiento
create SEQUENCE sec_alojamiento minvalue 1 maxvalue 999999 increment by 1 start with 1;
--Secuencia para generar un ID de itemalquilado
create SEQUENCE sec_alojamiento minvalue 1 maxvalue 999999 increment by 1 start with 1;
--Secuencia para generar un ID de personal
create SEQUENCE sec_personal minvalue 1 maxvalue 999999 increment by 1 start with 1;



