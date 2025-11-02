Compendio Exhaustivo: Transacciones, Propiedades ACID, Control de Concurrencia y Técnicas de Bloqueo
1. Conceptos de Transacciones
En el contexto de las bases de datos, la transacción se define como "una unidad de la ejecución de un programa" que puede estar compuesta por varias operaciones de acceso a la base de datos. Es un "conjunto de operaciones que se realizan como una sola unidad lógica de trabajo", y es esencial en los sistemas transaccionales (OLTP, On-Line Transaction Processing).
La responsabilidad de la transacción es garantizar que se "lleve a una BD de un estado consistente a otro diferente". El usuario o programador es quien debe decidir cuáles operaciones compondrán la transacción para asegurar la coherencia de la información.
El ciclo de vida de una transacción incluye varias operaciones registrables:
• inicio_t (Inicio de la transacción).
• leer (Lectura de gránulo y valor).
• escribir (Escritura de gránulo, valor escrito y valor anterior).
• fin_t (Fin de la transacción).
• confirmar (Commit).
• abortar (Abort).
Una transacción puede pasar por varios estados:
Estado
Descripción
Activa
Estado inicial.
Parcialmente confirmada
Se llega después de ejecutar todas las instrucciones.
Confirmada
Si todas las operaciones se superan con éxito y su efecto queda registrado en la BD.
Abortada
Si la transacción no tiene efecto alguno sobre el sistema, volviendo al estado original.
Ejemplo Visual: Estados de una Transacción
El flujo de una transacción es crucial para asegurar que, si hay fallos, el sistema sepa cómo reaccionar, llevando a la transacción de un estado activo, a través de lecturas y escrituras, a un estado final de confirmación o aborto:
stateDiagram
    direction LR
    Active: Activa
    PartiallyCommitted: Parcialmente confirmada
    Committed: Confirmada
    Aborted: Abortada
    
    Active --> PartiallyCommitted: fin_t
    Active --> Aborted: abortar
    PartiallyCommitted --> Committed: confirmar
    PartiallyCommitted --> Aborted: abortar
2. Propiedades ACID
Las bases de datos, especialmente las relacionales, deben cumplir con un conjunto de propiedades conocidas como ACID (Atomicidad, Consistencia, Aislamiento, Durabilidad). El Sistema de Gestión de Bases de Datos (SGBD) debe asegurar el cumplimiento de estas propiedades.
Narrativamente, las propiedades ACID son "propiedades que aseguran el procesamiento confiable de las transacciones de bases de datos".
A. Atomicidad (Atomicidad)
La atomicidad garantiza que una transacción es tratada como "una unidad atómica de trabajo; se completa totalmente o no se completa en absoluto". La fuente indica que esta propiedad "permite observarlas como operaciones atómicas: ocurren totalmente o no ocurren". Si alguna parte de la transacción falla, la transacción entera falla.
En esencia, la atomicidad asegura que "una transacción o se ejecuta completamente o no tiene efecto alguno". Esta responsabilidad recae en el subsistema de recuperación del SGBD.
C. Consistencia (Consistency)
La consistencia garantiza que una transacción "sólo lleva a la base de datos de un estado válido a otro". Se espera que "la ejecución aislada de la transacción conserva la consistencia de la base de datos".
Esta propiedad implica que, al finalizar la transacción, "debe dejar todos los datos en un estado coherente". La consistencia también implica que se deben aplicar todas las reglas de negocio y restricciones de integridad (como la integridad referencial) a las modificaciones realizadas.
I. Aislamiento (Isolation)
El aislamiento es la propiedad que define "cómo y cuándo los cambios producidos por una operación se hacen visibles para las demás operaciones concurrentes". El objetivo del aislamiento es que los efectos de una transacción no se vean influenciados por otras transacciones concurrentes. Una transacción "debe ejecutarse como si fuera la única transacción que estuviera ejecutándose en la BD en ese preciso momento".
El aislamiento es la propiedad ACID que se "relaja" con mayor frecuencia en los SGBDs. A mayor grado de aislamiento, se logra mayor precisión, pero a expensas de una menor concurrencia.
Niveles de Aislamiento
El nivel de aislamiento se ajusta para determinar "para una transacción el grado de aceptación de datos inconsistentes". El nivel de aislamiento para una sesión SQL establece el comportamiento de los bloqueos para las instrucciones SQL.
Algunos niveles de aislamiento comunes son:
1. Serializable: El nivel más estricto. Las transacciones concurrentes se ejecutan de tal manera que el resultado es equivalente a alguna ejecución serial.
2. Lecturas Repetibles (Repeatable Reads): Mantiene bloqueos de lectura y escritura hasta el final de la transacción. Sin embargo, "las lecturas fantasma pueden ocurrir" si no se gestionan los bloqueos de rango.
3. Lecturas Comprometidas (Read Committed): Mantiene bloqueos de escritura hasta el final, pero los bloqueos de lectura se cancelan tan pronto como termina la operación SELECT. Esto permite el efecto de las "lecturas no repetibles".
4. Lecturas No Comprometidas (Read Uncommitted): El nivel más bajo, que permite a una transacción leer filas que han sido modificadas por otra transacción que aún no ha confirmado (Lecturas Sucias).
Ejemplo de Problema de Concurrencia (Lecturas No Repetibles)
Una lectura no repetible ocurre cuando, durante el curso de una transacción, se lee una fila dos veces y los valores obtenidos no son los mismos, lo cual resulta "¡Extraño!".
Tiempo
T1 (Transacción 1)
T2 (Transacción 2)
Dato A (Inicial = 100)
T1: Inicio
lee(a) (A=100)
100
T2: Inicio
lee(a) (A=100)
100
a:=a+1 (A=101 en T2)
100 (Aún no confirmado)
escribe(a) (A=101)
101
COMMIT
101
T1: Siguiente paso
lee(a) (A=101)
101
muestra(a) (Muestra 101)
101
En este caso, la transacción T 
1
​
  lee el valor 100 al inicio y luego el valor 101 (cambiado por T 
2
​
 ), manifestando el problema de lecturas no repetibles.
D. Durabilidad (Durability)
La durabilidad, también conocida como permanencia, "asegura que una vez que una transacción es confirmada, las modificaciones son registradas permanentemente". Es responsabilidad del subsistema de recuperación del SGBD garantizar este requisito.
3. Control de Concurrencia y Técnicas de Bloqueo
En los sistemas multiusuario, es fundamental el control de concurrencia. El uso de transacciones concurrentes (interleaving) "exige la concurrencia de transacciones en BD multiusuario" para un mejor aprovechamiento de los recursos y una reducción en los tiempos de respuesta.
El objetivo de los sistemas de control de concurrencia es garantizar la consistencia al realizar las diferentes transacciones en una Base de Datos. La ejecución concurrente de varias transacciones es correcta solo si su efecto es el mismo que si se ejecutaran secuencialmente en cualquier orden (esto se llama secuencialidad o serializabilidad). Un planificador es el componente que arbitra los conflictos de acceso.
Existen dos clasificaciones principales de técnicas de control de concurrencia:
A. Control de Concurrencia Pesimista (Técnicas de Bloqueo)
Las técnicas más utilizadas para controlar el acceso concurrente se basan en el concepto de bloquear elementos de datos. El bloqueo es "una información del tipo de acceso que se permite a un elemento".
El SGBD impone los bloqueos necesarios en cada momento para prevenir la interacción destructiva entre usuarios que acceden a los mismos datos.
Granularidad del Bloqueo
La granularidad se refiere al tamaño de las unidades de datos (elementos) a las que se controla el acceso, como una relación, una tupla, un campo o un bloque.
• A mayor granularidad, menor concurrencia.
• Un sistema de granularidad múltiple permite varios niveles, lo que es una buena opción.
Ejemplos de niveles de granularidad incluyen:
• Fila (fila individual).
• Página (unidades de 8KB).
• Table (tabla completa).
• Database (base de datos completa).
Tipos de Bloqueo (Modos)
Los tipos de bloqueo dependen del tipo de operación:
Tipo de Bloqueo
Modo
Acceso Permitido
Propósito
Compartido (Shared, S)
Solo lectura.
Permite lecturas concurrentes.
Se utiliza para operaciones solo de lectura.
Exclusivo (Exclusive, X)
Lectura y escritura.
Solo permite que una transacción adquiera el bloqueo.
Se utiliza para operaciones que escriben datos.
Actualización (Update, U)
Temporal.
Solo una transacción puede adquirirlo.
Se utiliza para operaciones que pueden escribir; si modifica datos, se convierte en exclusivo.
Intención (Intention, I)
Varios modos (IS, IX, SIX).
Se usan para establecer una jerarquía de bloqueo.
Permite a una transacción bloquear un elemento a un nivel grueso si necesita un bloqueo específico en un nivel más fino.
Protocolo de Bloqueo en Dos Fases (2PL)
Aunque el uso de bloqueos por sí solo no asegura la serializabilidad, el Protocolo de Bloqueo en Dos Fases (2PL) es fundamental para garantizarla.
El requisito del 2PL es que "todos los bloqueos preceden a los desbloqueos". Una transacción de dos fases se divide en dos etapas:
1. Fase de Expansión (o de Crecimiento): Se pueden adquirir nuevos bloqueos, pero no se puede liberar ninguno.
2. Fase de Contracción: Se pueden liberar todos los bloqueos existentes, pero no se pueden adquirir nuevos bloqueos.
"Si S es cualquier planificación de transacciones de dos fases, S es secuenciable".
Existen variaciones de 2PL, como el B2F estricto, que "no libera ningún bloqueo exclusivo hasta después de confirmar o abortar".
Interbloqueo (Deadlock)
El protocolo de dos fases no asegura la ausencia de interbloqueos.
El interbloqueo es "una situación en la que los gránulos han sido bloqueados en una secuencia tal que un grupo de transacciones que no pueden seguir porque están esperando a las otras". Un deadlock ocurre cuando, por ejemplo, T 
1
​
  bloquea el elemento A y luego intenta bloquear B, mientras que T 
2
​
  bloquea B y luego intenta bloquear A. Ambas esperan indefinidamente.
Una forma de detectar un interbloqueo es mediante la existencia de un ciclo en un grafo de esperas.
Ejemplo de Código que Causa Interbloqueo (Deadlock)
Una secuencia de acciones que resulta en un interbloqueo es:
Transacción T 
1
​
 
Transacción T 
2
​
 
LOCK A;
LOCK B;
LOCK B; (Espera T 
2
​
  libere B)
LOCK A; (Espera T 
1
​
  libere A)
En este punto, T 
1
​
  espera B (que tiene T 
2
​
 ), y T 
2
​
  espera A (que tiene T 
1
​
 ).
B. Control de Concurrencia Optimista (Protocolos Basados en Validación o Marcas Temporales)
Las técnicas optimistas se aplican "cuando los conflictos entre las transacciones son raros" y buscan "evitar los costosos bloqueos".
1. Protocolos Optimistas de Validación: Esta técnica asume que todas las transacciones finalizarán con éxito. Las actualizaciones se realizan primero en memoria local de la transacción. Solo cuando la transacción intenta confirmarse (commit), se lleva a cabo la fase de validación.
    ◦ Si la validación es exitosa (no se viola la secuencialidad), se pasa a la fase de escritura en la base de datos.
    ◦ Si hay conflicto, la transacción se aborta y debe volverse a iniciar.
2. Protocolos Basados en Marcas Temporales (Timestamps): Estos se usan para asegurar la secuencialidad sin imponer bloqueos. A cada transacción (T 
i
​
 ) se le asocia una marca temporal (MT(T 
i
​
 )), que se asigna en el orden en que las transacciones entran al sistema (usando un contador o el reloj del sistema).
    ◦ Cada elemento de datos (D) lleva asociado dos marcas: MTR(D) (mayor marca de las transacciones que leyeron con éxito) y MTW(D) (mayor marca de las transacciones que escribieron con éxito).
    ◦ El protocolo de ordenación por marcas temporales procesa las operaciones conflictivas según este orden, asegurando la serializabilidad y la ausencia de interbloqueos (porque ninguna transacción espera).
Referencias Bibliográficas (Formato APA)
Arduino, G., & Alfonzo, P. L. (s.f.). Técnicas de control de concurrencia en base de datos: implementación en un sistema de gestión. SEDICI.
Astera Software. (s.f.). SQL vs. NoSQL: diferencias, ventajas y casos de uso.
Bookey. (s.f. a). Database Internals PDF. (Fragmentos de notas de clase).
Bookey. (s.f. b). Nosql Distilled PDF. (Resumen del Capítulo 16).
Dongee. (s.f.). Domina la Arquitectura de 3 Niveles en Bases de Datos: Una Guía Completa.
Escuela Superior Politécnica del Litoral. (s.f.). DSpace en ESPOL (Fragmentos sobre Data Warehouse).
FD I. (s.f. a). 7. Transacciones y control de la concurrencia.
FD I. (s.f. b). Tema 2. Diseño de bases de datos relacionales.
Google Cloud. (s.f.). Cómo obtener y analizar los planes de explicación de AlloyDB.
Grupo Editorial RA-MA. (s.f.). Gestión de Bases de Datos (Tabla de contenidos y extractos).
IONOS Digitalguide. (2024). ¿Qué es una base de datos relacionales?.
MALLA REDDY COLLEGE OF ENGINEERING & TECHNOLOGY. (s.f.). DATABASE MANAGEMENT SYSTEMS LECTURE NOTES (Unidad 2).
OneNine. (s.f.). Cómo analizar y reducir el tiempo de ejecución de consultas.
portalinstitutos. (s.f.). Tecnicatura Superior en... (Fragmentos de Ejes de Contenidos).
Slideshare. (2018). Glosario base de datos [DOCX]. (Presentado por Juan David Sandoval Balaguera).
UAL. (s.f.). Práctica 3. Desarrollo de bases de datos con ORACLE.
UNIVERSIDAD DE GUADALAJARA. (s.f.). Excerpts from "1. datos generales de la unidad de aprendizaje (ua) o asignatura".
Universitat de València. (2006/07 a). Conceptos sobre procesamiento de transacciones. (Tema 3: Bases de Datos II, Esther de Ves, Vicente Cerverón).
Universitat de València. (2006/07 b). Técnicas de control de concurrencia. (Tema 4: Bases de Datos II, Esther de Ves, Vicente Cerverón).
UPN. (s.f.). FACULTAD DE INGENIERÍA (Fragmentos de revisión sistemática).
Wikipedia, la enciclopedia libre. (s.f. a). Aislamiento (ACID).
Wikipedia, la enciclopedia libre. (s.f. b). Sistema de gestión de bases de datos.