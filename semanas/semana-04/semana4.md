Compendio Exhaustivo sobre Optimización de Consultas en Bases de Datos: Estadísticas, Índices y Planes de Ejecución
La optimización del rendimiento es una tarea primordial en la administración de bases de datos, que busca transformar operaciones lentas en procesos eficientes y sin complicaciones. Las técnicas clave para lograr este objetivo se centran en el uso de estadísticas, la implementación adecuada de índices y el análisis riguroso de los planes de ejecución.

--------------------------------------------------------------------------------
1. Estadísticas y Selectividad
El optimizador de consultas (o planificador de consultas) es un componente crucial del Sistema de Gestión de Bases de Datos (SGBD) cuya función principal es determinar la forma más eficiente de ejecutar una consulta SQL determinada. Para tomar esta decisión, el optimizador debe analizar las consultas entrantes y seleccionar el plan de ejecución más adecuado, basándose en la información que posee sobre la distribución de los datos, es decir, las estadísticas internas.
La precisión de estas estadísticas es vital. Si las estadísticas están obsoletas, el optimizador generará un plan de ejecución deficiente.
La respuesta a qué es un optimizador de consultas es que este analiza las consultas entrantes para eliminar redundancias y encontrar el plan de ejecución más eficiente basándose en estadísticas internas. Es crucial para mejorar el rendimiento general de la base de datos (Database Internals PDF - Bookey, s.f., Pregunta 11).
Para mantener la eficacia del sistema, se requieren comandos de mantenimiento regulares, como ANALYZE (mencionado en el contexto de PostgreSQL), que ayudan a mantener las estadísticas actualizadas, permitiendo así que el optimizador de consultas cree mejores planes. Una señal de que las estadísticas pueden estar desactualizadas es una discrepancia significativa entre el número de filas estimado y el número de filas real en el plan de ejecución.
Aunque la selectividad no se define explícitamente en las fuentes proporcionadas, el concepto está inherentemente ligado al filtrado de datos. El plan de ejecución muestra métricas como Rows Removed by Filter (Filas Eliminadas por Filtro), que "Indica cuántas filas fueron descartadas por el filtro". Una alta selectividad (pocas filas resultantes después de la aplicación de filtros) generalmente se logra mediante el uso de índices adecuados.

--------------------------------------------------------------------------------
2. Índices y su Impacto en el Costo
Los índices son estructuras de datos que se definen sobre uno o más campos de una tabla con el fin de proporcionar un acceso más eficiente a los datos. Un índice permite al SGBD buscar un valor específico y la dirección física de un registro en el archivo de datos, lo cual es mucho más rápido que realizar un escaneo secuencial (lectura de todas las filas una por una).
Beneficios y Tipos de Índices
El uso de índices adecuados es una estrategia fundamental de optimización que puede acelerar significativamente las búsquedas. Los índices deben agregarse a las columnas que se utilizan frecuentemente en las cláusulas WHERE, JOIN y ORDER BY.
La falta de índices es una causa común de consultas lentas, ya que activa escaneos completos de tablas (Seq Scan o Full Table Scan).
El modelo relacional impone restricciones de integridad, y "Todas las claves primarias llevan asociado un índice de forma predeterminada".
La tabla a continuación resume algunos tipos de índices comunes y sus mejores casos de uso (adaptado de Cómo analizar y reducir el tiempo de ejecución de consultas - OneNine, s.f., tabla de tipos de índices):
Tipo de índice
Mejor caso de uso
Impacto en el rendimiento
Clave primaria
Identificación de registros únicos
Acelera las búsquedas
Compuesto
Consultas con múltiples columnas
Maneja condiciones complejas de manera eficiente
Cubierta
Incluye todas las columnas requeridas
Elimina la necesidad de acceso a la tabla
El Costo de Ejecución y la Optimización I/O
El "costo estimado" es una métrica fundamental en el análisis de planes, utilizada por el optimizador para comparar diferentes estrategias de ejecución de consultas. Este costo se expresa en unidades arbitrarias basadas en el consumo de recursos, principalmente E/S (Entrada/Salida) y CPU.
El recurso más costoso que consume una consulta es, típicamente, el disco (I/O), debido a la latencia que implican las operaciones de lectura y escritura. Los índices reducen este costo:
Los índices permiten disminuir el tiempo de entrada/salida a disco. Por un lado porque los índices no requieren en general una exploración secuencial de sus registros hasta encontrar el valor deseado, sino que se organizan como estructuras que permiten localizar el valor en menos tiempo. Por otro lado, cuando se recorre el índice se hace sobre registros pequeños, en comparación con los registros más grandes que contiene el fichero de datos; por lo tanto, el número de accesos a disco es menor (Tema 2. Diseño de bases de datos relacionales - FdI, s.f., 2.4 Diseño físico).
Sin embargo, el uso de índices conlleva un costo de mantenimiento. "Si se declara un índice, ese índice se debe mantener actualizado cada vez que la tabla sufra cualquier modificación". Si se definen demasiados índices, el rendimiento de las operaciones de escritura puede reducirse significativamente.

--------------------------------------------------------------------------------
3. Planes de Ejecución (EXPLAIN/ANALYZE)
Los planes de ejecución son la herramienta esencial para el DBA (Administrador de Bases de Datos) y los desarrolladores para diagnosticar problemas de rendimiento. Un plan de ejecución "es una representación detallada de cómo el motor de base de datos... pretende ejecutar una consulta en SQL".
Funcionamiento de EXPLAIN y EXPLAIN ANALYZE
El proceso de optimización de consultas típicamente incluye la Planificación de Ejecución, donde se crea un plan detallado de cómo se ejecutará la consulta.
1. EXPLAIN: Este comando muestra el plan que el optimizador ha generado para una consulta (el plan previsto), sin realmente ejecutarla.
2. EXPLAIN ANALYZE: Esta opción no solo genera el plan previsto, sino que ejecuta la consulta y reporta las estadísticas de ejecución reales, incluyendo tiempos de ejecución reales, recuentos de filas y uso de recursos. Se recomienda evitar su uso en producción sobre consultas pesadas, ya que ejecuta la instrucción.
Los planes de ejecución se estructuran típicamente en forma de árbol. Las pautas generales para su lectura son: los íconos representan operadores (acciones específicas) y se leen de derecha a izquierda, de arriba abajo.
Algunos datos clave que proporciona el resultado de EXPLAIN incluyen:
• Nodos del plan: Representan los diferentes pasos en la ejecución (escaneo de tablas, uniones, ordenamiento, etc.).
• Costo: Se muestra como cost = 0.00..X. El primer número es el costo de recuperar la primera fila, y el segundo es el costo de recuperar la última fila.
• Filas estimadas vs. reales: La cantidad estimada de filas que se cree que la operación afectará, comparada con el número real de filas. Una gran diferencia puede indicar problemas de estadísticas obsoletas.
• Tiempo de ejecución: Incluye el Planning Time (tiempo que tardó el optimizador en generar el plan) y el Execution Time (tiempo real total de la ejecución).
• Tipo de escaneo: Si es Seq Scan (secuencial, ineficiente sin filtros) o Index Scan (uso de índice, eficiente).
Ejemplo Práctico Usando MySQL
Para analizar cómo MySQL ejecuta una consulta, simplemente se agrega el comando EXPLAIN antes de la sentencia SQL. A continuación, se presenta un ejemplo utilizando la sintaxis de MySQL, que puede ejecutarse y visualizarse a través de herramientas como MySQL Workbench (aunque las fuentes no especifican la interfaz visual de Workbench, la sintaxis SQL es compatible con MySQL 8.0).
Código SQL para analizar un plan:
Supongamos una tabla usuarios con un índice en edad. Queremos ver el plan de ejecución para una consulta que filtre por edad.
-- Ejemplo de EXPLAIN en MySQL
EXPLAIN SELECT id, nombre, edad 
FROM usuarios 
WHERE edad > 30 AND nombre LIKE 'A%';
Si el motor de base de datos es MySQL (como se indica en Cómo se utiliza EXPLAIN en MySQL, s.f., en Google Cloud), el comando EXPLAIN devolverá información detallada sobre los pasos.
ID
Select Type
Table
Partitions
Type
Possible Keys
Key
Key Len
Ref
Rows
Filtered
Extra
1
SIMPLE
usuarios
NULL
range
idx_edad, idx_nombre
idx_edad
4
NULL
15000
10.00
Using index condition; Using where
(Nota: Este ejemplo de tabla de salida es ilustrativo para la sintaxis de MySQL. El plan de ejecución de MySQL proporciona información sobre "Cómo MySQL planea ejecutar la consulta, a qué tablas accederá y cómo, si se están utilizando índices, y el número estimado de filas que examinará").
Si se deseara obtener estadísticas de tiempo de ejecución real (similar a EXPLAIN ANALYZE en PostgreSQL), se puede utilizar la variante que proporciona el tiempo de ejecución (aunque la sintaxis exacta puede variar por versión de MySQL y cliente, o usarse comandos adicionales como ANALYZE TABLE o herramientas de perfilado). El objetivo de este análisis es verificar si se están utilizando los índices correctos y si la estimación de filas es cercana a la realidad.

--------------------------------------------------------------------------------
Referencias Bibliográficas
DBA24. (s.f.). Explain Plan en PostgreSQL: Análisis, Optimización y Herramientas. DBA24.
FdI. (s.f.). Tema 2. Diseño de bases de datos relacionales. FdI.
Google Cloud. (s.f.). Cómo obtener y analizar los planes de explicación de AlloyDB.
OneNine. (s.f.). Cómo analizar y reducir el tiempo de ejecución de consultas. OneNine.
Orbegozo Arana, B. (2015). Curso práctico avanzado de PostgreSQL: la base de datos más potente. Alfaomega.
SEDICI. (s.f.). Técnicas de control de concurrencia en base de datos: implementación en un sistema de gestión.
Universitat de València. (2006/07). Conceptos sobre procesamiento de transacciones. BD2 - Tema 3.
UNIVERSIDAD DE GUADALAJARA. (s.f.). datos generales de la unidad de aprendizaje (ua) o asignatura.
Wikipedia. (s.f.). Modelo relacional. Wikipedia, la enciclopedia libre.
Wikipedia. (s.f.). Sistema de gestión de bases de datos. Wikipedia, la enciclopedia libre.

--------------------------------------------------------------------------------
Aclaración sobre la Referencia de MySQL: La fuente proporcionó directamente la sintaxis de EXPLAIN en MySQL, lo que permitió generar el ejemplo. Si bien las fuentes se centraron en PostgreSQL/AlloyDB para el detalle de las métricas de ANALYZE, los principios de costos e índices aplican universalmente en SGBD relacionales.