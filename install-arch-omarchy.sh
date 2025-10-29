#!/bin/bash

echo "=== Début de l'installation et configuration Arch Linux + Omarchy sur WSL ==="

# Vérification de l'exécution en root ou sudo
if [ "$EUID" -ne 0 ]; then
  echo "ERREUR : Ce script doit être exécuté avec les privilèges root ou sudo."
  exit 1
fi

echo "1/ Mise à jour des paquets système..."
pacman -Syu --noconfirm || { echo "Erreur lors de la mise à jour du système"; exit 1; }

# Demande d'entrée utilisateur pour nom et mot de passe
read -rp "2/ Entrez le nom d'utilisateur à créer : " username
if id "$username" &>/dev/null; then
  echo "L'utilisateur '$username' existe déjà. Continuer avec cet utilisateur."
else
  echo "Création de l'utilisateur '$username' avec home et shell bash..."
  useradd -m -G wheel -s /bin/bash "$username" || { echo "Erreur création utilisateur"; exit 1; }
  echo "Définissez maintenant le mot de passe pour $username :"
  passwd "$username" || { echo "Erreur de définition du mot de passe"; exit 1; }
fi

echo "3/ Installation et configuration de sudo..."
pacman -S --noconfirm sudo base-devel git vim || { echo "Erreur installation paquets"; exit 1; }

echo "Décommenter la ligne '%wheel ALL=(ALL) ALL' dans /etc/sudoers pour les privilèges sudo..."
sed -i '/^# %wheel ALL=(ALL) ALL/s/^# //' /etc/sudoers

echo "4/ Configuration de l'utilisateur par défaut dans WSL (/etc/wsl.conf)..."
grep -q "default=$username" /etc/wsl.conf || echo -e "[user]\ndefault=$username" >> /etc/wsl.conf

echo "5/ Installation de yay (helper AUR) pour l'utilisateur $username..."
if ! sudo -u "$username" command -v yay &> /dev/null; then
  sudo -u "$username" bash -c "git clone https://aur.archlinux.org/yay.git /home/$username/yay"
  sudo -u "$username" bash -c "cd /home/$username/yay && makepkg -si --noconfirm"
  sudo -u "$username" rm -rf /home/$username/yay
else
  echo "yay est déjà installé pour l'utilisateur $username."
fi

echo "6/ Installation des paquets Omarchy (Hyprland, Waybar, etc.)..."
pacman -S --noconfirm hyprland waybar nwg-wrapper jack2 pavucontrol waypipe pango noto-fonts noto-fonts-emoji alacritty alsa-utils pulseaudio || {
  echo "Erreur installation paquets essentiels Omarchy"
  exit 1
}

echo "Installation des paquets AUR spécifiques Omarchy (hyprland-omakase-git, waybar-omakase-git)..."
sudo -u "$username" yay -S --noconfirm hyprland-omakase-git waybar-omakase-git || {
  echo "Erreur installation paquets AUR Omarchy"
  exit 1
}

echo "7/ Clonage et configuration des fichiers Omarchy..."
cd /home/"$username" || { echo "Impossible d'accéder au répertoire home"; exit 1; }
if [ ! -d "omarchy" ]; then
  sudo -u "$username" git clone https://github.com/basecamp/omarchy.git
else
  echo "Le dossier omarchy existe déjà, mise à jour du dépôt..."
  cd omarchy || exit 1
  sudo -u "$username" git pull
  cd ..
fi

# Copier les configs dans ~/.config
echo "Mise en place des configurations Hyprland et Waybar..."
mkdir -p /home/"$username"/.config/hypr /home/"$username"/.config/waybar
sudo -u "$username" cp -r /home/"$username"/omarchy/configs/hypr/* /home/"$username"/.config/hypr/
sudo -u "$username" cp -r /home/"$username"/omarchy/configs/waybar/* /home/"$username"/.config/waybar/

echo "8/ Configuration du lancement d'Hyprland via ~/.xinitrc..."
echo "exec hyprland" | sudo -u "$username" tee /home/"$username"/.xinitrc > /dev/null
sudo -u "$username" chmod +x /home/"$username"/.xinitrc

echo "=== Installation et configuration terminées avec succès ==="
echo ""
echo "Redémarrez WSL avec : wsl --terminate ArchLinux"
echo "Puis lancez Arch Linux : wsl -d ArchLinux"
echo "Connectez-vous avec l'utilisateur '$username' (défini par défaut)"
echo "Pour démarrer Omarchy (Hyprland), tapez simplement :"
echo "hyprland"
echo ""
echo "Note : assurez-vous que WSLg est activé pour bénéficier du support graphique."
echo "Bon usage !"

exit 0
