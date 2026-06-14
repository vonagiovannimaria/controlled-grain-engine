autowatch = 1;

inlets = 1;
outlets = 1;

var bufferName = jsarguments.length > 1 ? jsarguments[1] : "env_view";
var size = jsarguments.length > 2 ? parseInt(jsarguments[2]) : 1024;

var envShape = 0;
var paramA = 0.15;
var paramB = 0.5;

function clamp(v, lo, hi) {
    return Math.max(lo, Math.min(hi, v));
}

function setshape(v) {
    envShape = Math.round(v);
    fill();
}

function param_a(v) {
    paramA = v;
    fill();
}

function param_b(v) {
    paramB = v;
    fill();
}

function bang() {
    fill();
}

function fill() {
    var b = new Buffer(bufferName);

    for (var i = 0; i < size; i++) {
        var x = i / (size - 1);
        var y = 0;

        if (envShape === 0) {
            // Hann
            y = 0.5 - 0.5 * Math.cos(2 * Math.PI * x);
        }

        else if (envShape === 1) {
            // Triangolare
            y = 1 - Math.abs((2 * x) - 1);
        }

        else if (envShape === 2) {
            // Gaussiano normalizzato
            var sigma = Math.max(paramA, 0.0001);
            var mu = paramB;
            var num = Math.pow(x - mu, 2);
            var den = 2 * Math.pow(sigma, 2);
            y = Math.exp(-num / den);
        }

        else if (envShape === 3) {
            // Trapezoidale
            var attack = clamp(paramA, 0.0001, 0.4999);
            var release = clamp(paramB, 0.0001, 0.4999);

            if (x < attack) {
                y = x / attack;
            }
            else if (x > 1 - release) {
                y = (1 - x) / release;
            }
            else {
                y = 1;
            }
        }

        else if (envShape === 4) {
            // Tukey semplificato
            var edge = clamp(paramA, 0.0001, 0.4999);

            if (x < edge) {
                var phaseA = x / edge;
                y = 0.5 - 0.5 * Math.cos(Math.PI * phaseA);
            }
            else if (x > 1 - edge) {
                var phaseB = (1 - x) / edge;
                y = 0.5 - 0.5 * Math.cos(Math.PI * phaseB);
            }
            else {
                y = 1;
            }
        }

        else if (envShape === 5) {
            // Blackman
            y = 0.42 - 0.5 * Math.cos(2 * Math.PI * x) + 0.08 * Math.cos(4 * Math.PI * x);
        }

        else if (envShape === 6) {
            // Percussivo
            var percAttack = clamp(paramA, 0.0001, 0.9999);
            var decayCurve = Math.max(paramB, 0.0001);

            if (x < percAttack) {
                y = x / percAttack;
            }
            else {
                var phase = (1 - x) / (1 - percAttack);
                y = Math.pow(phase, decayCurve);
            }
        }

        else {
            y = 0.5 - 0.5 * Math.cos(2 * Math.PI * x);
        }

        b.poke(1, i, clamp(y, 0, 1));
    }

//    outlet(0, "refresh");
}