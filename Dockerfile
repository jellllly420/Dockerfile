# syntax=docker/dockerfile:1
FROM ubuntu:24.04

# Switch to non-root user
# The official image of Ubuntu provides a non-root user "ubuntu". Here we use it.
ARG USERNAME=ubuntu
RUN apt update \
    && apt install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME
USER $USERNAME

# Switch to home directory
WORKDIR /home/$USERNAME

# Install common dev dependencies
RUN sudo apt upgrade -y \
    && sudo apt install -y build-essential git

# Setup SSH and GPG forwarding
# VSCode has out-of-box support for sharing local git credentials with containers.
# Check https://code.visualstudio.com/remote/advancedcontainers/sharing-git-credentials for more.
RUN sudo apt install -y gpg

# Install and configure oh-my-zsh
RUN sudo apt install -y curl zsh \
    && sudo chsh -s $(which zsh) $(whoami) \
    && zsh \
    && sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
    && git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions \
    && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting \
    && git clone https://github.com/TamCore/autoupdate-oh-my-zsh-plugins ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/autoupdate \
    && sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting autoupdate)/' ~/.zshrc

# Install Rust toolchain
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y \
    && . "$HOME/.cargo/env"

CMD [ "zsh" ]
