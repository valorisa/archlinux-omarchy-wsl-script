# Installation d'Arch Linux et Omarchy sous WSL2

Ce guide décrit la procédure pour installer Arch Linux officiellement sous WSL2 (Windows Subsystem for Linux), puis y configurer la distribution Omarchy avec Hyprland et ses dépendances.

---

## Prérequis

- Windows 11 avec WSL2 activé
- Connexion internet
- Droits administrateur sur Windows et dans WSL

---

## Étape 1 : Installation d'Arch Linux officielle sous WSL

1. Ouvrir PowerShell en mode administrateur.
2. Exécuter la commande suivante pour installer Arch Linux :
   ```
   wsl --install archlinux
   ```
3. Lancer Arch Linux via :
   ```
   wsl -d ArchLinux
   ```

---

## Étape 2 : Script d’installation et configuration

Vous devez exécuter un script bash qui :
- Crée un utilisateur normal avec droits sudo
- Met à jour le système
- Installe yay (gestionnaire de paquets AUR)
- Installe Hyprland, Waybar, et autres dépendances Omarchy
- Clone et configure Omarchy

---

## Utilisation du script fusionné

1. Sauvegardez le script complet (fournis dans le dossier `scripts/install-arch-omarchy.sh`) sur votre machine WSL dans Arch Linux.
2. Exécutez-le en root ou avec sudo :
   ```
   sudo bash install-arch-omarchy.sh
   ```
3. Suivez les instructions à l’écran.
4. Une fois terminé, redémarrez WSL depuis PowerShell :
   ```
   wsl --terminate ArchLinux
   wsl -d ArchLinux
   ```
5. Connectez-vous avec l’utilisateur créé, et lancez Omarchy avec :
   ```
   hyprland
   ```

---

## Support graphique

- Assurez-vous que WSLg est actif sur Windows 11.
- WSLg permet de faire tourner des applications graphiques Linux, notamment Hyprland et ses composants.

---

## Limitations connues

- Pas de système init complet : WSL ne gère pas un vrai boot Linux.
- Performances d’I/O variables, notamment sur disque NTFS (répertoire `/mnt/c`).
- Certaines fonctionnalités Wayland peuvent nécessiter des ajustements.

---

## Ressources

- [Arch Linux WSL officielle](https://wiki.archlinux.org/title/Install_Arch_Linux_on_WSL)
- [Omarchy GitHub](https://github.com/basecamp/omarchy)
- [Guide Korben - Arch Linux WSL](https://korben.info/arch-linux-officiel-wsl-windows-microsoft.html)
- [Blog Stéphane Robert - Arch Linux sous WSL2](https://blog.stephane-robert.info/post/wsl2-archlinux/)

---

## Auteur et Licence

- Script et documentation par [Valorisa].
- À usage personnel ou éducatif.
- Licence MIT.

---

Merci de votre attention et bon usage d’Omarchy sous WSL !
