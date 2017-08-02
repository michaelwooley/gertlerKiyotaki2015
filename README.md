# gertlerKiyotaki2015
This repository contains a solution to the model from 
[Gertler and Kiyotaki (_AER_, 2015)](http://www.econ.nyu.edu/user/gertlerm/GertlerKiyotakiAERJuly2015.pdf).
It was created as part of a class on macroeconomics in Fall, 2015.
The solution technique is both: 
- _Transparent:_ It isn't dependent on black-box optimization.
- _Fast:_ The time to solution is usually around 15-20 seconds.

How does it work? There are three basic ideas:
1. The model can be solved backwards in time. Moreover, when it is solved backwards the number of state variables shrinks from four to one. 
2. Each step in a proposed equilibrium path can be solved _analytically_. Demonstrating this requires symbolic algebra (the solutions 
run to  about 12,000 characters). However, with Matlab's symbolic math tools we can easily turn these expressions into callable functions.
3. We can find an equilibrium path through the correct choice of _one parameter_ (a perturbation term). There is a one-to-one mapping 
from the choice of this parameter to the "initial state" condition. Thus, to find an equilibrium path we can i) make guesses of this 
parameter then ii) use a quadratic spline to interpolate the correct parameter value.

## File Organization

The code is currently a mess of files. Part of this has to do with Matlab's insistence that each function get its own file. 
Part of it has to do with my relative inexperience in coding when I wrote it in 2015.

More information about the model and solution approach can be found in **`wooley_final.pdf`**. The script **`code/final.m`** 
will produce the analysis found in the paper. The outer loop file is `backUmbrella.m`. It will then call functions of the
for `qRunIter[*].m`, which will solve the inner loop.
