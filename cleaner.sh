#!/bin/bash

echo "Cleaning user-level cache and trash..."
sudo rm -rf ~/.cache/*
sudo rm -rf ~/.local/share/Trash/*
rm -rf ~/.var

echo "Cleaning Go module cache..."
sudo rm -rf ~/go/pkg/mod
#rm -rf ~/go/bin

echo "Clearing VS Code cache..."
sudo rm -rf ~/.config/Code/{Cache,CachedData,User/workspaceStorage,Service\ Worker}

echo "Clearing Firefox cache..."
sudo rm -rf ~/.mozilla/firefox/*.default-release/{cache2,thumbnails,startupCache}

echo "Cleaning journald logs (keeping only last 100MB)..."
sudo journalctl --vacuum-size=100M

echo "Cleaning pacman cache deeply..."
sudo pacman -Sc
sudo pacman -Scc
sudo pacman -Rns $(pacman -Qtdq)
paru -Rns $(paru -Qtdq)

echo "Cleaning Docker..."
#start docker if not
sudo systemctl start docker
docker system prune -af --volumes
sudo systemctl stop docker
sudo systemctl stop docker.socket

echo "Cleaning minikubes..."
minikube delete --all
minikube delete --all --purge
sudo rm -rf ~/.minikube
sudo rm -rf ~/.kube/cache

echo "System cleanup complete! You’ve saved some solid space."
