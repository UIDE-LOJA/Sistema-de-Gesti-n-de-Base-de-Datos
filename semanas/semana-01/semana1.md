Compendio Exhaustivo sobre Sistemas de Gestión de Bases de Datos (SGBD)
Revisión de Conceptos Básicos de SGBD
Definición y Propósito de un SGBD
Un Sistema Gestor de Bases de Datos (SGBD), también conocido como DBMS (por sus siglas en inglés, Database Management System), es definido como "una colección de datos relacionados entre sí, estructurados y organizados, y un conjunto de programas que acceden y gestionan esos datos". El SGBD es un software que facilita la administración de una base de datos, proporcionando el método de organización necesario para el almacenamiento y la recuperación flexible de grandes cantidades de información.
La Base de Datos (BD), por su parte, es la colección de datos interrelacionados utilizada para representar información relevante de un sistema o de una organización que se desea almacenar para su posterior consulta o actualización. En este contexto, es importante recordar que los datos son hechos conocidos que pueden registrarse, mientras que la información es el conjunto organizado de datos que ya han sido procesados y contextualizados, constituyendo un mensaje que modifica el estado de conocimiento del sujeto o sistema.
Los SGBD tienen el objetivo de fungir como interfaz entre la base de datos, los usuarios y las aplicaciones. Antes de su aparición, la información se gestionaba con sistemas de archivos convencionales que presentaban inconvenientes significativos, como la redundancia e inconsistencia de datos, problemas de integridad y atomicidad, y dificultades en el acceso concurrente.
Funcionalidades Clave de un SGBD
Los SGBD ofrecen un conjunto de herramientas indispensables para la gestión eficiente y segura de los datos, asegurando la preservación de la integridad y seguridad.
Entre las funciones principales de un SGBD se encuentran:
1. Definición de Datos: Esto implica "especificar los tipos de datos, estructuras y restricciones sobre los mismos". La definición de la base de datos se almacena en el Diccionario de Datos, que es una guía que describe la BD y los objetos que la componen.
2. Manipulación de Datos: Incluye herramientas para consultar y actualizar los datos y sus estructuras. Esto se realiza a través de Lenguajes de Manipulación de Datos (LMD o DML), que permiten realizar consultas, inserciones, eliminaciones y modificaciones.
3. Compartición y Concurrencia: Permite que la base de datos pueda manipularse de forma simultánea por diferentes usuarios o programas. Los SGBD son sistemas concurrentes y deben incluir protocolos que garanticen la propiedad de aislamiento de las transacciones.
4. Protección y Mantenimiento: Asegura la protección de la integridad de la base de datos ante fallas de hardware o software, incluyendo la seguridad contra accesos no autorizados. Esto incluye mecanismos de respaldo y recuperación para restablecer la información en caso de fallos.
Arquitectura: Componentes y Funcionalidades
Arquitectura de Tres Niveles (ANSI-SPARC)
La arquitectura de los sistemas de bases de datos más aceptada es la propuesta por el comité ANSI-SPARC (American National Standard Institute - Standards Planning and Requirements Committee) en 1975, cuyo objetivo principal es "el de separar los programas de aplicación de la BD física". Esta arquitectura describe los datos a tres niveles de abstracción:
1. Nivel Interno o Físico: Este es el nivel más bajo de abstracción y describe cómo se almacenan realmente los datos. Emplea un modelo físico de datos y es el único nivel donde los datos existen realmente.
2. Nivel Lógico o Conceptual: Describe la estructura de toda la base de datos para una comunidad de usuarios. Este esquema "describe las entidades, atributos, relaciones, operaciones de los usuarios y restricciones, ocultando los detalles de las estructuras físicas de almacenamiento". Los SGBD deben asegurar que una transacción, partiendo de un estado consistente, deje la BD en un estado también consistente.
3. Nivel Externo o de Vistas: Describe la parte de la BD a la que los usuarios pueden acceder. Puede haber varios esquemas externos o vistas de usuario, cada uno describiendo la visión que tiene un grupo de usuarios, ocultando el resto de la base de datos.
La implementación de esta arquitectura busca la independencia de los datos (física y lógica). La independencia lógica implica que los cambios realizados en los objetos de la base de datos no deben repercutir en los programas y usuarios que acceden a la misma. El SGBD es el encargado de transformar las peticiones y resultados entre estos tres niveles, un proceso denominado correspondencia o transformación.
Componentes Generales del SGBD
Un SGBD es un paquete de software muy complejo compuesto por varios subsistemas para manejar la definición, manipulación, control y generación de aplicaciones. Los componentes principales incluyen:
• Motor de la Base de Datos: Acepta peticiones lógicas de otros subsistemas, las convierte a su equivalente físico y accede a la base de datos y al diccionario.
• Intérprete o Procesador del Lenguaje: Procesa las sentencias de los lenguajes de base de datos (LDD/DDL y LMD/DML).
• Optimizador de Consultas: Su función es realizar la optimización de cada pregunta y elegir el plan de actuación más eficiente para su ejecución.
• Mecanismo de Almacenamiento: Traduce las operaciones a un lenguaje de bajo nivel para acceder a los datos.
• Motor de Transacciones: Gestiona la ejecución de transacciones para asegurar la corrección y fiabilidad.
Componentes Arquitectónicos Específicos (Ejemplo Oracle)
En sistemas comerciales robustos como Oracle, la arquitectura se divide en la Instancia y la Base de Datos propia. Una instancia de base de datos es "un conjunto de programas y de estructuras de memoria que permiten la gestión sobre la base de datos".
La arquitectura de Oracle incluye estructuras de memoria principales como el Área Global del Sistema (SGA) y el Área Global del Programa (PGA).
Componentes de Memoria (SGA):
• Búfer Caché de la Base de Datos: "Guarda temporalmente los datos mas recientemente consultados por los usuarios de base de datos".
• Búfer de Registro de Operaciones (Redo Log Buffer): "Guarda un registro de las modificaciones realizadas sobre la base de datos".
• Memoria Compartida (Shared Pool): Guarda temporalmente las sentencias SQL más usadas por los usuarios de la base de datos.
Procesos de Fondo (Background Processes):
Los procesos de fondo mantienen la relación entre las estructuras físicas y de memoria. Ejemplos incluyen:
• Database Writer (DBWR): "Escribe en los archivos de datos los bloques modificados a partir del búfer de la base de datos".
• Log Writer (LGWR): Escribe en disco las entradas del registro de operaciones.
• System Monitor (SMON): Realiza la recuperación de instancias durante el inicio de una instancia.
• Process Monitor (PMON): Recupera procesos cuando falla un proceso de usuario.
Tipos: Relacionales, Orientados a Objetos, NoSQL
1. Bases de Datos Relacionales (SQL)
El modelo relacional fue postulado por Edgar Frank Codd en 1970, basado en la lógica de predicados y la teoría de conjuntos. Es el modelo más utilizado en la actualidad.
Características:
• Estructura Tabular Rígida: La información se organiza en relaciones o tablas, compuestas por filas (registros o tuplas) y columnas (atributos). Las relaciones entre tablas se imponen mediante el uso de claves foráneas.
• Esquema Fijo: Trabajan con un esquema predefinido y estricto, que debe respetarse para garantizar la integridad.
• Lenguaje Estándar: Utiliza SQL (Structured Query Language) para consultar y manipular los datos.
Propiedades ACID:
Las bases de datos relacionales tradicionales (RDBMS) manejan un conjunto de propiedades definidas por el acrónimo ACID, cruciales para garantizar la confiabilidad.
"Los sistemas de administración de bases de datos relacionales (RDBMS) tradicionales manejan un conjunto de propiedades definidas por el acrónimo ACID (por sus siglas en inglés) que significan Atomicidad (Atomicity), Consistencia (Consistency), Aislamiento (Isolation) y Durabilidad (Durability).".
El aislamiento (Isolation) es una de las cuatro propiedades ACID y define cómo y cuándo los cambios producidos por una operación se hacen visibles para otras operaciones concurrentes.
Ventajas y Desventajas:
Las bases de datos relacionales son ideales para sistemas que requieren una fuerte consistencia de datos, como las transacciones financieras y los sistemas ERP/CRM. Sin embargo, presentan deficiencias con datos gráficos, multimedia, CAD y sistemas de información geográfica.
Ejemplos comunes de SGBD relacionales incluyen Oracle Database, Microsoft SQL Server, PostgreSQL y MySQL.
2. Bases de Datos Orientadas a Objetos (BDOO)
El modelo orientado a objetos surge a finales de la década de 1980 debido a las "limitaciones del modelo relacional, sobre todo a la hora de abordar tipos de datos más complejos" y por la necesidad de una mayor capacidad semántica en aplicaciones específicas.
Concepto y Principios:
Una BDOO es un sistema de gestión en el que la información se representa en forma de objetos, al igual que en la programación orientada a objetos. Los objetos almacenan datos, conexiones con otros objetos y comportamientos (métodos).
Los principios de la Programación Orientada a Objetos (POO), como la encapsulación, la herencia y el polimorfismo, son fundamentales en la organización y manipulación de los datos en las BDOO.
• Persistencia de objetos: Los objetos de lenguajes de POO (como Java o C++) se almacenan directamente, sin necesidad de convertirlos a tablas o registros.
• Aislamiento de los datos: El único acceso a los datos guardados es mediante los métodos definidos previamente, protegiéndolos de cambios no autorizados.
Aplicaciones y Ejemplos:
Las BDOO son útiles en aplicaciones que manejan datos complejos y heterogéneos, como sistemas de información geográfica (SIG), aplicaciones multimedia, y en investigaciones científicas.
Para interactuar con el sistema, se utiliza un lenguaje de consultas como OQL (Object Query Language), que está influenciado por el SQL y se basa en la manipulación de objetos.
Ejemplos de BDOO incluyen Db4o, ObjectDB y Versant Object Database. Existe el estándar ODMG (Object Database Management Group) que define un modelo de objetos y lenguajes como ODL y OQL para estas bases de datos.
3. Bases de Datos No Relacionales (NoSQL)
El término NoSQL ("no solo SQL") se refiere a una amplia clase de sistemas de gestión de bases de datos no relacionales que surgieron como alternativa al SGBDR tradicional. Los sistemas NoSQL crecieron con la necesidad de manejar grandes volúmenes de datos y la escalabilidad requerida por las principales redes sociales y aplicaciones web en tiempo real.
Arquitectura y Propiedades BASE:
A diferencia de los SGBD relacionales, los sistemas NoSQL:
1. Esquema Dinámico: No requieren esquemas fijos ni rígidos, permitiendo una mayor flexibilidad en la definición de esquemas, ya que la responsabilidad de la estructura recae en la aplicación y no en el motor de la base de datos.
2. Escalabilidad Horizontal: Están diseñadas para escalar horizontalmente (distribución entre múltiples nodos o sharding), utilizando clusters distribuidos de hardware de bajo costo para aumentar el desempeño.
3. Teorema CAP: El modelo NoSQL no siempre garantiza las propiedades ACID, sino que a menudo prioriza la disponibilidad y la tolerancia de partición. Por lo general, siguen las propiedades BASE (Basically Available, Soft state, Eventual consistency). La consistencia eventual significa que los datos pueden no ser inmediatamente consistentes en todos los nodos, pero lo serán con el tiempo.
Tipos de Bases de Datos NoSQL:
Las bases de datos NoSQL se clasifican según su forma de almacenar los datos:
Tipo de Base de Datos
Estructura Principal
Ejemplos
Uso Principal
Clave/Valor
Almacenamiento mediante estructuras con dos componentes: una clave única y un valor.
Redis, Amazon DynamoDB, Cassandra.
Almacenar sesiones de usuario, carritos de compras.
Orientadas a Documentos
Los datos se almacenan en colecciones de documentos, generalmente en formatos semiestructurados como JSON o XML.
MongoDB, CouchDB, RavenDB.
Big Data de alta variabilidad, gestión de contenidos, análisis en tiempo real.
Orientadas a Columnas (Familias de Columnas)
El almacenamiento se realiza por columnas, donde una fila de datos corresponde a un grupo de valores para un mismo atributo.
Cassandra, HBase.
Almacenamiento de datos a gran escala.
Orientadas a Grafos
Los datos se representan utilizando estructuras de grafos: nodos, aristas y propiedades.
Neo4j, OrientDB, JanusGraph.
Aplicaciones donde la interrelación entre los datos es fundamental, como redes sociales o topologías de red.
Comparativa con Bases de Datos Relacionales (Narrativa de Contraste):
Las tecnologías NoSQL no son un reemplazo para las bases de datos SQL, sino un modelo diferente que ofrece ventajas en escenarios donde las bases de datos relacionales fallan. Mientras que SQL ofrece un esquema fijo y cumplimiento ACID, lo que lo hace más rápido para aplicaciones transaccionales donde la consistencia es crucial (banca, sistemas ERP), NoSQL ofrece un esquema flexible y escalamiento horizontal, ideal para grandes conjuntos de datos, IoT y redes sociales, donde la alta disponibilidad es la prioridad.

--------------------------------------------------------------------------------
Referencias Bibliográficas
A continuación, se presenta un listado de referencias en formato APA basado en las fuentes proporcionadas:
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
