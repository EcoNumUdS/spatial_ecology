# ---------------------------------------------------------------------------
# Drossel & Schwabl (1992) self-organized critical forest-fire model
# Phys. Rev. Lett. 69(11), 1629-1632
#
# A cell of the lattice is in one of three states, updated in parallel
# (every cell uses the state of its neighbours at the PREVIOUS time step):
#
#   (i)   a burning tree becomes an empty site
#   (ii)  a tree becomes burning if at least one nearest neighbour is burning
#   (iii) an empty site grows a tree with probability p
#   (iv)  a tree with no burning neighbour is struck by lightning and starts
#         burning with probability f
#
# The only relevant parameter is the ratio f / p. The model self-organizes to
# a critical state as f / p -> 0 (with p small), where fires of every size
# occur and the mean forest density settles near 0.39 in two dimensions.
# ---------------------------------------------------------------------------

# State codes. Kept as integers so the lattice stays a plain integer matrix.
EMPTY   <- 0L
TREE    <- 1L
BURNING <- 2L

#' Create an initial lattice
#'
#' @param size    number of cells per side (the lattice is size x size)
#' @param density probability that a cell starts as a tree; 0 = bare ground
#' @return an integer matrix of states
ff_init <- function(size = 200L, density = 0) {
  stopifnot(size > 2, density >= 0, density <= 1)
  matrix(
    ifelse(runif(size * size) < density, TREE, EMPTY),
    nrow = size, ncol = size
  )
}

#' TRUE where a cell has at least one burning nearest neighbour
#'
#' Nearest neighbours are the four von Neumann neighbours (N, S, E, W).
#' The whole lattice is handled at once with shifted matrices, which is much
#' faster in R than looping over cells.
#'
#' @param burning  logical matrix, TRUE where a cell is burning
#' @param periodic wrap the edges (torus) or treat outside the lattice as empty
ff_neighbour_burning <- function(burning, periodic = FALSE) {
  nr <- nrow(burning)
  nc <- ncol(burning)

  if (periodic) {
    # Cyclic index vectors: row 1's "up" neighbour is row nr, and so on.
    up    <- c(2:nr, 1L)
    down  <- c(nr, 1:(nr - 1L))
    left  <- c(2:nc, 1L)
    right <- c(nc, 1:(nc - 1L))
    burning[up, ] | burning[down, ] | burning[, left] | burning[, right]
  } else {
    # Pad with a ring of FALSE, so cells outside the lattice never ignite.
    padded <- matrix(FALSE, nr + 2L, nc + 2L)
    padded[2:(nr + 1L), 2:(nc + 1L)] <- burning
    padded[1:nr,             2:(nc + 1L)] |  # neighbour above
    padded[3:(nr + 2L),      2:(nc + 1L)] |  # neighbour below
    padded[2:(nr + 1L),      1:nc]        |  # neighbour left
    padded[2:(nr + 1L), 3:(nc + 2L)]         # neighbour right
  }
}

#' Advance the lattice by one time step
#'
#' @param state    integer matrix of states
#' @param p        probability that an empty site grows a tree
#' @param f        probability that a tree is struck by lightning
#' @param periodic wrap the edges of the lattice
#' @return the new integer matrix of states
ff_step <- function(state, p, f, periodic = FALSE) {
  n <- length(state)

  is_tree    <- state == TREE
  is_empty   <- state == EMPTY
  is_burning <- state == BURNING

  # All four rules read `state`, the configuration at the previous time step,
  # and write into `new_state`. This is what makes the update parallel.
  new_state <- state

  # (i) burning trees leave behind empty ground
  new_state[is_burning] <- EMPTY

  # (ii) + (iv) a tree catches fire from a neighbour, or from lightning
  neighbour_fire <- ff_neighbour_burning(is_burning, periodic = periodic)
  lightning      <- matrix(runif(n) < f, nrow(state), ncol(state))
  new_state[is_tree & (neighbour_fire | lightning)] <- BURNING

  # (iii) empty ground regrows; sites that burned this step stay empty until
  #       the next one, because `is_empty` refers to the previous state
  growth <- matrix(runif(n) < p, nrow(state), ncol(state))
  new_state[is_empty & growth] <- TREE

  new_state
}

#' Run the model and return summary statistics for every time step
#'
#' Useful on its own (no plotting involved); the animation script calls
#' `ff_step()` directly so it can draw a frame after each step.
#'
#' @param steps number of time steps to run
#' @inheritParams ff_step
#' @param size  lattice side length
#' @return a data.frame with the density of trees and of burning cells per step
ff_simulate <- function(steps, size = 200L, p = 0.02, f = 2e-5,
                        periodic = FALSE, state = NULL) {
  if (is.null(state)) state <- ff_init(size)

  out <- data.frame(
    step    = seq_len(steps),
    trees   = NA_real_,
    burning = NA_real_
  )

  for (i in seq_len(steps)) {
    state <- ff_step(state, p = p, f = f, periodic = periodic)
    out$trees[i]   <- mean(state == TREE)
    out$burning[i] <- mean(state == BURNING)
  }

  attr(out, "final_state") <- state
  out
}
