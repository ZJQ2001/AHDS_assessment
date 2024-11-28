#!/bin/bash
# Create directories for raw data

# Fetch PubMed IDs for "long COVID"
echo "Fetching PubMed IDs..."
curl -s "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=pubmed&term=%22long%20covid%22&retmax=5" > raw/pmids.xml

# Extract PMIDs from XML
echo "Extracting PMIDs..."
grep -oP '<Id>\K[0-9]+' raw/pmids.xml > raw/pmid_list.txt

# Download metadata for each article
echo "Downloading article metadata..."
while read pmid; do
    curl -s "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=pubmed&id=$pmid" > raw/article-$pmid.xml
    sleep 1  # Pause to avoid overloading the API
done < raw/pmid_list.txt

echo "Data retrieval complete!"
