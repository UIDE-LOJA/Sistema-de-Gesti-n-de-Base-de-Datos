// Custom JavaScript for Semana 2 - Paradigmas de Simulación

// ===== FUNCIONES GLOBALES PARA AGENTE ASPIRADORA =====
// Declarar funciones globales temprano para evitar errores de referencia
let startVacuumSimulation, resetVacuumSimulation, closeResultsModal;

// Initialize presentation when DOM is loaded
document.addEventListener('DOMContentLoaded', function () {
    console.log('Presentación Semana 2 - Paradigmas de Simulación cargada');

    // Add interactive behaviors
    initializeInteractiveElements();

    // Add keyboard shortcuts
    addKeyboardShortcuts();

    // Initialize timers for activities
    initializeTimers();
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
}

// Add keyboard shortcuts
function addKeyboardShortcuts() {
    document.addEventListener('keydown', function (event) {
        // Press 'h' to show help
        if (event.key === 'h' || event.key === 'H') {
            showHelp();
        }

        // Press 't' to toggle timer
        if (event.key === 't' || event.key === 'T') {
            toggleTimer();
        }

        // Classification cheat sheet removed from keyboard shortcut
    });
}

// Show help overlay
function showHelp() {
    const helpContent = `
        <div style="position: fixed; top: 0; left: 0; width: 100%; height: 100%; 
                    background: rgba(0,0,0,0.8); z-index: 9999; display: flex; 
                    align-items: center; justify-content: center;" id="helpOverlay">
            <div style="background: white; padding: 2rem; border-radius: 10px; max-width: 500px;">
                <h3>Atajos de Teclado</h3>
                <ul style="text-align: left;">
                    <li><strong>H:</strong> Mostrar esta ayuda</li>
                    <li><strong>T:</strong> Activar/desactivar temporizador</li>
                    <li><strong><i class="fas fa-question-circle"></i> (icono flotante):</strong> Mostrar guía de clasificación</li>
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

// Show classification cheat sheet
function showClassificationCheatSheet() {
    const cheatSheetContent = `
        <div style="position: fixed; top: 0; left: 0; width: 100%; height: 100%; 
                    background: rgba(0,0,0,0.8); z-index: 9999; display: flex; 
                    align-items: center; justify-content: center;" id="cheatSheetOverlay">
            <div style="background: white; padding: 2rem; border-radius: 10px; max-width: 600px;">
                <h3>Guía Rápida de Clasificación</h3>
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; text-align: left;">
                    <div>
                        <h4 style="color: #28a745;">Temporal</h4>
                        <p><strong>Discreto:</strong> Cambios instantáneos en puntos específicos</p>
                        <p><strong>Continuo:</strong> Cambios graduales y constantes</p>
                    </div>
                    <div>
                        <h4 style="color: #910048;">Aleatoriedad</h4>
                        <p><strong>Determinístico:</strong> Mismas entradas = mismas salidas</p>
                        <p><strong>Estocástico:</strong> Interviene el azar</p>
                    </div>
                </div>
                <button onclick="closeOverlay('cheatSheetOverlay')" 
                        style="margin-top: 1rem; padding: 0.5rem 1rem; 
                               background: #910048; color: white; border: none; 
                               border-radius: 5px; cursor: pointer;">
                    Cerrar
                </button>
            </div>
        </div>
    `;

    document.body.insertAdjacentHTML('beforeend', cheatSheetContent);
}

// Close overlay function
function closeOverlay(overlayId) {
    const overlay = document.getElementById(overlayId);
    if (overlay) {
        overlay.remove();
    }
}

// Timer functionality
let timerInterval;
let timerActive = false;
let timeRemaining = 300; // 5 minutes default

function initializeTimers() {
    // Look for timer boxes and add functionality
    const timerBoxes = document.querySelectorAll('.timer-box');
    timerBoxes.forEach(box => {
        box.addEventListener('click', function () {
            const timeText = this.textContent;
            const minutes = parseInt(timeText.match(/(\d+)\s*minutos?/)?.[1] || '5');
            startTimer(minutes * 60);
        });
    });
}

function toggleTimer() {
    if (timerActive) {
        stopTimer();
    } else {
        startTimer(300); // 5 minutes default
    }
}

function startTimer(seconds) {
    timeRemaining = seconds;
    timerActive = true;

    // Create timer display
    const timerDisplay = document.createElement('div');
    timerDisplay.id = 'timerDisplay';
    timerDisplay.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        background: #910048;
        color: white;
        padding: 10px 15px;
        border-radius: 20px;
        font-weight: bold;
        z-index: 1000;
        font-size: 1.2em;
    `;
    document.body.appendChild(timerDisplay);

    timerInterval = setInterval(() => {
        const minutes = Math.floor(timeRemaining / 60);
        const seconds = timeRemaining % 60;
        timerDisplay.textContent = `${minutes}:${seconds.toString().padStart(2, '0')}`;

        if (timeRemaining <= 0) {
            stopTimer();
            alert('¡Tiempo terminado!');
        }

        timeRemaining--;
    }, 1000);
}

function stopTimer() {
    timerActive = false;
    clearInterval(timerInterval);
    const timerDisplay = document.getElementById('timerDisplay');
    if (timerDisplay) {
        timerDisplay.remove();
    }
}

// Add slide-specific behaviors
Reveal.addEventListener('slidechanged', function (event) {
    const currentSlide = event.currentSlide;

    // Auto-start timers on activity slides
    if (currentSlide.querySelector('.timer-box')) {
        console.log('Slide con actividad detectado');
    }

    // Add special effects for paradigm slides
    if (currentSlide.querySelector('.paradigm-comparison')) {
        animateParadigmCards();
    }
});

// Animate paradigm cards
function animateParadigmCards() {
    const cards = document.querySelectorAll('.paradigm-card');
    cards.forEach((card, index) => {
        setTimeout(() => {
            card.style.transform = 'scale(1.05)';
            card.style.transition = 'transform 0.3s ease';
            setTimeout(() => {
                card.style.transform = 'scale(1)';
            }, 300);
        }, index * 200);
    });
}

// Add classification helper
function classifySystem(system, temporal, randomness) {
    return {
        system: system,
        temporal: temporal, // 'discrete' or 'continuous'
        randomness: randomness, // 'deterministic' or 'stochastic'
        description: `${system} es ${temporal} y ${randomness}`
    };
}

// Example classifications for reference
const exampleClassifications = [
    classifySystem('Cajero automático', 'discreto', 'estocástico'),
    classifySystem('Llenado de tanque', 'continuo', 'determinístico'),
    classifySystem('Llegada de clientes', 'discreto', 'estocástico'),
    classifySystem('Crecimiento poblacional', 'continuo', 'estocástico'),
    classifySystem('Cálculo de interés', 'discreto', 'determinístico')
];

console.log('Ejemplos de clasificación cargados:', exampleClassifications);

// Interactive Classification System
function initializeClassificationSystem() {
    // Add click handlers for classification cards
    const classificationItems = document.querySelectorAll('[onclick*="borderColor"]');
    classificationItems.forEach(item => {
        item.addEventListener('click', function () {
            // Toggle selection
            if (this.style.borderColor === 'rgb(40, 167, 69)') {
                this.style.borderColor = '#ddd';
                this.style.background = 'rgba(255, 255, 255, 0.9)';
            } else {
                this.style.borderColor = '#28a745';
                this.style.background = 'rgba(40, 167, 69, 0.1)';
            }
        });
    });
}

// Classification Helper Function
function showClassificationHint(systemName) {
    const hints = {
        'cajero': 'Pista: ¿El saldo cambia gradualmente o de golpe cuando retiras dinero?',
        'piscina': 'Pista: ¿El agua sube de manera constante o a saltos?',
        'produccion': 'Pista: ¿Los autos se completan uno por uno o gradualmente?',
        'bacteria': 'Pista: ¿Las bacterias se reproducen constantemente o en momentos específicos?',
        'semaforos': 'Pista: ¿Las luces cambian gradualmente o instantáneamente?'
    };

    const hint = hints[systemName.toLowerCase()];
    if (hint) {
        alert(hint);
    }
}

// Enhanced slide navigation with progress tracking
let slideProgress = {
    temporal: false,
    aleatoriedad: false,
    agentes: false,
    actividades: false
};

function updateProgress(section) {
    slideProgress[section] = true;
    updateProgressIndicator();
}

function updateProgressIndicator() {
    const completed = Object.values(slideProgress).filter(Boolean).length;
    const total = Object.keys(slideProgress).length;
    const percentage = (completed / total) * 100;

    // Update any progress indicators on the page
    const progressBars = document.querySelectorAll('.progress-bar');
    progressBars.forEach(bar => {
        bar.style.width = percentage + '%';
    });
}

// Gallery interaction functions
function initializeGalleries() {
    // Add click handlers for gallery items
    const galleryItems = document.querySelectorAll('[style*="transform: scale"]');
    galleryItems.forEach(item => {
        item.addEventListener('click', function () {
            // Add a subtle flash effect when clicked
            const originalBg = this.style.background;
            this.style.background = 'rgba(233, 171, 33, 0.2)';
            setTimeout(() => {
                this.style.background = originalBg;
            }, 300);

            // Show additional info if available
            const title = this.querySelector('h6');
            if (title) {
                showGalleryInfo(title.textContent);
            }
        });
    });
}

function showGalleryInfo(title) {
    const info = {
        'Sistema de Colas': 'Los clientes llegan y son atendidos en momentos específicos. El número en cola cambia instantáneamente.',
        'Cajero Automático': 'Las transacciones ocurren en eventos discretos. El saldo se actualiza inmediatamente.',
        'Línea de Producción': 'Los productos se completan uno por uno en momentos determinados del proceso.',
        'Flujo de Líquido': 'El caudal varía continuamente según la presión y las condiciones del sistema.',
        'Transferencia de Calor': 'La temperatura cambia gradualmente siguiendo las leyes de la termodinámica.',
        'Crecimiento Poblacional': 'La población aumenta de forma continua según tasas de natalidad y mortalidad.',
        'Posición de Partícula': 'La trayectoria se calcula exactamente usando ecuaciones de movimiento.',
        'Cálculo de Interés': 'El resultado es predecible usando fórmulas matemáticas establecidas.',
        'Cantidad Económica (CEP)': 'La cantidad óptima se determina mediante optimización matemática.',
        'Llegada de Clientes': 'Los tiempos de llegada siguen distribuciones probabilísticas.',
        'Fallas de Equipos': 'Las fallas ocurren según patrones probabilísticos impredecibles.',
        'Fluctuaciones del Mercado': 'Los precios varían según factores aleatorios múltiples.',
        'Sistema Aeroportuario': 'Combina llegadas discretas de aviones con flujo continuo de combustible.',
        'Sistema Hospitalario': 'Mezcla llegadas discretas de pacientes con uso continuo de recursos.',
        'Planta Manufacturera': 'Integra órdenes discretas con flujos continuos de materiales.'
    };

    const description = info[title];
    if (description) {
        // Create a tooltip or small popup
        const tooltip = document.createElement('div');
        tooltip.style.cssText = `
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background: rgba(0, 0, 0, 0.9);
            color: white;
            padding: 1rem 1.5rem;
            border-radius: 8px;
            max-width: 300px;
            z-index: 10000;
            font-size: 0.9em;
            text-align: center;
            box-shadow: 0 4px 20px rgba(0,0,0,0.3);
        `;
        tooltip.innerHTML = `
            <h6 style="margin: 0 0 0.5rem 0; color: #E9AB21;">${title}</h6>
            <p style="margin: 0; line-height: 1.4;">${description}</p>
            <button onclick="this.parentElement.remove()" 
                    style="margin-top: 0.8rem; padding: 0.3rem 0.8rem; 
                           background: #E9AB21; color: black; border: none; 
                           border-radius: 4px; cursor: pointer; font-size: 0.8em;">
                Cerrar
            </button>
        `;

        document.body.appendChild(tooltip);

        // Auto-remove after 8 seconds
        setTimeout(() => {
            if (tooltip.parentElement) {
                tooltip.remove();
            }
        }, 8000);
    }
}

// Enhanced image loading with fallbacks
function handleImageError(img) {
    // Fallback to a placeholder if Unsplash image fails
    img.src = 'data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMzAwIiBoZWlnaHQ9IjIwMCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48cmVjdCB3aWR0aD0iMTAwJSIgaGVpZ2h0PSIxMDAlIiBmaWxsPSIjZGRkIi8+PHRleHQgeD0iNTAlIiB5PSI1MCUiIGZvbnQtZmFtaWx5PSJBcmlhbCIgZm9udC1zaXplPSIxNCIgZmlsbD0iIzk5OSIgdGV4dC1hbmNob3I9Im1pZGRsZSIgZHk9Ii4zZW0iPkltYWdlbiBubyBkaXNwb25pYmxlPC90ZXh0Pjwvc3ZnPg==';
    img.alt = 'Imagen no disponible';
}

// Simple dice functionality (no animations)
function initializeDiceAnimations() {
    // Dice icons are now static - no animations
    console.log('Dice animations disabled for cleaner presentation');
}

// Initialize enhanced features when DOM is ready
document.addEventListener('DOMContentLoaded', function () {
    initializeClassificationSystem();
    initializeGalleries();

    // Add error handling to all images
    const images = document.querySelectorAll('img[src*="unsplash"]');
    images.forEach(img => {
        img.addEventListener('error', () => handleImageError(img));
    });

    // Add progress tracking to slides
    Reveal.addEventListener('slidechanged', function (event) {
        const slide = event.currentSlide;

        // Track progress based on slide content
        if (slide.querySelector('h2').textContent.includes('Temporal')) {
            updateProgress('temporal');
        } else if (slide.querySelector('h2').textContent.includes('Aleatoriedad')) {
            updateProgress('aleatoriedad');
        } else if (slide.querySelector('h2').textContent.includes('Agentes')) {
            updateProgress('agentes');
        } else if (slide.querySelector('h2').textContent.includes('Actividades')) {
            updateProgress('actividades');
        }
    });
});

// Interactive Timer Functions for Activities
let timers = {};

function startTimer(timerId, seconds) {
    // Stop any existing timer for this ID
    if (timers[timerId]) {
        clearInterval(timers[timerId].interval);
    }

    // Initialize timer object
    timers[timerId] = {
        timeRemaining: seconds,
        originalTime: seconds,
        interval: null,
        isRunning: true
    };

    // Start the countdown
    timers[timerId].interval = setInterval(() => {
        const timer = timers[timerId];
        const minutes = Math.floor(timer.timeRemaining / 60);
        const secs = timer.timeRemaining % 60;

        // Update display
        const display = document.getElementById(timerId + '-display');
        if (display) {
            display.textContent = `${minutes.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`;

            // Change color when time is running low
            if (timer.timeRemaining <= 60) {
                display.style.color = '#dc3545'; // Red
            } else if (timer.timeRemaining <= 120) {
                display.style.color = '#ffc107'; // Yellow
            } else {
                display.style.color = 'var(--uide-primary)'; // Normal
            }
        }

        // Check if time is up
        if (timer.timeRemaining <= 0) {
            clearInterval(timer.interval);
            timer.isRunning = false;

            // Flash the timer and show alert
            if (display) {
                display.style.animation = 'flash 1s infinite';
                display.textContent = '00:00';
            }

            // Show notification
            showTimerNotification(timerId);
        }

        timer.timeRemaining--;
    }, 1000);
}

function pauseTimer(timerId) {
    if (timers[timerId] && timers[timerId].interval) {
        clearInterval(timers[timerId].interval);
        timers[timerId].isRunning = false;

        // Update display to show paused state
        const display = document.getElementById(timerId + '-display');
        if (display) {
            display.style.opacity = '0.6';
        }
    }
}

function resetTimer(timerId, seconds) {
    // Clear existing timer
    if (timers[timerId]) {
        clearInterval(timers[timerId].interval);
    }

    // Reset display
    const display = document.getElementById(timerId + '-display');
    if (display) {
        const minutes = Math.floor(seconds / 60);
        const secs = seconds % 60;
        display.textContent = `${minutes.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`;
        display.style.color = 'var(--uide-primary)';
        display.style.opacity = '1';
        display.style.animation = 'none';
    }

    // Reset timer object
    timers[timerId] = {
        timeRemaining: seconds,
        originalTime: seconds,
        interval: null,
        isRunning: false
    };
}

function showTimerNotification(timerId) {
    // Create notification
    const notification = document.createElement('div');
    notification.style.cssText = `
        position: fixed;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        background: #dc3545;
        color: white;
        padding: 20px 30px;
        border-radius: 10px;
        font-size: 1.5em;
        font-weight: bold;
        z-index: 10000;
        box-shadow: 0 4px 20px rgba(0,0,0,0.3);
        animation: pulse 0.5s ease-in-out;
    `;
    notification.innerHTML = `
        <i class="fas fa-clock"></i> ¡Tiempo terminado!
        <div style="font-size: 0.7em; margin-top: 10px;">
            <button onclick="this.parentElement.parentElement.remove()" 
                    style="background: white; color: #dc3545; border: none; 
                           padding: 5px 15px; border-radius: 5px; cursor: pointer;">
                Cerrar
            </button>
        </div>
    `;

    document.body.appendChild(notification);

    // Auto-remove after 5 seconds
    setTimeout(() => {
        if (notification.parentElement) {
            notification.remove();
        }
    }, 5000);

    // Play sound if available
    try {
        const audio = new Audio('data:audio/wav;base64,UklGRnoGAABXQVZFZm10IBAAAAABAAEAQB8AAEAfAAABAAgAZGF0YQoGAACBhYqFbF1fdJivrJBhNjVgodDbq2EcBj+a2/LDciUFLIHO8tiJNwgZaLvt559NEAxQp+PwtmMcBjiR1/LMeSwFJHfH8N2QQAoUXrTp66hVFApGn+DyvmwhBSuBzvLZiTYIG2m98OScTgwOUarm7blmGgU7k9n1unEiBC13yO/eizEIHWq+8+OWT');
        audio.play().catch(() => {
            // Ignore audio errors
        });
    } catch (e) {
        // Ignore audio errors
    }
}

// ===== SIMULACIÓN AGENTE ASPIRADORA =====

// Variables globales para la simulación
let vacuumSimulation = {
    isRunning: false,
    agentPosition: { x: 0, y: 0 },
    gridSize: { width: 4, height: 2 },
    dirtyCells: new Set(),
    cleanedCells: new Set(),
    currentStep: 0,
    maxSteps: 20,
    animationSpeed: 1500, // ms entre movimientos
    intervalId: null
};

// Inicializar la simulación del agente aspiradora
function initializeVacuumSimulation() {
    // Generar suciedad aleatoria
    generateRandomDirt();

    // Posicionar el agente en (0,0)
    positionVacuumAgent(0, 0);

    // Actualizar estado inicial
    updateAgentStatus('Listo para comenzar', 0, 0);

    console.log('Simulación del agente aspiradora inicializada');
}

// Generar suciedad aleatoria en las celdas
function generateRandomDirt() {
    const { dirtyCells } = vacuumSimulation;
    dirtyCells.clear();

    // Generar entre 3-6 celdas sucias aleatoriamente
    const numDirtyCells = Math.floor(Math.random() * 4) + 3;

    while (dirtyCells.size < numDirtyCells) {
        const cellIndex = Math.floor(Math.random() * 8);
        dirtyCells.add(cellIndex);
    }

    // Actualizar visualización
    updateCellsDisplay();
}

// Actualizar la visualización de las celdas
function updateCellsDisplay() {
    const { dirtyCells, cleanedCells } = vacuumSimulation;

    for (let i = 0; i < 8; i++) {
        const cell = document.getElementById(`cell-${i}`);
        const dirtMarker = cell.querySelector('.dirt-marker');

        // Limpiar clases previas
        cell.classList.remove('dirty', 'clean', 'current');

        if (dirtyCells.has(i) && !cleanedCells.has(i)) {
            // Celda sucia
            cell.classList.add('dirty');
            dirtMarker.style.display = 'block';
            dirtMarker.style.animation = 'dirt-appear 0.5s ease-out';
        } else if (cleanedCells.has(i)) {
            // Celda limpia
            cell.classList.add('clean');
            dirtMarker.style.display = 'none';
        } else {
            // Celda normal
            dirtMarker.style.display = 'none';
        }
    }
}

// Posicionar el agente aspiradora
function positionVacuumAgent(x, y) {
    const agent = document.getElementById('vacuum-agent');
    const cellIndex = y * 4 + x;
    const targetCell = document.getElementById(`cell-${cellIndex}`);

    if (agent && targetCell) {
        const cellRect = targetCell.getBoundingClientRect();
        const containerRect = targetCell.parentElement.getBoundingClientRect();

        // Calcular posición centrada (responsive)
        const isMobile = window.innerWidth <= 768;
        const cellSize = isMobile ? 50 : 65;
        const gap = isMobile ? 4 : 6;
        const agentSize = isMobile ? 32 : 40;

        // Centrar el agente en la celda
        const cellCenterX = (x * (cellSize + gap)) + (cellSize / 2) - (agentSize / 2);
        const cellCenterY = (y * (cellSize + gap)) + (cellSize / 2) - (agentSize / 2);

        const relativeX = cellCenterX;
        const relativeY = cellCenterY;

        agent.style.transform = `translate(${relativeX}px, ${relativeY}px)`;

        // Actualizar posición en el estado
        vacuumSimulation.agentPosition = { x, y };

        // Marcar celda actual
        document.querySelectorAll('.vacuum-cell').forEach(cell => {
            cell.classList.remove('current');
        });
        targetCell.classList.add('current');
    }
}

// Iniciar la simulación (función interna)
function startVacuumSimulationInternal() {
    if (vacuumSimulation.isRunning) return;

    vacuumSimulation.isRunning = true;
    vacuumSimulation.currentStep = 0;

    // Actualizar botones
    const startBtn = document.getElementById('start-simulation');
    const resetBtn = document.getElementById('reset-simulation');

    if (startBtn) {
        startBtn.innerHTML = '<i class="fas fa-pause"></i> Pausar';
        startBtn.onclick = pauseVacuumSimulation;
    }

    // Iniciar el bucle de simulación
    runSimulationStep();

    updateAgentStatus('Simulación en progreso...',
        vacuumSimulation.agentPosition.x,
        vacuumSimulation.agentPosition.y);
}

// Pausar la simulación
function pauseVacuumSimulation() {
    vacuumSimulation.isRunning = false;

    if (vacuumSimulation.intervalId) {
        clearTimeout(vacuumSimulation.intervalId);
    }

    // Actualizar botones
    const startBtn = document.getElementById('start-simulation');
    if (startBtn) {
        startBtn.innerHTML = '<i class="fas fa-play"></i> Continuar';
        startBtn.onclick = startVacuumSimulationInternal;
    }

    updateAgentStatus('Simulación pausada',
        vacuumSimulation.agentPosition.x,
        vacuumSimulation.agentPosition.y);
}

// Ejecutar un paso de la simulación
function runSimulationStep() {
    if (!vacuumSimulation.isRunning) return;

    const { agentPosition, dirtyCells, cleanedCells, gridSize } = vacuumSimulation;
    const currentCellIndex = agentPosition.y * gridSize.width + agentPosition.x;

    // Verificar si la celda actual está sucia
    if (dirtyCells.has(currentCellIndex) && !cleanedCells.has(currentCellIndex)) {
        // Aspirar la suciedad
        cleanCell(currentCellIndex);

        updateAgentStatus('Aspirando suciedad...', agentPosition.x, agentPosition.y);

        // Esperar un momento antes del siguiente movimiento
        vacuumSimulation.intervalId = setTimeout(() => {
            moveToNextCell();
        }, vacuumSimulation.animationSpeed);

    } else {
        // Moverse a la siguiente celda
        moveToNextCell();
    }

    // Incrementar contador de pasos
    vacuumSimulation.currentStep++;

    // Verificar si se completó la limpieza o se alcanzó el máximo de pasos
    if (isCleaningComplete() || vacuumSimulation.currentStep >= vacuumSimulation.maxSteps) {
        completeSimulation();
    }
}

// Limpiar una celda
function cleanCell(cellIndex) {
    const { cleanedCells } = vacuumSimulation;
    const agent = document.getElementById('vacuum-agent');
    const cell = document.getElementById(`cell-${cellIndex}`);

    // Añadir a celdas limpias
    cleanedCells.add(cellIndex);

    // Animación de limpieza del agente
    if (agent) {
        agent.style.animation = 'vacuum-clean 1s ease-in-out';
        setTimeout(() => {
            agent.style.animation = '';
        }, 1000);
    }

    // Animación de la celda siendo limpiada
    if (cell) {
        cell.style.animation = 'cell-cleaning 1s ease-in-out';
        setTimeout(() => {
            cell.style.animation = '';
            updateCellsDisplay();
        }, 1000);
    }
}

// Mover a la siguiente celda
function moveToNextCell() {
    const { agentPosition, gridSize, dirtyCells, cleanedCells } = vacuumSimulation;

    // Estrategia simple: movimiento sistemático por filas
    let nextX = agentPosition.x;
    let nextY = agentPosition.y;

    // Buscar la siguiente celda sucia más cercana
    let targetFound = false;

    // Primero buscar celdas sucias
    for (let y = 0; y < gridSize.height && !targetFound; y++) {
        for (let x = 0; x < gridSize.width && !targetFound; x++) {
            const cellIndex = y * gridSize.width + x;
            if (dirtyCells.has(cellIndex) && !cleanedCells.has(cellIndex)) {
                nextX = x;
                nextY = y;
                targetFound = true;
            }
        }
    }

    // Si no hay celdas sucias, moverse sistemáticamente
    if (!targetFound) {
        nextX = agentPosition.x + 1;
        if (nextX >= gridSize.width) {
            nextX = 0;
            nextY = agentPosition.y + 1;
            if (nextY >= gridSize.height) {
                nextY = 0;
            }
        }
    }

    // Mover el agente
    positionVacuumAgent(nextX, nextY);

    updateAgentStatus('Moviéndose...', nextX, nextY);

    // Programar el siguiente paso
    if (vacuumSimulation.isRunning) {
        vacuumSimulation.intervalId = setTimeout(() => {
            runSimulationStep();
        }, vacuumSimulation.animationSpeed);
    }
}

// Verificar si se completó la limpieza
function isCleaningComplete() {
    const { dirtyCells, cleanedCells } = vacuumSimulation;

    for (let cellIndex of dirtyCells) {
        if (!cleanedCells.has(cellIndex)) {
            return false;
        }
    }
    return true;
}

// Completar la simulación
function completeSimulation() {
    vacuumSimulation.isRunning = false;

    if (vacuumSimulation.intervalId) {
        clearTimeout(vacuumSimulation.intervalId);
    }

    // Actualizar botones
    const startBtn = document.getElementById('start-simulation');
    if (startBtn) {
        startBtn.innerHTML = '<i class="fas fa-check"></i> Completado';
        startBtn.disabled = true;
        startBtn.style.background = '#28a745';
    }

    const message = isCleaningComplete() ?
        '¡Limpieza completada exitosamente!' :
        'Simulación terminada (máximo de pasos alcanzado)';

    updateAgentStatus(message,
        vacuumSimulation.agentPosition.x,
        vacuumSimulation.agentPosition.y);

    // Mostrar estadísticas finales
    showSimulationResults();
}

// Mostrar resultados de la simulación
function showSimulationResults() {
    const { dirtyCells, cleanedCells, currentStep } = vacuumSimulation;
    const efficiency = Math.round((cleanedCells.size / dirtyCells.size) * 100);

    // Crear overlay de fondo
    const overlay = document.createElement('div');
    overlay.id = 'results-overlay';
    overlay.style.cssText = `
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0, 0, 0, 0.5);
        z-index: 9999;
        display: flex;
        align-items: center;
        justify-content: center;
        animation: fadeIn 0.3s ease-out;
    `;

    // Crear modal
    const resultsDiv = document.createElement('div');
    resultsDiv.style.cssText = `
        background: white;
        padding: 2rem;
        border-radius: 12px;
        box-shadow: 0 8px 32px rgba(0,0,0,0.3);
        text-align: center;
        border: 3px solid var(--uide-primary);
        max-width: 400px;
        width: 90%;
        position: relative;
        animation: slideIn 0.3s ease-out;
    `;

    resultsDiv.innerHTML = `
        <!-- Botón X para cerrar -->
        <button onclick="closeResultsModal()" 
                style="position: absolute; top: 10px; right: 10px; 
                       background: none; border: none; font-size: 1.5em; 
                       color: #999; cursor: pointer; width: 30px; height: 30px;
                       display: flex; align-items: center; justify-content: center;
                       border-radius: 50%; transition: all 0.2s ease;"
                onmouseover="this.style.background='#f0f0f0'; this.style.color='#333';"
                onmouseout="this.style.background='none'; this.style.color='#999';">
            <i class="fas fa-times"></i>
        </button>
        
        <h4 style="color: var(--uide-primary); margin: 0 0 1rem 0;">
            <i class="fas fa-chart-bar"></i> Resultados de la Simulación
        </h4>
        
        <div style="background: #f8f9fa; padding: 1rem; border-radius: 8px; margin-bottom: 1rem;">
            <p style="margin: 0.5rem 0;"><strong>Celdas Limpiadas:</strong> ${cleanedCells.size}/${dirtyCells.size}</p>
            <p style="margin: 0.5rem 0;"><strong>Eficiencia:</strong> ${efficiency}%</p>
            <p style="margin: 0.5rem 0;"><strong>Pasos Ejecutados:</strong> ${currentStep}</p>
            ${efficiency === 100 ?
            '<p style="margin: 0.5rem 0; color: #28a745; font-weight: bold;"><i class="fas fa-check-circle"></i> ¡Limpieza Perfecta!</p>' :
            '<p style="margin: 0.5rem 0; color: #ffc107;"><i class="fas fa-info-circle"></i> Algunas celdas quedaron sin limpiar</p>'
        }
        </div>
        
        <div style="margin-top: 1rem;">
            <button onclick="closeResultsModal()" 
                    style="background: var(--uide-primary); color: white; border: none; 
                           padding: 0.8rem 1.5rem; border-radius: 25px; cursor: pointer; 
                           margin-right: 0.5rem; transition: all 0.2s ease;"
                    onmouseover="this.style.transform='translateY(-2px)'; this.style.boxShadow='0 4px 12px rgba(0,0,0,0.2)';"
                    onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='none';">
                <i class="fas fa-times"></i> Cerrar
            </button>
            <button onclick="closeResultsModal(); resetVacuumSimulation();" 
                    style="background: var(--uide-secondary); color: white; border: none; 
                           padding: 0.8rem 1.5rem; border-radius: 25px; cursor: pointer;
                           transition: all 0.2s ease;"
                    onmouseover="this.style.transform='translateY(-2px)'; this.style.boxShadow='0 4px 12px rgba(0,0,0,0.2)';"
                    onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='none';">
                <i class="fas fa-redo"></i> Nueva Simulación
            </button>
        </div>
        
        <p style="font-size: 0.8em; color: #666; margin-top: 1rem; margin-bottom: 0;">
            <i class="fas fa-keyboard"></i> Presiona <kbd style="background: #f0f0f0; padding: 2px 6px; border-radius: 3px;">Esc</kbd> para cerrar
        </p>
    `;

    // Añadir modal al overlay
    overlay.appendChild(resultsDiv);

    // Cerrar al hacer clic en el overlay (fondo)
    overlay.addEventListener('click', function (e) {
        if (e.target === overlay) {
            closeResultsModal();
        }
    });

    // Cerrar con tecla Escape
    const escapeHandler = function (e) {
        if (e.key === 'Escape') {
            closeResultsModal();
        }
    };
    document.addEventListener('keydown', escapeHandler);

    // Guardar referencia del handler para poder removerlo
    overlay.escapeHandler = escapeHandler;

    // Añadir al DOM
    document.body.appendChild(overlay);

    // Enfocar el modal para que funcione la tecla Escape
    resultsDiv.focus();
}

// Función para cerrar el modal de resultados (función interna)
function closeResultsModalInternal() {
    const overlay = document.getElementById('results-overlay');
    if (overlay) {
        // Remover el event listener de Escape
        if (overlay.escapeHandler) {
            document.removeEventListener('keydown', overlay.escapeHandler);
        }

        // Animación de salida
        overlay.style.animation = 'fadeOut 0.2s ease-out';
        setTimeout(() => {
            if (overlay.parentElement) {
                overlay.remove();
            }
        }, 200);
    }
}

// Reiniciar la simulación (función interna)
function resetVacuumSimulationInternal() {
    // Detener simulación actual
    vacuumSimulation.isRunning = false;
    if (vacuumSimulation.intervalId) {
        clearTimeout(vacuumSimulation.intervalId);
    }

    // Reiniciar estado
    vacuumSimulation.agentPosition = { x: 0, y: 0 };
    vacuumSimulation.cleanedCells.clear();
    vacuumSimulation.currentStep = 0;

    // Generar nueva configuración de suciedad
    generateRandomDirt();

    // Reposicionar agente
    positionVacuumAgent(0, 0);

    // Actualizar botones
    const startBtn = document.getElementById('start-simulation');
    if (startBtn) {
        startBtn.innerHTML = '<i class="fas fa-play"></i> Iniciar';
        startBtn.onclick = startVacuumSimulation;
        startBtn.disabled = false;
        startBtn.style.background = 'var(--uide-primary)';
    }

    // Actualizar estado
    updateAgentStatus('Listo para comenzar', 0, 0);

    console.log('Simulación reiniciada');
}

// Actualizar el estado del agente
function updateAgentStatus(status, x, y) {
    const statusText = document.getElementById('status-text');
    const positionText = document.getElementById('position-text');
    const cleanCount = document.getElementById('clean-count');
    const statusContainer = document.getElementById('agent-status');

    if (statusText) {
        statusText.textContent = status;
    }

    if (positionText) {
        positionText.textContent = `(${x}, ${y})`;
    }

    if (cleanCount) {
        cleanCount.textContent = vacuumSimulation.cleanedCells.size;
    }

    // Animación de actualización
    if (statusContainer) {
        statusContainer.classList.add('status-updating');
        setTimeout(() => {
            statusContainer.classList.remove('status-updating');
        }, 300);
    }
}

// Inicializar cuando el DOM esté listo
document.addEventListener('DOMContentLoaded', function () {
    // Esperar un poco para que los elementos se rendericen
    setTimeout(() => {
        if (document.getElementById('vacuum-simulation')) {
            initializeVacuumSimulation();
        }
    }, 500);
});

// Asignar funciones a variables globales y window
startVacuumSimulation = function () {
    return startVacuumSimulationInternal();
};

resetVacuumSimulation = function () {
    return resetVacuumSimulationInternal();
};

closeResultsModal = function () {
    return closeResultsModalInternal();
};

// Exponer funciones en window para acceso desde HTML
window.startVacuumSimulation = startVacuumSimulation;
window.resetVacuumSimulation = resetVacuumSimulation;
window.closeResultsModal = closeResultsModal;
// ===== MATRIZ DE CLASIFICACIÓN INTERACTIVA =====

// Animar tarjeta de matriz al hacer hover
function animateMatrixCard(card, category) {
    // Animar íconos
    const icons = card.querySelectorAll('.matrix-icon-1, .matrix-icon-2');
    icons.forEach((icon, index) => {
        setTimeout(() => {
            icon.style.animation = 'matrix-icon-bounce 0.6s ease-out';
        }, index * 100);
    });

    // Efecto de brillo
    card.style.background = getMatrixCardHoverColor(category);

    // Animar ejemplo
    const example = card.querySelector('.matrix-example');
    if (example) {
        example.style.transform = 'scale(1.05) translateY(-2px)';
    }
}

// Resetear animación de tarjeta
function resetMatrixCard(card) {
    // Resetear íconos
    const icons = card.querySelectorAll('.matrix-icon-1, .matrix-icon-2');
    icons.forEach(icon => {
        icon.style.animation = '';
    });

    // Resetear ejemplo
    const example = card.querySelector('.matrix-example');
    if (example) {
        example.style.transform = '';
    }
}

// Obtener color de hover según categoría
function getMatrixCardHoverColor(category) {
    const colors = {
        'discrete-deterministic': 'rgba(40, 167, 69, 0.2)',
        'discrete-stochastic': 'rgba(35, 53, 110, 0.2)',
        'continuous-deterministic': 'rgba(233, 171, 33, 0.2)',
        'continuous-stochastic': 'rgba(145, 0, 72, 0.2)'
    };
    return colors[category] || 'rgba(0, 0, 0, 0.1)';
}

// Mostrar detalles de la matriz al hacer clic
function showMatrixDetails(category) {
    const details = {
        'discrete-deterministic': {
            title: 'Discreto + Determinístico',
            description: 'Sistemas donde los cambios ocurren en momentos específicos y los resultados son completamente predecibles.',
            examples: [
                '<i class="fas fa-chart-bar"></i> Cálculo de inventario EOQ',
                '<i class="fas fa-dollar-sign"></i> Cálculo de interés compuesto',
                '<i class="fas fa-calculator"></i> Algoritmos matemáticos',
                '<i class="fas fa-chart-line"></i> Modelos de optimización lineal'
            ],
            characteristics: [
                'Estados bien definidos',
                'Transiciones en momentos específicos',
                'Resultados reproducibles',
                'No hay incertidumbre'
            ],
            color: '#28a745'
        },
        'discrete-stochastic': {
            title: 'Discreto + Estocástico',
            description: 'Sistemas donde los cambios ocurren en eventos específicos pero con resultados aleatorios.',
            examples: [
                '<i class="fas fa-users"></i> Sistemas de colas (llegada de clientes)',
                '<i class="fas fa-dice"></i> Juegos de azar',
                '<i class="fas fa-phone"></i> Llamadas telefónicas',
                '<i class="fas fa-traffic-light"></i> Semáforos con tráfico variable'
            ],
            characteristics: [
                'Eventos en momentos específicos',
                'Resultados probabilísticos',
                'Requiere análisis estadístico',
                'Múltiples corridas necesarias'
            ],
            color: '#23356E'
        },
        'continuous-deterministic': {
            title: 'Continuo + Determinístico',
            description: 'Sistemas donde las variables cambian continuamente de manera predecible.',
            examples: [
                '<i class="fas fa-tint"></i> Flujo de líquidos',
                '<i class="fas fa-thermometer-half"></i> Transferencia de calor',
                '<i class="fas fa-rocket"></i> Trayectoria de proyectiles',
                '<i class="fas fa-bolt"></i> Circuitos eléctricos'
            ],
            characteristics: [
                'Cambio continuo en el tiempo',
                'Ecuaciones diferenciales',
                'Resultados exactos',
                'Leyes físicas deterministas'
            ],
            color: '#E9AB21'
        },
        'continuous-stochastic': {
            title: 'Continuo + Estocástico',
            description: 'Sistemas donde las variables cambian continuamente pero con componentes aleatorios.',
            examples: [
                '<i class="fas fa-seedling"></i> Crecimiento poblacional',
                '<i class="fas fa-chart-line"></i> Mercados financieros',
                '<i class="fas fa-water"></i> Movimiento browniano',
                '<i class="fas fa-virus"></i> Propagación de epidemias'
            ],
            characteristics: [
                'Cambio continuo con ruido',
                'Ecuaciones diferenciales estocásticas',
                'Resultados probabilísticos',
                'Análisis de Monte Carlo'
            ],
            color: '#910048'
        }
    };

    const detail = details[category];
    if (!detail) return;

    // Crear modal con detalles
    const modal = document.createElement('div');
    modal.style.cssText = `
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0, 0, 0, 0.7);
        z-index: 10000;
        display: flex;
        align-items: center;
        justify-content: center;
        animation: fadeIn 0.3s ease-out;
        backdrop-filter: blur(3px);
    `;

    modal.innerHTML = `
        <div style="background: white; padding: 2rem; border-radius: 15px; max-width: 600px; width: 90%; 
                    box-shadow: 0 10px 40px rgba(0,0,0,0.3); position: relative; max-height: 80vh; overflow-y: auto;">
            
            <button onclick="this.parentElement.parentElement.remove()" 
                    style="position: absolute; top: 15px; right: 15px; background: none; border: none; 
                           font-size: 1.5em; color: #999; cursor: pointer; width: 30px; height: 30px;
                           display: flex; align-items: center; justify-content: center; border-radius: 50%;
                           transition: all 0.2s ease;"
                    onmouseover="this.style.background='#f0f0f0'; this.style.color='#333';"
                    onmouseout="this.style.background='none'; this.style.color='#999';">
                <i class="fas fa-times"></i>
            </button>
            
            <h3 style="color: ${detail.color}; margin: 0 0 1rem 0; text-align: center;">
                <i class="fas fa-chart-bar"></i> ${detail.title}
            </h3>
            
            <p style="color: #666; line-height: 1.6; margin-bottom: 1.5rem; text-align: center;">
                ${detail.description}
            </p>
            
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem;">
                <div>
                    <h5 style="color: ${detail.color}; margin-bottom: 0.8rem;">
                        <i class="fas fa-lightbulb"></i> Ejemplos:
                    </h5>
                    <ul style="list-style: none; padding: 0;">
                        ${detail.examples.map(example =>
        `<li style="padding: 0.3rem 0; font-size: 0.9em;">${example}</li>`
    ).join('')}
                    </ul>
                </div>
                
                <div>
                    <h5 style="color: ${detail.color}; margin-bottom: 0.8rem;">
                        <i class="fas fa-cogs"></i> Características:
                    </h5>
                    <ul style="list-style: none; padding: 0;">
                        ${detail.characteristics.map(char =>
        `<li style="padding: 0.3rem 0; font-size: 0.9em;">
                                <i class="fas fa-check" style="color: ${detail.color}; margin-right: 0.5rem;"></i>
                                ${char}
                            </li>`
    ).join('')}
                    </ul>
                </div>
            </div>
            
            <div style="text-align: center; margin-top: 1.5rem; padding-top: 1rem; border-top: 1px solid #eee;">
                <button onclick="this.parentElement.parentElement.remove()" 
                        style="background: ${detail.color}; color: white; border: none; 
                               padding: 0.8rem 2rem; border-radius: 25px; cursor: pointer; 
                               font-size: 0.9em; transition: all 0.2s ease;"
                        onmouseover="this.style.transform='translateY(-2px)'; this.style.boxShadow='0 4px 12px rgba(0,0,0,0.2)';"
                        onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='none';">
                    <i class="fas fa-check"></i> Entendido
                </button>
            </div>
        </div>
    `;

    // Cerrar al hacer clic en el fondo
    modal.addEventListener('click', function (e) {
        if (e.target === modal) {
            modal.remove();
        }
    });

    // Cerrar con tecla Escape
    const escapeHandler = function (e) {
        if (e.key === 'Escape') {
            modal.remove();
            document.removeEventListener('keydown', escapeHandler);
        }
    };
    document.addEventListener('keydown', escapeHandler);

    document.body.appendChild(modal);
}

// Hacer funciones accesibles globalmente
window.animateMatrixCard = animateMatrixCard;
window.resetMatrixCard = resetMatrixCard;
window.showMatrixDetails = showMatrixDetails;
//===== TABLA DE DECISIONES INTERACTIVA =====

// Contador para las entradas de la tabla
let decisionEntryCounter = 2;

// Posibles percepciones y acciones para el agente
const agentPerceptions = [
    { icon: 'fas fa-circle', color: '#dc3545', text: 'Celda sucia' },
    { icon: 'fas fa-check-circle', color: '#28a745', text: 'Celda limpia' },
    { icon: 'fas fa-exclamation-triangle', color: '#ffc107', text: 'Obstáculo detectado' },
    { icon: 'fas fa-battery-quarter', color: '#dc3545', text: 'Batería baja' },
    { icon: 'fas fa-wifi', color: '#007bff', text: 'Señal perdida' }
];

const agentActions = [
    { icon: 'fas fa-broom', color: '#28a745', text: 'Aspirar' },
    { icon: 'fas fa-arrow-right', color: '#007bff', text: 'Mover derecha' },
    { icon: 'fas fa-arrow-left', color: '#007bff', text: 'Mover izquierda' },
    { icon: 'fas fa-arrow-up', color: '#007bff', text: 'Mover arriba' },
    { icon: 'fas fa-arrow-down', color: '#007bff', text: 'Mover abajo' },
    { icon: 'fas fa-pause', color: '#6c757d', text: 'Esperar' },
    { icon: 'fas fa-home', color: '#17a2b8', text: 'Regresar base' }
];

const agentResults = [
    { icon: 'fas fa-check', color: '#28a745', text: 'Limpia' },
    { icon: 'fas fa-map-marker-alt', color: '#007bff', text: 'Pos (1,0)' },
    { icon: 'fas fa-map-marker-alt', color: '#007bff', text: 'Pos (0,1)' },
    { icon: 'fas fa-map-marker-alt', color: '#007bff', text: 'Pos (2,1)' },
    { icon: 'fas fa-times', color: '#dc3545', text: 'Bloqueado' },
    { icon: 'fas fa-battery-full', color: '#28a745', text: 'Cargando' },
    { icon: 'fas fa-signal', color: '#28a745', text: 'Conectado' }
];

// Función para añadir una nueva entrada a la tabla de decisiones
function addDecisionEntry() {
    decisionEntryCounter++;

    // Seleccionar elementos aleatorios
    const perception = agentPerceptions[Math.floor(Math.random() * agentPerceptions.length)];
    const action = agentActions[Math.floor(Math.random() * agentActions.length)];
    const result = agentResults[Math.floor(Math.random() * agentResults.length)];

    const tableBody = document.getElementById('decision-table-body');
    if (!tableBody) return;

    // Crear nueva fila
    const newRow = document.createElement('tr');
    newRow.style.cssText = `
        background: #fff;
        animation: slideInRow 0.5s ease-out;
        opacity: 0;
        transform: translateX(-20px);
    `;

    newRow.innerHTML = `
        <td style="padding: 0.4rem; border: 1px solid #ddd; text-align: center; font-weight: bold;">${decisionEntryCounter}</td>
        <td style="padding: 0.4rem; border: 1px solid #ddd;">
            <i class="${perception.icon}" style="color: ${perception.color};"></i> ${perception.text}
        </td>
        <td style="padding: 0.4rem; border: 1px solid #ddd;">
            <i class="${action.icon}" style="color: ${action.color};"></i> ${action.text}
        </td>
        <td style="padding: 0.4rem; border: 1px solid #ddd;">
            <i class="${result.icon}" style="color: ${result.color};"></i> ${result.text}
        </td>
    `;

    // Añadir la fila con animación
    tableBody.appendChild(newRow);

    // Animar la entrada
    setTimeout(() => {
        newRow.style.opacity = '1';
        newRow.style.transform = 'translateX(0)';
        newRow.style.transition = 'all 0.5s ease-out';
    }, 50);

    // Resaltar la nueva fila temporalmente
    setTimeout(() => {
        newRow.style.background = 'rgba(40, 167, 69, 0.1)';
        setTimeout(() => {
            newRow.style.background = '#fff';
        }, 1000);
    }, 100);

    // Limitar a máximo 8 entradas para no sobrecargar
    if (tableBody.children.length > 8) {
        const firstRow = tableBody.firstElementChild;
        firstRow.style.animation = 'slideOutRow 0.3s ease-out';
        setTimeout(() => {
            if (firstRow.parentElement) {
                firstRow.remove();
            }
        }, 300);
    }

    // Mostrar mensaje de aprendizaje
    showLearningMessage();
}

// Mostrar mensaje de aprendizaje del agente
function showLearningMessage() {
    const messages = [
        'El agente registra esta experiencia...',
        'Aprendiendo nuevo patrón de comportamiento...',
        'Actualizando tabla de decisiones...',
        'Mejorando estrategia basada en experiencia...',
        'Registrando secuencia percepción-acción...'
    ];

    const message = messages[Math.floor(Math.random() * messages.length)];

    // Crear tooltip temporal
    const tooltip = document.createElement('div');
    tooltip.style.cssText = `
        position: absolute;
        top: -40px;
        right: 10px;
        background: rgba(35, 53, 110, 0.9);
        color: white;
        padding: 0.5rem 0.8rem;
        border-radius: 15px;
        font-size: 0.7em;
        white-space: nowrap;
        z-index: 1000;
        animation: tooltipFade 2s ease-out;
        pointer-events: none;
    `;
    tooltip.innerHTML = `<i class="fas fa-brain"></i> ${message}`;

    const container = document.getElementById('decision-table-container');
    if (container) {
        container.style.position = 'relative';
        container.appendChild(tooltip);

        setTimeout(() => {
            if (tooltip.parentElement) {
                tooltip.remove();
            }
        }, 2000);
    }
}

// Hacer función accesible globalmente
window.addDecisionEntry = addDecisionEntry;
// Función para reiniciar la tabla de decisiones
function resetDecisionTable() {
    const tableBody = document.getElementById('decision-table-body');
    if (!tableBody) return;

    // Animar salida de todas las filas existentes
    const rows = Array.from(tableBody.children);
    rows.forEach((row, index) => {
        setTimeout(() => {
            row.style.animation = 'slideOutRow 0.3s ease-out';
            setTimeout(() => {
                if (row.parentElement) {
                    row.remove();
                }
            }, 300);
        }, index * 100);
    });

    // Reiniciar contador
    decisionEntryCounter = 0;

    // Añadir las filas iniciales después de limpiar
    setTimeout(() => {
        addInitialDecisionEntries();
        showResetMessage();
    }, rows.length * 100 + 400);
}

// Función para añadir las entradas iniciales
function addInitialDecisionEntries() {
    const tableBody = document.getElementById('decision-table-body');
    if (!tableBody) return;

    // Datos iniciales
    const initialEntries = [
        {
            perception: { icon: 'fas fa-circle', color: '#dc3545', text: 'Celda sucia' },
            action: { icon: 'fas fa-broom', color: '#28a745', text: 'Aspirar' },
            result: { icon: 'fas fa-check', color: '#28a745', text: 'Limpia' }
        },
        {
            perception: { icon: 'fas fa-check-circle', color: '#28a745', text: 'Celda limpia' },
            action: { icon: 'fas fa-arrow-right', color: '#007bff', text: 'Mover derecha' },
            result: { icon: 'fas fa-map-marker-alt', color: '#007bff', text: 'Pos (1,0)' }
        }
    ];

    initialEntries.forEach((entry, index) => {
        decisionEntryCounter++;

        const newRow = document.createElement('tr');
        newRow.style.cssText = `
            background: ${index % 2 === 0 ? '#f8f9fa' : '#fff'};
            animation: slideInRow 0.5s ease-out;
            animation-delay: ${index * 0.2}s;
            opacity: 0;
            transform: translateX(-20px);
        `;

        newRow.innerHTML = `
            <td style="padding: 0.4rem; border: 1px solid #ddd; text-align: center; font-weight: bold;">${decisionEntryCounter}</td>
            <td style="padding: 0.4rem; border: 1px solid #ddd;">
                <i class="${entry.perception.icon}" style="color: ${entry.perception.color};"></i> ${entry.perception.text}
            </td>
            <td style="padding: 0.4rem; border: 1px solid #ddd;">
                <i class="${entry.action.icon}" style="color: ${entry.action.color};"></i> ${entry.action.text}
            </td>
            <td style="padding: 0.4rem; border: 1px solid #ddd;">
                <i class="${entry.result.icon}" style="color: ${entry.result.color};"></i> ${entry.result.text}
            </td>
        `;

        tableBody.appendChild(newRow);

        // Animar la entrada
        setTimeout(() => {
            newRow.style.opacity = '1';
            newRow.style.transform = 'translateX(0)';
            newRow.style.transition = 'all 0.5s ease-out';
        }, (index * 200) + 100);
    });
}

// Mostrar mensaje de reinicio
function showResetMessage() {
    const message = 'Tabla reiniciada - Memoria del agente limpia';

    // Crear tooltip temporal
    const tooltip = document.createElement('div');
    tooltip.style.cssText = `
        position: absolute;
        top: -40px;
        left: 50%;
        transform: translateX(-50%);
        background: rgba(145, 0, 72, 0.9);
        color: white;
        padding: 0.5rem 1rem;
        border-radius: 15px;
        font-size: 0.7em;
        white-space: nowrap;
        z-index: 1000;
        animation: tooltipFade 2.5s ease-out;
        pointer-events: none;
    `;
    tooltip.innerHTML = `<i class="fas fa-redo"></i> ${message}`;

    const container = document.getElementById('decision-table-container');
    if (container) {
        container.style.position = 'relative';
        container.appendChild(tooltip);

        setTimeout(() => {
            if (tooltip.parentElement) {
                tooltip.remove();
            }
        }, 2500);
    }
}

// Hacer función accesible globalmente
window.resetDecisionTable = resetDecisionTable;