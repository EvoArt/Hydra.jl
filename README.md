# Hydra


[![Build Status](https://github.com/EvoArt/Hydra.jl/workflows/CI/badge.svg)](https://github.com/EvoArt/Hydra.jl/actions)
[![Build Status](https://ci.appveyor.com/api/projects/status/github/EvoArt/Hydra.jl?svg=true)](https://ci.appveyor.com/project/EvoArt/Hydra-jl)
[![Coverage](https://codecov.io/gh/EvoArt/Hydra.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/EvoArt/Hydra.jl)

PERMANOVA implementation Based on the work of Marti Anderson. This package aims to provide similar functionality to the `adonis2` in the R package `vegan`. In keeping with names from mythology, the many headed Lernaean Hydra represents the multivariate response data we aim to tackle here. Though perhaps Heracles or Iolis (the eventual slayers of the Hydra) would be more apt.

![alt text](https://github.com/EvoArt/Hydra/blob/master/docs/Sargent_Hercules.jpg?raw=true)

The function function `hydra2` expects:

*   data: a table/dataframe with a column containing the independent variable. 
*   D: a distance matix
* formula: a [StatsModels.jl](https://juliastats.org/StatsModels.jl/stable/formula/) formula 
*    pairs: and optional keyword boolean argument, telling hydra2 to also compute pairwise statistics.

This function returns a `HydraSummary` struct when pairs == `false` and an array of `HydraSummary`s when pairs == `true`.

`permute` accepts a `HydraSummary` or array thereof, as well al the desired number of permutations. P-Values are calculated by simultaneous permutation of rows and columns. If an array is passed in, thenan Array will be returned, with pairwise P-values in the lower triangle and the global P-value in the top right. Optionally, when permuting an array of pairwise results, a vector of level names (in lexographical order) or the full vector/column used as the independent variable in `hydra2` may be passed as an argument after the array. This will return a Named array, with appropriate column and row names.

