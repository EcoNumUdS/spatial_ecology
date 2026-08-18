# ============================================

# Recall
    figure from Mouquet et al. 

# Definition

# The four paradigms of metacommunity ecology 
    figure from Leibold et al.

# Competition-colonization tradeoff
    - definition
    - figure from Tilman

# Neutral theory 
    - definition
    - figure from Hubbell

# Species sorting
    - definition
    - figure from Whittaker

# Mass effect
    - definition
    - figure from Loreau

# ============================================
# DISCUSSION
    split in groups and propose a set of predictions 
# ============================================s


# ============================================
# EXERCISE
# ============================================

# Neutral model - verbal description

    - Consider a lattice with each cell occupied by a single individual
    - Time scale corresponds to the replacement of 1 individual at a time
    - All species have the same probability of mortality
    - Compute number of seeds reaching a seed trap at the center of the cell
    - Dispersal occurs from neighbours with probability (1-m) and from a regional pool with probability m
    - For simplicity, all species have the same abundance in the regional pool
    - All species produce the same number of seeds
    - Recruitment occurs by selecting a seed at random from the seed trap
    - Repeat for a (very) large number of time steps

# Neutral model 

    SET run parameters $l$, $s$, $nsteps$
    SET ecological parameters $m$, $d$ and $r$

    DEFINE array XY of spatial coordinates of size $l^2$ 
    DEFINE array J of size $L^2 x S$

    COMPUTE connectivity matrix ConMat 

    FOR n in 1:nsteps
        SELECT a cell z at random 
            J[z] = 0
        COMPUTE replacement probability for each species
        DRAW a species identity using multinomial distribution
        UPDATE array J

# Neutral model - Replacement probability

    ## Local replacement 
        n_propagules = ContMat%*%J
        p_local = n_propagules/(r^2-1)

    ## Regional replacement 
        p_regional = 1/s

    ## Final probability
        p = (1-m)*p_local + m*p_regional

# Add species-sorting


    ## verbal description


    ## additions to pseudo-code

        n_propagules = ContMat%*%J
        survival = survival_fn(E,O,sigma)
        p_local = survival * n_propagules/(r^2-1)


# Compare expectations 

    - local abundance distribution at equilibrium 
    - regional abundance distribution at equilibrium
    - species area relationship
    - shared species as a function of distance 
    - species-environment relationship

# Advanced

    - compare different spatial autocorrelations to evaluate the effect of mass effect
    - think about a way to incorporate competition-colonization trade-off
