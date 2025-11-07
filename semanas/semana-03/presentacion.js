// Presentation Controller and Mermaid Management System

class PresentationController {
    constructor() {
        this.slides = document.querySelectorAll('.slide:not(.loading-slide)');
        this.currentSlide = 0;
        this.totalSlides = this.slides.length;
        this.isTransitioning = false;
        this.loadingComplete = false;
        
        // Cache DOM elements immediately
        this.prevBtn = document.getElementById('prevBtn');
        this.nextBtn = document.getElementById('nextBtn');
        this.currentSlideEl = document.getElementById('currentSlide');
        this.totalSlidesEl = document.getElementById('totalSlides');
        this.progressBar = document.getElementById('progressBar');
        this.loadingSlide = document.getElementById('loadingSlide');
        
        this.totalSlidesEl.textContent = this.totalSlides;
        
        this.startLoadingSequence();
        this.bindEvents();
        this.loadFromURL();
        this.updateDisplay();
    }

    bindEvents() {
        this.prevBtn.addEventListener('click', () => this.previousSlide());
        this.nextBtn.addEventListener('click', () => this.nextSlide());
        
        // Minimal keyboard events - IMMEDIATE response
        document.addEventListener('keydown', (e) => {
            if (this.isTransitioning) return;
            
            const key = e.code; // Use keyCode for better performance
            switch(key) {
                case 'ArrowLeft':
                case 'ArrowUp':
                    e.preventDefault();
                    this.previousSlide();
                    break;
                case 'ArrowRight':
                case 'ArrowDown':
                case 'Space':
                    e.preventDefault();
                    this.nextSlide();
                    break;
            }
        }, { passive: false });

        // Simplified touch support - removed for performance
        // Touch navigation disabled to improve INP
    }

    goToSlide(index) {
        if (index < 0 || index >= this.totalSlides || this.isTransitioning) return;
        
        this.isTransitioning = true;
        
        // INSTANT visual feedback - no transitions
        this.slides[this.currentSlide].style.display = 'none';
        this.slides[index].style.display = 'flex';
        
        this.currentSlide = index;
        
        // Update UI immediately
        this.currentSlideEl.textContent = index + 1;
        this.progressBar.style.width = `${((index + 1) / this.totalSlides) * 100}%`;
        this.prevBtn.disabled = index === 0;
        this.nextBtn.disabled = index === this.totalSlides - 1;
        
        // Check readiness of diagrams for this slide
        if (typeof window.checkSlideReadiness === 'function') {
            window.checkSlideReadiness(index);
        }
        
        // Reset transition flag immediately
        this.isTransitioning = false;
    }

    nextSlide() {
        if (this.currentSlide < this.totalSlides - 1) {
            this.goToSlide(this.currentSlide + 1);
        }
    }

    previousSlide() {
        if (this.currentSlide > 0) {
            this.goToSlide(this.currentSlide - 1);
        }
    }

    updateDisplay() {
        if (this.loadingComplete) {
            // Update slide counter only after loading
            this.currentSlideEl.textContent = this.currentSlide + 1;
            this.progressBar.style.width = `${((this.currentSlide + 1) / this.totalSlides) * 100}%`;
            this.prevBtn.disabled = this.currentSlide === 0;
            this.nextBtn.disabled = this.currentSlide === this.totalSlides - 1;
        }
    }
    
    startLoadingSequence() {
        const steps = ['step1', 'step2', 'step3', 'step4'];
        const progressEl = document.getElementById('loadingProgress');
        let currentStep = 0;
        
        const advanceStep = () => {
            if (currentStep > 0) {
                const prevStep = document.getElementById(steps[currentStep - 1]);
                prevStep.classList.remove('active');
                prevStep.classList.add('completed');
                prevStep.querySelector('i').className = 'fas fa-check-circle';
            }
            
            if (currentStep < steps.length) {
                document.getElementById(steps[currentStep]).classList.add('active');
                progressEl.style.width = `${((currentStep + 1) / steps.length) * 100}%`;
                currentStep++;
                
                if (currentStep < steps.length) {
                    setTimeout(advanceStep, 1200);
                } else {
                    // Final step - start presentation
                    setTimeout(() => {
                        this.completeLoading();
                    }, 800);
                }
            }
        };
        
        // Start the sequence
        setTimeout(advanceStep, 500);
    }
    
    completeLoading() {
        this.loadingComplete = true;
        
        // Hide loading slide
        this.loadingSlide.style.display = 'none';
        
        // Show first real slide
        this.slides[0].style.display = 'flex';
        
        // Update display
        this.updateDisplay();
        
        // Initialize Mermaid system - but wait for Mermaid to be available
        this.initializeMermaidWhenReady();
    }
    
    initializeMermaidWhenReady() {
        const checkMermaidAndInit = () => {
            if (typeof mermaid !== 'undefined' && mermaid.initialize) {
                console.log('🚀 Mermaid disponible! Iniciando sistema...');
                
                // First configure Mermaid
                if (!window.configureMermaid()) {
                    console.error('❌ No se pudo configurar Mermaid, reintentando...');
                    setTimeout(checkMermaidAndInit, 1000);
                    return;
                }
                
                // Then initialize the system
                window.initializeMermaidSystem();
                console.log(`🚀 Presentación lista! Iniciando renderizado progresivo de ${window.mermaidSlideQueue.length} diagramas...`);
                
                // Start progressive rendering after ensuring everything is ready
                setTimeout(() => {
                    window.renderMermaidProgressive();
                }, 1500);
            } else {
                console.log('⏳ Esperando a que Mermaid esté disponible...');
                setTimeout(checkMermaidAndInit, 500);
            }
        };
        
        checkMermaidAndInit();
    }

    // Removed - elements cached in constructor

    // Removed floating elements completely for performance

    updateURL() {
        // Simplified URL update
        window.location.hash = `slide-${this.currentSlide + 1}`;
    }

    loadFromURL() {
        const hash = window.location.hash;
        if (hash.startsWith('#slide-')) {
            const slideNumber = parseInt(hash.replace('#slide-', ''));
            if (slideNumber >= 1 && slideNumber <= this.totalSlides) {
                // Hide all slides
                for (let i = 0; i < this.slides.length; i++) {
                    this.slides[i].style.display = 'none';
                }
                
                this.currentSlide = slideNumber - 1;
                this.slides[this.currentSlide].style.display = 'flex';
                
                // Update UI immediately
                this.currentSlideEl.textContent = slideNumber;
                this.progressBar.style.width = `${(slideNumber / this.totalSlides) * 100}%`;
                this.prevBtn.disabled = slideNumber === 1;
                this.nextBtn.disabled = slideNumber === this.totalSlides;
            }
        }
    }
}

// Mermaid Official Progressive Rendering System (v10+)
window.mermaidSlideQueue = [];
window.mermaidProcessed = new Set();

// Initialize Mermaid diagrams according to official docs
window.initializeMermaidSystem = () => {
    console.log('🔧 Iniciando sistema Mermaid v10+...');
    
    // First ensure Mermaid is configured
    if (!window.configureMermaid()) {
        console.error('❌ No se pudo configurar Mermaid, abortando inicialización');
        return;
    }
    
    // Convert our custom structure to standard Mermaid format
    const slides = document.querySelectorAll('.slide');
    console.log(`📊 Encontradas ${slides.length} slides`);
    
    slides.forEach((slide, slideIndex) => {
        const customMermaidElements = slide.querySelectorAll('.mermaid');
        console.log(`📋 Slide ${slideIndex}: ${customMermaidElements.length} elementos mermaid`);
        
        customMermaidElements.forEach((element, diagramIndex) => {
            const contentEl = element.querySelector('.mermaid-content');
            const loadingEl = element.querySelector('.mermaid-loading');
            
            if (contentEl && contentEl.textContent.trim()) {
                let diagramCode = contentEl.textContent.trim();
                console.log(`📝 Contenido original longitud: ${diagramCode.length}`);
                
                // Remove YAML frontmatter if present (not supported in v10+)
                if (diagramCode.startsWith('---')) {
                    const frontmatterEnd = diagramCode.indexOf('---', 3);
                    if (frontmatterEnd !== -1) {
                        diagramCode = diagramCode.substring(frontmatterEnd + 3).trim();
                        console.log(`✂️ YAML frontmatter removido, nueva longitud: ${diagramCode.length}`);
                    }
                }
                
                // Clean up any problematic characters or HTML entities
                diagramCode = diagramCode
                    .replace(/&quot;/g, '"')
                    .replace(/&lt;/g, '<')
                    .replace(/&gt;/g, '>')
                    .replace(/&amp;/g, '&');
                
                const id = `slide-${slideIndex}-diagram-${diagramIndex}`;
                
                // Create standard Mermaid pre tag (as per official docs)
                const preElement = document.createElement('pre');
                preElement.className = 'mermaid';
                preElement.textContent = diagramCode;
                preElement.style.display = 'none'; // Start hidden
                preElement.setAttribute('data-slide-id', slideIndex.toString());
                preElement.setAttribute('data-diagram-id', id);
                
                // Replace custom structure with standard one
                element.appendChild(preElement);
                
                // Queue for progressive rendering
                window.mermaidSlideQueue.push({
                    slideIndex,
                    diagramIndex,
                    id,
                    element,
                    preElement,
                    loadingEl
                });
                
                console.log(`📋 Encolado diagrama: ${id}`);
            }
        });
    });
};

// Progressive rendering using official mermaid.run() method
window.renderMermaidProgressive = async () => {
    // Triple-check that Mermaid is available and properly initialized
    if (typeof mermaid === 'undefined' || !mermaid.initialize || !mermaid.run) {
        console.error('❌ Mermaid no está disponible para el renderizado');
        // Retry after a delay
        setTimeout(() => {
            window.renderMermaidProgressive();
        }, 1000);
        return;
    }
    
    const unprocessed = window.mermaidSlideQueue.filter(item => !window.mermaidProcessed.has(item.id));
    
    if (unprocessed.length === 0) {
        console.log('✅ Todos los diagramas Mermaid han sido renderizados');
        return;
    }
    
    // Get next diagram to process
    const nextItem = unprocessed[0];
    const { id, element, preElement, loadingEl } = nextItem;
    
    try {
        console.log(`🔄 Renderizando diagrama: ${id}`);
        
        // Show loading state
        if (loadingEl) {
            loadingEl.style.display = 'flex';
        }
        
        // Show the pre element for Mermaid to process
        preElement.style.display = 'block';
        
        // Use official mermaid.run() method (recommended for v10+)
        await mermaid.run({
            nodes: [preElement],
            suppressErrors: false
        });
        
        // Hide loading, show rendered diagram
        if (loadingEl) {
            loadingEl.style.display = 'none';
        }
        
        // Mark as processed
        window.mermaidProcessed.add(id);
        console.log(`✅ Diagrama renderizado exitosamente: ${id}`);
        
        // Continue with next diagram after delay
        setTimeout(() => {
            window.renderMermaidProgressive();
        }, 500);
        
    } catch (error) {
        console.warn(`❌ Error renderizando ${id}:`, error);
        
        // Check if it's a timing error and retry
        if (error.message && error.message.includes('mermaid is not defined')) {
            console.log('⏳ Reintentando por error de timing...');
            setTimeout(() => {
                window.renderMermaidProgressive();
            }, 1500);
            return;
        }
        
        // Show error state for actual diagram errors
        if (loadingEl) {
            loadingEl.innerHTML = `
                <div style="color: #f56565; text-align: center; padding: 2rem;">
                    <i class="fas fa-exclamation-triangle" style="font-size: 2rem; margin-bottom: 1rem;"></i>
                    <p>Error renderizando diagrama</p>
                    <p style="font-size: 0.9rem; opacity: 0.8;">${error.message || 'Revisa la sintaxis Mermaid'}</p>
                </div>
            `;
        }
        
        // Hide broken pre element
        preElement.style.display = 'none';
        
        // Mark as processed to continue
        window.mermaidProcessed.add(id);
        
        // Continue with next diagram
        setTimeout(() => {
            window.renderMermaidProgressive();
        }, 500);
    }
};

// Check diagram readiness for current slide
window.checkSlideReadiness = (slideIndex) => {
    const slideItems = window.mermaidSlideQueue.filter(item => item.slideIndex === slideIndex);
    const renderedCount = slideItems.filter(item => window.mermaidProcessed.has(item.id)).length;
    
    if (slideItems.length > 0) {
        console.log(`📊 Slide ${slideIndex}: ${renderedCount}/${slideItems.length} diagramas listos`);
        
        if (renderedCount < slideItems.length) {
            console.log(`⏳ Algunos diagramas aún se están procesando...`);
        }
    }
};

// CRITICAL: Prevent Mermaid auto-initialization ASAP
if (typeof window !== 'undefined') {
    // Set global flag to prevent auto-initialization
    window.mermaidStartOnLoad = false;
    
    // Try to configure immediately when Mermaid loads
    let mermaidConfigAttempts = 0;
    const earlyMermaidConfig = () => {
        if (typeof mermaid !== 'undefined' && mermaidConfigAttempts < 10) {
            console.log('⚡ Configuración temprana de Mermaid detectada');
            mermaid.initialize({ startOnLoad: false });
            return true;
        }
        mermaidConfigAttempts++;
        if (mermaidConfigAttempts < 10) {
            setTimeout(earlyMermaidConfig, 100);
        }
        return false;
    };
    
    // Start early configuration attempts
    earlyMermaidConfig();
}

// Optimized initialization with Mermaid lazy loading
document.addEventListener('DOMContentLoaded', () => {
    new PresentationController();
});

// Configure Mermaid when it becomes available
window.configureMermaid = () => {
    if (typeof mermaid !== 'undefined') {
        console.log('🧪 Configurando Mermaid v10+ con mejores prácticas...');
        
        try {
            // CRITICAL: Completely disable auto-initialization
            if (mermaid.mermaidAPI) {
                mermaid.mermaidAPI.initialize({ startOnLoad: false });
            }
            
            // Initialize Mermaid with minimal, safe configuration
            mermaid.initialize({
                startOnLoad: false, // CRITICAL: We control rendering manually
                theme: 'dark',
                securityLevel: 'loose',
                deterministicIds: false, // Disable for compatibility
                suppressErrorRendering: false,
                flowchart: {
                    useMaxWidth: true,
                    htmlLabels: false // Disable HTML labels for compatibility
                }
            });
            
            console.log('✅ Mermaid configurado correctamente');
            return true;
        } catch (error) {
            console.error('❌ Error configurando Mermaid:', error);
            return false;
        }
    } else {
        console.warn('⚠️ Mermaid aún no está disponible');
        return false;
    }
};

// Remove redundant configuration - handled by initializeMermaidWhenReady()
// This was causing timing conflicts

// Handle direct URL access
window.addEventListener('load', () => {
    const hash = window.location.hash;
    if (hash.startsWith('#slide-')) {
        const slideNumber = parseInt(hash.replace('#slide-', ''));
        if (slideNumber >= 1 && slideNumber <= document.querySelectorAll('.slide').length) {
            // Scroll to top to ensure proper viewing
            window.scrollTo(0, 0);
        }
    }
});

// Cursor personalizado eliminado para mejorar rendimiento

// Debug: Verificar que el archivo se carga correctamente
console.log('🚀 presentacion.js cargado correctamente');