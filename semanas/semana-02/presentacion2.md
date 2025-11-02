# Presentación Semana 2: Transacciones y Control de Concurrencia
## Propiedades ACID, Técnicas de Bloqueo y Gestión de Transacciones

---

## 🎯 Objetivos de la Presentación

- Comprender el concepto de **transacciones** y su ciclo de vida
- Analizar las **propiedades ACID** y su importancia en SGBD
- Explorar técnicas de **control de concurrencia** y bloqueo
- Identificar problemas de **concurrencia** y sus soluciones

---

## 📊 Agenda

1. **Conceptos de Transacciones**
2. **Propiedades ACID**
3. **Control de Concurrencia**
4. **Técnicas de Bloqueo**
5. **Protocolos de Validación**

---

## 💼 Conceptos de Transacciones

### Definición Fundamental

> *"Una transacción es una unidad de la ejecución de un programa que puede estar compuesta por varias operaciones de acceso a la base de datos"*

### Características Clave
- **Unidad lógica de trabajo** compuesta por múltiples operaciones
- **Responsabilidad**: Llevar la BD de un estado consistente a otro diferente
- **Contexto**: Esencial en sistemas transaccionales (OLTP)
- **Control**: El usuario/programador decide qué operaciones componen la transacción

---

## 🔄 Ciclo de Vida de una Transacción

### Operaciones Registrables

#### Operaciones Básicas
- **inicio_t**: Inicio de la transacción
- **leer**: Lectura de gránulo y valor
- **escribir**: Escritura de gránulo, valor escrito y valor anterior
- **fin_t**: Fin de la transacción

#### Operaciones de Control
- **confirmar (COMMIT)**: Confirma los cambios permanentemente
- **abortar (ABORT)**: Cancela la transacción y deshace cambios

---

## 📊 Estados de una Transacción

### Diagrama de Estados

| **Estado** | **Descripción** |
|------------|-----------------|
| **Activa** | Estado inicial de la transacción |
| **Parcialmente confirmada** | Después de ejecutar todas las instrucciones |
| **Confirmada** | Operaciones exitosas, efectos registrados en BD |
| **Abortada** | Sin efecto sobre el sistema, retorna al estado original |

### Flujo de Estados
```
Activa → Parcialmente confirmada → Confirmada
   ↓              ↓
 Abortada ← ← ← ← ←
```

---

## 🛡️ Propiedades ACID: Fundamentos

### Definición Central

> *"Propiedades que aseguran el procesamiento confiable de las transacciones de bases de datos"*

### Los Cuatro Pilares
- **A**tomicidad (Atomicity)
- **C**onsistencia (Consistency) 
- **A**islamiento (Isolation)
- **D**urabilidad (Durability)

### Responsabilidad
El **Sistema de Gestión de Bases de Datos (SGBD)** debe asegurar el cumplimiento de estas propiedades

---

## ⚛️ Atomicidad (Atomicity)

### Concepto Central
> *"Una unidad atómica de trabajo; se completa totalmente o no se completa en absoluto"*

### Principios Clave
- **Todo o nada**: La transacción se ejecuta completamente o no tiene efecto alguno
- **Operaciones atómicas**: Ocurren totalmente o no ocurren
- **Manejo de fallos**: Si alguna parte falla, la transacción entera falla

### Responsabilidad
- **Subsistema de recuperación** del SGBD
- **Rollback automático** en caso de fallo
- **Garantía de integridad** ante interrupciones

---

## ✅ Consistencia (Consistency)

### Definición
> *"Una transacción sólo lleva a la base de datos de un estado válido a otro"*

### Garantías
- **Estados válidos**: Solo transiciones entre estados coherentes
- **Conservación**: La ejecución aislada conserva la consistencia
- **Coherencia final**: Todos los datos quedan en estado coherente

### Implicaciones
- **Reglas de negocio** se aplican a todas las modificaciones
- **Restricciones de integridad** (como integridad referencial)
- **Validaciones** antes de confirmar cambios

---

## 🔒 Aislamiento (Isolation)

### Concepto Fundamental
> *"Define cómo y cuándo los cambios producidos por una operación se hacen visibles para las demás operaciones concurrentes"*

### Objetivo Principal
- **Independencia**: Efectos no influenciados por otras transacciones
- **Exclusividad aparente**: Como si fuera la única transacción ejecutándose
- **Control de visibilidad**: Gestión de cuándo se ven los cambios

### Característica Importante
- **Propiedad más relajada** en SGBDs
- **Trade-off**: Mayor aislamiento = mayor precisión, menor concurrencia

---

## 📊 Niveles de Aislamiento

### Jerarquía de Niveles (De mayor a menor restricción)

#### 1. Serializable
- **Nivel más estricto**
- **Ejecución equivalente** a alguna ejecución serial
- **Máxima integridad**, mínima concurrencia

#### 2. Lecturas Repetibles (Repeatable Reads)
- **Bloqueos de lectura y escritura** hasta el final
- **Problema**: Lecturas fantasma pueden ocurrir

#### 3. Lecturas Comprometidas (Read Committed)
- **Bloqueos de escritura** hasta el final
- **Bloqueos de lectura** se cancelan tras SELECT
- **Permite**: Lecturas no repetibles

#### 4. Lecturas No Comprometidas (Read Uncommitted)
- **Nivel más bajo**
- **Permite**: Leer filas modificadas no confirmadas (Lecturas Sucias)

---

## ⚠️ Problema: Lecturas No Repetibles

### Escenario de Ejemplo

| **Tiempo** | **T1 (Transacción 1)** | **T2 (Transacción 2)** | **Dato A** |
|------------|-------------------------|-------------------------|------------|
| T1: Inicio | lee(a) → A=100 | - | 100 |
| T2: Inicio | - | lee(a) → A=100 | 100 |
| T2: Modifica | - | a:=a+1 → A=101 | 100 (no confirmado) |
| T2: Confirma | - | escribe(a), COMMIT | 101 |
| T1: Relee | lee(a) → A=101 | - | 101 |
| **Resultado** | **¡Extraño!** | **Exitoso** | **Inconsistente para T1** |

### Problema Identificado
La transacción T1 lee el valor 100 al inicio y luego 101, manifestando **lecturas no repetibles**

---

## 💾 Durabilidad (Durability)

### Definición
> *"Asegura que una vez que una transacción es confirmada, las modificaciones son registradas permanentemente"*

### Características
- **Permanencia**: Cambios persisten incluso ante fallos del sistema
- **Resistencia a fallos**: Supervivencia a caídas de energía, crashes del sistema
- **Recuperabilidad**: Capacidad de restaurar estado tras fallo

### Responsabilidad
- **Subsistema de recuperación** del SGBD
- **Logs de transacciones** para recuperación
- **Respaldos y checkpoints** periódicos

---

## 🚦 Control de Concurrencia: Necesidad

### Contexto Multiusuario
- **Transacciones concurrentes** (interleaving) en BD multiusuario
- **Mejor aprovechamiento** de recursos del sistema
- **Reducción** en tiempos de respuesta
- **Múltiples usuarios** accediendo simultáneamente

### Objetivo Principal
> *"Garantizar la consistencia al realizar diferentes transacciones en una Base de Datos"*

### Criterio de Correctitud
**Serializabilidad**: La ejecución concurrente es correcta solo si su efecto es el mismo que si se ejecutaran secuencialmente en cualquier orden

---

## 🏗️ Arquitectura de Control de Concurrencia

### Componente Clave: Planificador
- **Arbitro de conflictos** de acceso
- **Coordinador** de operaciones concurrentes
- **Garante** de la consistencia del sistema

### Dos Enfoques Principales

#### 1. Control Pesimista
- **Asume conflictos** frecuentes
- **Técnicas de bloqueo** preventivas
- **Bloquea recursos** antes del acceso

#### 2. Control Optimista
- **Asume conflictos** raros
- **Validación posterior** a la ejecución
- **Rollback** si hay conflictos

---

## 🔐 Control de Concurrencia Pesimista

### Técnicas de Bloqueo

#### Concepto Fundamental
> *"El bloqueo es una información del tipo de acceso que se permite a un elemento"*

#### Propósito
- **Prevenir interacción destructiva** entre usuarios
- **Controlar acceso** a datos compartidos
- **Imposición automática** por el SGBD

### Granularidad del Bloqueo
La granularidad se refiere al **tamaño de las unidades de datos** a las que se controla el acceso

#### Principio Clave
> *"A mayor granularidad, menor concurrencia"*

---

## 📏 Niveles de Granularidad

### Jerarquía de Granularidad (De menor a mayor)

#### Nivel Fila
- **Unidad**: Fila individual
- **Granularidad**: Muy fina
- **Concurrencia**: Máxima
- **Overhead**: Alto

#### Nivel Página
- **Unidad**: Bloques de 8KB
- **Granularidad**: Fina
- **Concurrencia**: Alta
- **Overhead**: Medio

#### Nivel Tabla
- **Unidad**: Tabla completa
- **Granularidad**: Gruesa
- **Concurrencia**: Baja
- **Overhead**: Bajo

#### Nivel Base de Datos
- **Unidad**: BD completa
- **Granularidad**: Muy gruesa
- **Concurrencia**: Mínima
- **Overhead**: Mínimo

### Recomendación
**Sistema de granularidad múltiple** permite varios niveles según necesidades

---

## 🏷️ Tipos de Bloqueo (Modos)

### Clasificación por Operación

| **Tipo** | **Modo** | **Acceso Permitido** | **Propósito** |
|----------|----------|----------------------|---------------|
| **Compartido (S)** | Solo lectura | Lecturas concurrentes | Operaciones de solo lectura |
| **Exclusivo (X)** | Lectura y escritura | Solo una transacción | Operaciones que escriben datos |
| **Actualización (U)** | Temporal | Solo una transacción | Operaciones que pueden escribir |
| **Intención (I)** | Varios modos (IS, IX, SIX) | Jerarquía de bloqueo | Bloqueo a nivel grueso |

### Detalles de Modos

#### Bloqueo Compartido (Shared, S)
- **Múltiples transacciones** pueden leer simultáneamente
- **No permite escritura** mientras está activo
- **Compatibilidad** entre bloqueos compartidos

#### Bloqueo Exclusivo (Exclusive, X)
- **Una sola transacción** tiene acceso completo
- **Lectura y escritura** exclusivas
- **Incompatible** con cualquier otro bloqueo

---

## 🔄 Protocolo de Bloqueo en Dos Fases (2PL)

### Concepto Central
> *"Todos los bloqueos preceden a los desbloqueos"*

### Las Dos Fases

#### 1. Fase de Expansión (Crecimiento)
- **Se pueden adquirir** nuevos bloqueos
- **NO se puede liberar** ningún bloqueo existente
- **Acumulación** de recursos necesarios

#### 2. Fase de Contracción
- **Se pueden liberar** todos los bloqueos existentes
- **NO se pueden adquirir** nuevos bloqueos
- **Liberación** progresiva de recursos

### Garantía Fundamental
> *"Si S es cualquier planificación de transacciones de dos fases, S es secuenciable"*

---

## 📊 Variaciones del Protocolo 2PL

### 2PL Básico
- **Implementación estándar** del protocolo
- **Liberación inmediata** tras uso
- **Riesgo de rollback** en cascada

### 2PL Estricto
- **No libera bloqueos exclusivos** hasta COMMIT/ABORT
- **Previene rollback** en cascada
- **Mayor seguridad**, menor concurrencia

### 2PL Riguroso
- **No libera ningún bloqueo** hasta COMMIT/ABORT
- **Máxima seguridad**
- **Mínima concurrencia**

---

## ⚠️ Problema: Interbloqueo (Deadlock)

### Definición
> *"Situación en la que un grupo de transacciones no pueden continuar porque están esperando unas a las otras"*

### Ejemplo Clásico

| **Transacción T1** | **Transacción T2** |
|-------------------|-------------------|
| LOCK A; | LOCK B; |
| LOCK B; (Espera T2 libere B) | LOCK A; (Espera T1 libere A) |

### Resultado
- **T1 espera B** (que tiene T2)
- **T2 espera A** (que tiene T1)
- **Espera indefinida** = Deadlock

### Detección
**Grafo de esperas**: La existencia de un **ciclo** indica deadlock

---

## 🔍 Técnicas de Manejo de Deadlock

### 1. Prevención
- **Ordenamiento de recursos**: Acceso en orden predefinido
- **Timeout de transacciones**: Cancelación automática tras tiempo límite
- **Detección de patrones**: Evitar secuencias conflictivas

### 2. Detección
- **Grafo de esperas**: Construcción y análisis periódico
- **Algoritmos de detección**: Búsqueda de ciclos
- **Intervenciones automáticas**: Abort de transacciones seleccionadas

### 3. Recuperación
- **Selección de víctima**: Criterios para abortar transacciones
- **Rollback**: Deshacimiento de cambios parciales
- **Reinicio**: Nuevo intento de la transacción abortada

---

## 🌟 Control de Concurrencia Optimista

### Filosofía
> *"Los conflictos entre las transacciones son raros"*

### Objetivo
**Evitar los costosos bloqueos** cuando la probabilidad de conflicto es baja

### Dos Enfoques Principales

#### 1. Protocolos de Validación
#### 2. Protocolos Basados en Marcas Temporales

---

## ✅ Protocolos Optimistas de Validación

### Fases del Protocolo

#### 1. Fase de Lectura
- **Ejecución normal** de la transacción
- **Actualizaciones en memoria local** (no en BD)
- **Sin bloqueos** durante la ejecución

#### 2. Fase de Validación
- **Verificación de conflictos** al intentar COMMIT
- **Análisis de serializabilidad** con otras transacciones
- **Decisión**: Confirmar o abortar

#### 3. Fase de Escritura
- **Si validación exitosa**: Escritura real en BD
- **Si hay conflicto**: Abort y reinicio de transacción

### Ventajas
- **Alta concurrencia** cuando conflictos son raros
- **Sin deadlocks** por diseño
- **Menor overhead** durante ejecución

---

## ⏰ Protocolos Basados en Marcas Temporales

### Concepto Central
**Asegurar serializabilidad sin imponer bloqueos** mediante ordenamiento temporal

### Asignación de Marcas
- **MT(Ti)**: Marca temporal asignada a transacción Ti
- **Orden de entrada**: Marca basada en tiempo de llegada al sistema
- **Contador o reloj**: Mecanismos de asignación

### Marcas por Elemento de Datos

#### Para cada elemento D:
- **MTR(D)**: Mayor marca de transacciones que leyeron con éxito
- **MTW(D)**: Mayor marca de transacciones que escribieron con éxito

---

## 🔄 Protocolo de Ordenación por Marcas Temporales

### Reglas de Operación

#### Para Operación de Lectura read(X) por Ti:
```
Si MT(Ti) < MTW(X):
    Abortar Ti (lee valor obsoleto)
Si MT(Ti) ≥ MTW(X):
    Ejecutar read(X)
    MTR(X) = max(MTR(X), MT(Ti))
```

#### Para Operación de Escritura write(X) por Ti:
```
Si MT(Ti) < MTR(X):
    Abortar Ti (valor ya leído por transacción posterior)
Si MT(Ti) < MTW(X):
    Abortar Ti (escritura obsoleta)
Si condiciones satisfechas:
    Ejecutar write(X)
    MTW(X) = MT(Ti)
```

### Ventajas
- **Sin deadlocks**: Ninguna transacción espera
- **Serializabilidad garantizada**: Por orden temporal
- **Decisiones inmediatas**: Sin esperas por recursos

---

## ⚖️ Comparación: Pesimista vs. Optimista

| **Aspecto** | **Control Pesimista** | **Control Optimista** |
|-------------|------------------------|----------------------|
| **Asunción** | Conflictos frecuentes | Conflictos raros |
| **Bloqueos** | Preventivos, extensivos | Mínimos o ninguno |
| **Deadlocks** | Posibles (requiere manejo) | Imposibles por diseño |
| **Concurrencia** | Limitada por bloqueos | Alta durante ejecución |
| **Overhead** | Durante ejecución | Durante validación |
| **Abort Rate** | Bajo (prevención) | Alto si muchos conflictos |
| **Mejor para** | Alta contención | Baja contención |

---

## 🏢 Aplicaciones en el Mundo Real

### Sistemas OLTP (Online Transaction Processing)
- **Bancos**: Transferencias, depósitos, retiros
- **E-commerce**: Compras, inventario, pagos
- **Reservas**: Vuelos, hoteles, eventos
- **Control**: Bloqueos estrictos para consistencia

### Sistemas OLAP (Online Analytical Processing)
- **Data warehouses**: Consultas complejas, reportes
- **Business Intelligence**: Análisis multidimensional
- **Control**: Optimista por baja contención de escritura

### Sistemas Distribuidos
- **Bases de datos distribuidas**: Coordinación entre nodos
- **Microservicios**: Transacciones entre servicios
- **Cloud**: Elasticidad y disponibilidad

---

## 🛠️ Herramientas y Tecnologías

### SGBDs Relacionales Tradicionales
- **MySQL**: InnoDB engine, niveles de aislamiento configurables
- **PostgreSQL**: MVCC (Multi-Version Concurrency Control)
- **Oracle**: Advanced Queuing, RAC (Real Application Clusters)
- **SQL Server**: Lock Manager, Always On Availability Groups

### Bases de Datos NoSQL
- **MongoDB**: Optimistic Concurrency Control
- **Cassandra**: Eventually Consistent, Tunable Consistency
- **Redis**: Single-threaded, atomic operations

### Sistemas de Nueva Generación
- **CockroachDB**: Distributed SQL, ACID garantizado
- **TiDB**: Distributed transactions, HTAP
- **YugabyteDB**: Multi-region deployment, strong consistency

---

## 📊 Métricas y Monitoring

### Indicadores de Rendimiento

#### Métricas de Concurrencia
- **Número de transacciones concurrentes** activas
- **Tiempo promedio de bloqueo** por transacción
- **Tasa de deadlocks** por unidad de tiempo
- **Throughput** (transacciones por segundo)

#### Métricas de Contención
- **Lock wait time**: Tiempo esperando bloqueos
- **Lock escalation**: Frecuencia de escalado de bloqueos
- **Abort rate**: Porcentaje de transacciones abortadas
- **Resource utilization**: Uso de CPU, memoria, I/O

### Herramientas de Monitoreo
- **SQL Server Profiler**: Análisis de eventos y bloqueos
- **Oracle AWR**: Automatic Workload Repository
- **PostgreSQL pg_stat**: Estadísticas de actividad
- **MySQL Performance Schema**: Instrumentación de rendimiento

---

## 🚀 Tendencias y Evolución

### Nuevos Paradigmas

#### 1. Multi-Version Concurrency Control (MVCC)
- **Versiones múltiples** de datos
- **Lectores no bloquean escritores**
- **Garbage collection** de versiones antiguas

#### 2. Transacciones Distribuidas
- **2PC (Two-Phase Commit)**: Coordinación distribuida
- **Saga Pattern**: Transacciones de larga duración
- **Compensating Transactions**: Deshacimiento semántico

#### 3. Consistency Models
- **Strong Consistency**: Linearizability, Sequential consistency
- **Eventual Consistency**: CRDTs, Gossip protocols
- **Causal Consistency**: Happened-before relationships

---

## 🎯 Mejores Prácticas

### Diseño de Transacciones
1. **Mantén transacciones cortas** para reducir contención
2. **Minimiza el scope** de bloqueos
3. **Ordena acceso a recursos** para prevenir deadlocks
4. **Usa niveles de aislamiento apropiados** según necesidades

### Optimización de Rendimiento
1. **Indexación adecuada** para reducir lock time
2. **Particionamiento** para distribuir contención
3. **Connection pooling** para gestión eficiente
4. **Batch processing** para operaciones masivas

### Manejo de Errores
1. **Retry logic** con backoff exponencial
2. **Circuit breakers** para fallas cascada
3. **Timeout configurables** por tipo de operación
4. **Logging detallado** para diagnóstico

---

## 🔬 Casos de Estudio

### Caso 1: Sistema Bancario
**Escenario**: Transferencia entre cuentas
- **Requerimientos**: Atomicidad absoluta, sin pérdida de dinero
- **Solución**: 2PL Estricto, nivel Serializable
- **Consideraciones**: Deadlock detection, timeout conservador

### Caso 2: E-commerce Inventory
**Escenario**: Múltiples compradores, stock limitado
- **Requerimientos**: Prevenir overselling, alta concurrencia
- **Solución**: Optimistic locking con versioning
- **Consideraciones**: Retry logic, user feedback

### Caso 3: Analytics Dashboard
**Escenario**: Reportes en tiempo real, múltiples consultas
- **Requerimientos**: Consistencia eventual, alta performance
- **Solución**: Read Committed, MVCC
- **Consideraciones**: Snapshot isolation, cache strategies

---

## 💡 Lecciones Clave

### Principios Fundamentales
1. **ACID es la base** de sistemas confiables
2. **Concurrencia vs. Consistencia** es un trade-off constante
3. **No existe solución única** - cada caso requiere análisis
4. **Monitoring es esencial** para optimización continua

### Decisiones de Diseño
- **Conoce tu workload**: OLTP vs OLAP, read-heavy vs write-heavy
- **Evalúa tolerancia a inconsistencias** temporales
- **Considera escala futura** y distribución geográfica
- **Planifica para fallos** y recuperación

### Evolución Continua
- **Technology landscape** cambia constantemente
- **New consistency models** emergen regularmente
- **Cloud-native patterns** requieren nuevos enfoques
- **Microservices** introducen complejidades distribuidas

---

## 🔮 Reflexiones Finales

### Preguntas para Considerar
- ¿Cómo balancear **consistencia** vs. **disponibilidad** en sistemas distribuidos?
- ¿Qué **nivel de aislamiento** es apropiado para tu aplicación específica?
- ¿Cómo **monitorear y diagnosticar** problemas de concurrencia efectivamente?
- ¿Cuándo es apropiado **relajar ACID** por performance?

### El Futuro de las Transacciones
> *"Las transacciones seguirán evolucionando hacia modelos híbridos que combinen las garantías de ACID con la escalabilidad de sistemas distribuidos"*

---

## 📖 Para Profundizar

### Lecturas Fundamentales
- Gray, J. & Reuter, A. *Transaction Processing: Concepts and Techniques*
- Bernstein, P. A. & Newcomer, E. *Principles of Transaction Processing*
- Weikum, G. & Vossen, G. *Transactional Information Systems*

### Recursos Técnicos
- **Papers clásicos**: Lamport's "Time, Clocks and Ordering of Events"
- **Documentación SGBD**: MySQL InnoDB, PostgreSQL MVCC
- **Distributed Systems**: Martin Kleppmann's "Designing Data-Intensive Applications"

### Especializaciones Avanzadas
- **Distributed Transactions**: Two-phase commit, Consensus algorithms
- **MVCC Implementation**: Version chains, garbage collection
- **Modern Approaches**: CRDTs, Event sourcing, CQRS
- **Performance Tuning**: Lock analysis, query optimization

---

*Presentación basada en el compendio de Semana 2 - SGBD:  
Transacciones, Propiedades ACID, Control de Concurrencia y Técnicas de Bloqueo*