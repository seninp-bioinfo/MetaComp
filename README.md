# MetaComp

Metagenome taxonomy assignment comparison toolkit. The toolkit is being developed for [EDGE platform](https://github.com/LANL-Bioinformatics/EDGE) and reflects its backend specificity. The routines, however, can be used as a stand-alone library for multi-project comparative visualization of taxonomy assignments obtained for metagenomic samples processed with GOTTCHA/GOTTCHA2, BWA, KRAKEN, or METAPHLAN.

[![Build Status](https://travis-ci.org/seninp-bioinfo/MetaComp.svg?branch=master)](https://travis-ci.org/seninp-bioinfo/MetaComp?branch=master)
[![codecov.io](http://codecov.io/github/seninp-bioinfo/MetaComp/coverage.svg?branch=master)](http://codecov.io/github/seninp-bioinfo/MetaComp?branch=master)
[![License](http://img.shields.io/:license-gpl2-green.svg)](http://www.gnu.org/licenses/gpl-2.0.html)

#### 0.0 Installation from latest sources
    install.packages("devtools")
    library(devtools)
    install_github(repo = 'seninp-bioinfo/MetaComp', ref = "v1.3")
    
to use the library, simply load it into R environment:

    library(MetaComp)

#### 1.0 Reading a single taxonomic assignment files
    the_gottcha_assignment <- load_gottcha_assignment(data_file_g)
    the_kraken_assignment <- load_kraken_assignment(data_file_k)
    the_metaphlan_assignment <- load_metaphlan_assignment(data_file_m)
    
#### 1.1 Reading multiple taxonomic assignment files
The package functions `load_xxx_assignments` (where `xxx` stands for gottcha, kraken, or metaphlan) are designed to read a tool-specific assignment files. The configuration file for these functions must be tab-delimeted two columns file where the first column is the project id (used as the project's name in plotting), and the second column is an actual assignment file path:

    the_assignments_list_g <- load_gottcha_assignments(config_file_g)
    the_assignments_list_k <- load_kraken_assignments(config_file_k)
    the_assignments_list_m <- load_metaphlan_assignments(config_file_m)

#### 2.0 Merging multiple taxonomic assignments into a single table
The `merge_xxx_assignments` function is capable to merge a named list of GOTTCHA, Kraken, or MetaPhlAn assignments into a single table using `LEVEL` and `TAXA` columns as ids. 

#### 3.0 Plotting a single assignment as a heatmap
The function `plot_xxx_assignment` accepts a single assignment table and outputs a ggplot object or produces a PDF plot using ggplot2's `geom_tile`.

![Single column plot](https://raw.githubusercontent.com/seninp-bioinfo/MetaComp/master/inst/site/test1.png)
    
#### 3.1 Plotting multiple assignments as a single heatmap
The function `plot_merged_assignment` accepts a single merged assignment table as an input and outputs a ggplot object or produces a PDF plot using ggplot2's `geom_tile`.

![Multiple columns plot](https://raw.githubusercontent.com/seninp-bioinfo/MetaComp/master/inst/site/test2.png)

#### 4.0. Running merge in a batch mode
The following script can be used to run the merge procedure in a batch mode: 
    
    # load library
    require(MetaComp)
    #
    # configure runtime
    options(echo = TRUE)
    args <- commandArgs(trailingOnly = TRUE)
    #
    # print provided args
    print(paste("provided args: ", args))
    #
    # acquire values
    srcFile <- args[1]
    destFile <- args[2]
    taxonomyLevelArg <- args[3]
    plotTitleArg <- args[4]
    plotFileArg <- args[5]
    rowLimitArg <- args[6]
    sortingOrderArg <- args[7]
    #
    # read the data and produce the merged table
    merged <- merge_gottcha_assignments(load_gottcha_assignments(srcFile))
    #
    # write the merge table as a TAB-delimeted file
    write.table(merged, file = destFile, col.names = T, row.names = F, quote = T, sep = "\t")
    #
    # produce a PDF of the merged assignment
    plot_merged_assignment(assignment = merged, taxonomy_level = taxonomyLevelArg,
                       sorting_order = sortingOrderArg, row_limit = base::strtoi(rowLimitArg),
                       plot_title = plotTitleArg, filename = plotFileArg)
    
To execute the scrip, use Rscript as shown below:

    $> Rscript merge_and_plot_gottcha_assignments.R assignments_table_gottcha.txt merged_assignments.txt \
                                        family "Merge test plot" merge_test 20 alphabetical
    
this command line arguments are (some of these are clickable -- so you can see examples):
* `Rscript` - a way to execute the [R script](https://stat.ethz.ch/R-manual/R-devel/library/utils/html/Rscript.html)
* [`merge_and_plot_gottcha_assignments.R`](https://raw.githubusercontent.com/seninp-bioinfo/MetaComp/master/inst/site/merge_and_plot_gottcha_assignments.R)- the above script filename
* [`assignments_table_gottcha.txt`](https://raw.githubusercontent.com/seninp-bioinfo/MetaComp/master/inst/site/assignments_table_gottcha.txt) - the tab delimeted table of assignments (two columns: `project_id` TAB `assignment_path`)
* [`merged_assignments_gottcha.txt`](https://raw.githubusercontent.com/seninp-bioinfo/MetaComp/master/inst/site/merged_assignments_gottcha.txt) - the tab-delimeted output file name
* `family` - a LEVEL at which the plot should be produced
* `"Merge test plot"`- the output plot's title
* `merge_test` - the output plot filename mask, [`".pdf"`](https://github.com/seninp-bioinfo/MetaComp/blob/master/inst/site/merge_gottcha_test.pdf) and [`".svg"`](https://github.com/seninp-bioinfo/MetaComp/blob/master/inst/site/merge_gottcha_test.svg) files will be produced...
* `20` the max number of rows to plot (in the specified sorting order)
* `alphabetical` the merged *plot* sorting order
