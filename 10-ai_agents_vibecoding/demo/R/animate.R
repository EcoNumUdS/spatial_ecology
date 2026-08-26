# ---------------------------------------------------------------------------
# Animate the Drossel & Schwabl forest-fire model as a GIF.
#
# Run from the project root:   Rscript R/animate.R
#
# The script writes one PNG per time step into a temporary folder, then
# assembles them with gifski. Nothing is kept in memory except the running
# density series, so the lattice size and the number of frames can be raised
# without running out of RAM.
# ---------------------------------------------------------------------------

source(file.path("R", "forest_fire.R"))

if (!requireNamespace("gifski", quietly = TRUE)) {
  stop("Package 'gifski' is required: install.packages('gifski')")
}

# --- parameters ------------------------------------------------------------
# f / p is the only parameter that matters. Small values give the critical
# state described in the paper: rare lightning, large fires, density ~ 0.39.
set.seed(42)

size      <- 200L    # lattice is size x size cells
p         <- 0.02    # tree growth probability per empty cell per step
f_over_p  <- 0.001   # lightning-to-growth ratio
f         <- p * f_over_p
periodic  <- FALSE   # FALSE = fire dies at the edges of the map

n_burnin  <- 2000L   # steps discarded so the lattice reaches its steady state
n_frames  <- 400L    # animated steps (one frame per time step)
fps       <- 20

out_gif   <- file.path("output", "forest_fire.gif")
out_plot  <- file.path("output", "forest_density.png")

# --- colours ---------------------------------------------------------------
bg_col   <- "#12100e"
pal      <- c("#3a2d22", "#3f9b52", "#ff7518")  # EMPTY, TREE, BURNING
fg_col   <- "#e8e2d8"
grid_col <- "#4a4239"

# --- 1. burn-in ------------------------------------------------------------
cat("Burn-in:", n_burnin, "steps ...\n")
state <- ff_init(size)
for (i in seq_len(n_burnin)) {
  state <- ff_step(state, p = p, f = f, periodic = periodic)
}

# --- 2. animated steps -----------------------------------------------------
frame_dir <- file.path(tempdir(), "ff_frames")
unlink(frame_dir, recursive = TRUE)
dir.create(frame_dir, showWarnings = FALSE)

trees   <- numeric(n_frames)
burning <- numeric(n_frames)

cat("Rendering", n_frames, "frames ...\n")
for (i in seq_len(n_frames)) {
  state <- ff_step(state, p = p, f = f, periodic = periodic)
  trees[i]   <- mean(state == TREE)
  burning[i] <- mean(state == BURNING)

  png(file.path(frame_dir, sprintf("frame_%04d.png", i)),
      width = 640, height = 780, bg = bg_col)
  # Two stacked panels: the map on top, the forest density below.
  layout(matrix(1:2, ncol = 1), heights = c(640, 140))

  # --- map ---
  # pty = "s" keeps the plotting region square, so cells stay square too.
  par(mar = c(0, 0, 2.4, 0), bg = bg_col, pty = "s")
  plot.new()
  # pal[state + 1] maps state codes 0/1/2 onto colours; as.raster() draws the
  # matrix exactly as it is laid out, one pixel per cell.
  raster_cols <- matrix(pal[state + 1L], nrow(state), ncol(state))
  rasterImage(as.raster(raster_cols), 0, 0, 1, 1, interpolate = FALSE)
  mtext(sprintf("Drossel & Schwabl forest-fire model   |   %d x %d   |   p = %g   |   f/p = %g",
                size, size, p, f_over_p),
        side = 3, line = 1.0, adj = 0, col = fg_col, cex = 0.85)
  mtext(sprintf("step %3d      forest %.3f      burning %.4f",
                i, trees[i], burning[i]),
        side = 3, line = 0.0, adj = 0, col = fg_col, cex = 0.85, family = "mono")

  # --- density trace ---
  par(mar = c(2.4, 4.2, 0.6, 0.8), mgp = c(2.4, 0.6, 0), pty = "m",
      col.axis = fg_col, col.lab = fg_col, fg = grid_col)
  plot(NA, xlim = c(1, n_frames), ylim = c(0, 0.6),
       xlab = "", ylab = "forest density", bty = "n", las = 1, cex.axis = 0.8)
  # 0.39 is the mean density the paper reports for the critical state (d = 2).
  abline(h = 0.39, col = grid_col, lty = 2)
  text(n_frames, 0.39, "0.39", pos = 3, offset = 0.2, col = grid_col, cex = 0.7)
  lines(seq_len(i), trees[seq_len(i)], col = pal[2], lwd = 2)
  points(i, trees[i], col = pal[3], pch = 19, cex = 0.8)
  dev.off()

  if (i %% 50 == 0) cat("  frame", i, "/", n_frames, "\n")
}

# --- 3. assemble the GIF ---------------------------------------------------
frames <- sort(list.files(frame_dir, pattern = "[.]png$", full.names = TRUE))
dir.create("output", showWarnings = FALSE)
gifski::gifski(frames, gif_file = out_gif, width = 640, height = 780,
               delay = 1 / fps, progress = TRUE)
cat("GIF written:", out_gif, "\n")

# --- 4. a static summary plot ----------------------------------------------
png(out_plot, width = 900, height = 500, bg = "white")
par(mfrow = c(2, 1), mar = c(4, 4.5, 2, 1))
plot(trees, type = "l", col = "#2e7d32", lwd = 1.5,
     xlab = "time step", ylab = "forest density",
     main = sprintf("Steady state, f/p = %g  (mean = %.3f)", f_over_p, mean(trees)))
abline(h = 0.39, lty = 2, col = "grey40")
plot(burning, type = "h", col = "#e65100",
     xlab = "time step", ylab = "burning density",
     main = "Fire activity")
dev.off()
cat("Plot written:", out_plot, "\n")

cat(sprintf("\nMean forest density over the animation: %.3f (paper: ~0.39 for d = 2)\n",
            mean(trees)))
