AHDS_summative_assessment "COVID-19 Publications Mini Project"

Overview
This project explores trends in COVID-19 research publications by analyzing article metadata retrieved from PubMed. The workflow includes downloading, processing, and visualizing data programmatically as part of a Snakemake pipeline.

Setup:
Prerequisites
Conda: Used for package management.
Git: Version control to track project development.
Snakemake: Workflow management.
Environment Setup
Clone this repository:
Create and activate the Conda environment:
conda env create -f environment.yml
conda activate AHDS-env

Configuration
Before running the scripts, ensure that the config.yaml file is properly set up with the necessary configurations such as directory paths and processing options.

Running the Program
To run the entire pipeline, use the provided Snakefile which orchestrates the execution of scripts in the correct order:

snakemake
If you want to do a commit run in BlueCrystal, run

~/.bashrc
snakemake  --cores 1  

Before running, check the config file to make sure the request data is correct.

Alternatively, individual components can be run as follows:

Download Data:

snakemake download_data --cores 1

Processing Articles:

Process XML files:
snakemake process_data  --cores 1

Clean Titles:
snakemake process_titles --cores 1

Data Visualisation:

snakemake visualisation --cores 1


remove data, logs and plots directory:
snakemake clean
remove plots directory::
snakemake cleanplot
The data folder is used to hold the data used by this project. The directory called raw where the raw data is stored. The directory called clean where the clean data generated by scripts will go.

The result of the data visualization will be saved in the plots folder, but you can also check out step4_result directly, which is a visualization of the sample data.


The project consists of four key steps:

Download Data
Fetch PubMed IDs for "long COVID" articles using the PubMed API.
Download metadata for each article as XML files.
Script: download_data.sh

Process Data
Extract publication year and title from the XML files.
Clean titles by removing XML tags and invalid entries.
Save the processed data as a TSV file.
Script: process_data.sh
Text Processing

Use the R tidytext package to preprocess titles:
Remove stopwords and digits.
Perform word stemming.
Script: process_titles.R

Visualization
Generate visualizations to analyze trends in article titles over time.
Example: Frequency of specific words or trends in topics over the years.
Script: visualisation.R

git init
Pipeline Execution
Configure Snakemake: Define the workflow in a Snakefile with the following steps:

download_data.sh
process_data.sh
process_titles.R
visualisation.R
Run the Pipeline: Execute the entire pipeline using Snakemake:

snakemake --cores <number_of_cores>
Results
Processed Data: Saved in clean/processed_data.tsv.
Visualizations: Generated plots to analyze publication trends.

Logs
Logs for the data fetching process can be found in the logs directory, providing details about the execution and any potential errors
