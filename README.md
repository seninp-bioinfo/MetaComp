# MetaComp

Metagenome comparison heatmap ... 

[![Build Status](https://travis-ci.org/seninp-bioinfo/MetaComp.svg?branch=master)](https://travis-ci.org/seninp-bioinfo/MetaComp?branch=master)
[![codecov.io](http://codecov.io/github/seninp-bioinfo/MetaComp/coverage.svg?branch=master)](http://codecov.io/github/seninp-bioinfo/MetaComp?branch=master)

#### 0.0 Installation from latest sources
    install.packages("devtools")
    library(devtools)
    install_github('seninp-bioinfo/MetaComp')
    
to use the library, simply load it into R environment:

    library(MetaComp)

#### 1.0 Reading a single GOTTCHA assignment file
    the_gottcha_assignment <- load_gottcha_assignments(data_file)
    
#### 1.1 Reading multiple GOTTCHA assignment files
The package function `load_gottcha_assignments` can be used to read GOTTCHA assignments from multiple filesystem locations when configured by a single tab-delimeted two columns file -- first column for the project id, second column for the assignment file:

    the_assignments_list <- load_gottcha_assignments(config_file)    

#### 2.0 Merging multiple GOTTCA assignments into a single table
The `merge_gottcha_assignments` function is capable to merge a named list of GOTTCHA assignments into a single table using `LEVEL` and `TAXA` columns as ids. 

#### 3.0 Plotting a single assignment as a heatmap
The function `plot_gottcha_assignment` accepts a single assignment table and outputs a ggplot object or produces a PDF plot using ggplot2's `geom_tile`.

![Single column plot](https://raw.githubusercontent.com/seninp-bioinfo/MetaComp/master/inst/site/test1.png)
    
#### 3.1 Plotting multiple assignments as a single heatmap
The function `plot_gottcha_assignment` accepts a single merged assignment table and outputs a ggplot object or produces a PDF plot using ggplot2's `geom_tile`.

![Multiple columns plot](https://raw.githubusercontent.com/seninp-bioinfo/MetaComp/master/inst/site/test2.png)
