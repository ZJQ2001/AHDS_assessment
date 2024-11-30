# Snakefile

# Define the raw data directory
raw_dir="raw"
clean_dir="clean"
output_visualization = "graph/word_frequency_trend.png"


# Specify the workflow's target
rule all:
    input:
        f"{raw_dir}/pmid_list.txt",              
        f"{clean_dir}/processed_data.tsv",       
        f"{clean_dir}/processed_data_output.tsv",
        output_visualization         


# Rule to download data
rule download_data:
    output:
        pmid_list = f"{raw_dir}/pmid_list.txt",
    shell:
        """
        bash scripts/download_data.sh
        """

# Rule to process data
rule process_data:
    input:
        pmid_list = f"{raw_dir}/pmid_list.txt",
    output:
        processed_data = f"{clean_dir}/processed_data.tsv"
    shell:
        """
        bash scripts/process_data.sh
        """

# Rule to process titles using R
rule process_titles:
    input:
        "clean/processed_data.tsv"
    output:
        processed_titles = f"{clean_dir}/processed_data_output.tsv"
    script:
        "scripts/process_titles.R"


# Rule to generate visualization using R
rule visualize_data:
    input:
        processed_titles = f"{clean_dir}/processed_data_output.tsv"
    output:
        visualization = output_visualization
    script:
        "scripts/visualisation.R"


