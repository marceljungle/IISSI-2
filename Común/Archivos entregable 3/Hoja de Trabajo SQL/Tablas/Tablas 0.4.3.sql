------------------------------------VERSI�N 0.4.2------------------------------------   
--Este script contiene las tablas y drop tables pertenecientes a los subsistemas de producci�n, almac�n y t�cnico.
--Respecto a la versi�n anterior:
  --Correcci�n de foreign keys de algunas tablas
  --Adici�n de constraints para fechas
  --Asignaci�n de claves candidatas para algunas tablas
  --Correcci�n del orden de creaci�n y borrado de las tablas
  --Adicion de inserts
------------------------------------DROP_TABLES------------------------------------   
            DROP TABLE Altavoces;
            DROP TABLE Ordenador;
            DROP TABLE Cable;
            DROP TABLE Proyector;
            DROP TABLE Foco;
            DROP TABLE mesaMezcla;
            DROP TABLE Pantalla;
            DROP TABLE Microfono;
            
            
            DROP TABLE Transporte;
            DROP TABLE Alojamiento;
            DROP TABLE itemAlquilado;
            DROP TABLE Envios;
            DROP TABLE Mantenimiento;
            DROP TABLE Inventario;
            DROP TABLE personal;
            DROP TABLE ParteEquipo;
            DROP TABLE Evento;
            
           
            
            
            
  
           
  

------------------------------------TABLAS_IMPORTANTES------------------------------------


            create table Evento (
            eid number(5) primary key,
            precioTotal number(10),
            lugar varchar2(40),
            fechaInicio date,
            fechaFin date,
            constraint fechas check(fechaInicio < fechaFin),
            descripcionCliente varchar2(140),
            estadoEvento varchar2(15) check (estadoEvento in ('realizado','porRealizar'))
            );
            

            
            create table Alojamiento(
            ciudad varchar2(20),
            direccion varchar2(50) primary key,
            fechaInicio date default SYSDATE,
            fechaFin date,
            constraint FECHAALOJ check(fechaInicio < fechaFin),
            hotel varchar2(40),
            numPersonas number(4)
            );
            
            create table parteEquipo(
            peid number(4) primary key,
            referencia number(10),
            eid number(5),
            foreign key(eid) references evento
            );
            
            CREATE TABLE personal(
            pid number(7) primary key,
            departamento varchar2(10) check(departamento in('Tecnico','Produccion','Almacen','Comercial','Externo')),
            nombre varchar2(20),
            cargo varchar2(20),
            sueldo number(10) check (sueldo>20),
            dni varchar2(9) unique,
            telefono number(9),
            estado varchar2(7)check (estado in('Libre','Ocupado')),
            eid number(5),
            peid number(4),
            foreign key(eid) references evento,
            foreign key(peid) references parteEquipo
            );

            create table Transporte(
            tid number(5) primary key,
            medioUtilizado varchar2(10),
            numPersonas number(4),
            direccion varchar2(50),
            foreign key(direccion) references alojamiento
            );

            create table Inventario(
            referencia number(10) primary key,
            nombre varchar2(30),
            estadoItem varchar2(20) check (estadoItem in ('disponible','enEvento','enMantenimiento','por reparar')),
            precio number(20) check (precio>=0),
            peid number(4),
            pid number(5),
            foreign key(peid) references parteEquipo,
            foreign key(pid) references personal
            );
            
            create table Envios(
            enid number(14) primary key,
            direccion varchar2(30),
            fechaEntrada date,
            fechaSalida date, 
            pid number(5),
            constraint FECHAENV check(fechaEntrada < fechaSalida),
            estadoEnvio varchar2(11) check (estadoEnvio in ('porRealizar','enEvento','recibido')),
            foreign key(pid) references personal
            );
            
            create table itemAlquilado(
            tipo varchar2(10),
            nombre varchar2(10),
            Empresa varchar2(10) not null,
            fechaLlegada date default sysdate,
            fechaDevolucion date not null,
            constraint FECHAALQ check(fechaLlegada <= fechaDevolucion),
            cantidad number(5),
            precio number(5) check (precio >=0),
            pid number(4),
            envid number(14),
            peid number(4),
            enid number(14),
            foreign key(peid) references parteEquipo,
            foreign key(enid) references envios
            );
          
            create table Mantenimiento(
            fechaInicio date,
            fechaFin date,
            pid number(5),
            constraint FECHAMAN check(fechaInicio < fechaFin),
            foreign key(pid) references personal
            );







------------------------------------TABLAS_MENOS_IMPORTANTES------------------------------------


            create table Altavoces(
            potencia number(4),
            referencia number(10),
            pulgadas number(2),
            foreign key(referencia) references inventario
            );
            
            create table Microfono(
            alimentacion varchar2(7),
            tipoSujeccion varchar2(10),
            referencia number(10),
            foreign key(referencia) references inventario
            );
            
            create table Pantalla(
            tama�o number(3),
            resolucion number(4),
            referencia number(10),
            foreign key(referencia) references inventario
            );
            
            create table mesaMezcla(
            canales number(2),
            tipo varchar2(10),
            referencia number(10),
            foreign key(referencia) references inventario
            );
            
            create table Foco(
            tipoLuz varchar2(20),
            tipoMovimimiento varchar2(7),
            potencia number(5),
            referencia number(10),
            foreign key(referencia) references inventario
            );
            
            create table Proyector(
            resolucion number(4),
            lumenes number(5),
            referencia number(10),
            foreign key(referencia) references inventario
            );
            
            create table Cable(
            conexion varchar2(6),
            metros number(4),
            referencia number(10),
            foreign key(referencia) references inventario
            );
            
            create table Ordenador(
            procesador varchar2(15),
            gbram number(3),
            referencia number(10),
            foreign key(referencia) references inventario
            );

------------------------------------INSERTACION_DE_VALORES------------------------------------
insert into PERSONAL values(1,'Tecnico','Antonio Laguna','Informatico',1500,'14526234J',634634573,'Ocupado',1,1);
insert into PERSONAL values(2,'Tecnico','Mariano Jimenez','Electricista',1600,'45225675H',666342573,'Ocupado',2,2);
insert into PERSONAL values(3,'Tecnico','Maria Dolores Crespo','Electricista',1700,'14256234K',665895245,'Ocupado',1,1);
insert into PERSONAL values(4,'Almacen','Antonio Tallon','Mozo de Almacen',1200,'57426723J',665236745,'Ocupado',null,null);

insert into EVENTO values(1,25000,'Plaza Espa�a',TO_DATE('2019/05/03 19:00:00','yyyy/mm/dd hh24:mi:ss'),TO_DATE('2019/05/04 00:00:00','yyyy/mm/dd hh24:mi:ss'),'Evento en conmemoracion del decimo aniversario de Murillo','porRealizar');
insert into EVENTO values(2,20000,'Hospital Virgen del Rocio',TO_DATE('2019/03/20 10:40:00','yyyy/mm/dd hh24:mi:ss'),TO_DATE('2019/03/20 12:30:00','yyyy/mm/dd hh24:mi:ss'),'Evento cirugia didactica para los alumnos','porRealizar');

insert into PARTEEQUIPO values(1,371647381,1);
insert into PARTEEQUIPO values(2,345727475,2);

insert into ALOJAMIENTO values('Sevilla','Avenida Merico,N�3',TO_DATE('2019/05/02 16:00:00','yyyy/mm/dd hh24:mi:ss'), TO_DATE('2019/05/05 16:00:00','yyyy/mm/dd hh24:mi:ss'),'Hotel Reina Sofia',5);
insert into ALOJAMIENTO values('Sevilla','Calle Tajo,N�45',TO_DATE('2019/03/19 16:00:00','yyyy/mm/dd hh24:mi:ss'), TO_DATE('2019/03/21 16:00:00','yyyy/mm/dd hh24:mi:ss'),'Hotel Carlos III',6);

insert into TRANSPORTE values(1,'Furgoneta',2,'Avenida Merico,N�3');

insert into MANTENIMIENTO values();

insert into INVENTARIO values(1,'altavoz estero','enEvento',50,1,3);
insert into INVENTARIO values(2,'Cable Coaxial','enEvento',25,1,3);
insert into INVENTARIO values(3,'Foco Light++','enEvento',30,1,3);
insert into INVENTARIO values(4,'Mesa Mezcla X-PRO','enEvento',150,1,1);
insert into INVENTARIO values(5,'Microfono Artix','enEvento',100,1,3);
insert into INVENTARIO values(6,'Ordenador PCcom','enMantenimiento',1150,null,4);
insert into INVENTARIO values(7,'Pantalla Nvidia 4K','disponible',950,null,null);
insert into INVENTARIO values(8,'Proyector Philips','por reparar',100,1,4);

insert into ALTAVOCES values (150,1,23);
insert into CABLE values('XLR',5,2);
insert into FOCO values('LED','Movil',100,3);
insert into MESAMEZCLA values(5,'Analogica',4);
insert into MICROFONO values('Phantom','Solapa',5);
insert into ORDENADOR values('Intel i9 9900K',16,6);
insert into PANTALLA values(23,2160,7);
insert into PROYECTOR values(2160,5000,8);