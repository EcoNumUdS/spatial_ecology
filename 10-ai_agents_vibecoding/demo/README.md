# Drossel & Schwabl (1992) forest-fire model

Reproduction in R of the self-organized critical forest-fire model from
Drossel, B. & Schwabl, F. (1992), *Self-Organized Critical Forest-Fire Model*,
Phys. Rev. Lett. **69**(11), 1629-1632 (`context/Drossel1992.pdf`).

## Vibecoding

The model was implemented in R using Claude Code with Opus 5. The model is implemented in `R/forest_fire.R`. The Drossel & Schwabl paper is summarized in `html/tutorial.html`, which is built into a self-contained file with `html/build.py`. The tutorial page can be viewed in a browser, and the code snippets can be copied into R to run the model.

The instruction file `CLAUDE.md` provided basic guidance on the project. The prompts used to generate the code are :

```
Code the model and simulation and create a GIF of the animated map.
```

```
Create an interactive html tutorial page that explains the model and the code with step-by-step instructions and figures.
```

```
What external information not provided by the paper is needed to implement the model?
```

## The model

A square lattice where each cell is **empty**, holds a **tree**, or is
**burning**. Every cell is updated at the same time (parallel update), using
the state of the lattice at the previous time step:

| # | Rule |
|---|------|
| i | a burning tree becomes an empty site |
| ii | a tree becomes burning if at least one of its 4 nearest neighbours is burning |
| iii | an empty site grows a tree with probability `p` |
| iv | a tree with no burning neighbour is struck by lightning with probability `f` |

Rules (i)-(iii) are the Bak-Chen-Tang model; rule (iv), the lightning, is what
Drossel & Schwabl added, and it is what drives the system to a critical state.
The only parameter that matters is the ratio **`f / p`**: multiplying `f` and
`p` by the same factor only rescales time.

## Files

| Path | What it is |
|------|------------|
| `R/forest_fire.R` | the model: `ff_init()`, `ff_step()`, `ff_simulate()` |
| `R/animate.R` | runs a simulation and writes the GIF + a summary plot |
| `R/figures.R` | maps and statistics for the tutorial page |
| `html/tutorial.html` | tutorial page template (with `{{TOKEN}}` placeholders) |
| `html/build.py` | inlines the figures and stats into one self-contained file |
| `output/forest_fire.gif` | animated map, 400 time steps |
| `output/forest_density.png` | forest density and fire activity over time |
| `output/tutorial.html` | the built interactive tutorial, one file, no dependencies |

## Running it

Needs R and one package for the GIF encoding:

```r
install.packages("gifski")
```

Then, from the project root:

```sh
Rscript R/animate.R
```

Takes about 30 s and rewrites the two files in `output/`. The parameters are
at the top of `R/animate.R` (`size`, `p`, `f_over_p`, `n_frames`, `periodic`).

To rebuild the interactive tutorial page:

```sh
Rscript R/figures.R      # ~2 min: maps + stats.json in output/figures/
python html/build.py     # output/tutorial.html
```

`build.py` pulls the code snippets straight out of `R/forest_fire.R` by line
number, so the page cannot drift away from the code that actually runs. If you
reorder that file, update the line ranges near the bottom of `build.py`.

To use the model without any plotting:

```r
source("R/forest_fire.R")
sim <- ff_simulate(steps = 2000, size = 200, p = 0.02, f = 2e-5)
plot(sim$trees, type = "l")          # forest density over time
image(attr(sim, "final_state"))      # the final map
```

## What to look for in the animation

- **Fire fronts.** Fires do not appear as isolated flickers, they sweep across
  the map as thin advancing lines, leaving brown scars that regrow behind them.
  This is the spatial signature the paper describes: a cluster burns from one
  edge to the other over many time steps.
- **No characteristic fire size.** Some lightning strikes die immediately,
  others clear a large fraction of the map. That absence of a typical scale is
  the "critical" part — the paper shows the cluster-size distribution is a
  power law, `N(s) ~ s^-tau` with `tau = 2` in 2D.
- **A steady density.** The forest density fluctuates around a constant value
  instead of drifting, without any parameter being tuned to a special value.
  That is the "self-organized" part.

## A note on the density value

The paper reports a mean forest density of **0.39** for the critical state in
two dimensions. This demo settles around **0.44** instead, which is expected:

- `f / p = 0.001` here, not the `f / p -> 0` limit the theory assumes;
- the lattice is only 200 x 200, so the largest fires are cut off by the size
  of the map. The paper is explicit that `L^d` must be much larger than the
  largest forest cluster to avoid this.

Lowering `f_over_p` and raising `size` in `R/animate.R` moves the density
towards 0.39, at the cost of a longer run.
