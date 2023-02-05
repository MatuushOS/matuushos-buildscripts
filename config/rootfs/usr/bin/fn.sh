full() {
  echo "Setting up Steam, Heroic as a EGL client, wine and Proton-GE through ProtonUp"
  clear
  echo "Setting up Steam"
  sudo tee /etc/apt/sources.list.d/steam.list <<'EOF'
deb [arch=amd64,i386] http://repo.steampowered.com/steam/ stable steam
deb-src [arch=amd64,i386] http://repo.steampowered.com/steam/ stable steam
EOF
sudo dpkg --add-architecture i386
sudo apt update
sudo apt install -y \
  libgl1-mesa-dri:amd64 \
  libgl1-mesa-dri:i386 \
  libgl1-mesa-glx:amd64 \
  libgl1-mesa-glx:i386 \
  steam-launcher
  clear
  echo "Setting up Heroic and Proton-GE"
  sudo apt install -y flatpak
  flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  flatpak install flathub com.heroicgameslauncher.hgl flathub net.davidotek.pupgui2 -y
  clear
  echo "Setting up Wine"
  sudo mkdir -pm755 /etc/apt/keyrings
  sudo wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
  sudo wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/jammy/winehq-jammy.sources
  sudo apt install --install-recommends winehq-stable -y
  clear
  echo "All done!"
}
steam() {
 echo "Setting up Steam"
 sudo tee /etc/apt/sources.list.d/steam.list <<'EOF'                     
 deb [arch=amd64,i386] http://repo.steampowered.com/steam/ stable steam    
 deb-src [arch=amd64,i386] http://repo.steampowered.com/steam/ stable steam
EOF
  sudo dpkg --add-architecture i386
  sudo apt update
  sudo apt install -y \ 
   libgl1-mesa-dri:amd64 \
   libgl1-mesa-dri:i386 \ 
   libgl1-mesa-glx:amd64 \
   libgl1-mesa-glx:i386 \
   steam-launcher
  echo "All done!"
}
wineproton() {
  echo "Setting up Proton-GE"
  sudo apt install -y flatpak                                                                                                                                                                                                            
  flatpak remote-add --if-not-exists --system flathub https://flathub.org/repo/flathub.flatpakrepo                                                                                                                                       
  flatpak install flathub flathub net.davidotek.pupgui2 -y                                                                                                                                                                               
  clear                                                                                                                                                                                                                                  
  echo "Setting up Wine"                                                                                                                                                                                                                 
  sudo mkdir -pm755 /etc/apt/keyrings                                                                                                                                                                                                    
  sudo wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key                                                                                                                                         
  sudo wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/jammy/winehq-jammy.sources                                                                                                                       
  sudo apt install --install-recommends winehq-stable -y                                                                                                                                                                                 
  clear                                                                                                                                                                                                                                  
  echo "All done!"                                                                                                                                                                                                                       
}
selinux_ubuntu() {
  sudo apt install selinux selinux-basics selinux-policy-default auditd
  sudo su -c 'wget -O /usr/share/initramfs-tools/scripts/init-bottom/ https://wiki.debian.org/SELinux/Setup?action=AttachFile&do=get&target=_load_selinux_policy
  update-intramfs -u
  selinux-activate
  check-selinux-installation'
}
selinux_install() {
	read -p "Do you want to install SELinux? (Y/n): " install
	if [ $install = Yy ]; then
		apt update -y
		apt install selinux selinux-basics selinux-policy-default auditd -y
		selinux-activate
	else
		echo "Not installing SELinux"
	fi
}

selinux_uninstall() {
read -p "Do you want to uninstall SELinux? (Y/n): " uninstall
if [ $uninstall = Yy ]; then
	apt remove selinux selinux-basics selinux-policy-default auditd -y
	apt autoremove -y
	update-grub
else
	echo "Keeping SELinux in place."
fi
}

firewall() {
if [ ! -f "/usr/sbin/ufw" ]; then
	read -p "Firewall is not installed. Do you want to install it now? (Y/n):" fw
	if [ $fw = Yy ]; then
		apt update
		apt install ufw -y
		ufw enable
	else
		echo "I wonder why."
	elif [ -f "/usr/sbin/ufw" ]; then
		read -p "Firewall is already installed. Do you want to uninstall it? (y/N):" why
		if [ $why = Yy ]; then
			ufw disable
			apt remove ufw
		else
			echo "Good decision."
		fi
	fi
fi
}
autoupd() {
	read -p "Do you want to enable automatic updates? (Y/n): " choice
	if [ $choice = yY ]; then
		apt update -y
		apt install -y unattended-upgrades
		systemctl enable --now unattended-upgrades
	else
		echo "You have to update your system manually."
	fi
		
}
export full
export steam
export wineproton
export selinux_{install,uninstall}
export firewall
export autoupd
