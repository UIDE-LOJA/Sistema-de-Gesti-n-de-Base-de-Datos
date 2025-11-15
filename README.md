# Universidad Internacional del Ecuador

## SISTEMA DE ASEGURAMIENTO INTERNO DE CALIDAD

### MACROPROCESO GESTIÓN ACADÉMICA

**Versión:** 1.1

### PROCESO GESTIÓN DE ENSEÑANZA - APRENDIZAJE

Los cursos indicados con el logotipo de ASU indican cursos que se complementan con el contenido y los materiales del curso de ASU. El curso se impartirá en todas las sedes de la UIDE.

---

## Escuela de Ciencias de la Computación

### Ingeniería en Tecnologías de la Información

# SÍLABO DE LTI_05A_300 Sistemas de Gestión de Base de Datos

---

## DATOS INFORMATIVOS

**Código y Nombre de la Asignatura:** LTI_05A_300 Sistemas de Gestión de Base de Datos

**Número de horas componente docencia:** 1

**Número de horas componente de prácticas de aplicación y experimentación de los aprendizajes:** 1

**Número de horas de aprendizaje autónomo:** 1

**Número de créditos de asignatura:** 1

**Nivel al que pertenece la asignatura:** 3

**Periodo académico ordinario:** octubre 2025 – febrero 2026

**Estructura curricular:**

* ☐ Unidad Básica
* ☒ Unidad profesional
* ☐ Unidad de integración curricular


**Prerrequisito(s):** LTI_05A-200 - Estructura, Modelado, Almacenamiento de Bases de Datos

**Correquisito(s):** Ninguno

**Número de sesiones:** 16 horas / 16 semanas

**Horario de clases:** jueves, 08:00 – 10:00

**Horario de tutorías:** lunes, 10:00 – 12:00; viernes, 08:00 – 09:00

---

## DESCRIPCIÓN Y COMO APORTA AL PERFIL PROFESIONAL

La asignatura "Sistemas de Gestión de Base de Datos" está diseñada para formar a los estudiantes en técnicas avanzadas y complejas de administración de sistemas de bases de datos, incluyendo el control de concurrencia, la recuperación ante fallos, la optimización de consultas y estrategias sofisticadas de particionamiento. Los estudiantes desarrollarán habilidades rigurosas para el uso de herramientas especializadas en monitoreo y análisis de rendimiento, la formulación de políticas de respaldo efectivas, y la evaluación crítica de los planes de ejecución de consultas, con énfasis en la eficiencia y la escalabilidad.

Al finalizar la asignatura, el estudiante estará en capacidad de:

1. Aplicar técnicas avanzadas de control de concurrencia, recuperación ante fallos y optimización de consultas.

2. Implementar estrategias de particionamiento, administración de almacenamiento e índices.

3. Diseñar políticas efectivas de respaldo en los SGBD

4. Utilizar herramientas especializadas de monitoreo y análisis de rendimiento.

5. Evaluar planes de ejecución de consultas.

---

## DATOS GENERALES DEL DOCENTE

**Nombre del Profesor:** Charlie Alexander Cárdenas Toledo

**Grado Académico:** Magister en Ciencias y Tecnologías de la Computación

**e-mail:** chcardenasto@uide.edu.ec

**Teléfono fijo:** (07) 258-4567

**Teléfono móvil:** +593980762456

---

## LUGAR DONDE SE EMITE EL DOCUMENTO

**Nombre del Coordinador/a Académico:** Mgs. Darío Javier Valarezo León

**Ubicación / Dirección del establecimiento educativo:** Calle Agustín Carrión Palacios entre Av. Salvador Bustamante Celi y Beethoven. Sector Jipiro

**Teléfono del establecimiento educativo:** +593 22985600 Ext. 6008

---

## CONTENIDOS DE LA ASIGNATURA (Distribución por semana de la 1 a la 16 /1 a la 9 para idiomas. No se puede unir dos o tres semanas en una misma planificación)

| Semana | Unidad / Tema | No. Horas | Resultado de Aprendizaje | Herramienta | Actividad Calificada |
|--------|---------------|-----------|--------------------------|-------------|----------------------|
| 1 | Unidad 1: Fundamentos de SGBD y Transacciones Revisión de conceptos básicos de SGBD Arquitectura: componentes y funcionalidades Tipos: relacionales, orientados a objetos, NoSQL | 1 1 1 | Explicar conceptos básicos, arquitectura y tipos de SGBD. Analizar y comparar diferentes SGBD. Investigar evolución histórica de SGBD. | Lectura Videos Diapositivas Caso de estudio Tutor inteligente | PE-1.1: Mapear arquitectura de un SGBD (cliente/servidor, procesos, buffers) en diagrama. (2.25) TA-1.1: Ficha 1 pág. comparando 2 modelos (relacional vs documental) con un caso de uso. (2.25) |
| 2 | Unidad 1: Fundamentos de SGBD y Transacciones Conceptos de transacciones Propiedades ACID Control de concurrencia y técnicas de bloqueo | 1 1 1 | Definir transacciones y propiedades ACID Demostrar control de concurrencia en SGBD Diseñar pruebas para verificar propiedades ACID. | Docente por un día Lectura Videos Diapositivas Caso de estudio Tutor inteligente | GA-1.1: Preguntas guiadas sobre ACID, aislamiento y bloqueo vs MVCC. (1) PE-1.2: Simular fenómenos (dirty/non-repeatable/phantom) con 2 sesiones SQL con IA. (2.25) TA-1.2: Mini-reporte (1 pág.): elegir nivel de aislamiento para 3 escenarios y justificar. (2.25) |
| 3 | Unidad 2: Recuperación y Optimización Logging/ARIES, checkpoints, crash recovery; journaling, write-ahead log | 1 1 1 | Diseñar pruebas para verificar propiedades ACID. Implementar logging y simular recuperaciones. Crear manual de recuperación ante fallos. | Docente por un día Lectura Videos Diapositivas Caso de estudio Tutor inteligente | PE-1.3: Laboratorio: activar WAL, forzar transacciones y observar registros/checkpoints. (2.25) TA-1.3: Resumen técnico (1 pág.) de ARIES (analyze-redo-undo) con esquema. (2.25) GA: Revisión Proyecto (0) |
| 4 | Unidad 2: Recuperación y Optimización Estadísticas, selectividad; índices y costo; planes de ejecución (EXPLAIN/ANALYZE). | 1 1 1 | Explicar optimización de consultas e índices. Optimizar consultas y evaluar planes de ejecución. Investigar técnicas avanzadas de optimización. | Docente por un día Lectura Videos Diapositivas Caso de estudio Tutor inteligente | PE-1.4: Ejecutar EXPLAIN/ANALYZE en 3 consultas; comparar con/sin índice. (2.25) TA-1.4: Informe breve con métricas (latencia, rows, plan) y decisión de índice. (2.25) |
| 5 | Evaluación Evaluación Diagnóstica | 1 1 1 | EVALUACIÓN SEMANA 1-4, PRESENTACIÓN PROYECTO - FASE I | Caso de estudio. Banco de preguntas | GA-1.2: Evaluación Teórica (3) GA-1.3: Evaluación Práctica (4) GA-1.4: Proyecto Fase I (4) |
| 6 | Unidad 3: Almacenamiento y Rendimiento Estructuras de almacenamiento Particionamiento de tablas Gestión de espacios de tablas | 1 1 1 | Explicar estructuras de almacenamiento y particionamiento. Implementar particionamiento de tablas. Investigar estrategias avanzadas de almacenamiento | Docente por un día Lectura Videos Diapositivas Caso de estudio Tutor inteligente | PE-2.1: Crear tabla + índice B-Tree y Hash; medir lecturas y tiempos en búsquedas. (2.25) TA-2.1: Mini-reporte: proponer estrategia de partición (range/hash) para un dataset. (2.25) |
| 7 | Unidad 3: Almacenamiento y Rendimiento Herramientas de monitoreo de SGBD Análisis de rendimiento y cuellos de botella Técnicas de ajuste de rendimiento | 1 1 1 | Describir herramientas de monitoreo y análisis de rendimiento. Utilizar herramientas para identificar cuellos de botella. Elaborar plan de optimización de rendimiento. | Docente por un día Lectura Videos Diapositivas Caso de estudio Tutor inteligente Advanced Skill Certificate | GA-2.1: Part 1 Quiz (1) PE-2.2: Perf lab: medir EXPLAIN (ANALYZE, BUFFERS) y re-escribir consulta para bajar costo. (2.25) TA-2.2: Tabla "antes/después" con métricas (p95, buffers, rows) y 3 lecciones. (2.25) |
| 8 | Unidad 4: Respaldo y Seguridad Estrategias de respaldo Tipos de respaldos: completos, incrementales, diferenciales Procesos de recuperación de bases de datos | 1 1 1 | Explicar estrategias y tipos de respaldo. Realizar respaldos y recuperaciones. Diseñar plan de respaldo para caso de estudio. | Docente por un día Lectura Videos Diapositivas Caso de estudio Tutor inteligente Advanced Skill Certificate | GA-2.2: Part 2 Quiz (1) PE-2.3: Ejecutar backup full y restore (o PITR simulado) en entorno de práctica. (2.25) TA-2.3: Checklist de respaldo y plan de pruebas de restauración (1 pág.). (2.25) |
| 9 | Unidad 4: Respaldo y Seguridad Gestión de cuentas de usuario Asignación y revocación de privilegios Roles y perfiles de seguridad | 1 1 1 | Describir gestión de usuarios y privilegios. Configurar perfiles de seguridad en SGBD. Analizar políticas de seguridad en organizaciones. | Docente por un día Lectura Videos Diapositivas Caso de estudio Tutor inteligente Advanced Skill Certificate | GA-2.3: Part 3 Quiz. (1) PE-2.4: Script de RBAC (crear roles, GRANT/REVOKE) + habilitar TLS local y log de auditoría. (2.25) TA-2.4: Memo 1 pág.: hardening mínimo de una BD (pasos y riesgos mitigados). (2.25) GA: Revisión Proyecto (0) |
| 10 | Evaluación Evaluación Formativa | 1 1 1 | EVALUACIÓN SEMANA 6-9, PRESENTACIÓN PROYECTO - FASE II | Caso de estudio. Banco de preguntas | GA-2.4: Evaluación Práctica (4) GA-2.5: Proyecto Fase II (5) |
| 11 | Unidad 5: Bases de Datos Distribuidas y NoSQL Replicación sincrónica/asincrónica; fragmentación/sharding; consultas distribuidas. | 1 1 1 | Explicar conceptos de bases de datos distribuidas. Implementar fragmentación y replicación. Investigar casos de uso de bases distribuidas. | Docente por un día Lectura Videos Diapositivas Caso de estudio Tutor inteligente | GA-3.1: Replicación (sync/async) y sharding: conceptos y trade-offs. (1) PE-3.1: Montar replicación primaria-réplica (local/docker); medir lag y failover manual. (2.4) TA-3.1: Propuesta de sharding para un caso (clave, estrategia y riesgos). (2.4) |
| 12 | Unidad 5: Bases de Datos Distribuidas y NoSQL Consistencia (CAP/PACELC); 2PC/3PC; NoSQL: documental, clave-valor, columnar, grafos (modelado y casos). | 1 1 1 | Describir tipos y características de NoSQL. Desarrollar aplicación usando base de datos NoSQL. Comparar rendimiento SGBD relacional vs NoSQL. | Docente por un día Lectura Videos Diapositivas Caso de estudio Tutor inteligente | PE-3.2: Implementar transacción distribuida simple (2 "nodos" simulados) o usar prepared transactions; probar fallos (2.4) TA-3.2: Cuadro comparativo de NoSQL (doc/kv/columnar/grafos) con 2 casos reales. (2.4) GA: Revisión Proyecto (0) |
| 13 | Unidad 6: Data Warehousing y Big Data Modelo estrella/copo; ETL/ELT; OLAP (cubos, roll-up/drill-down); BI/visualización. | 1 1 1 | Explicar conceptos de data warehousing y OLAP. Diseñar y consultar un data warehouse simple. Explorar herramientas de BI y visualización. | Docente por un día Lectura Videos Diapositivas Caso de estudio Tutor inteligente Advanced Skill Certificate | GA-3.2: Part 4 Quiz (1) PE-3.3: Diseñar modelo estrella y cargar mini-dataset (ETL simple); ejecutar 2 consultas OLAP. (2.4) TA-3.3: Dashboard simple (capturas) con 2 métricas y 1 insight. (2.4) |
| 14 | Unidad 6: Data Warehousing y Big Data Hadoop/Spark; lakehouse; conectores a SGBD; federación de datos. | 1 1 1 | Introducir conceptos de Big Data y frameworks. Utilizar Hadoop o Spark para procesamiento de datos Investigar casos de éxito de Big Data en la industria. | Docente por un día Lectura Videos Diapositivas Caso de estudio Tutor inteligente | GA-3.3: Hadoop/Spark y lakehouse: cuándo y por qué. (1) PE-3.4: Job Spark local (o simulado) con agregación; comparar con SQL en SGBD. (2.4) TA-3.4: Informe corto: criterio de selección entre BD transaccional vs Spark/lakehouse. (2.4) |
| 15 | Unidad 7: Tendencias Avanzadas en Bases de Datos Bases de datos en la nube (AWS) Bases de datos en memoria Inteligencia artificial y aprendizaje automático en SGBD | 1 1 1 | Describir bases de datos en la nube e in-memory. Implementar solución en base de datos en la nube. Explorar aplicaciones de IA en SGBD. | Docente por un día Lectura Videos Diapositivas Caso de estudio Tutor inteligente Advanced Skill Certificate | GA-3.4: Part 5 Quiz (1) PE-3.5: PoC: Redis (cache) o time-series (TSDB) con consulta y métrica de latencia. (2.4) TA-3.5: Nota técnica: cuándo usar vector DB + caso de búsqueda semántica. (2.4) |
| 16 | Evaluación Evaluación Sumativa | 1 1 1 | EVALUACIÓN SEMANA 1-15, PRESENTACIÓN PROYECTO - FASE III FINAL | Caso de estudio. Banco de preguntas | GA-3.5: Evaluación Práctica (6) GA-3.6: Proyecto Fase III (6) |

---

## COMPETENCIAS TRANSVERSALES

Competencias que se desarrollarán en esta asignatura durante el presente periodo académico, con el resultado de aprendizaje y evidencia de evaluación.

| Competencias a desarrollar | Resultados de aprendizaje | Evidencia de Evaluación |
|----------------------------|---------------------------|-------------------------|
| Comunicación efectiva | Elaborar informes técnicos y comparativos sobre modelos de bases de datos, niveles de aislamiento y estrategias de optimización. Presentar de forma clara resultados de análisis de rendimiento, respaldos y replicación. | TA-1.1: Ficha comparativa de modelos relacional vs documental. TA-1.2: Mini-reporte sobre niveles de aislamiento. TA-1.3: Resumen técnico de ARIES. TA-1.4: Informe con métricas y decisión de índice. TA-2.1: Reporte sobre estrategia de partición. TA-2.2: Tabla comparativa "antes/después" con métricas. TA-2.3: Checklist de respaldo y plan de restauración. TA-2.4: Memo técnico de hardening. TA-3.1: Propuesta de sharding. TA-3.2: Cuadro comparativo de NoSQL. TA-3.3: Dashboard con métricas e insight. TA-3.4: Informe de selección entre BD transaccional y Spark. TA-3.5: Nota técnica sobre vector DB y búsqueda semántica. |
| Desarrollo personal y profesional | Desarrollar autonomía en la configuración, administración y evaluación de sistemas de bases de datos reales. Fortalecer la responsabilidad y el trabajo metódico en la gestión de proyectos y prácticas de laboratorio. | TA-2.3: Checklist de respaldo y plan de restauración. TA-3.2: Cuadro comparativo de NoSQL. GA-1.4: Proyecto Fase I. GA-2.5: Proyecto Fase II. GA-3.6: Proyecto Fase III. |
| Pensamiento crítico y sistémico | Analizar y comparar el comportamiento de los SGBD frente a distintos mecanismos de control, recuperación y optimización. Evaluar decisiones de diseño en función de la escalabilidad y eficiencia. | GA-1.1: Preguntas guiadas sobre ACID, aislamiento y bloqueo vs MVCC. PE-1.2: Simulación de fenómenos de concurrencia (dirty, non-repeatable, phantom). PE-1.4: Comparación con y sin índice (EXPLAIN/ANALYZE). PE-2.2: Laboratorio de optimización con EXPLAIN (ANALYZE, BUFFERS). PE-2.4: Script de RBAC, TLS y log de auditoría. GA-2.1: Part 1 Quiz. GA-2.2: Part 2 Quiz. GA-2.3: Part 3 Quiz. GA-3.1: Actividad de reflexión sobre replicación y sharding. GA-3.2: Part 4 Quiz. GA-3.4: Part 5 Quiz. |
| Cultura digital | Usar herramientas de monitoreo, replicación y optimización de SGBD en entornos reales o simulados. Aplicar técnicas modernas de administración, particionamiento, auditoría y seguridad. | PE-1.1: Diagrama de arquitectura de SGBD (cliente/servidor, procesos, buffers). PE-1.3: Laboratorio con WAL y checkpoints. PE-2.1: Creación de índices B-Tree y Hash. PE-2.3: Backup y restore (PITR). PE-2.4: Configuración de RBAC, TLS y auditoría. PE-3.1: Replicación primaria-réplica. PE-3.2: Transacción distribuida simple o prepared transactions. PE-3.3: Modelo estrella y consultas OLAP. PE-3.4: Job Spark local con agregaciones. PE-3.5: PoC con Redis o TSDB. |
| Investigación y espíritu empresarial | Diseñar soluciones de administración de datos que respondan a necesidades empresariales complejas.Evaluar y justificar la adopción de tecnologías emergentes de bases de datos y procesamiento distribuido. | GA-1.2: Evaluación teórica. GA-1.3: Evaluación práctica. GA-2.4: Evaluación práctica. GA-3.3: Evaluación teórica. GA-3.5: Evaluación práctica. |

---

## EVALUACIÓN

**Parámetros – Saber, Saber Hacer Porcentaje**

**Semana 5**

Gestión de trabajo autónomo:

• TA-1.1: Ficha 1 pág. comparando 2 modelos (relacional vs documental) — 2.25

• TA-1.2: Mini-reporte (1 pág.): elegir nivel de aislamiento para 3 escenarios — 2.25

• TA-1.3: Resumen técnico (1 pág.) de ARIES (analyze-redo-undo) — 2.25

• TA-1.4: Informe breve con métricas y decisión de índice — 2.25

Gestión de practica y experimentación:

• PE-1.1: Mapear arquitectura de un SGBD (cliente/servidor, procesos, buffers) — 2.25

• PE-1.2: Simular fenómenos (dirty/non-repeatable/phantom) con 2 sesiones SQL — 2.25

• PE-1.3: Laboratorio: activar WAL, forzar transacciones y observar checkpoints — 2.25

• PE-1.4: Ejecutar EXPLAIN/ANALYZE en 3 consultas; comparar con/sin índice — 2.25

Gestión de aprendizaje:

• GA-1.1: Preguntas guiadas sobre ACID, aislamiento y bloqueo vs MVCC — 1

• GA-1.2: Evaluación Teórica — 3

• GA-1.3: Evaluación Práctica — 4

• GA-1.4: Proyecto Fase I — 4

**30%**

**Semana 10**

Gestión de trabajo autónomo:

• TA-2.1: Mini-reporte: estrategia de partición (range/hash) — 2.25

• TA-2.2: Tabla comparativa "antes/después" con métricas y 3 lecciones — 2.25

• TA-2.3: Checklist de respaldo y plan de pruebas de restauración — 2.25

• TA-2.4: Memo 1 pág.: hardening mínimo de una BD — 2.25

Gestión de practica y experimentación:

• PE-2.1: Crear tabla + índice B-Tree y Hash; medir lecturas y tiempos en búsquedas — 2.25

• PE-2.2: Perf lab: medir EXPLAIN (ANALYZE, BUFFERS) y re-escribir consulta para bajar costo — 2.25

• PE-2.3: Ejecutar backup full y restore (o PITR simulado) en entorno de práctica — 2.25

• PE-2.4: Script de RBAC (crear roles, GRANT/REVOKE) + habilitar TLS local y log de auditoría — 2.25

Gestión de aprendizaje:

• GA-2.1: Part 1 Quiz — 1

• GA-2.2: Part 2 Quiz — 1

• GA-2.3: Part 3 Quiz — 1

• GA-2.4: Evaluación Práctica — 4

• GA-2.5: Proyecto Fase II — 5

**30%**

**Semana 16**

Gestión de trabajo autónomo:

• TA-3.1: Propuesta de sharding (clave, estrategia, riesgos) — 2.4

• TA-3.2: Cuadro comparativo de NoSQL (doc/kv/columnar/grafos) — 2.4

• TA-3.3: Dashboard con métricas y un insight — 2.4

• TA-3.4: Informe corto: criterio de selección entre BD transaccional y Spark — 2.4

• TA-3.5: Nota técnica: cuándo usar vector DB + caso de búsqueda semántica — 2.4

Gestión de practica y experimentación:

• PE-3.1: Montar replicación primaria-réplica; medir lag y failover — 2.4

• PE-3.2: Transacción distribuida simple (2 nodos) o prepared transactions — 2.4

• PE-3.3: Modelo estrella + mini ETL; ejecutar consultas OLAP — 2.4

• PE-3.4: Job Spark local con agregaciones; comparar con SQL — 2.4

• PE-3.5: PoC: Redis o TSDB con consulta y métrica de latencia — 2.4

Gestión de aprendizaje:

• GA-3.1: Replicación (sync/async) y sharding: conceptos y trade-offs — 1

• GA-3.2: Part 4 Quiz — 1

• GA-3.4: Part 5 Quiz — 1

• GA-3.5: Evaluación Práctica — 6

• GA-3.6: Proyecto Fase III — 6

**40%**

---

## BIBLIOGRAFÍA

### Bibliografía básica:

• Núñez, R. (2023). Gestión de bases de datos: (1 ed.). RA-MA Editorial. https://0310s0g1g-y-https-elibro-net.proxy.uide.edu.ec/es/lc/uide/titulos/235056

• López Fandiño, V. (2023). Sistemas de Big Data: (1 ed.). RA-MA Editorial. https://0310s0g1g-y-https-elibro-net.proxy.uide.edu.ec/es/lc/uide/titulos/235054

• López Querol, J. Campos Monge, E. M. y Campos Monge, M. (2023). Algoritmia y bases de datos: (1 ed.). Madrid, RA-MA Editorial. Recuperado de https://0310s0g1a-y-https-elibro-net.proxy.uide.edu.ec/es/lc/uide/titulos/230563

### Bibliografía complementaria:

• Coronel, C., & Morris, S. (2022). Database systems: Design, implementation, & management (13th ed.). Cengage Learning.

• Petrov, A. (2019). Database internals: A deep dive into how distributed data systems work. O'Reilly Media.

• Sadalage, P. J., & Fowler, M. (2022). NoSQL distilled: A brief guide to the emerging world of polyglot persistence (Updated ed.). Addison-Wesley Professional.

• Ponniah, P. (2021). Data warehousing fundamentals: A comprehensive guide for IT professionals (2nd ed.). Wiley.

• Marz, N., & Warren, J. (2021). Big data: Principles and best practices of scalable realtime data systems (Updated ed.). Manning Publications.

• Basta, A. (2019). Database security: A practical guide. Cengage Learning.

• Kleppmann, M. (2023). Designing data-intensive applications (Updated ed.). O'Reilly Media.

• Renard, E. (2023). Cloud native databases. Packt Publishing.

• Amazon Web Services. (2023). Amazon Relational Database Service (RDS) – Servicio de bases de datos relacionales gestionado en la nube. AWS. https://aws.amazon.com/es/rds/

### Fuentes ASU:

• Arizona State University. (2025). Understanding Data Source. Information Technology Program. Online.

---

## RESPONSABILIDAD

**Elaborado Por:**

Cargo: Docente de la carrera de Ingeniería en Tecnologías de la información

Nombre: Prof. Charlie Cárdenas Toledo, M.Sc.

**Revisado Por:**

Cargo: Coordinador académico de la carrera de Ingeniería en Tecnologías de la información

Nombre: Mgs. Darío Javier Valarezo León

**Aprobado Por:**

Cargo: Directora de la carrera de Ingeniería en Tecnologías de la información

Nombre: Mgs. Lorena Elizabeth Conde Zhingre

---

> Se considera copia no controlada a cualquier impresión de este documento.