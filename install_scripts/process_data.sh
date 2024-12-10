# -------------------- Synteny Analysis --------------------
brew update                        # Update the package lists
brew install minimap2              # Install Minimap2 for pairwise alignment

minimap2 monkeypox.fna variola.fna > variola_vs_monkeypox.paf
minimap2 cowpox_genome_ncbi.fa variola.fna > variola_vs_cowpox.paf
minimap2 vaccinia_genome_ncbi.fa variola.fna > variola_vs_vaccinia.paf
# Generate a PAF file showing alignments between Variola and other 3 viruses genomes

sudo jbrowse add-assembly monkeypox.fna --load copy -n monkeypox --out /var/www/html/jbrowse2
sudo jbrowse add-assembly variola.fna --load copy -n variola --out /var/www/html/jbrowse2
sudo jbrowse add-assembly cowpox_genome_ncbi.fa --load copy -n cowpox --out /var/www/html/jbrowse2
sudo jbrowse add-assembly vaccinia_genome_ncbi.fa --load copy -n vaccinia --out /var/www/html/jbrowse2
sudo jbrowse add-assembly B14R_gene.fna --load copy -n B14R --out /var/www/html/jbrowse2
# Add all of the viruses and B14R gene assemblies to JBrowse with a specified name

sudo jbrowse add-track variola_vs_monkeypox.paf --assemblyNames variola,monkeypox --load copy --out /var/www/html/jbrowse2
sudo jbrowse add-track variola_vs_cowpox.paf --assemblyNames variola,cowpox --load copy --out /var/www/html/jbrowse2
sudo jbrowse add-track variola_vs_vaccinia.paf --assemblyNames variola,vaccinia --load copy --out /var/www/html/jbrowse2
# Add the Variola vs other 3 viruses synteny track to JBrowse

# -------------------- Add Annotation --------------------

# Variola
export GFF_ROOT=https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/859/885/GCF_000859885.1_ViralProj15197/
wget $GFF_ROOT/GCF_000859885.1_ViralProj15197_genomic.gff.gz
gunzip GCF_000859885.1_ViralProj15197_genomic.gff.gz
sudo jbrowse sort-gff GCF_000859885.1_ViralProj15197_genomic.gff > variola.gff
# Download and decompress the Variola GFF file, sort the  GFF file using JBrowse

bgzip variola.gff
tabix variola.gff.gz
# Compress the GFF file into a .gz format and index it with tabix

sudo jbrowse add-track variola.gff.gz --assemblyNames variola --out $APACHE_ROOT/jbrowse2 --load copy
# Add the Variola annotation track to JBrowse

# Monkeypox
export GFF_ROOT=https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/023/516/015/GCA_023516015.3_ASM2351601v1/
wget $GFF_ROOT/GCA_023516015.3_ASM2351601v1_genomic.gff.gz
gunzip GCA_023516015.3_ASM2351601v1_genomic.gff.gz
sudo jbrowse sort-gff GCA_023516015.3_ASM2351601v1_genomic.gff > monkeypox.gff
# Download and decompress the Monkeypox GFF file, sort the  GFF file using JBrowse

bgzip monkeypox.gff
tabix monkeypox.gff.gz
# Compress the GFF file into a .gz format and index it with tabix

sudo jbrowse add-track monkeypox.gff.gz --assemblyNames monkeypox --out $APACHE_ROOT/jbrowse2 --load copy
# Add the Monkeypox annotation track to JBrowse

# Cowpox
curl -o cowpox_genome.gff.gz "https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/839/185/GCF_000839185.1_ViralProj14174/GCF_000839185.1_ViralProj14174_genomic.gff.gz"
gunzip cowpox_genome.gff.gz
sudo jbrowse sort-gff cowpox_genome.gff > cowpox_genome_sorted.gff
bgzip cowpox_genome_sorted.gff
tabix cowpox_genome_sorted.gff.gz
sudo jbrowse add-track cowpox_genome_sorted.gff.gz --assemblyNames cowpox --out $APACHE_ROOT/jbrowse2 --load copy
# Same as above with Cowpox where we use curl here

# Vaccinia
curl -o vaccinia_genome.gff.gz "https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/860/085/GCF_000860085.1_ViralProj15241/GCF_000860085.1_ViralProj15241_genomic.gff.gz"
gunzip vaccinia_genome.gff.gz
sudo jbrowse sort-gff vaccinia_genome.gff > vaccinia_genome_sorted.gff
bgzip vaccinia_genome_sorted.gff
tabix vaccinia_genome_sorted.gff.gz
sudo jbrowse add-track vaccinia_genome_sorted.gff.gz --assemblyNames vaccinia --out $APACHE_ROOT/jbrowse2 --load copy
# Same as above with Vaccinia where we use curl here

# --------------------
sudo jbrowse text-index --out $APACHE_ROOT/jbrowse2
# Build a text index for all assemblies and tracks in JBrowse for fast searching
