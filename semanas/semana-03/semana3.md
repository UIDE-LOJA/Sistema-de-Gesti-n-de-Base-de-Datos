
Compendio Exhaustivo sobre Mecanismos de Persistencia y Recuperación de Bases de Datos: Logging, WAL, Checkpoints y ARIES
La administración de bases de datos requiere un conocimiento profundo de los mecanismos de respaldo y recuperación para asegurar la continuidad del negocio y la integridad de la información. La seguridad de la información está estrechamente ligada a los procesos de respaldo y recuperación, que permiten mantener la disponibilidad de los datos incluso después de un fallo. Los temas de Logging, Write-Ahead Log (WAL), Checkpoints y el algoritmo ARIES son fundamentales para garantizar las propiedades ACID, especialmente la Durabilidad y la Atomicidad.
1. Registro de Operaciones (Logging) y Write-Ahead Log (WAL)
El registro de operaciones, o log, es la técnica más habitual para la recuperación ante caídas del sistema. Este registro almacena de forma consecutiva los cambios aplicados a la base de datos y el estado de cada transacción. El log se mantiene en almacenamiento estable (generalmente disco).
1.1 Estructura del Registro y Registros de Log
El log es una secuencia de registros de log que mantiene información sobre las actividades de actualización en la base de datos.
Una entrada de registro de actualización describe una única operación de escritura en la base de datos y debe contener los siguientes campos:
• Identificador de la Transacción.
• Identificador del Elemento de Dato.
• Valor Anterior (V 
1
​
 ).
• Valor Nuevo (V 
2
​
 ).
Además de los registros de actualización, existen registros que marcan el ciclo de vida de una transacción:
• Inicio: <T 
i
​
 start>, para registrar el inicio de la transacción T 
i
​
 .
• Confirmación: <T 
i
​
 commit>, cuando la transacción T 
i
​
  ha finalizado con éxito.
• Aborto/Retroceso: <T 
i
​
 abort>, indicando que la transacción T 
i
​
  ha sido abortada.
1.2 La Regla del Write-Ahead Log (WAL)
El Write-Ahead Log (WAL), conocido también como registro anticipado de escritura o bitácora de compromiso (commit log), es una estructura auxiliar de disco de solo anexión (append-only) utilizada para la recuperación de transacciones y el manejo de caídas del sistema.
La regla fundamental del WAL (write-ahead logging) establece: "Before a block of data in main memory is output to the database, all log records pertaining to data in that block must have been output to stable storage" (Antes de que un bloque de datos en la memoria principal se envíe a la base de datos, todos los registros de log pertenecientes a los datos de ese bloque deben haber sido enviados al almacenamiento estable).
En términos sencillos, el WAL garantiza que los cambios en la base de datos se registren primero en el log antes de que se modifique físicamente la base de datos en el disco. Este mecanismo es significativo porque "By logging changes before they are applied, it enables recovery from crashes and maintains consistency" (Al registrar los cambios antes de que se apliquen, permite la recuperación de caídas y mantiene la consistencia).
Ejemplo visual de WAL en la práctica: La opción WAL en la herramienta EXPLAIN (ANALYZE, VERBOSE, ..., WAL) de PostgreSQL/AlloyDB permite visualizar la actividad del registro de escritura anticipada. Los resultados muestran el impacto en bytes y registros:
( postgres @ 10 . 3 . 1 . 17 : 5432 )   [ postgres ]  >  EXPLAIN   ( ANALYZE , VERBOSE ,   ...   BUFFERS ,   WAL )   select   *   from   public . effective_io_concurrency_test ;
...
WAL :   records = 18   bytes = 5178   
...
Esta información de WAL incluye la cantidad de registros y bytes leídos del WAL para mantener la coherencia.
2. Recuperación Basada en el Log y ARIES
La recuperación se basa en dos técnicas principales: modificación diferida o inmediata de la base de datos.
1. Modificación Diferida: Las operaciones de escritura solo se anotan en el log. Las escrituras físicas en el disco solo se realizan cuando la transacción es parcialmente comprometida (justo antes de ser marcada como comprometida). Si ocurre un fallo en medio de estas escrituras, la transacción se puede deshacer.
2. Modificación Inmediata: Las escrituras físicas en el disco se realizan inmediatamente después de que se anota la operación en el log, incluso antes de que la transacción se confirme.
ARIES: Algoritmo de Recuperación (State-of-the-Art)
ARIES (Algorithm for Recovery and Isolation Exploiting Semantics) es un "state of the art recovery method" (método de recuperación de última generación). Está diseñado para optimizar los procesos de recuperación.
ARIES se diferencia de los modelos de recuperación simplificados en varios aspectos:
• Utiliza Log Sequence Numbers (LSN) para identificar cada registro del log. Estos LSN se almacenan en las páginas de datos para rastrear qué actualizaciones ya se aplicaron.
• Utiliza Compensation Log Records (CLRs) para registrar las acciones realizadas durante la fase de undo (deshacer) que no necesitan ser deshechas nuevamente.
• Utiliza estructuras de datos específicas como la DirtyPageTable.
El algoritmo ARIES se realiza en tres fases consecutivas ante una caída del sistema:
1. Fase de Análisis (Analysis pass): El sistema escanea el log desde el último registro de checkpoint (punto de control). Durante esta fase, se determinan tres puntos clave:
    ◦ Qué transacciones quedaron incompletas (necesitan deshacerse).
    ◦ Qué páginas en el buffer estaban "sucias" (no actualizadas en el disco) al momento de la caída, utilizando la tabla DirtyPageTable.
    ◦ El RedoLSN (el LSN a partir del cual debe comenzar la fase de Redo).
2. Fase de Rehacer (Redo pass): Esta fase "Repeats history" (Repite la historia) al aplicar todas las acciones registradas en el log desde el punto RedoLSN. El propósito es llevar la base de datos al estado que tenía exactamente en el momento de la caída, incluyendo tanto los cambios confirmados como los no confirmados.
3. Fase de Deshacer (Undo pass): En esta fase, el sistema "Rolls back all incomplete transactions" (deshace todas las transacciones incompletas). Se escanea el log hacia atrás, realizando el proceso de undo (retroceso) en los registros de log de las transacciones que no finalizaron (las que están en la lista undo-list obtenida en la fase de análisis).
Ejemplo Visual del Proceso de Recuperación de ARIES: El proceso de tres pases de ARIES se puede ilustrar en el tiempo de la siguiente manera, donde el log es escaneado en ambas direcciones a partir del último punto de control:
Tiempo
Log
Antiguo
...
Último checkpoint
⟵ Análisis
Final del Log (Crash!)
⟶ Redo pass (Repite la historia)
Nuevo
⟵ Undo pass (Deshace transacciones incompletas)
(Nota: Se ha omitido la imagen ya que no es posible reproducir con precisión el diagrama de flujo específico de ARIES en texto, pero la descripción de los tres pases cumple la función de ejemplo del proceso.)
3. Puntos de Control (Checkpoints)
Un punto de control (checkpoint) es un evento que ayuda a sincronizar la caché de buffer de la base de datos con los archivos de datos en el disco. Su función principal es reducir el trabajo necesario durante la recuperación tras un fallo, limitando la cantidad de registros del log que deben ser examinados y rehechos.
• Propósito: Los puntos de control actúan como un marcador de sincronización.
• Mecanismo (Oracle/Similar): El proceso Checkpoint (CKPT) es responsable de indicar al Database Writer (DBWR) que "escriba en los archivos de datos todos los bloques del buffer de datos que se hayan modificado desde el último punto de control". También se encarga de actualizar las cabeceras de los archivos de datos, Redo Logs y archivos de control con el número de punto de control.
• En ARIES: Los puntos de control se loguean e incluyen la DirtyPageTable (páginas modificadas en memoria) y la lista de transacciones activas. A diferencia de otros sistemas, ARIES no escribe las páginas sucias inmediatamente al hacer el checkpoint; estas se vacían continuamente en segundo plano, manteniendo el checkpoint como una operación de baja sobrecarga.
4. Recuperación Ante Fallos (Crash Recovery)
La recuperación ante fallos es un componente crítico de la administración de bases de datos. El objetivo es garantizar que la base de datos se restablezca a un estado consistente, asegurando que las transacciones confirmadas persistan y que las no confirmadas sean revertidas.
Narrativamente, podemos entender la recuperación como un proceso de volver a la normalidad después de un evento inesperado, ya sea un fallo de la transacción, un deadlock, un error de software/hardware, o un fallo catastrófico.
El mecanismo general de recuperación en sistemas como Oracle se basa en el log de Redo y los segmentos de Rollback:
“Para resolver esta situación, Oracle realiza dos pasos: rehacer y deshacer (rolling forward y rolling back)”.
4.1 Fases de Recuperación (Redo y Undo)
• Rehacer (Rolling Forward / Redo): Este paso consiste en "Volver a aplicar a los archivos de datos todas las modificaciones guardadas en el archivo de registro de operaciones". En Oracle, el Monitor del Sistema (SMON) tiene como objetivo principal ejecutar las tareas de inicialización y recuperación de una instancia de base de datos, siendo responsable de aplicar los archivos redo logs y recuperar la información que ha sido confirmada por el usuario. Después de esta fase, los archivos de datos contienen todos los cambios (confirmados y no confirmados) que estaban en el log.
• Deshacer (Rolling Back / Undo): Tras la fase de redo, se utilizan los segmentos de rollback para identificar y deshacer (undo) aquellas transacciones que no se llegaron a validar (no confirmadas). En caso de fallos de proceso de usuario (como una desconexión anormal), el Process Monitor (PMON) detecta el error y "deshace los cambios de la transacción actual de usuario, libera los bloqueos de tablas y filas actuales, y libera otros recursos".
4.2 Ejemplo de Recuperación en Oracle
Un proceso de Recuperación Completa en Oracle (cuando solo fallan archivos de datos y hay redundancia de logs) ilustra claramente las fases:
1. Restauración: Recuperar el respaldo más reciente del archivo de datos.
2. Redo: Aplicar los cambios efectuados de las últimas transacciones usando los archivos redo logs (Redo aplicado). Los archivos de datos contendrán ahora cambios confirmados y no confirmados.
3. Apertura: Abrir la base de datos (etapa OPEN).
4. Undo: Aplicar las rutinas de undo (rollback) para los datos no confirmados.
5. Recuperación Exitosa: Los archivos de datos son recuperados y son consistentes con todo el sistema.
Diagrama de Estados de Recuperación de una Base de Datos Oracle (Recuperación Automática): La recuperación en sistemas como Oracle sigue una secuencia de estados (NOMOUNT → MOUNT → OPEN).
graph TD
    A[Inicio] --> B{Cargar configuración de respaldos};
    B --> C{Verificar datos del servidor redundante};
    C --> D{Verificar existencia de respaldo completo de base de datos};
    D -- Éxito --> E[Iniciar la base de datos en estado NOMOUNT FORCE];
    E --> F[Reiniciar la base de datos y cambiar a estado NOMOUNT];
    F --> G[Cambiar el estado de la base de datos a MOUNT];
    G --> H[Recuperar base de datos];
    H --> I[Cambiar el estado de la base de datos a OPEN];
    I --> J{Generar bitácora de proceso};
    D -- Error --> K{Generar bitácora de errores};
    K --> L[Enviar notificaciones];
    L --> Fin;
    J --> Fin;

    subgraph Proceso de Recuperación
        E --> R1[Restaurar el archivo de parámetros de la base de datos];
        F --> R2[Restaurar el archivo de control de la base de datos];
        G --> R3[Restaurar base de datos];
    end
(Fuente adaptada: Figura 5.6. Diagrama de estados de recuperación de base de datos, en ESPOL)
En esta secuencia, la etapa NOMOUNT es crucial para la recuperación del archivo de parámetros, y luego se pasa al estado MOUNT, donde se localizan los archivos de control y se identifica el repositorio de respaldos. Finalmente, en la etapa OPEN, el SMON realiza la recuperación automática aplicando los redo logs.
Referencias Bibliográficas (APA)
Las referencias se basan en la documentación proporcionada:
FdI. (s.f.). 7. Transacciones y control de la concurrencia. Google Cloud. (s.f.). Cómo obtener y analizar los planes de explicación de AlloyDB. IONOS. (2024). ¿Qué es una base de datos relacionales? - IONOS. MALLA REDDY COLLEGE OF ENGINEERING & TECHNOLOGY. (s.f.). DATABASE MANAGEMENT SYSTEMS LECTURE NOTES. SEDICI. (s.f.). Técnicas de control de concurrencia en base de datos: implementación en un sistema de gestión. UNIVERSIDAD DE GUADALAJARA. (s.f.). 1. datos generales de la unidad de aprendizaje (ua) o asignatura. Universitat de València. (2006/07). Conceptos sobre procesamiento de transacciones. Universitat de València. (2006/07). Técnicas de control de concurrencia. UAL. (s.f.). Práctica 3. Desarrollo de bases de datos con ORACLE. Wikipedia. (s.f.). Aislamiento (ACID) - Wikipedia, la enciclopedia libre. ESPOL. (s.f.). Facultad de Ingeniería en Electricidad y Computación - DSpace en ESPOL. ESPOL. (s.f.). DSpace en ESPOL - Escuela Superior Politécnica del Litoral. Gestores de base de datos. (s.f.). Gestores de base de datos pdf. SIU. (s.f.). Trabajo Final de Grado: - SIU.