
# Intro 
    Picture : archipelago

# Intro 
    Picture : forest patches in an agricultural landscape

# Intro 
    Picture : ponds

# Intro 
    Picture : trees

# Patch
    Picture : 
    Definition  : 

# Scale-dependence of organisms
    Figure : Yetz

# Dynamics on a real landscapes 
    Picture : small beetle
    Picture : forest landscapes

# Colonization 
    Multiple processes : foraging, dispersal, establishment, population growth 
    Conceptual equation

# Extinction 
    Multiple causes : stochsticity, selection, perturbation 
    Conceptual equation 

# Combining processes 

# The Levins model 
    Central equation

    Condition for persistence 

# The Levins model : solution 

    Equation for time dynamics 
    Equation for equilibrum 

# The Levins model : interpretation  
    - occupancy augmente avec la capacité de colonisation
    - occupancy diminue avec le taux d'extinction
    - stable
    - croissance asymptotique
    - variabilité dépend du nombre de patches

# The Levins model : assumptions 
    - discrete landscape
    - separation of time scales 
    - infinite number of patches
    - all patches are identical
    - surrounding matrix is inhospitable
    - indepdendence of c and e
    - global dispersal 

# Exercise 1a

    Stochastic simulation with global dispersal 

# Exercise 1b

    Stochastic simulation with local dispersal 




# Pair-approximation 
    Setting : patches positioned on a circle
    Nearest-neighbor dispersal 
    Pair approximation : the occurrence of the focal species in a patch can be computed from the knowledge of species occurrence in the two neigh boring patches

# Pair-approximation : model 
    X_x(t) : a random variable describing the occupancy of patch x at time t

    We keep track of pairs of patches : 

    p_EE = E[(1-X_x)(1-X_{x+1})]
    p_OE = p_EO = E[X_x(1-X_{x+1})]
    p_OO = E[X_xX_{x+1}]

    With definition of occupancy p = p_{OO}+p_{OE}

# Pair-approximation : model 

    Based on these definitions, and colonization rate of c/2 towards each side of an occupied patch, we get : 

# Pair-approximation : solution 

    Which yields the metapopulation occupancy 

    p = \frac{1-2(e/c)}{1-(e/c)}

# Pair-approximation : autocorrelation


    Nearest neighbor dispersal has for result that pairs of patches tend to be more similar than with global dispersal. 

    The spatial autocorrelation in this model is : 

        \rho = \frac{e}{c}

    And we can re-arrange equilibrium solution as : 

        p^* = 1 - \frac{e}{c}\frac{1}{1-\rho}

# Pair-approximation : interpretation 



    => here comes the important notion of dispersal limitation 





# Habitat destruction

    Standard model assumes that the entire landscape is available for colonization

    Habitat loss can be introduced as follows :

# Habitat destruction : conclusion

    Persistence now requires : 

    Which means that a species may go extinct, even if c>e and that there are remaining suitable habitats
    
# Habitat destruction : spatially explicit dispersal

    Figure : patch size distribution with destruction
    Figure : extinction threshold for spatially implicit and explicit landsacles

    Conclusion : spatially explicit dynamics magnifies the effect of habitat destruction





