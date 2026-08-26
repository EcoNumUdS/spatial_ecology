# ---------------------------------------------------------------------------
# Assets for the interactive tutorial page (html/).
#
#   Rscript R/figures.R
#
# Writes to output/figures/:
#   map_large.png     a big steady-state map
#   front_1..4.png    one fire front followed over 30 time steps
#   stats.json        density series + forest-cluster size distribution,
#                     charted by the HTML page so the charts follow its theme
# ---------------------------------------------------------------------------

source(file.path("R", "forest_fire.R"))
set.seed(7)

fig_dir <- file.path("output", "figures")
dir.create(fig_dir, recursive = TRUE, showWarnings = FALSE)

pal <- c("#3a2d22", "#3f9b52", "#ff7518")  # EMPTY, TREE, BURNING

#' Write a lattice (or a crop of one) as a PNG with one pixel per cell
save_map <- function(state, file, px = 800) {
  png(file, width = px, height = px, bg = pal[1])
  # xaxs/yaxs = "i" removes the 4% padding R adds by default, so the raster
  # reaches the edge of the image.
  par(mar = c(0, 0, 0, 0), pty = "s", xaxs = "i", yaxs = "i")
  plot.new()
  cols <- matrix(pal[state + 1L], nrow(state), ncol(state))
  rasterImage(as.raster(cols), 0, 0, 1, 1, interpolate = FALSE)
  dev.off()
}

#' Label the connected components of a logical lattice, by flood fill
#'
#' Cells are visited once each; `stack` holds the cells still to expand.
#' Returns an integer vector, one label per cell (0 where `mask` is FALSE),
#' in the same column-major order as the matrix.
ff_label <- function(mask) {
  nr <- nrow(mask)
  nc <- ncol(mask)
  m  <- as.vector(mask)
  lab   <- integer(length(m))
  stack <- integer(length(m))
  k <- 0L

  for (start in which(m)) {
    if (lab[start] != 0L) next
    k <- k + 1L
    lab[start] <- k
    stack[1L]  <- start
    top <- 1L

    while (top > 0L) {
      cell <- stack[top]
      top  <- top - 1L
      r  <- (cell - 1L) %%  nr + 1L
      cc <- (cell - 1L) %/% nr + 1L
      # push the four nearest neighbours that are still unlabelled
      if (r  > 1L) { j <- cell - 1L; if (m[j] && lab[j] == 0L) { lab[j] <- k; top <- top + 1L; stack[top] <- j } }
      if (r  < nr) { j <- cell + 1L; if (m[j] && lab[j] == 0L) { lab[j] <- k; top <- top + 1L; stack[top] <- j } }
      if (cc > 1L) { j <- cell - nr; if (m[j] && lab[j] == 0L) { lab[j] <- k; top <- top + 1L; stack[top] <- j } }
      if (cc < nc) { j <- cell + nr; if (m[j] && lab[j] == 0L) { lab[j] <- k; top <- top + 1L; stack[top] <- j } }
    }
  }
  lab
}

# --- 1. a large steady-state map -------------------------------------------
cat("Large map ...\n")
L_big <- 400L
p_big <- 0.02
f_big <- p_big * 0.0005
state <- ff_init(L_big)
for (i in seq_len(3000)) state <- ff_step(state, p = p_big, f = f_big)
save_map(state, file.path(fig_dir, "map_large.png"), px = 800)

# --- 2. one fire front, followed for 30 steps -------------------------------
# Fires are scattered over the lattice, so pick the window with the most fire
# in it: coarse-grain the burning cells into blocks, score each step by the
# busiest block, and keep the best lattice seen over a fixed search. Bounded
# by construction, unlike waiting for a fire of some given size to appear.
cat("Fire front ...
")
half  <- 45L
block <- 45L
clamp <- function(centre) {
  centre <- max(half + 1L, min(L_big - half, centre))
  (centre - half):(centre + half)
}

best_score <- -1L
best_state <- state
best_rc    <- c(L_big %/% 2L, L_big %/% 2L)

for (i in seq_len(800)) {
  state <- ff_step(state, p = p_big, f = f_big)
  burning <- which(state == BURNING)
  if (!length(burning)) next

  rows <- (burning - 1L) %%  L_big + 1L
  cols <- (burning - 1L) %/% L_big + 1L
  key  <- paste((rows - 1L) %/% block, (cols - 1L) %/% block)
  tab  <- table(key)

  if (max(tab) > best_score) {
    best_score <- as.integer(max(tab))
    best_state <- state
    sel        <- key == names(which.max(tab))
    best_rc    <- c(as.integer(mean(rows[sel])), as.integer(mean(cols[sel])))
  }
}
cat("  busiest window holds", best_score, "burning cells
")

state <- best_state
win_r <- clamp(best_rc[1])
win_c <- clamp(best_rc[2])

front_steps <- c(0L, 10L, 20L, 30L)
for (k in seq_along(front_steps)) {
  if (k > 1L) {
    for (i in seq_len(front_steps[k] - front_steps[k - 1L])) {
      state <- ff_step(state, p = p_big, f = f_big)
    }
  }
  save_map(state[win_r, win_c], file.path(fig_dir, sprintf("front_%d.png", k)),
           px = 420)
}

# --- 3. forest density through time ----------------------------------------
cat("Density series ...\n")
L <- 200L
p <- 0.02
f <- p * 0.001
state <- ff_init(L)
for (i in seq_len(1500)) state <- ff_step(state, p = p, f = f)  # burn-in

n_rec   <- 1500L
density <- numeric(n_rec)
for (i in seq_len(n_rec)) {
  state <- ff_step(state, p = p, f = f)
  density[i] <- mean(state == TREE)
}

# --- 4. size distribution of connected forest clusters ----------------------
# The paper's N(s): how many tree clusters of size s exist in the steady state.
# A cluster is a group of trees connected through nearest neighbours; when
# lightning hits any of its trees, the whole cluster burns down.
cat("Cluster sizes ...\n")
ff_cluster_sizes <- function(state) tabulate(ff_label(state == TREE))

n_snap    <- 25L
all_sizes <- integer(0)
for (snap in seq_len(n_snap)) {
  for (i in seq_len(100)) state <- ff_step(state, p = p, f = f)
  all_sizes <- c(all_sizes, ff_cluster_sizes(state))
  cat("  snapshot", snap, "/", n_snap, "\n")
}

# Logarithmic binning: under a power law, linear bins get too noisy at large s.
# Bin edges grow geometrically and counts are divided by the bin width.
edges  <- unique(round(exp(seq(0, log(max(all_sizes) + 1), length.out = 26))))
counts <- as.integer(table(cut(all_sizes, breaks = edges, right = FALSE)))
widths <- diff(edges)
mids   <- sqrt(edges[-length(edges)] * edges[-1])
keep   <- counts > 0
cluster_s <- mids[keep]
cluster_n <- counts[keep] / widths[keep] / n_snap

# --- 5. write the data the page charts --------------------------------------
json_num <- function(x, digits = 6) paste(round(x, digits), collapse = ",")
json <- sprintf(
  '{\n  "p": %g,\n  "f_over_p": %g,\n  "size": %d,\n  "mean_density": %.4f,\n  "density": [%s],\n  "cluster_s": [%s],\n  "cluster_n": [%s]\n}\n',
  p, 0.001, L, mean(density),
  json_num(density, 5), json_num(cluster_s, 3), json_num(cluster_n, 5)
)
writeLines(json, file.path(fig_dir, "stats.json"))

cat("\nMean forest density:", round(mean(density), 3), "\n")
cat("Clusters measured:", length(all_sizes), " largest:", max(all_sizes), "\n")
cat("Files in", fig_dir, ":", paste(list.files(fig_dir), collapse = ", "), "\n")
