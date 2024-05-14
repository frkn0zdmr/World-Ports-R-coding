Analyzing Trade Volume of World Ports
This project aims to analyze the trade volume of world ports using R programming language. It utilizes various packages such as ggplot2, dplyr, readxl, ggmap, and magick for data manipulation, visualization, and map creation. The project involves:

Data Loading and Exploration:

The readxl package is used to read an Excel file containing world port rankings.
The dataset is explored to understand the structure and contents.
Visualizing Top Ports and Countries by Trade Volume:

Using ggplot2, bar plots are created to visualize the trade volume of the top ports and countries in 2020.
The visualization provides insights into the distribution of trade volumes across different ports and countries.
Creating Interactive Maps:

The ggmap package is employed to create interactive maps of world ports.
Google Maps API is used to obtain longitude and latitude coordinates for the ports.
Scatter plots on the map illustrate the trade volume of each port in 2020.
Animating Port Maps Over Time:

Individual maps are generated for each year from 2011 to 2020, depicting the trade volume of ports.
The magick package is utilized to animate these maps into a GIF, showcasing the changes in trade volume over the years.
Usage Instructions:
Ensure that R and RStudio are installed on your system.
Install the required packages using the following commands:
R
Copy code
install.packages("ggplot2")
install.packages("dplyr")
install.packages("readxl")
install.packages("ggmap")
install.packages("magick")
Run the provided R script to execute the analysis.
View the generated visualizations and animations to gain insights into the trade volume of world ports.
File Description:
worldport_rank.xlsx: Excel file containing data on world port rankings.
script.R: R script for data loading, exploration, visualization, and map creation.
port.gif: Animated GIF showing the changes in trade volume of world ports from 2011 to 2020.
Credits:
This project was created by Furkan Ozdemir as part of Introduction to Computational Statistics and Data Analysis. 

Special thanks to the creators of ggplot2, dplyr, readxl, ggmap, and magick packages for their invaluable contributions to the R community.

