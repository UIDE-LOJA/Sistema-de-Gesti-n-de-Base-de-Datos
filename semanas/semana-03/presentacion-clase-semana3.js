// Custom JavaScript for SGBD-ASC Semana 3 - Logging, WAL, Checkpoints y ARIES

// Initialize presentation when DOM is loaded
document.addEventListener('DOMContentLoaded', function () {
    console.log('Presentación SGBD-ASC Semana 3 - Logging y Recuperación cargada');

    // Add interactive behaviors
    initializeInteractiveElements();

    // Add keyboard shortcuts
    addKeyboardShortcuts();

    // Initialize recovery simulation
    initializeRecoverySimulation();
});

// Initialize interactive elements
function initializeInteractiveElements() {
    // Add hover effects to concept boxes
    const conceptBoxes = document.querySelectorAll('.concept-box');
    conceptBoxes.forEach(box => {
        box.addEventListener('mouseenter', function () {
            this.style.transform = 'translateY(-2px)';
            this.style.boxShadow = '0 6px 12px rgba(0, 0, 0, 0.15)';
            this.style.transition = 'all 0.3s ease';
        });

        box.addEventListener('mouseleave', function () {
            this.style.transform = 'translateY(0)';
            this.style.boxShadow = '0 4px 6px rgba(0, 0, 0, 0.1)';
        });
    });

    // Add click effects to interactive boxes
    const interactiveBoxes = document.querySelectorAll('.interactive-box');
    interactiveBoxes.forEach(box => {
        box.addEventListener('click', function () {
            this.style.background = 'rgba(233, 171, 33, 0.3)';
            setTimeout(() => {
                this.style.background = 'rgba(233, 171, 33, 0.2)';
            }, 200);
        });
    });

    // Add syntax highlighting to code blocks
    highlightCodeBlocks();
}

// Add keyboard shortcuts
function addKeyboardShortcuts() {
    document.addEventListener('keydown', function (event) {
        // Press 'h' to show help
        if (event.key === 'h' || event.key === 'H') {
            showHelp();
        }

        // Press 'r' to show recovery info
        if (event.key === 'r' || event.key === 'R') {
            showRecoveryInfo();
        }

        // Press 'w' to show WAL info
        if (event.key === 'w' || event.key === 'W') {
            showWALInfo();
        }
    });
}

// Show help overlay
function showHelp() {
    const helpContent = `
        <div style="position: fixed; top: 0; left: 0; width: 100%; height: 100%; 
                    background: rgba(0,0,0,0.8); z-index: 9999; display: flex; 
                    align-items: center; justify-content: center;" id="helpOverlay">
            <div style="background: white; padding: 2rem; border-radius: 10px; max-width: 500px;">
                <h3><i class="fas fa-question-circle"></i> Atajos de Teclado</h3>
                <ul style="text-align: left;">
                    <li><strong>H:</strong> Mostrar esta ayuda</li>
                    <li><strong>R:</strong> Información de recuperación</li>
                    <li><strong>W:</strong> Información de WAL</li>
                    <li><strong><i class="fas fa-life-ring"></i> (icono flotante):</strong> Guía de recuperación</li>
                    <li><strong>ESC:</strong> Cerrar overlays</li>
                    <li><strong>Espacio:</strong> Siguiente slide</li>
                    <li><strong>Shift + Espacio:</strong> Slide anterior</li>
                </ul>
                <button onclick="closeOverlay('helpOverlay')" 
                        style="margin-top: 1rem; padding: 0.5rem 1rem; 
                               background: #28a745; color: white; border: none; 
                               border-radius: 5px; cursor: pointer;">
                    Cerrar
                </button>
            </div>
        </div>
    `;

    document.body.insertAdjacentHTML('beforeend', helpContent);

    // Close on ESC
    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape') {
            closeOverlay('helpOverlay');
        }
    });
}

// Show recovery information
function showRecoveryInfo() {
    const recoveryContent = `
        <div style="position: fixed; top: 0; left: 0; width: 100%; height: 100%; 
                    background: rgba(0,0,0,0.8); z-index: 9999; display: flex; 
                    align-items: center; justify-content: center;" id="recoveryOverlay">
            <div style="background: white; padding: 2rem; border-radius: 10px; max-width: 600px;">
                <h3><i class="fas fa-life-ring"></i> Guía Rápida de Recuperación</h3>
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; text-align: left;">
                    <div>
                        <h4 style="color: #28a745;">ARIES - 3 Fases</h4>
                        <p><strong>1. Análisis:</strong> Identificar transacciones incompletas</p>
                        <p><strong>2. Redo:</strong> Repetir la historia</p>
                        <p><strong>3. Undo:</strong> Deshacer transacciones incompletas</p>
                    </div>
                    <div>
                        <h4 style="color: #dc3545;">Tipos de Fallos</h4>
                        <p><strong>Transacción:</strong> Error en lógica</p>
                        <p><strong>Sistema:</strong> Fallo de hardware/software</p>
                        <p><strong>Catastrófico:</strong> Pérdida de almacenamiento</p>
                    </div>
                </div>
                <button onclick="closeOverlay('recoveryOverlay')" 
                        style="margin-top: 1rem; padding: 0.5rem 1rem; 
                               background: #dc3545; color: white; border: none; 
                               border-radius: 5px; cursor: pointer;">
                    Cerrar
                </button>
            </div>
        </div>
    `;

    document.body.insertAdjacentHTML('beforeend', recoveryContent);
}

// Show WAL information
function showWALInfo() {
    const walContent = `
        <div style="position: fixed; top: 0; left: 0; width: 100%; height: 100%; 
                    background: rgba(0,0,0,0.8); z-index: 9999; display: flex; 
                    align-items: center; justify-content: center;" id="walOverlay">
            <div style="background: white; padding: 2rem; border-radius: 10px; max-width: 600px;">
                <h3><i class="fas fa-forward"></i> Write-Ahead Log (WAL)</h3>
                <div style="text-align: left;">
                    <h4 style="color: #23356e;">Regla Fundamental</h4>
                    <p><em>"Antes de escribir cualquier cambio al disco, primero se debe escribir el registro correspondiente al log"</em></p>
                    
                    <h4 style="color: #e9ab21;">Secuencia de Operaciones</h4>
                    <ol>
                        <li><strong>Modificación en memoria</strong></li>
                        <li><strong>Escritura al log</strong> (obligatorio)</li>
                        <li><strong>Escritura a disco</strong></li>
                    </ol>
                    
                    <h4 style="color: #28a745;">Beneficios</h4>
                    <ul>
                        <li>Garantiza durabilidad</li>
                        <li>Permite recuperación</li>
                        <li>Mantiene consistencia</li>
                    </ul>
                </div>
                <button onclick="closeOverlay('walOverlay')" 
                        style="margin-top: 1rem; padding: 0.5rem 1rem; 
                               background: #23356e; color: white; border: none; 
                               border-radius: 5px; cursor: pointer;">
                    Cerrar
                </button>
            </div>
        </div>
    `;

    document.body.insertAdjacentHTML('beforeend', walContent);
}

// Close overlay function
function closeOverlay(overlayId) {
    const overlay = document.getElementById(overlayId);
    if (overlay) {
        overlay.remove();
    }
}

// Highlight code blocks
function highlightCodeBlocks() {
    const codeBlocks = document.querySelectorAll('pre code');
    codeBlocks.forEach(block => {
        // Add line numbers for SQL blocks
        if (block.classList.contains('sql')) {
            addLineNumbers(block);
        }
        
        // Add copy button
        addCopyButton(block);
    });
}

// Add line numbers to code blocks
function addLineNumbers(codeBlock) {
    const lines = codeBlock.textContent.split('\n');
    const numberedLines = lines.map((line, index) => {
        if (line.trim() === '') return line;
        return `${(index + 1).toString().padStart(2, ' ')}| ${line}`;
    });
    codeBlock.textContent = numberedLines.join('\n');
}

// Add copy button to code blocks
function addCopyButton(codeBlock) {
    const copyButton = document.createElement('button');
    copyButton.innerHTML = '<i class="fas fa-copy"></i>';
    copyButton.style.cssText = `
        position: absolute;
        top: 5px;
        right: 5px;
        background: rgba(0,0,0,0.7);
        color: white;
        border: none;
        padding: 5px 8px;
        border-radius: 3px;
        cursor: pointer;
        font-size: 0.8em;
        opacity: 0;
        transition: opacity 0.3s;
    `;

    const pre = codeBlock.parentElement;
    pre.style.position = 'relative';
    pre.appendChild(copyButton);

    // Show button on hover
    pre.addEventListener('mouseenter', () => {
        copyButton.style.opacity = '1';
    });

    pre.addEventListener('mouseleave', () => {
        copyButton.style.opacity = '0';
    });

    // Copy functionality
    copyButton.addEventListener('click', () => {
        navigator.clipboard.writeText(codeBlock.textContent).then(() => {
            copyButton.innerHTML = '<i class="fas fa-check"></i>';
            setTimeout(() => {
                copyButton.innerHTML = '<i class="fas fa-copy"></i>';
            }, 2000);
        });
    });
}

// Initialize recovery simulation
function initializeRecoverySimulation() {
    // Add interactive elements for recovery demonstration
    const recoveryElements = document.querySelectorAll('[data-recovery-demo]');
    recoveryElements.forEach(element => {
        element.addEventListener('click', function() {
            const demoType = this.getAttribute('data-recovery-demo');
            runRecoveryDemo(demoType);
        });
    });
}

// Run recovery demonstration
function runRecoveryDemo(demoType) {
    switch(demoType) {
        case 'wal':
            demonstrateWAL();
            break;
        case 'checkpoint':
            demonstrateCheckpoint();
            break;
        case 'aries':
            demonstrateARIES();
            break;
        default:
            console.log('Demo type not recognized:', demoType);
    }
}

// Demonstrate WAL process
function demonstrateWAL() {
    const demo = `
        <div style="position: fixed; top: 0; left: 0; width: 100%; height: 100%; 
                    background: rgba(0,0,0,0.9); z-index: 9999; display: flex; 
                    align-items: center; justify-content: center;" id="walDemo">
            <div style="background: white; padding: 2rem; border-radius: 10px; max-width: 700px;">
                <h3><i class="fas fa-play-circle"></i> Demostración WAL</h3>
                <div id="walSteps" style="text-align: left; margin: 1rem 0;">
                    <div class="demo-step" data-step="1">
                        <h4>Paso 1: Transacción inicia</h4>
                        <code>BEGIN TRANSACTION;</code>
                    </div>
                    <div class="demo-step" data-step="2" style="opacity: 0.3;">
                        <h4>Paso 2: Escribir al WAL</h4>
                        <code>&lt;T1, X, 100, 150&gt;</code>
                    </div>
                    <div class="demo-step" data-step="3" style="opacity: 0.3;">
                        <h4>Paso 3: Modificar en memoria</h4>
                        <code>X = 150 (en buffer)</code>
                    </div>
                    <div class="demo-step" data-step="4" style="opacity: 0.3;">
                        <h4>Paso 4: Escribir a disco</h4>
                        <code>COMMIT;</code>
                    </div>
                </div>
                <div style="text-align: center;">
                    <button onclick="nextWALStep()" id="walNextBtn"
                            style="padding: 0.5rem 1rem; background: #28a745; color: white; 
                                   border: none; border-radius: 5px; cursor: pointer; margin-right: 10px;">
                        Siguiente Paso
                    </button>
                    <button onclick="closeOverlay('walDemo')" 
                            style="padding: 0.5rem 1rem; background: #dc3545; color: white; 
                                   border: none; border-radius: 5px; cursor: pointer;">
                        Cerrar
                    </button>
                </div>
            </div>
        </div>
    `;

    document.body.insertAdjacentHTML('beforeend', demo);
    window.currentWALStep = 1;
}

// Next WAL step
function nextWALStep() {
    window.currentWALStep = (window.currentWALStep || 1) + 1;
    
    if (window.currentWALStep <= 4) {
        // Highlight current step
        const steps = document.querySelectorAll('.demo-step');
        steps.forEach((step, index) => {
            if (index < window.currentWALStep) {
                step.style.opacity = '1';
                step.style.background = 'rgba(40, 167, 69, 0.1)';
            }
        });
        
        if (window.currentWALStep === 4) {
            document.getElementById('walNextBtn').textContent = 'Completado';
            document.getElementById('walNextBtn').disabled = true;
            document.getElementById('walNextBtn').style.background = '#6c757d';
        }
    }
}

// Demonstrate checkpoint process
function demonstrateCheckpoint() {
    const demo = `
        <div style="position: fixed; top: 0; left: 0; width: 100%; height: 100%; 
                    background: rgba(0,0,0,0.9); z-index: 9999; display: flex; 
                    align-items: center; justify-content: center;" id="checkpointDemo">
            <div style="background: white; padding: 2rem; border-radius: 10px; max-width: 700px;">
                <h3><i class="fas fa-flag-checkered"></i> Demostración Checkpoint</h3>
                <div style="text-align: left; margin: 1rem 0;">
                    <h4>Proceso de Checkpoint:</h4>
                    <ol>
                        <li><strong>Escribir páginas sucias al disco</strong></li>
                        <li><strong>Registrar checkpoint en el log</strong></li>
                        <li><strong>Actualizar punteros de control</strong></li>
                        <li><strong>Sincronizar archivos de control</strong></li>
                    </ol>
                    
                    <h4>Beneficios:</h4>
                    <ul>
                        <li>Reduce tiempo de recuperación</li>
                        <li>Limita cantidad de log a procesar</li>
                        <li>Garantiza punto de consistencia conocido</li>
                    </ul>
                </div>
                <button onclick="closeOverlay('checkpointDemo')" 
                        style="padding: 0.5rem 1rem; background: #dc3545; color: white; 
                               border: none; border-radius: 5px; cursor: pointer;">
                    Cerrar
                </button>
            </div>
        </div>
    `;

    document.body.insertAdjacentHTML('beforeend', demo);
}

// Demonstrate ARIES process
function demonstrateARIES() {
    const demo = `
        <div style="position: fixed; top: 0; left: 0; width: 100%; height: 100%; 
                    background: rgba(0,0,0,0.9); z-index: 9999; display: flex; 
                    align-items: center; justify-content: center;" id="ariesDemo">
            <div style="background: white; padding: 2rem; border-radius: 10px; max-width: 800px;">
                <h3><i class="fas fa-star"></i> Demostración ARIES</h3>
                <div style="display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 1rem; text-align: left;">
                    <div style="border: 2px solid #28a745; padding: 1rem; border-radius: 5px;">
                        <h4 style="color: #28a745;">Fase 1: Análisis</h4>
                        <ul style="font-size: 0.9em;">
                            <li>Escanear log desde último checkpoint</li>
                            <li>Identificar transacciones activas</li>
                            <li>Construir DirtyPageTable</li>
                            <li>Determinar RedoLSN</li>
                        </ul>
                    </div>
                    <div style="border: 2px solid #ffc107; padding: 1rem; border-radius: 5px;">
                        <h4 style="color: #ffc107;">Fase 2: Redo</h4>
                        <ul style="font-size: 0.9em;">
                            <li>Repetir historia desde RedoLSN</li>
                            <li>Aplicar todos los cambios</li>
                            <li>Restaurar estado al momento del fallo</li>
                            <li>Incluir cambios confirmados y no confirmados</li>
                        </ul>
                    </div>
                    <div style="border: 2px solid #dc3545; padding: 1rem; border-radius: 5px;">
                        <h4 style="color: #dc3545;">Fase 3: Undo</h4>
                        <ul style="font-size: 0.9em;">
                            <li>Escanear log hacia atrás</li>
                            <li>Deshacer transacciones incompletas</li>
                            <li>Generar CLRs</li>
                            <li>Liberar recursos</li>
                        </ul>
                    </div>
                </div>
                <div style="text-align: center; margin-top: 1rem;">
                    <button onclick="closeOverlay('ariesDemo')" 
                            style="padding: 0.5rem 1rem; background: #dc3545; color: white; 
                                   border: none; border-radius: 5px; cursor: pointer;">
                        Cerrar
                    </button>
                </div>
            </div>
        </div>
    `;

    document.body.insertAdjacentHTML('beforeend', demo);
}

// Add slide-specific behaviors
Reveal.addEventListener('slidechanged', function (event) {
    const currentSlide = event.currentSlide;

    // Add special effects for different sections
    if (currentSlide.querySelector('h2')) {
        const title = currentSlide.querySelector('h2').textContent;
        
        if (title.includes('WAL')) {
            animateWALElements();
        } else if (title.includes('ARIES')) {
            animateARIESElements();
        } else if (title.includes('Checkpoint')) {
            animateCheckpointElements();
        }
    }
});

// Animate WAL elements
function animateWALElements() {
    const walElements = document.querySelectorAll('.concept-box');
    walElements.forEach((element, index) => {
        setTimeout(() => {
            element.style.transform = 'scale(1.02)';
            element.style.transition = 'transform 0.3s ease';
            setTimeout(() => {
                element.style.transform = 'scale(1)';
            }, 300);
        }, index * 100);
    });
}

// Animate ARIES elements
function animateARIESElements() {
    const phases = document.querySelectorAll('.column');
    phases.forEach((phase, index) => {
        setTimeout(() => {
            phase.style.opacity = '0.7';
            phase.style.transform = 'translateY(-5px)';
            phase.style.transition = 'all 0.5s ease';
            setTimeout(() => {
                phase.style.opacity = '1';
                phase.style.transform = 'translateY(0)';
            }, 500);
        }, index * 200);
    });
}

// Animate checkpoint elements
function animateCheckpointElements() {
    const checkpointElements = document.querySelectorAll('ul li, ol li');
    checkpointElements.forEach((element, index) => {
        setTimeout(() => {
            element.style.background = 'rgba(233, 171, 33, 0.1)';
            element.style.padding = '0.2rem';
            element.style.borderRadius = '3px';
            element.style.transition = 'all 0.3s ease';
            setTimeout(() => {
                element.style.background = 'transparent';
            }, 1000);
        }, index * 150);
    });
}

// Global function for floating help icon
function showRecoveryInfo() {
    const recoveryInfo = `
        <div style="position: fixed; top: 0; left: 0; width: 100%; height: 100%; 
                    background: rgba(0,0,0,0.8); z-index: 9999; display: flex; 
                    align-items: center; justify-content: center;" id="recoveryInfoOverlay">
            <div style="background: white; padding: 2rem; border-radius: 10px; max-width: 600px;">
                <h3><i class="fas fa-life-ring"></i> Guía de Recuperación y Logging</h3>
                <div style="text-align: left;">
                    <h4 style="color: #23356e;">Conceptos Clave</h4>
                    <ul>
                        <li><strong>WAL:</strong> Write-Ahead Log - Registro anticipado</li>
                        <li><strong>ARIES:</strong> Algorithm for Recovery and Isolation Exploiting Semantics</li>
                        <li><strong>LSN:</strong> Log Sequence Number - Identificador único</li>
                        <li><strong>CLR:</strong> Compensation Log Record - Registro de compensación</li>
                        <li><strong>Checkpoint:</strong> Punto de sincronización</li>
                    </ul>
                    
                    <h4 style="color: #e9ab21;">Comandos Útiles PostgreSQL</h4>
                    <ul style="font-size: 0.9em;">
                        <li><code>SHOW wal_level;</code> - Ver nivel WAL</li>
                        <li><code>SELECT pg_current_wal_lsn();</code> - LSN actual</li>
                        <li><code>EXPLAIN (WAL) SELECT ...;</code> - Analizar WAL</li>
                    </ul>
                </div>
                <button onclick="closeOverlay('recoveryInfoOverlay')" 
                        style="margin-top: 1rem; padding: 0.5rem 1rem; 
                               background: #23356e; color: white; border: none; 
                               border-radius: 5px; cursor: pointer;">
                    Cerrar
                </button>
            </div>
        </div>
    `;

    document.body.insertAdjacentHTML('beforeend', recoveryInfo);
}

// Enhanced error handling
window.addEventListener('error', function(event) {
    console.error('Error en presentación SGBD-ASC:', event.error);
});

// Performance monitoring
let performanceMetrics = {
    slideChanges: 0,
    interactionCount: 0,
    startTime: Date.now()
};

// Track slide changes
Reveal.addEventListener('slidechanged', function() {
    performanceMetrics.slideChanges++;
});

// Track interactions
document.addEventListener('click', function() {
    performanceMetrics.interactionCount++;
});

// Log performance on page unload
window.addEventListener('beforeunload', function() {
    const duration = Date.now() - performanceMetrics.startTime;
    console.log('Métricas de presentación:', {
        duration: duration / 1000 + ' segundos',
        slideChanges: performanceMetrics.slideChanges,
        interactions: performanceMetrics.interactionCount
    });
});

console.log('JavaScript para SGBD-ASC Semana 3 inicializado correctamente');