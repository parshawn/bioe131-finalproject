
# JBrowse Setup and Synteny Analysis Guide

This guide provides step-by-step instructions for setting up JBrowse for synteny analysis and annotation across **MacOS**, **AWS**, and **Windows**. It includes commands, explanations, and troubleshooting tips.

---

## **MacOS Setup**

### Pre-requisites
1. Install **Homebrew**:
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

2. Install required tools:
   ```bash
   brew install samtools htslib node wget apache2 minimap2
   npm install -g @jbrowse/cli
   ```

3. Start Apache:
   ```bash
   sudo apachectl start
   ```

4. Set environment variable for Apache root:
   ```bash
   export APACHE_ROOT='/usr/local/var/www'
   ```

### Setup JBrowse
1. Create a temporary directory for setup:
   ```bash
   mkdir tmp && cd tmp
   ```

2. Create and configure JBrowse directory:
   ```bash
   jbrowse create jbrowse2_output
   sudo mv jbrowse2_output $APACHE_ROOT/jbrowse2
   sudo chown -R $(whoami) $APACHE_ROOT/jbrowse2
   ```

---

## **AWS Setup**

### Pre-requisites
1. Update and install dependencies:
   ```bash
   sudo apt update
   sudo apt install wget curl apache2 minimap2 samtools
   ```

2. Install Node.js and JBrowse CLI:
   ```bash
   curl -fsSL https://fnm.vercel.app/install | bash
   source ~/.bashrc
   fnm use --install-if-missing 20
   npm install -g @jbrowse/cli
   ```

3. Start Apache:
   ```bash
   sudo service apache2 start
   ```

4. Set environment variable for Apache root:
   ```bash
   export APACHE_ROOT='/var/www/html'
   ```

### Setup JBrowse
1. Create a temporary directory for setup:
   ```bash
   mkdir tmp && cd tmp
   ```

2. Create and configure JBrowse directory:
   ```bash
   jbrowse create jbrowse2_output
   sudo mv jbrowse2_output $APACHE_ROOT/jbrowse2
   sudo chown -R $(whoami) $APACHE_ROOT/jbrowse2
   ```

---

## **Windows Setup**

### Pre-requisites
1. Install required tools:
   - [Node.js](https://nodejs.org/)
   - [Git Bash](https://git-scm.com/downloads)
   - [Apache Server (WAMP/XAMPP)](https://www.apachefriends.org/index.html)
   - Samtools/HTSlib (via Conda or binaries)

2. Install JBrowse CLI:
   ```bash
   npm install -g @jbrowse/cli
   ```

3. Set the Apache root path (e.g., `C:\xampp\htdocs`).

### Setup JBrowse
1. Create a temporary directory for setup:
   ```bash
   mkdir tmp && cd tmp
   ```

2. Create and configure JBrowse directory:
   ```bash
   jbrowse create jbrowse2_output
   mv jbrowse2_output C:/xampp/htdocs/jbrowse2
   ```

---

## **Downloading and Indexing Genomic Data**

Repeat the following steps for each virus:

### Variola Virus
```bash
export FASTA_ROOT="https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/859/885/GCF_000859885.1_ViralProj15197/"
wget $FASTA_ROOT/GCF_000859885.1_ViralProj15197_genomic.fna.gz
gunzip GCF_000859885.1_ViralProj15197_genomic.fna.gz
mv GCF_000859885.1_ViralProj15197_genomic.fna variola.fna
samtools faidx variola.fna
```

### Monkeypox Virus
```bash
export FASTA_ROOT="https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/023/516/015/GCA_023516015.3_ASM2351601v1/"
wget $FASTA_ROOT/GCA_023516015.3_ASM2351601v1_genomic.fna.gz
gunzip GCA_023516015.3_ASM2351601v1_genomic.fna.gz
mv GCA_023516015.3_ASM2351601v1_genomic.fna monkeypox.fna
samtools faidx monkeypox.fna
```

### Cowpox and Vaccinia
```bash
curl -o cowpox_genome_ncbi.fa "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=NC_003663.2&rettype=fasta&retmode=text"
samtools faidx cowpox_genome_ncbi.fa

curl -o vaccinia_genome_ncbi.fa "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=NC_006998.1&rettype=fasta&retmode=text"
samtools faidx vaccinia_genome_ncbi.fa
```

---

## **Synteny Analysis**

### Generate PAF Files
```bash
minimap2 monkeypox.fna variola.fna > variola_vs_monkeypox.paf
minimap2 cowpox_genome_ncbi.fa variola.fna > variola_vs_cowpox.paf
minimap2 vaccinia_genome_ncbi.fa variola.fna > variola_vs_vaccinia.paf
```

### Add Assemblies to JBrowse
```bash
jbrowse add-assembly monkeypox.fna --load copy -n monkeypox --out $APACHE_ROOT/jbrowse2
jbrowse add-assembly variola.fna --load copy -n variola --out $APACHE_ROOT/jbrowse2
jbrowse add-assembly cowpox_genome_ncbi.fa --load copy -n cowpox --out $APACHE_ROOT/jbrowse2
jbrowse add-assembly vaccinia_genome_ncbi.fa --load copy -n vaccinia --out $APACHE_ROOT/jbrowse2
```

### Add Tracks to JBrowse
```bash
jbrowse add-track variola_vs_monkeypox.paf --assemblyNames variola,monkeypox --load copy --out $APACHE_ROOT/jbrowse2 --force
jbrowse add-track variola_vs_cowpox.paf --assemblyNames variola,cowpox --load copy --out $APACHE_ROOT/jbrowse2 --force
jbrowse add-track variola_vs_vaccinia.paf --assemblyNames variola,vaccinia --load copy --out $APACHE_ROOT/jbrowse2 --force
```

---

## **Final Steps**

### Index Everything
```bash
jbrowse text-index --out $APACHE_ROOT/jbrowse2 --force
```

### Publish to GitHub Pages
1. Navigate to the local GitHub repository:
   ```bash
   cd ~/github-repo
   ```

2. Copy the JBrowse folder to the repository:
   ```bash
   cp -r /var/www/html/jbrowse2 ~/github-repo/
   ```

3. Commit and push changes:
   ```bash
   git add .
   git commit -m "Add JBrowse setup and tracks"
   git push origin main
   ```

4. Enable GitHub Pages via repository settings.

---

## **Troubleshooting**

1. **Synteny Tracks Empty**:
   - Ensure PAF files match assembly names in JBrowse.
   - Verify PAF file structure for valid alignment data.

2. **Permission Issues**:
   - Use `sudo` where necessary.
   - Ensure correct permissions for Apache's document root and JBrowse folder.

3. **GitHub Not Displaying Changes**:
   - Ensure changes are committed to the correct branch.
   - Clear browser cache or reload the GitHub Pages URL.

---

This guide provides a comprehensive walkthrough for setting up JBrowse and performing synteny analysis. For additional help, contact your system administrator or refer to JBrowse documentation.