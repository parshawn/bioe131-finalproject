# -------------------- Variola assembly --------------------
export FASTA_ROOT=https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/859/885/GCF_000859885.1_ViralProj15197/
wget $FASTA_ROOT/GCF_000859885.1_ViralProj15197_genomic.fna.gz
# Download the Variola virus genomic FASTA file

gunzip GCF_000859885.1_ViralProj15197_genomic.fna.gz
mv GCF_000859885.1_ViralProj15197_genomic.fna variola.fna
samtools faidx variola.fna
# Decompress, rename and index the variola FASTA file for random access queries with samtools

# -------------------- Monkeypox assembly --------------------
export FASTA_ROOT=https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/023/516/015/GCA_023516015.3_ASM2351601v1/
wget $FASTA_ROOT/GCA_023516015.3_ASM2351601v1_genomic.fna.gz
# Download the Monkeypox virus genomic FASTA file

gunzip GCA_023516015.3_ASM2351601v1_genomic.fna.gz
mv GCA_023516015.3_ASM2351601v1_genomic.fna monkeypox.fna
samtools faidx monkeypox.fna
# Decompress, rename and index the Monkeypox FASTA file for random access queries with samtools

# -------------------- Cowpox assembly -----------------------
curl -o cowpox_genome_ncbi.fa "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=NC_003663.2&rettype=fasta&retmode=text"
samtools faidx cowpox_genome_ncbi.fa
# Same as above, but we use curl instead of wget here

# -------------------- Vaccinia assembly ---------------------
curl -o vaccinia_genome_ncbi.fa "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=NC_006998.1&rettype=fasta&retmode=text"
samtools faidx vaccinia_genome_ncbi.fa
# Same as above, but we use curl instead of wget here
