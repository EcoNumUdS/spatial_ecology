title : From individuals to collective behaviour


# Intro 

picture  : gps collar
figure : animal tracking

# Statistical description of movement

figure : frequency distribution of home range size 
figure : habitat selection (Northrup et al. 2022)

# Outline

- Random walk and diffusion 
- Home range analysis
- Spreading rate
- Predator-prey interactions
- Self-organization & complex spatial structures


# ==================
# Mechanistic home range analysis
# ==================

# Random walk

Definition : a stochastic process that describes a path that consists of a succession of random steps on some mathematical space

Figure : Figure 2.1. Case 2001

# Diffusion

Definition : the population of consequence of many individuals simultaneously undergoing random walks in continuous time and across continuous space

Figure : 2.2. Case 2001

# A numerical example

\begin{itemize}
    \item Start with $N = 2000$
    \item Each time step, $1/10$ individuals ($d = 0.1$) move to the left and the same to the right
\end{itemize}

\begin{table}[]
\begin{tabular}{lllllll}
       & x=1 & x=2 & x=3  & x=4  & x=5 & x=6 \\
Time 0 &     &     & 1000 & 1000 &     &     \\
Time 1 &     & 100 & 900  & 900  & 100 &     \\
Time 2 & 10  & 170 & 820  & 820  & 170 & 10 
\end{tabular}
\end{table}

# More broadly 

Density change per cell follow : 

$N_{x, t+1} = N_{x, t} + dN_{x-1, t} + dN_{x+1, t} - 2dN_{x, t}$

# Result 

Which looks like : 

Figure : figure 2.5

# From discrete to continuous

We can reformulate the equation as a change in density at location $x$ : 

$\Delta N_x = N_{x, t+1}-N_{x, t} = d[(N_{x-1, t}-N_{x, t}) + N_{x+1, t}-N_{x, t})]$

As the time and spatial steps get smaller, the formula becomes : 

$\frac{dN(x.t)}{dt} = D \frac{\partial^2N(x,t)}{\partial^2 x}$

Where : 
\begin{itemize}
    \item The left term is the rate at which the density at position $x$ is changing over time
    \item $D$ is the diffusion parameter
    \item The right term is a density gradient at location $x$
\end{itemize}

# Diffusion coefficient

Units are $distance^2$ per time

Interpretation is the mean square displacement (one dimension): 

$D = \frac{\overline{\delta^2}}{2t}$

# Solution 

The number of individuals relased at a location will follow a normal distribution : 

$N(x,t) = \frac{N_0}{\sqrt{4\piDt}}exp\frac{-(x-\overline{x})^2}{4Dt}$

With interpretation : 
\begin{itemize}
    \The mean displacement expands across space at a rate proportional to the square root of time
    \The total area (range size) increases proportionnally with time
\end{itemize}


# ==================
# Diffusion
# ==================

# Definition
- The population of consequence of many individuals simultaneously undergoing random walks in continuous time and across continuous space
- Essential statistical properties : 
    - center of the distribution should not change over time
    - Individuals will spread out over time
    - Particle density takes the shape of a sample from a normal distribution in two-dimensional space

# Example of random walk (Case 2.1)

# Example of random walk (Case 2.2)

# Bivariate normal distribution
    Useful interpretations

    Figure 2.2

# Bivariate normal distribution
    Density changes per cell
    Figure 2.4

# Origin of the diffusion equation 

# Diffusion coefficient
    Definition
    How to compute it

# ==================
# Local tendency model
# ==================

# Movement kernel 

# Solving for space use 
    conclusion : simplest model predicting a stationary distribution of position 


# ==================
# Spreading rate (reaction-diffusion)
# ==================

# Movement plus geometric growth
    intuition 
    equation
    Figure 2.8

# Movement plus geometric growth
    Figure 2.8
    solution (Eq. 2.6)

# The muskrat example 


# ==================
# Predator prey interactions
# ==================

# Functional response 

# A mechanistic approach

# Law of mass action

# Available time for search

# Example for arctic fox 

# Density-dependence of movement

# Non-random movement

# Dimensionality

