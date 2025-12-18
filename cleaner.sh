#!/bin/bash
set -e

echo "Cleaning user-level cache and trash..."
rm -rf ~/.cache/*
rm -rf ~/.local/share/Trash/*
rm -rf ~/.var/app/*

echo "Cleaning Go module cache..."
rm -rf ~/go/pkg/mod

echo "Clearing VS Code cache..."
rm -rf ~/.config/Code/Cache \
       ~/.config/Code/CachedData \
       ~/.config/Code/User/workspaceStorage \
       ~/.config/Code/Service\ Worker

echo "Clearing Firefox cache..."
rm -rf ~/.mozilla/firefox/*.default-release/cache2 \
       ~/.mozilla/firefox/*.default-release/thumbnails \
       ~/.mozilla/firefox/*.default-release/startupCache

echo "Cleaning journald logs (keeping last 100MB)..."
sudo journalctl --vacuum-size=100M

echo "Cleaning pacman temp download files..."
sudo rm -f /var/cache/pacman/pkg/download-*

echo "Cleaning pacman cache (safe)..."
sudo pacman -Sc --noconfirm

echo "Removing orphan packages..."
orphans=$(pacman -Qtdq || true)
if [ -n "$orphans" ]; then
  sudo pacman -Rns $orphans --noconfirm
fi

echo "Removing AUR orphans..."
aur_orphans=$(paru -Qtdq || true)
if [ -n "$aur_orphans" ]; then
  paru -Rns $aur_orphans --noconfirm
fi

echo "Cleaning Docker..."
if systemctl is-active --quiet docker; then
  docker system prune -af --volumes
fi

echo "Cleaning minikube..."
minikube delete --all || true
rm -rf ~/.minikube ~/.kube/cache

echo "System cleanup complete!"
