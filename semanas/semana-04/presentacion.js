/* ============================================ */
/* TEMPLATE DE PRESENTACIÓN UIDE - CONTROLADOR */
/* Sistema de navegación para presentaciones */
/* ============================================ */

class PresentationController {
    constructor() {
        // Elementos del DOM
        this.slides = document.querySelectorAll('.slide');
        this.currentSlide = 0;
        this.totalSlides = this.slides.length;
        this.isTransitioning = false;
        
        // Cache de elementos de navegación
        this.prevBtn = document.getElementById('prevBtn');
        this.nextBtn = document.getElementById('nextBtn');
        this.currentSlideEl = document.getElementById('currentSlide');
        this.totalSlidesEl = document.getElementById('totalSlides');
        this.progressBar = document.getElementById('progressBar');
        
        this.init();
    }

    init() {
        // Establecer total de slides
        if (this.totalSlidesEl) {
            this.totalSlidesEl.textContent = this.totalSlides;
        }
        
        // Vincular eventos
        this.bindEvents();
        
        // Mostrar primera slide
        this.goToSlide(0);
        
        console.log('✅ Presentación UIDE inicializada con', this.totalSlides, 'slides');
    }

    bindEvents() {
        // Navegación con botones
        if (this.prevBtn) {
            this.prevBtn.addEventListener('click', () => this.previousSlide());
        }
        
        if (this.nextBtn) {
            this.nextBtn.addEventListener('click', () => this.nextSlide());
        }
        
        // Navegación con teclado
        document.addEventListener('keydown', (e) => {
            if (this.isTransitioning) return;
            
            switch(e.key) {
                case 'ArrowLeft':
                case 'ArrowUp':
                    e.preventDefault();
                    this.previousSlide();
                    break;
                case 'ArrowRight':
                case 'ArrowDown':
                case ' ':
                    e.preventDefault();
                    this.nextSlide();
                    break;
                case 'Home':
                    e.preventDefault();
                    this.goToSlide(0);
                    break;
                case 'End':
                    e.preventDefault();
                    this.goToSlide(this.totalSlides - 1);
                    break;
            }
        });
        
        // Soporte para gestos táctiles (swipe)
        let touchStartX = 0;
        let touchEndX = 0;
        
        document.addEventListener('touchstart', (e) => {
            touchStartX = e.changedTouches[0].screenX;
        });
        
        document.addEventListener('touchend', (e) => {
            touchEndX = e.changedTouches[0].screenX;
            this.handleSwipe();
        });
        
        const handleSwipe = () => {
            const swipeThreshold = 50;
            const diff = touchStartX - touchEndX;
            
            if (Math.abs(diff) > swipeThreshold) {
                if (diff > 0) {
                    // Swipe izquierda - siguiente slide
                    this.nextSlide();
                } else {
                    // Swipe derecha - slide anterior
                    this.previousSlide();
                }
            }
        };
        
        this.handleSwipe = handleSwipe;
    }

    goToSlide(index) {
        if (index < 0 || index >= this.totalSlides || this.isTransitioning) {
            return;
        }
        
        this.isTransitioning = true;
        
        // Ocultar todas las slides
        this.slides.forEach(slide => {
            slide.classList.remove('active');
            slide.style.display = 'none';
        });
        
        // Mostrar slide objetivo
        this.slides[index].classList.add('active');
        this.slides[index].style.display = 'flex';
        
        this.currentSlide = index;
        
        // Actualizar UI
        this.updateUI();
        
        // Permitir transiciones nuevamente
        setTimeout(() => {
            this.isTransitioning = false;
        }, 300);
    }

    updateUI() {
        // Actualizar contador de slides
        if (this.currentSlideEl) {
            this.currentSlideEl.textContent = this.currentSlide + 1;
        }
        
        // Actualizar barra de progreso
        if (this.progressBar) {
            const progress = ((this.currentSlide + 1) / this.totalSlides) * 100;
            this.progressBar.style.width = `${progress}%`;
        }
        
        // Actualizar estado de botones
        if (this.prevBtn) {
            this.prevBtn.disabled = this.currentSlide === 0;
        }
        
        if (this.nextBtn) {
            this.nextBtn.disabled = this.currentSlide === this.totalSlides - 1;
        }
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
}

// Inicializar cuando el DOM esté listo
document.addEventListener('DOMContentLoaded', () => {
    new PresentationController();
});

console.log('🚀 Sistema de presentación UIDE cargado');
