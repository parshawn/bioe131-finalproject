# -------------------- Setup if using a Linux or Windows Device --------------------


sudo su -                                  # Switch to the root user
passwd ubuntu                              # Set a new password for the 'ubuntu' user

ubuntu                                     # (User input) Enter the new password (e.g., "ubuntu")
ubuntu                                     # (User input) Confirm the password

exit                                       # Exit the root shell, returning to the 'ubuntu' user

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# Run Homebrew's installation script from GitHub

echo >> /home/ubuntu/.bashrc
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/ubuntu/.bashrc
# Append Homebrew environment initialization commands to the .bashrc file
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
# Apply the updated environment variables from Homebrew immediately

# installs fnm (Fast Node Manager)
curl -fsSL https://fnm.vercel.app/install | bash
# activate fnm
source ~/.bashrc
# download and install Node.js
fnm use --install-if-missing 20
# verifies the right Node.js version is in the environment
node -v # should print `v20.18.0`
# verifies the right npm version is in the environment
npm -v # should print `10.8.2

# -------------------- Setup if using a Mac -----------------------------------------

xcode-select --install
#install command line tools if not already

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc

echo 'export PATH="/opt/homebrew/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc

brew --version
brew update

node -v


# NOTE:
# Homebrew is not a Node.js package manager.
# Please ensure it is already installed on your system.
# Follow official instructions at https://brew.sh/
# Homebrew only supports installing major Node.js versions and might not support the latest Node.js version from the 20 release line.
# download and install Node.js
brew install node@20
# verifies the right Node.js version is in the environment
node -v # should print `v20.18.0`
# verifies the right npm version is in the environment
npm -v # should print `10.8.2`

# -------------------- Start for Environment Setup -----------------------------------

# For all sudo apt commands, if using a make, use brew install

brew install unzip                      # Install 'unzip' utility for extracting archives 

curl -fsSL https://fnm.vercel.app/install | bash
# Download and run the Fast Node Manager (fnm) installation script

source ~/.bashrc                            # Reload the shell configuration to include fnm
fnm use --install-if-missing 20             # Use or install Node.js v20 if it's not present

sudo npm install -g @jbrowse/cli                 # Install the JBrowse CLI tool globally

# -------------------- Linux Only ----------------------------------------------------
sudo apt install wget apache2               # Install 'wget' for downloads and 'apache2' for a web server (FOR LINUX / WINDOWS ONLY)
# ------------------------------------------------------------------------------------

brew install samtools htslib                # Use Homebrew to install 'samtools' and 'htslib' for genomic data

# -------------------- Linux Only ----------------------------------------------------
sudo service apache2 start                  # Start the Apache web server (FOR LINUX / WINDOWS ONLY)
# ------------------------------------------------------------------------------------

# -------------------- Mac Only ------------------------------------------------------
sudo brew services start httpd              # Start the Apache web server (FOR MAC ONLY)
# ------------------------------------------------------------------------------------

export APACHE_ROOT='/var/www/html'          # Set an environment variable to point to Apache's document root

mkdir tmp                                   # Create a temporary directory
cd tmp                                      # Change into the temporary directory

jbrowse create output_folder                
# Create a JBrowse project structure called 'output_folder'
sudo mv output_folder $APACHE_ROOT/jbrowse2 
# Move the created JBrowse folder into the Apache document root
sudo chown -R $(whoami) $APACHE_ROOT/jbrowse2
# Change ownership of the JBrowse directory so the current user can modify it