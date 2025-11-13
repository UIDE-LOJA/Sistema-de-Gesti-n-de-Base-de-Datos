// Demos Interactivas para HCI Semana 3

// Demo 1: Color Psychology Interactive
function initColorPsychologyDemo() {
    const hueSlider = document.getElementById('hueSlider');
    const satSlider = document.getElementById('satSlider');
    const lightSlider = document.getElementById('lightSlider');
    const previewButton = document.getElementById('previewButton');
    const hueValue = document.getElementById('hueValue');
    const satValue = document.getElementById('satValue');
    const lightValue = document.getElementById('lightValue');
    const hslCode = document.getElementById('hslCode');
    const hexCode = document.getElementById('hexCode');
    const colorFeedback = document.getElementById('colorFeedback');

    if (!hueSlider) return;

    function hslToHex(h, s, l) {
        l /= 100;
        const a = s * Math.min(l, 1 - l) / 100;
        const f = n => {
            const k = (n + h / 30) % 12;
            const color = l - a * Math.max(Math.min(k - 3, 9 - k, 1), -1);
            return Math.round(255 * color).toString(16).padStart(2, '0');
        };
        return `#${f(0)}${f(8)}${f(4)}`;
    }

    function getColorFeedback(h, s, l) {
        let emotion = '';
        let icon = '';
        
        // Hue-based emotions
        if (h >= 0 && h < 30) {
            emotion = '🔴 Rojo: Urgencia, peligro, acción inmediata';
            icon = 'fa-exclamation-triangle';
        } else if (h >= 30 && h < 60) {
            emotion = '🟠 Naranja: Energía, entusiasmo, llamado a la acción';
            icon = 'fa-bolt';
        } else if (h >= 60 && h < 150) {
            emotion = '🟢 Verde: Éxito, confirmación, seguridad';
            icon = 'fa-check-circle';
        } else if (h >= 150 && h < 210) {
            emotion = '🔵 Cian: Calma, confianza, profesionalismo';
            icon = 'fa-shield-alt';
        } else if (h >= 210 && h < 270) {
            emotion = '🔵 Azul: Confianza, estabilidad, corporativo';
            icon = 'fa-building';
        } else if (h >= 270 && h < 330) {
            emotion = '🟣 Púrpura: Creatividad, lujo, innovación';
            icon = 'fa-star';
        } else {
            emotion = '🔴 Magenta: Pasión, creatividad, atención';
            icon = 'fa-heart';
        }

        // Saturation feedback
        if (s < 30) {
            emotion += '<br><small>⚪ Baja saturación: Sutil, profesional, menos llamativo</small>';
        } else if (s > 70) {
            emotion += '<br><small>⚡ Alta saturación: Vibrante, llamativo, energético</small>';
        }

        // Lightness feedback
        if (l < 30) {
            emotion += '<br><small>🌑 Oscuro: Serio, elegante, puede ser difícil de leer</small>';
        } else if (l > 70) {
            emotion += '<br><small>☀️ Claro: Suave, amigable, puede perder impacto</small>';
        }

        return `<i class="fas ${icon}"></i> ${emotion}`;
    }

    function updateColor() {
        const h = parseInt(hueSlider.value);
        const s = parseInt(satSlider.value);
        const l = parseInt(lightSlider.value);
        
        const hslColor = `hsl(${h}, ${s}%, ${l}%)`;
        const hexColor = hslToHex(h, s, l);
        
        if (previewButton) {
            previewButton.style.backgroundColor = hslColor;
        }
        
        if (hueValue) hueValue.textContent = h;
        if (satValue) satValue.textContent = s;
        if (lightValue) lightValue.textContent = l;
        if (hslCode) hslCode.textContent = hslColor;
        if (hexCode) hexCode.textContent = hexColor;
        
        if (colorFeedback) {
            colorFeedback.innerHTML = `<p style="margin: 0; font-size: 0.85rem; color: #e2e8f0; line-height: 1.6;">${getColorFeedback(h, s, l)}</p>`;
        }
    }

    hueSlider.addEventListener('input', updateColor);
    satSlider.addEventListener('input', updateColor);
    lightSlider.addEventListener('input', updateColor);
    
    // Initialize
    updateColor();
}

// Demo 2: Gestalt Proximity Interactive - BancoApp Menu
function initGestaltProximityDemo() {
    const spacingSlider = document.getElementById('spacingSlider');
    const spacingValue = document.getElementById('spacingValue');
    const proximityCanvas = document.getElementById('proximityCanvas');
    
    if (!spacingSlider || !proximityCanvas) return;
    
    const ctx = proximityCanvas.getContext('2d');
    
    function drawBancoAppMenu(spacing) {
        const width = proximityCanvas.width = proximityCanvas.parentElement.clientWidth - 40;
        const height = proximityCanvas.height = 400;
        
        ctx.clearRect(0, 0, width, height);
        
        // Menu items for BancoApp
        const groups = [
            { title: 'Operaciones', items: ['💸 Transferir', '💳 Pagar', '📱 Recargar'], color: '#28a745' },
            { title: 'Consultas', items: ['💰 Saldo', '📊 Movimientos', '📄 Estados'], color: '#007bff' },
            { title: 'Configuración', items: ['👤 Perfil', '🔒 Seguridad', '❓ Ayuda'], color: '#6c757d' }
        ];
        
        let y = 40;
        const itemHeight = 35;
        const itemSpacing = 8;
        const groupSpacing = spacing;
        
        groups.forEach((group, groupIndex) => {
            // Draw group title
            ctx.fillStyle = '#E9AB21';
            ctx.font = 'bold 14px Arial';
            ctx.textAlign = 'left';
            ctx.fillText(group.title, 20, y);
            y += 25;
            
            // Draw items in group
            group.items.forEach((item, itemIndex) => {
                // Draw button background
                ctx.fillStyle = group.color;
                ctx.fillRect(20, y, width - 40, itemHeight);
                
                // Draw button text
                ctx.fillStyle = '#ffffff';
                ctx.font = '13px Arial';
                ctx.textAlign = 'left';
                ctx.fillText(item, 35, y + 22);
                
                y += itemHeight + itemSpacing;
            });
            
            // Add spacing between groups
            if (groupIndex < groups.length - 1) {
                y += groupSpacing;
            }
        });
        
        // Draw visual indicators
        ctx.strokeStyle = '#E9AB21';
        ctx.lineWidth = 2;
        ctx.setLineDash([5, 5]);
        
        // Indicate group boundaries
        let indicatorY = 40;
        groups.forEach((group, index) => {
            if (index > 0) {
                ctx.beginPath();
                ctx.moveTo(10, indicatorY - groupSpacing / 2);
                ctx.lineTo(width - 10, indicatorY - groupSpacing / 2);
                ctx.stroke();
            }
            indicatorY += 25 + (group.items.length * (itemHeight + itemSpacing)) + groupSpacing;
        });
        
        ctx.setLineDash([]);
    }
    
    spacingSlider.addEventListener('input', function() {
        const spacing = parseInt(this.value);
        spacingValue.textContent = spacing;
        drawBancoAppMenu(spacing);
    });
    
    // Initialize
    drawBancoAppMenu(parseInt(spacingSlider.value));
}

// Demo 3: Affordance Comparison
function initAffordanceDemo() {
    const styleToggle = document.getElementById('styleToggle');
    const demoButtons = document.querySelectorAll('.demo-button');
    
    if (!styleToggle) return;
    
    styleToggle.addEventListener('change', function() {
        const isFlat = this.checked;
        
        demoButtons.forEach(button => {
            if (isFlat) {
                button.style.boxShadow = 'none';
                button.style.background = button.dataset.flatColor || button.style.background;
            } else {
                button.style.boxShadow = '0 4px 8px rgba(0,0,0,0.2), inset 0 -2px 4px rgba(0,0,0,0.1)';
                button.style.background = button.dataset.gradientColor || button.style.background;
            }
        });
    });
}

// Demo 4: Contrast Checker
function initContrastChecker() {
    const fgColorInput = document.getElementById('fgColor');
    const bgColorInput = document.getElementById('bgColor');
    const contrastPreview = document.getElementById('contrastPreview');
    const contrastRatio = document.getElementById('contrastRatio');
    const wcagResult = document.getElementById('wcagResult');
    
    if (!fgColorInput || !bgColorInput) return;
    
    function hexToRgb(hex) {
        const result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
        return result ? {
            r: parseInt(result[1], 16),
            g: parseInt(result[2], 16),
            b: parseInt(result[3], 16)
        } : null;
    }
    
    function getLuminance(r, g, b) {
        const [rs, gs, bs] = [r, g, b].map(c => {
            c = c / 255;
            return c <= 0.03928 ? c / 12.92 : Math.pow((c + 0.055) / 1.055, 2.4);
        });
        return 0.2126 * rs + 0.7152 * gs + 0.0722 * bs;
    }
    
    function getContrastRatio(fg, bg) {
        const fgRgb = hexToRgb(fg);
        const bgRgb = hexToRgb(bg);
        
        const l1 = getLuminance(fgRgb.r, fgRgb.g, fgRgb.b);
        const l2 = getLuminance(bgRgb.r, bgRgb.g, bgRgb.b);
        
        const lighter = Math.max(l1, l2);
        const darker = Math.min(l1, l2);
        
        return (lighter + 0.05) / (darker + 0.05);
    }
    
    function updateContrast() {
        const fg = fgColorInput.value;
        const bg = bgColorInput.value;
        
        if (contrastPreview) {
            contrastPreview.style.color = fg;
            contrastPreview.style.backgroundColor = bg;
        }
        
        const ratio = getContrastRatio(fg, bg);
        
        if (contrastRatio) {
            contrastRatio.textContent = ratio.toFixed(2) + ':1';
        }
        
        if (wcagResult) {
            let result = '';
            if (ratio >= 7) {
                result = '<span style="color: #4ade80;"><i class="fas fa-check-circle"></i> AAA (Excelente)</span>';
            } else if (ratio >= 4.5) {
                result = '<span style="color: #4ade80;"><i class="fas fa-check-circle"></i> AA (Bueno)</span>';
            } else if (ratio >= 3) {
                result = '<span style="color: #fbbf24;"><i class="fas fa-exclamation-triangle"></i> AA Large (Aceptable para texto grande)</span>';
            } else {
                result = '<span style="color: #f87171;"><i class="fas fa-times-circle"></i> Falla (Contraste insuficiente)</span>';
            }
            wcagResult.innerHTML = result;
        }
    }
    
    fgColorInput.addEventListener('input', updateContrast);
    bgColorInput.addEventListener('input', updateContrast);
    
    // Initialize
    updateContrast();
}

// Initialize all demos when DOM is ready
document.addEventListener('DOMContentLoaded', function() {
    // Small delay to ensure presentation controller is initialized
    setTimeout(() => {
        initColorPsychologyDemo();
        initGestaltProximityDemo();
        initAffordanceDemo();
        initContrastChecker();
        console.log('✅ Interactive demos initialized');
    }, 500);
});
