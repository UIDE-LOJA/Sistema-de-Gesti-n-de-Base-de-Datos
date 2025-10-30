# Sistemas de Gestión de Bases de Datos - Semana 1

## Contexto Curricular y Objetivos

### Ubicación en el Programa
Esta semana establece los **cimientos conceptuales** para todo el curso de SGBD.

**Ruta de Aprendizaje:**
- **Semana 1 (Actual):** Fundamentos de SGBD - Arquitectura, componentes y modelos de datos
- **Semana 2:** Modelo Relacional - SQL básico y operaciones
- **Unidades 2-4:** Temas Avanzados - Diseño, normalización, optimización

### Objetivos de Aprendizaje

**Competencias Conceptuales:**
- **Definir** qué es un SGBD y su propósito
- **Explicar** la arquitectura ANSI-SPARC
- **Identificar** componentes principales
- **Distinguir** modelos de datos

**Competencias Prácticas:**
- **Mapear** arquitecturas de SGBD
- **Comparar** modelos relacionales vs NoSQL
- **Analizar** casos de uso específicos
- **Evaluar** ventajas y desventajas

---

## 1. Arquitectura de SGBD

### 1.1 Definición y Propósito
Un **Sistema Gestor de Bases de Datos (SGBD)** es una colección de datos relacionados entre sí, estructurados y organizados, y un conjunto de programas que acceden y gestionan esos datos.

**Objetivo Principal:**
Fungir como **interfaz entre la base de datos, los usuarios y las aplicaciones**, proporcionando el método de organización necesario para el almacenamiento y la recuperación flexible de grandes cantidades de información.

### 1.2 Arquitectura de Tres Niveles (ANSI-SPARC)

La arquitectura más aceptada fue propuesta por el comité **ANSI-SPARC** en 1975, con el objetivo de **separar los programas de aplicación de la BD física**.

#### Nivel Interno o Físico
Es el **nivel más bajo de abstracción** y describe cómo se almacenan realmente los datos.
- Emplea un **modelo físico de datos**
- Es el **único nivel donde los datos existen realmente**
- Gestiona estructuras de almacenamiento físico
- Controla índices, archivos y métodos de acceso

#### Nivel Lógico o Conceptual
Describe la **estructura de toda la base de datos** para una comunidad de usuarios.
- Describe **entidades, atributos, relaciones**
- Define **operaciones y restricciones**
- Oculta detalles de estructuras físicas
- Asegura **consistencia transaccional**

#### Nivel Externo o de Vistas
Describe la **parte de la BD a la que los usuarios pueden acceder**.
- Puede haber **varios esquemas externos**
- Cada vista describe la **visión de un grupo de usuarios**
- Oculta el resto de la base de datos
- Proporciona **seguridad y personalización**

### 1.3 Independencia de Datos

**Beneficios de la Arquitectura de Tres Niveles:**
- **Independencia Lógica:** Los cambios en objetos de BD no afectan programas y usuarios
- **Correspondencia:** El SGBD transforma peticiones y resultados entre niveles

---

## 2. Componentes del SGBD

### 2.1 Componentes Principales
Un SGBD es un **paquete de software complejo** compuesto por varios subsistemas que trabajan coordinadamente.

**Componentes principales:**
- **👥 Usuarios/Aplicaciones** → **🖥️ Interfaz de Usuario**
- **⚙️ Procesador de Consultas** → **🔧 Motor de BD**
- **💾 Base de Datos** ← **👨‍💼 Administrador DBA** → **🛠️ Herramientas de Admin**

### 2.2 Funciones Principales del SGBD

Un SGBD debe proporcionar **funciones esenciales** para la gestión eficiente y segura de los datos.

#### Gestión de Datos
- **Almacenamiento físico** eficiente
- **Organización de archivos** e índices
- **Gestión de espacio** en disco
- **Compresión** y optimización

#### Procesamiento de Consultas
- **Análisis sintáctico** de SQL
- **Optimización** de consultas
- **Ejecución** eficiente
- **Gestión de resultados**

#### Control y Seguridad
- **Autenticación** y autorización
- **Integridad referencial**
- **Control de concurrencia**
- **Auditoría** y logging

#### Administración
- **Backup y recovery**
- **Monitoreo** de rendimiento
- **Mantenimiento** automático
- **Gestión de usuarios**

### 2.3 Arquitectura Cliente/Servidor

**Modelo de Distribución Básico:**
- **💻 Cliente/Aplicación** → **🌐 Red/Comunicación** → **🖥️ Servidor/SGBD** → **💾 Base de Datos**

**Cliente:**
- Interfaz de usuario
- Aplicaciones de usuario
- Herramientas de consulta
- Interfaces gráficas

**Servidor:**
- Motor de BD
- Procesamiento de consultas
- Gestión de transacciones
- Control de concurrencia

### 2.4 Arquitectura Cliente/Servidor Detallada

**Modelo de Distribución Avanzado:**
- **📱 Aplicaciones Móviles/Web** → **🌐 Red Internet/LAN**
- **🛠️ Herramientas de Admin** → **🌐 Red Internet/LAN**
- **🖥️ Interfaces de Usuario** → **🌐 Red Internet/LAN**
- **🌐 Red Internet/LAN** → **⚙️ Motor SGBD/Servidor** → **💾 Base de Datos**
---

## 3. Modelos de Datos

### 3.1 Clasificación General

Los modelos de datos definen **cómo se estructuran, almacenan y manipulan los datos** en un sistema de gestión de bases de datos.

**Tipos principales:**
- **🏛️ Relacional:** Estructura Tabular - SQL, ACID, Esquema Fijo
- **📄 Documental:** Documentos JSON/XML - NoSQL, BASE, Esquema Flexible

### 3.2 Modelo Relacional
Postulado por **Edgar Frank Codd en 1970**, basado en la lógica de predicados y la teoría de conjuntos. Es el modelo más utilizado en la actualidad.

#### Características Principales:

**Estructura Tabular Rígida:**
La información se organiza en **relaciones o tablas**, compuestas por filas (registros) y columnas (atributos)

**Esquema Fijo:**
Trabajan con un **esquema predefinido y estricto** que debe respetarse para garantizar la integridad

**Lenguaje Estándar:**
Utiliza **SQL (Structured Query Language)** para consultar y manipular los datos

#### Propiedades ACID

Las bases de datos relacionales manejan un conjunto de propiedades definidas por el acrónimo **ACID**, cruciales para garantizar la confiabilidad.

- **⚛️ Atomicity:** Todo o nada
- **✅ Consistency:** Estado válido
- **🔒 Isolation:** Transacciones independientes
- **💾 Durability:** Persistencia garantizada

### 3.3 Modelo Documental (NoSQL)

El término **NoSQL ("no solo SQL")** se refiere a sistemas de gestión de bases de datos no relacionales que surgieron como alternativa al SGBDR tradicional.

#### Características Principales:

**Esquema Dinámico:**
No requieren **esquemas fijos ni rígidos**, permitiendo mayor flexibilidad

**Escalabilidad Horizontal:**
Diseñadas para **escalar horizontalmente** usando clusters distribuidos

**Almacenamiento de Documentos:**
Los datos se almacenan en **documentos JSON/XML** con estructura flexible

#### Propiedades BASE

Los sistemas NoSQL siguen las propiedades **BASE** en lugar de ACID, priorizando disponibilidad y tolerancia de partición.

**ACID (Relacional) → BASE (NoSQL):**
- **⚛️ Atomicity** → **🌐 Basically Available** (Alta Disponibilidad)
- **✅ Consistency** → **⏰ Eventual Consistency** (Consistencia Eventual)
- **🔒 Isolation** → **🔄 Soft State** (Estado Flexible)
- **💾 Durability** → **🌐 Basically Available** (Alta Disponibilidad)

**Propiedades BASE:**
- **🌐 Basically Available:** El sistema está básicamente disponible la mayor parte del tiempo
- **🔄 Soft State:** El estado del sistema puede cambiar con el tiempo
- **⏰ Eventual Consistency:** Los datos serán consistentes eventualmente, no inmediatamente

### 3.4 Comparación: Relacional vs Documental
| Aspecto | Modelo Relacional | Modelo Documental |
|---------|-------------------|-------------------|
| **Estructura** | Tablas con filas y columnas | Documentos JSON/XML |
| **Esquema** | Fijo y predefinido | Flexible y dinámico |
| **Escalabilidad** | Vertical (más potencia) | Horizontal (más nodos) |
| **Consistencia** | ACID - Inmediata | BASE - Eventual |
| **Casos de Uso** | Transacciones financieras, ERP | Big Data, IoT, redes sociales |

#### Ejemplos de Implementación

**SGBD Relacionales:**
- Oracle Database
- Microsoft SQL Server
- PostgreSQL
- MySQL

**SGBD Documentales:**
- MongoDB
- CouchDB
- Amazon DynamoDB
- RavenDB

---

## Síntesis y Conclusiones

### Conceptos Fundamentales Consolidados

**Arquitectura y Estructura:**
- Los **SGBD** son sistemas complejos con arquitectura de **tres niveles**
- La **independencia de datos** es clave para la flexibilidad
- Los **componentes** trabajan coordinadamente

**Modelos y Aplicaciones:**
- **Modelo relacional:** ACID, estructura rígida
- **Modelo documental:** BASE, flexibilidad
- Cada modelo tiene **casos de uso específicos**

### Continuidad del Aprendizaje

Los fundamentos estudiados en esta semana son la **base para temas avanzados**:

**Próxima Semana:**
- Modelo relacional detallado
- SQL y operaciones básicas
- Diseño de esquemas

**Unidades Futuras:**
- Normalización y diseño
- Transacciones y concurrencia
- Optimización y rendimiento

### Fundamentos Consolidados

✅ **Arquitectura ANSI-SPARC** comprendida
✅ **Componentes del SGBD** identificados
✅ **Modelos de datos** comparados

---

## Referencias (Formato APA)
Amra, N., & Bedoya, H. (2014). Modernizing IBM i Applications from the Database up to the User Interface and Everything in Between. IBM ReadBooks.
Anderson, M., Fox, J., & Bolton, C. (2010). Microsoft SQL Server 2008 Administration for Oracle DBAs. McGraw-Hill Osborne Media.
Antaño, A. C. M., Castro, J. M. M., & Valencia, R. E. C. (2014). Migración de Bases de Datos SQL a NoSQL. Revista Tlamati, Especial, 3, 144-148.
Astera Equipo de análisis. (2025). SQL vs. NoSQL: 5 diferencias principales. Astera Software.
Ayala, J. (2015). Fundamentos de bases de datos. Recuperado de http://ri.uaemex.mx/bitstream/handle/20.500.11799/33944/secme-19274.pdf?sequence.
Caqui Vargas, J. G., & Pareja Limaco, J. P. (2018). ESTUDIO COMPARATIVO ENTRE LAS BASES DE DATOS RELACIONAL Y NO RELACIONALES: UNA REVISIÓN DE LA LITERATURA CIENTÍFICA. (Trabajo de investigación para optar el grado de Bachiller en Ingeniería de Sistemas Computacionales). Facultad de Ingeniería - UPN.
Castro Romero, A., & González Sanabria, J., & Callejas Cuervo, M. (2012). Utilidad y funcionamiento de las bases de datos NoSQL. Facultad de Ingeniería, 21(33), 21-32.
Del Giudice, G., & Della Mea, M. (s.f.). Trabajo Final de Grado. SIU.
Dongee. (2023). Domina la Arquitectura de 3 Niveles en Bases de Datos: Una Guía Completa.
Elmasri, R., & Navathe, S. B. (2011). Sistemas de bases de datos. Pearson.
Gaimil Villarreal, L. A. (2017). Bases de datos relacionales y no relacionales.
Gómez, J. (2007). Base de datos.
Herrera, H. A., & Valenzuela, C. R. (2016). NoSQL, la nueva tendencia en el manejo de datos. Tecnología Investigación y Academia, 4(1), 147-150.
IONOS Digitalguide. (2022). Introducción al sistema gestor de base de datos (SGBD).
IONOS Equipo editorial. (2024). Bases de datos relacionales.
Jaramillo Valbuena, S., & Londoño, J. M. (2014). Sistemas para almacenar grandes volúmenes de datos. En R. Llamosa Villalba (Ed.). Revista Gerencia Tecnológica Informática, 13(37), 17-28.
Juárez, F. R. (2006). Definición de Base de Datos.
Merchán Millán, C. M. (2019). Arquitectura de Bases de Datos Relacionales. (Tesis de Grado). Facultad de Ingeniería en Electricidad y Computación - ESPOL.
Moreno Arboleda, F. J., Quintero Rendón, J. E., & Rueda Vásquez, R. (2016). Una comparación de rendimiento entre Oracle y MongoDB. Ciencia e Ingeniería Neogranadina, 26(1), 109-129.
Mosquera, J. (2024). BDOO Bases de Datos Orientadas a Objetos: Ejemplos. jhonmosquera.com.
Nayak, A., Poriya, A., & Poojary, D. (s.f.). Type of NOSQL Databases and its Comparison with Relational Databases.
Núñez Hervas, R. (2023). Gestión de Bases de Datos. Grupo Editorial RA-MA.
Oppel, A. (2011). Fundamentos de bases de datos. McGrawn Hill.
Orbegozo Arana, B. (2015). Curso práctico avanzado de PostgreSQL: la base de datos más potente. Alfaomega.
Ramez, E., & Navathe, S. B. (2011). Sistemas de bases de datos. Pearson.
Sadalage, P. & Fowler, M. (2013). NoSQL Distilled, A Brief Guide to the Emerging World of Polyglote. Persistence. Addison Wesley.
SGBD. (2006). Gestores de base de datos pdf. (Rolando Delgado Escobar, Ed.).
Silverschatz, A., Korth, H.F., & Sudarshan, S. (1998). Fundamentos de bases de datos. (3ª ed.). McGraw-Hill.
Sistema de gestión de bases de datos. (s.f.). En Wikipedia, la enciclopedia libre. Recuperado de https://es.wikipedia.org/w/index.php?title=Sistema_de_gestión_de_bases_de_datos&oldid=169119499.
Técnicas de control de concurrencia. (2006/07). Técnicas de control de concurrencia. Universitat de València.
Técnicas de control de concurrencia en base de datos: implementación en un sistema de gestión. (s.f.). SEDICI.
Valderrey Sanz, P. (2011). Gestión de bases de datos. Starbook.
València, U. de. (2006/07). Conceptos sobre procesamiento de transacciones.
