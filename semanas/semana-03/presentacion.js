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
        
        // Initialize Mermaid rendering
        window.initializeMermaidQueue();
        console.log(`🚀 Presentación lista! Iniciando renderizado de ${window.mermaidQueue.length} diagramas...`);
        window.renderNextMermaid();
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

// Mermaid Progressive Rendering System
window.mermaidQueue = [];
window.mermaidRendered = new Set();

// Collect all mermaid diagrams for progressive rendering
window.initializeMermaidQueue = () => {
    const slides = document.querySelectorAll('.slide');
    slides.forEach((slide, slideIndex) => {
        const mermaidElements = slide.querySelectorAll('.mermaid');
        mermaidElements.forEach((el, diagramIndex) => {
            const contentEl = el.querySelector('.mermaid-content');
            if (contentEl) {
                const id = `slide-${slideIndex}-diagram-${diagramIndex}`;
                window.mermaidQueue.push({
                    slideIndex,
                    diagramIndex,
                    element: el,
                    id: id,
                    code: contentEl.textContent.trim()
                });
                el.setAttribute('data-mermaid-id', id);
            }
        });
    });
};

// Progressive rendering function
window.renderNextMermaid = () => {
    const nextItem = window.mermaidQueue.find(item => !window.mermaidRendered.has(item.id));
    if (!nextItem) {
        console.log('All Mermaid diagrams rendered!');
        return;
    }
    
    const { element, id, code } = nextItem;
    const loadingEl = element.querySelector('.mermaid-loading');
    
    if (loadingEl) {
        loadingEl.style.display = 'flex';
    }
    
    try {
        // Generate safe ID without decimals
        const safeId = `mermaid_${id.replace(/-/g, '_')}_${Date.now()}`;
        
        mermaid.render(safeId, code)
            .then(result => {
                if (loadingEl) {
                    loadingEl.style.display = 'none';
                }
                element.innerHTML = result.svg;
                element.setAttribute('data-processed', 'true');
                window.mermaidRendered.add(id);
                
                console.log(`✅ Rendered diagram: ${id}`);
                
                // Render next diagram after short delay
                setTimeout(() => {
                    window.renderNextMermaid();
                }, 200);
            })
            .catch(err => {
                console.warn(`❌ Failed to render ${id}:`, err);
                if (loadingEl) {
                    loadingEl.innerHTML = `
                        <div style="color: #f56565; text-align: center;">
                            <i class="fas fa-exclamation-triangle" style="font-size: 2rem;"></i>
                            <p>Error en diagrama</p>
                        </div>
                    `;
                }
                window.mermaidRendered.add(id); // Mark as processed
                
                // Continue with next diagram
                setTimeout(() => {
                    window.renderNextMermaid();
                }, 200);
            });
    } catch (error) {
        console.error(`❌ Exception rendering ${id}:`, error);
        window.mermaidRendered.add(id);
        setTimeout(() => {
            window.renderNextMermaid();
        }, 200);
    }
};

// Check if diagram is available for current slide
window.checkSlideReadiness = (slideIndex) => {
    const slideItems = window.mermaidQueue.filter(item => item.slideIndex === slideIndex);
    const renderedCount = slideItems.filter(item => window.mermaidRendered.has(item.id)).length;
    
    if (slideItems.length > 0 && renderedCount < slideItems.length) {
        console.log(`📊 Slide ${slideIndex}: ${renderedCount}/${slideItems.length} diagramas listos`);
    }
};

// Optimized initialization with Mermaid lazy loading
document.addEventListener('DOMContentLoaded', () => {
    new PresentationController();
});

// Load Mermaid after everything else is ready
window.addEventListener('load', () => {
    if (typeof mermaid !== 'undefined') {
        // Initialize Mermaid with performance settings
        mermaid.initialize({
            startOnLoad: false,
            theme: 'dark',
            themeVariables: {
                primaryColor: '#910048',
                primaryTextColor: '#f8fafc',
                primaryBorderColor: '#23356E',
                lineColor: '#E9AB21',
                secondaryColor: '#23356E',
                tertiaryColor: '#E9AB21',
                background: '#0f1419',
                mainBkg: 'rgba(15, 23, 42, 0.8)',
                secondBkg: 'rgba(26, 31, 58, 0.8)',
                tertiaryBkg: 'rgba(145, 0, 72, 0.1)'
            },
            timeline: {
                useMaxWidth: true,
                numberSectionStyles: 3
            },
            // Performance optimizations
            securityLevel: 'loose',
            deterministicIds: true
        });
        
        // Start presentation after loading is complete
        // This will be called from the loading sequence
    }
});

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