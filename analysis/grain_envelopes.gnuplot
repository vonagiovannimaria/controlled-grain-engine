# ============================================================
# Controlled Grain Engine - Grafici degli inviluppi granulari
# Gnuplot script
# ============================================================

reset
set encoding utf8

# ------------------------------------------------------------
# Terminale e impostazioni generali
# ------------------------------------------------------------

set terminal pdfcairo enhanced font "CMU Serif,12" size 12cm,8cm

set samples 1000
set xrange [0:1]
set yrange [0:1.05]

set xlabel "Fase normalizzata del grano"
set ylabel "Ampiezza normalizzata"

set grid
set key outside right center
set border linewidth 1.2

# ------------------------------------------------------------
# Funzioni di utilità
# ------------------------------------------------------------

clamp(v, lo, hi) = (v < lo ? lo : (v > hi ? hi : v))

# ------------------------------------------------------------
# Parametri degli inviluppi
# ------------------------------------------------------------

# Gaussiano
sigma = 0.15
mu = 0.5

# Trapezoidale
trap_attack = 0.20
trap_release = 0.20

# Tukey
tukey_edge = 0.25

# Percussivo
perc_attack = 0.08
decay_curve = 3.0

# ------------------------------------------------------------
# Definizione degli inviluppi
# ------------------------------------------------------------

hann(x) = clamp(0.5 - 0.5 * cos(2.0 * pi * x), 0, 1)

triangular(x) = clamp(1.0 - abs((2.0 * x) - 1.0), 0, 1)

gaussian(x) = clamp(exp(-((x - mu)**2) / (2.0 * sigma**2)), 0, 1)

trapezoidal(x) = clamp( \
    x < trap_attack ? x / trap_attack : \
    x > 1.0 - trap_release ? (1.0 - x) / trap_release : \
    1.0, 0, 1)

tukey(x) = clamp( \
    x < tukey_edge ? 0.5 - 0.5 * cos(pi * (x / tukey_edge)) : \
    x > 1.0 - tukey_edge ? 0.5 - 0.5 * cos(pi * ((1.0 - x) / tukey_edge)) : \
    1.0, 0, 1)

blackman(x) = clamp(0.42 - 0.5 * cos(2.0 * pi * x) + 0.08 * cos(4.0 * pi * x), 0, 1)

percussive(x) = clamp( \
    x < perc_attack ? x / perc_attack : \
    ((1.0 - x) / (1.0 - perc_attack))**decay_curve, 0, 1)

# ============================================================
# 1. Grafico complessivo
# ============================================================

set output "grain_envelopes_all.pdf"
set title "Funzioni di inviluppo implementate in Controlled Grain Engine"

plot \
    hann(x)        title "Hann"          with lines linewidth 2, \
    triangular(x)  title "Triangolare"   with lines linewidth 2, \
    gaussian(x)    title "Gaussiano"     with lines linewidth 2, \
    trapezoidal(x) title "Trapezoidale"  with lines linewidth 2, \
    tukey(x)       title "Tukey"         with lines linewidth 2, \
    blackman(x)    title "Blackman"      with lines linewidth 2, \
    percussive(x)  title "Percussivo"    with lines linewidth 2

unset output

# ============================================================
# 2. Grafici singoli
# ============================================================

set key off

set output "envelope_hann.pdf"
set title "Inviluppo di Hann"
plot hann(x) with lines linewidth 2
unset output

set output "envelope_triangular.pdf"
set title "Inviluppo triangolare"
plot triangular(x) with lines linewidth 2
unset output

set output "envelope_gaussian.pdf"
set title sprintf("Inviluppo gaussiano: {/Symbol s} = %.2f, {/Symbol m} = %.2f", sigma, mu)
plot gaussian(x) with lines linewidth 2
unset output

set output "envelope_trapezoidal.pdf"
set title sprintf("Inviluppo trapezoidale: attack = %.2f, release = %.2f", trap_attack, trap_release)
plot trapezoidal(x) with lines linewidth 2
unset output

set output "envelope_tukey.pdf"
set title sprintf("Inviluppo di Tukey: edge = %.2f", tukey_edge)
plot tukey(x) with lines linewidth 2
unset output

set output "envelope_blackman.pdf"
set title "Inviluppo di Blackman"
plot blackman(x) with lines linewidth 2
unset output

set output "envelope_percussive.pdf"
set title sprintf("Inviluppo percussivo: attack = %.2f, decay curve = %.2f", perc_attack, decay_curve)
plot percussive(x) with lines linewidth 2
unset output