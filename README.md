# Controlled Grain Engine

**Controlled Grain Engine** is a real-time granular synthesis processor developed in **Max/MSP**.

The project was created by **Giovanni Maria Vona** as an academic work for the course of **Campionamento, sintesi ed elaborazione digitale dei suoni II** within the First Level Academic Diploma in **Tecnico del Suono** at the Conservatorio Statale di Musica “O. Respighi” in Latina.

The processor transforms sampled audio material through the generation, overlap and real-time control of short sound fragments called grains.

## Overview

Controlled Grain Engine works on an audio file loaded into a buffer and allows the user to control the main parameters of granular synthesis:

- buffer reading position
- loop region selection
- grain duration
- grain density
- pitch transposition
- pitch dispersion
- reading-position dispersion
- playback speed
- grain envelope shape

The project is designed as a modular Max/MSP patch in which the main functions of the granular process remain clearly separated: buffer loading, loop-region control, grain generation, transposition, density control, envelope shaping and audio output.

The processor can move between two main sonic behaviors:

- recognizable transformation of the source sample
- dense, unstable or abstract granular textures

## Concept

The project explores the relationship between deterministic control and controlled randomness.

The user can define a region of the audio buffer, set the main synthesis parameters and control the way the file is traversed. At the same time, the system can introduce random deviations in the pitch and reading position of individual grains.

This makes it possible to obtain different degrees of transformation, from relatively transparent resynthesis to more unstable and microscopic reorganization of the source material.

## Granular Synthesis Model

In Controlled Grain Engine, each grain is a short portion of the audio buffer with its own:

- start position
- end position
- duration
- pitch ratio
- amplitude envelope

The global reading pointer defines the area of the buffer currently being explored, while each grain receives its own reading position, optionally modified by random dispersion.

The overlap of many grains produces a granular cloud whose density and morphology can be controlled in real time.

## Buffer and Loop Region

The source material is loaded into an audio buffer and displayed through a waveform interface.

The user can process either:

- the entire buffer
- a manually selected loop region

The selected region is defined by two points in the waveform. The system automatically calculates:

```text
Ls = min(S1, S2)
Le = max(S1, S2)
Ld = |S2 - S1|
```

where:

- `S1` and `S2` are the two selection points
- `Ls` is the loop start
- `Le` is the loop end
- `Ld` is the loop duration

The global reading pointer is then remapped inside the selected region:

```text
P(t) = Ls + φ(t) · Ld
```

where `φ(t)` is a normalized pointer between 0 and 1.

## Grain Generation and Density

The granular engine uses a multivoice structure.

Each voice plays a portion of the buffer, allowing multiple grains to overlap without interrupting one another. The density parameter controls the temporal distance between grain generations.

In the current implementation, density acts as an inter-grain time control:

- higher values produce more separated grains
- lower values increase overlap and create more continuous textures

The interaction between grain duration and density is one of the main factors shaping the morphology of the resulting sound.

## Duration, Pitch and Buffer Reading

Grain duration and the portion read from the buffer are treated as separate parameters.

The duration of the grain defines how long the event lasts. The read duration defines how much of the source buffer is traversed during that time.

Pitch transposition is obtained by modifying the ratio between these two values:

```text
Dr = Dg · rp
```

where:

- `Dg` is the grain duration
- `rp` is the pitch ratio
- `Dr` is the portion read from the buffer

When the pitch is expressed in semitones, the ratio is calculated as:

```text
rp = 2^(n/12)
```

where `n` is the number of semitones.

This makes it possible to transpose the source material independently from the global playback speed of the buffer.

## Grain Envelopes

Each grain is multiplied by an amplitude envelope to avoid clicks and shape the morphology of the sound event.

The envelope selector is implemented in **Gen** and supports multiple shapes:

- Hann
- triangular
- Gaussian
- trapezoidal
- Tukey
- Blackman
- percussive

The envelope is calculated from a normalized phase value:

```text
x ∈ [0, 1]
```

Some envelope shapes use two auxiliary parameters, `A` and `B`, whose function depends on the selected shape.

Examples:

- in the Gaussian envelope, `A` controls the standard deviation and `B` controls the center
- in the trapezoidal envelope, `A` controls attack and `B` controls release
- in the Tukey envelope, `A` controls the smoothed edge width
- in the percussive envelope, `A` controls attack and `B` controls the decay curve

The available envelope curves are documented in:

```text
max/CGE/other/grain_envelopes_all.pdf
```

## Parameters

The main synthesis parameters include:

- **Playback speed** — controls the movement of the global reading pointer through the buffer or loop region
- **Grain duration** — controls the duration of each grain, from very short impulses to more recognizable fragments
- **Density** — controls the temporal distance between grain generations
- **Pitch** — controls transposition through the ratio between grain duration and buffer read duration
- **Pitch dispersion** — adds random variation around the main pitch value
- **Position dispersion** — adds random variation around the current reading position
- **Envelope shape** — selects the grain amplitude window
- **Envelope parameters A/B** — control shape-dependent envelope parameters

## Repository Structure

```text
controlled-grain-engine/
├── README.md
├── LICENSE.md
├── analysis/
│   └── grain_envelopes.gnuplot
├── docs/
│   ├── CGE-Presentazione.pdf
│   └── CGE-Tesina.pdf
└── max/
    └── CGE/
        ├── CGE.maxproj
        ├── code/
        │   ├── envelope_view.js
        │   └── inviluppo1.gendsp
        ├── media/
        │   ├── snare-example.wav
        │   └── grain_envelopes_all-1.png
        ├── other/
        │   └── grain_envelopes_all.pdf
        └── patchers/
            └── MASTER-controlled-grain-engine.maxpat
```

The `max/CGE/` folder contains the complete Max/MSP project. Open `CGE.maxproj` from this folder to preserve the expected project structure and relative paths between patchers, code files, media files and support resources.

## Requirements

To open and use the project:

- Max/MSP
- Gen, included in Max
- an audio output system compatible with Max/MSP

The main patch is located at:

```text
max/CGE/patchers/CGE_MASTER.maxpat
```

The Max project file is:

```text
max/CGE/CGE.maxproj
```

## Usage

1. Open the Max project:

```text
max/CGE/CGE.maxproj
```

2. Open the main patch:

```text
max/CGE/patchers/CGE_MASTER.maxpat
```

3. Possibly replace the audio file in the buffer by loading another one.

4. Select a loop region in the waveform, or use the full buffer.

5. Enable the granular engine.

6. Adjust the synthesis parameters:

- playback speed
- grain duration
- density
- pitch
- pitch dispersion
- position dispersion
- envelope shape
- envelope parameters

7. Listen to the resulting granular transformation.

## Current Limitations

The current version implements the main functions of a real-time granular processor, but it is still open to future development.

Possible limitations include:

- no explicit time-varying tendency masks for parameter evolution
- grain duration is currently controlled globally
- pitch and position dispersion could be made more flexible over time
- preset management and MIDI mapping can be further developed
- graphical feedback for random distributions and parameter trajectories could be expanded

These limitations do not affect the basic operation of the processor, but indicate possible future directions for making the system more flexible in compositional and performative contexts.

## Future Development

Possible future improvements include:

- time-varying parameter masks
- independent random grain durations
- dynamic pitch-dispersion ranges
- dynamic position-dispersion ranges
- MIDI mapping
- internal automation
- expanded visualization of grain distributions
- more advanced performance controls

## Project Status

Academic project / working prototype.

The current version is functional and was developed as an exam project. The repository is intended as an archive of the project and as a basis for future development.

## License

Code, Max/MSP patches, Gen files and JavaScript files are released under the MIT License.

Documentation, presentation materials, diagrams and audio examples are released under a Creative Commons Attribution-NonCommercial 4.0 International License, unless otherwise stated.

See `LICENSE.md` for details.

## Author

**Giovanni Maria Vona**  
Sound Engineering student  
Conservatorio Statale di Musica “O. Respighi” — Latina  
DSP · Sound Design · Electroacoustic Music · Audio Programming
