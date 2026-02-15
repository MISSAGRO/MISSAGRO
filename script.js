document.addEventListener('DOMContentLoaded', () => {
    // === NAVIGATION LOGIC ===
    const navLinks = document.querySelectorAll('.nav-links a');
    const sections = document.querySelectorAll('.page-section');
    const mobileMenuBtn = document.querySelector('.mobile-menu-btn');
    const navList = document.querySelector('.nav-links');

    function navigateToSection(targetId) {
        // Hide all sections
        sections.forEach(section => {
            section.classList.remove('active');
            section.style.display = 'none'; // Ensure it's hidden for the fade effect to work on re-display
        });

        // Show target section
        const targetSection = document.getElementById(targetId);
        if (targetSection) {
            targetSection.style.display = 'block';
            // Slight delay to allow display:block to apply before adding class for animation
            setTimeout(() => {
                targetSection.classList.add('active');
            }, 10);

            // If it's the home section, trigger hero animations if any
        }

        // Update Nav Links
        navLinks.forEach(link => {
            link.classList.remove('active');
            if (link.getAttribute('data-target') === targetId) {
                link.classList.add('active');
            }
        });

        // Close mobile menu if open
        if (window.innerWidth <= 768) {
            navList.style.display = 'none';
        }
    }

    // Event Listeners for Nav Links
    navLinks.forEach(link => {
        link.addEventListener('click', (e) => {
            e.preventDefault();
            const targetId = link.getAttribute('data-target');
            navigateToSection(targetId);
        });
    });

    // Handle CTA buttons in Hero
    const ctaButtons = document.querySelectorAll('.cta-group a');
    ctaButtons.forEach(btn => {
        btn.addEventListener('click', (e) => {
            e.preventDefault();
            const targetId = btn.getAttribute('data-nav');
            if (targetId) navigateToSection(targetId);
        });
    });

    // Mobile Menu Toggle
    mobileMenuBtn.addEventListener('click', () => {
        if (navList.style.display === 'flex') {
            navList.style.display = 'none';
        } else {
            navList.style.display = 'flex';
            navList.style.flexDirection = 'column';
            navList.style.position = 'absolute';
            navList.style.top = '70px';
            navList.style.left = '0';
            navList.style.width = '100%';
            navList.style.background = 'var(--bg-card)';
            navList.style.padding = '20px';
        }
    });

    // === ANIMATION FOR HERO TITLE ===
    const animatedTitle = document.querySelector('.animated-title');
    if (animatedTitle) {
        const text = animatedTitle.getAttribute('data-text');
        const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@#$%&';

        function animateText() {
            let iterations = 0;
            const interval = setInterval(() => {
                animatedTitle.innerText = animatedTitle.innerText
                    .split('')
                    .map((letter, index) => {
                        if (index < iterations) {
                            return text[index];
                        }
                        return chars[Math.floor(Math.random() * chars.length)];
                    })
                    .join('');

                if (iterations >= text.length) {
                    clearInterval(interval);
                }
                iterations += 1 / 3;
            }, 50);
        }

        // Delay start for better impact
        setTimeout(animateText, 800);

        // Re-trigger on hover for "wow" factor
        animatedTitle.addEventListener('mouseover', animateText);
    }




    // === TECNO RADAR DASHBOARD LOGIC ===
    const radarData = {
        questions: [
            // AXIS: Digitalización
            { id: 'd1', axis: 'Digitalización', text: '¿Utiliza plataformas de gestión integral (SaaS) para centralizar la información?', options: ['Ninguna', 'Solo registro básico', 'Uso habitual', 'Integración total'], values: [1, 2, 4, 5] },
            { id: 'd2', axis: 'Digitalización', text: '¿Sus datos están integrados automáticamente entre diferentes plataformas?', options: ['No están integrados', 'Carga manual', 'Sincronización parcial', 'Automatización total'], values: [1, 2, 4, 5] },
            { id: 'd3', axis: 'Digitalización', text: '¿Cuenta con conectividad (Wi-Fi/4G/LoRa) en los lotes?', options: ['Sin señal', 'Solo en el casco', 'Cobertura parcial', 'Conectividad total'], values: [1, 3, 4, 5] },
            { id: 'd4', axis: 'Digitalización', text: '¿Realiza copias de seguridad de sus datos agronómicos en la nube?', options: ['No', 'A veces', 'Frecuentemente', 'Sistema automático'], values: [1, 2, 4, 5] },

            // AXIS: Maquinaria
            { id: 'm1', axis: 'Maquinaria', text: '¿Qué nivel de automatización tienen sus tractores/cosechadoras?', options: ['Manual', 'Piloto automático básico', 'Piloto con giro en cabecera', 'Autónoma / Supervisada'], values: [1, 3, 4, 5] },
            { id: 'm2', axis: 'Maquinaria', text: '¿Utiliza telemetría para monitoreo de flota en tiempo real?', options: ['Ninguna', 'Monitoreo básico', 'Seguimiento activo', 'Análisis predictivo de fallas'], values: [1, 2, 4, 5] },
            { id: 'm3', axis: 'Maquinaria', text: '¿Realiza aplicaciones variables (VRA) de semillas/fertilizantes?', options: ['Dosis fija', 'Pruebas ocasionales', 'Uso habitual en lotes clave', 'VRA en todo el campo'], values: [1, 3, 4, 5] },
            { id: 'm4', axis: 'Maquinaria', text: '¿Sus máquinas integran sensores en tiempo real (humedad, rendimiento, NIR)?', options: ['Sin sensores', 'Sensor de rinde', 'Sensores múltiples', 'Control activo de dosis'], values: [1, 2, 4, 5] },

            // AXIS: Decisiones
            { id: 'de1', axis: 'Decisiones', text: '¿Utiliza mapas de rinde para planificar la siguiente campaña?', options: ['No', 'Solo visualización', 'Análisis para fertilización', 'Prescripciones automáticas'], values: [1, 2, 4, 5] },
            { id: 'de2', axis: 'Decisiones', text: '¿Cuenta con estaciones meteorológicas propias o redes locales de datos?', options: ['Pronóstico público', 'Redes regionales', 'Estación propia básica', 'Red de estaciones integrada'], values: [1, 3, 4, 5] },
            { id: 'de3', axis: 'Decisiones', text: '¿Utiliza modelos predictivos o algoritmos para predecir enfermedades/plagas?', options: ['Observación visual', 'Alertas generales', 'Software especializado', 'Modelos personalizados'], values: [1, 2, 4, 5] },
            { id: 'de4', axis: 'Decisiones', text: '¿Analiza sus márgenes brutos mediante herramientas dinámicas por ambiente?', options: ['Cálculo general', 'Excel por lote', 'Sistemas de costos dinámicos', 'Simuladores de escenarios'], values: [1, 2, 4, 5] },

            // AXIS: Sostenibilidad
            { id: 's1', axis: 'Sostenibilidad', text: '¿Realiza monitoreo sistemático de la huella de carbono?', options: ['No', 'Planificando', 'Primeras mediciones', 'Certificación activa'], values: [1, 3, 4, 5] },
            { id: 's2', axis: 'Sostenibilidad', text: '¿Qué porcentaje de sus insumos son biológicos o de bajo impacto?', options: ['0%', '1-10%', '11-30%', 'Más del 30%'], values: [1, 2, 4, 5] },
            { id: 's3', axis: 'Sostenibilidad', text: '¿Tiene trazabilidad total de los envases y residuos químicos?', options: ['Solo disposición final', 'Registro manual', 'Registro digital', 'Sistema de gestión circular'], values: [1, 2, 4, 5] },
            { id: 's4', axis: 'Sostenibilidad', text: '¿Implementa manejos de sitio específico para reducir el uso de agua/herbicidas?', options: ['No', 'Aplicación selectiva', 'Manejo por ambientes', 'Manejo ultra-fino (Planta por planta)'], values: [1, 3, 4, 5] },

            // AXIS: Capacitación
            { id: 'ca1', axis: 'Capacitación', text: '¿El personal operativo recibe capacitación en herramientas digitales?', options: ['Nunca', 'Cuando llega una máquina nueva', 'Anualmente', 'Programa continuo'], values: [1, 2, 4, 5] },
            { id: 'ca2', axis: 'Capacitación', text: '¿Cuenta con un responsable de AgTech o tecnología dentro de la empresa?', options: ['No', 'Dueño/Asesor general', 'Responsable técnico', 'Departamento de Innovación'], values: [1, 2, 4, 5] },
            { id: 'ca3', axis: 'Capacitación', text: '¿Utiliza consultoría externa especializada para integrar nuevas tecnologías?', options: ['No', 'Ocasionalmente', 'Para proyectos específicos', 'Acompañamiento permanente'], values: [1, 2, 4, 5] },
            { id: 'ca4', axis: 'Capacitación', text: '¿Tienen incentivos internos para la adopción de nuevas tecnologías?', options: ['No', 'Cultura de apertura', 'Incentivos individuales', 'Estrategia de empresa tecnológica'], values: [1, 2, 4, 5] },

            // AXIS: Trazabilidad
            { id: 't1', axis: 'Trazabilidad', text: '¿Utiliza cuaderno de campo digital en tiempo real?', options: ['Cuaderno de papel', 'Excel posterior', 'App móvil en el lote', 'Carga automática de máquinas'], values: [1, 2, 4, 5] },
            { id: 't2', axis: 'Trazabilidad', text: '¿Sus procesos de cosecha y logística están digitalizados?', options: ['Carta de porte papel', 'Seguimiento por GPS', 'Gestión de pesaje digital', 'Control total de flujo de granos'], values: [1, 2, 4, 5] },
            { id: 't3', axis: 'Trazabilidad', text: '¿Está preparado para auditorías de sostenibilidad mediante registros digitales?', options: ['No', 'Parcialmente', 'Procesos certificados', 'Blockchain / Auditoría en tiempo real'], values: [1, 3, 4, 5] },
            { id: 't4', axis: 'Trazabilidad', text: '¿Comparte activamente la trazabilidad de su producción con la cadena de valor?', options: ['No', 'A pedido de clientes', 'Plataformas de origen', 'Ecosistema digital compartido'], values: [1, 2, 4, 5] }
        ],
        answers: {},
        currentStep: 0
    };

    const questionContent = document.getElementById('question-content');
    const nextBtn = document.getElementById('next-question');
    const prevBtn = document.getElementById('prev-question');
    const progressFill = document.getElementById('radar-progress');

    // State: -1 = Welcome Screen, 0+ = Questions
    radarData.currentStep = -1;

    function updateRadarUI() {
        if (!questionContent) return;

        if (radarData.currentStep === -1) {
            // Welcome Screen
            nextBtn.innerText = 'Comenzar Diagnóstico';
            prevBtn.style.display = 'none';
            progressFill.style.width = '0%';
            questionContent.innerHTML = `
                <h4>¿Estás listo para medir tu evolución digital?</h4>
                <p>Este diagnóstico evaluará 6 ejes estratégicos de tu producción. Al finalizar, obtendrás un perfil detallado y recomendaciones personalizadas.</p>
                <div class="highlight-text">Tiempo estimado: 3 minutos</div>
            `;
            return;
        }

        const q = radarData.questions[radarData.currentStep];
        nextBtn.innerText = radarData.currentStep === radarData.questions.length - 1 ? 'Finalizar Diagnóstico' : 'Siguiente';

        progressFill.style.width = `${((radarData.currentStep + 1) / radarData.questions.length) * 100}%`;

        questionContent.innerHTML = `
            <div class="question-axis">${q.axis}</div>
            <h4>${q.text}</h4>
            <div class="options-grid">
                ${q.options.map((opt, i) => `
                    <button class="option-btn ${radarData.answers[q.id] === q.values[i] ? 'selected' : ''}" 
                            onclick="window.selectOption('${q.id}', ${q.values[i]})">
                        ${opt}
                    </button>
                `).join('')}
            </div>
        `;

        prevBtn.style.display = 'inline-block';
    }

    window.selectOption = (qId, val) => {
        radarData.answers[qId] = val;
        const options = document.querySelectorAll('.option-btn');
        options.forEach(btn => btn.classList.remove('selected'));
        event.target.classList.add('selected');
    };

    if (nextBtn) {
        nextBtn.addEventListener('click', () => {
            if (radarData.currentStep === -1) {
                radarData.currentStep = 0;
                updateRadarUI();
            } else if (radarData.currentStep < radarData.questions.length - 1) {
                if (radarData.answers[radarData.questions[radarData.currentStep].id]) {
                    radarData.currentStep++;
                    updateRadarUI();
                } else {
                    alert('Por favor, selecciona una opción antes de continuar.');
                }
            } else {
                if (radarData.answers[radarData.questions[radarData.currentStep].id]) {
                    showResults();
                } else {
                    alert('Por favor, selecciona una opción antes de finalizar.');
                }
            }
        });
    }

    if (prevBtn) {
        prevBtn.addEventListener('click', () => {
            if (radarData.currentStep === 0) {
                radarData.currentStep = -1;
                updateRadarUI();
            } else if (radarData.currentStep > 0) {
                radarData.currentStep--;
                updateRadarUI();
            }
        });
    }

    function showResults() {
        document.getElementById('radar-questionnaire').style.display = 'none';
        document.getElementById('radar-results').style.display = 'block';

        const ctx = document.getElementById('radarChart').getContext('2d');

        // Aggregate values by axis
        const axisScores = {};
        const axisCounts = {};

        radarData.questions.forEach(q => {
            if (!axisScores[q.axis]) {
                axisScores[q.axis] = 0;
                axisCounts[q.axis] = 0;
            }
            axisScores[q.axis] += (radarData.answers[q.id] || 0);
            axisCounts[q.axis]++;
        });

        const labels = Object.keys(axisScores);
        const averages = labels.map(label => axisScores[label] / axisCounts[label]);

        const isPrint = window.matchMedia('print').matches;
        const colorPrimary = isPrint ? '#000' : '#00ff9d';
        const colorBg = isPrint ? 'rgba(0, 0, 0, 0.1)' : 'rgba(0, 255, 157, 0.2)';
        const colorGrid = isPrint ? 'rgba(0, 0, 0, 0.2)' : 'rgba(255, 255, 255, 0.1)';
        const colorText = isPrint ? '#000' : '#e0e0e0';

        new Chart(ctx, {
            type: 'radar',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Nivel Tecnológico',
                    data: averages,
                    backgroundColor: colorBg,
                    borderColor: colorPrimary,
                    borderWidth: 2,
                    pointBackgroundColor: colorPrimary,
                    pointBorderColor: '#fff',
                    pointHoverBackgroundColor: '#fff',
                    pointHoverBorderColor: colorPrimary
                }]
            },
            options: {
                scales: {
                    r: {
                        angleLines: { color: colorGrid },
                        grid: { color: colorGrid },
                        pointLabels: {
                            color: colorText,
                            font: { family: 'Orbitron', size: 12 }
                        },
                        suggestedMin: 0,
                        suggestedMax: 5,
                        ticks: { display: false, stepSize: 1 }
                    }
                },
                plugins: {
                    legend: { display: false },
                    tooltip: {
                        callbacks: {
                            label: function (context) {
                                return `Nivel: ${context.raw.toFixed(1)} / 5.0`;
                            }
                        }
                    }
                }
            }
        });

        const totalAvg = averages.reduce((a, b) => a + b, 0) / averages.length;
        const profileName = document.getElementById('profile-name');
        const profileDesc = document.getElementById('profile-desc');

        // Classification into 4 Levels
        if (totalAvg >= 4.2) {
            profileName.innerText = 'Nivel 4: Líder de Precisión';
            profileName.style.color = '#00ff9d';
            profileDesc.innerText = 'Eres un referente en innovación. Tu sistema productivo está altamente digitalizado, con procesos automatizados y decisiones basadas en ciencia de datos. El próximo paso es la autonomía total y la integración de IA profunda.';
        } else if (totalAvg >= 3.0) {
            profileName.innerText = 'Nivel 3: Productor Tecnificado';
            profileName.style.color = '#00e1ff';
            profileDesc.innerText = 'Tienes una sólida base tecnológica. Utilizas herramientas digitales de forma sistemática y tu maquinaria está actualizada. Te encuentras en la fase de optimización, buscando extraer el máximo valor de tus datos.';
        } else if (totalAvg >= 1.8) {
            profileName.innerText = 'Nivel 2: Productor en Transición';
            profileName.style.color = '#f1c40f';
            profileDesc.innerText = 'Has iniciado el camino hacia la digitalización. Reconoces el valor de la tecnología y has implementado soluciones aisladas. El desafío ahora es integrar estas herramientas para lograr un flujo de información coherente.';
        } else {
            profileName.innerText = 'Nivel 1: Productor Tradicional';
            profileName.style.color = '#e74c3c';
            profileDesc.innerText = 'Tu manejo se basa primordialmente en la experiencia empírica y métodos tradicionales. Existe un amplio horizonte de mejora mediante la digitalización básica para optimizar márgenes y reducir riesgos.';
        }
    }

    // Initialize UI
    updateRadarUI();


    // === IFRAME LOADING (REMOVED logic used for previous version) ===

});
