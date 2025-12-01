#!/usr/bin/env bash

set -e  # Exit on error

echo "Installing Rust..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

echo "Loading Rust environment..."
source "$HOME/.cargo/env"

echo "Installing Rust CLI tools..."

# Install cargo packages
echo "Installing eza..."
cargo install eza

echo "Installing bat..."
cargo install bat

echo "Installing du-dust..."
cargo install du-dust

echo "Installing fd-find..."
cargo install fd-find

echo "Installing ripgrep..."
cargo install ripgrep

echo "Installing procs..."
cargo install procs

echo "Installing zoxide..."
cargo install zoxide

echo "Installing bottom..."
cargo install bottom

echo "Installing bandwhich..."
cargo install bandwhich

echo "Setting capabilities for bandwhich..."
sudo setcap cap_sys_ptrace,cap_dac_read_search,cap_net_raw,cap_net_admin+ep $(which bandwhich)

echo "Installing dns-doge..."
cargo install dns-doge

echo "Installing dua-cli..."
cargo install dua-cli

echo "Installing dysk..."
cargo install --locked dysk

echo "Installing macchina..."
cargo install macchina

echo "Installing topgrade..."
cargo install topgrade

echo "Installing starship..."
curl -sS https://starship.rs/install.sh | sh

echo "Installing Nerd Font..."
wget -P ~/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/BigBlueTerminal.zip \
&& cd ~/.local/share/fonts \
&& unzip BigBlueTerminal.zip \
&& rm BigBlueTerminal.zip \
&& fc-cache -fv

echo ""
echo "Adding zoxide and starship to ~/.bashrc..."
echo '' | tee -a ~/.bashrc
echo '# Zoxide initialization' | tee -a ~/.bashrc
echo 'eval "$(zoxide init bash)"' | tee -a ~/.bashrc
echo '' | tee -a ~/.bashrc
echo '# Starship initialization' | tee -a ~/.bashrc
echo 'eval "$(starship init bash)"' | tee -a ~/.bashrc
source ~/.bashrc
