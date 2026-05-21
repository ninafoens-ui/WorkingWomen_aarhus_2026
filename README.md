# Working Women in the 19th century

This code was developed as part of a final project in Digital Archives and Methodology at Aarhus University. The main objective of this project was to investigate employment opportunities for women in the 19th century in Aarhus and Randers counties.
The data was obtained from the Aarhus census and processed by the group members. 

## Description

This code was used in our final project for our exam and portfolio assignments for the course. We used our data analysis to analyze, describe, and discuss women’s employment and economic opportunities in the 19th century in relation to the historical context of the nearingsretslov and industrialization in Denmark. 

## Overview

### Dependencies
Software Lincense:
R and Rstudio: GNU General Public License v3
OpenRefine: Creative Commons Attribution 4.0 International License.

### Installing

* How/where to download programs: (https://rstudio-education.github.io/hopr/starting.html)
* Any modifications needed to be made to files/folders: Tidyverse, Leaflet

### Executing program

# How to run the program

1. Clone or download the repository.

2. Place the census datasets in the `data/` folder:
   - `census_1845_cleancsv.csv`
   - `census_1860_cleancsv.csv`

3. Open the R project or set the working directory to the project folder.

4. Install required packages:
```
 install.packages(c(
     "tidyverse",
     "readr",
     "ggplot2",
     "scales"
   ))
```

5. Load the required libraries:
```
    library(tidyverse)
   library(readr)
   library(ggplot2)
   library(scales)
```

6. Run the main analysis script:
```
   source("scripts/main_analysis.R")
```

7. The script will:
   - import and clean the census datasets
   - standardize occupational categories
   - merge the 1845 and 1860 census data
   - create grouped age categories
   - generate visualisations of women’s occupations
   - calculate occupational proportions by year

8. Output files will be saved in:
   - `fig.output/`

9. Generated figures include:
   - Occupational distributions
   - Age-group comparisons
   - Occupational proportions across census years

## Authors

Contributors names and contact info

Luna Marie Swchartz Marcher: 202307449@post.au.dk
Andrea Sif Bragadottir: 202306457@post.au.dk
Stephanie Torpdahl Joel: 202304548@post.au.dk
Nina Føns Sørensen: 202308085@post.au.dk


## License

This project is licensed under the [NAME HERE] License - see the LICENSE.md file for detailsThe census data from Aarhus Archives is licensed under Public Domain Dedication and License (PDDL)
  -The datasets are based on Danish census records from 1845 and 1860.
  -Occupational categories were harmonized across census years to allow longitudinal comparison.
  - All figures and tables in the article can be reproduced by running the main script.
The Rscript and data produced in this project is licensed under Creative Commons Attribution–ShareAlike 4.0 International (CC BY-SA 4.0)

## Acknowledgments

*Carpentry.com
*Thanks to the teachers of the course: Adela Sobotkova, Jonathan Lanz, Stephan Smuts and all the student assistants for the guidance and technical assistance during our work with the final project.  
*Aarhus City Archives
*Max Odsberg 

