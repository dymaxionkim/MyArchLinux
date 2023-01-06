# MyArchLinux

_Setting Recipe & Dotfiles_

## Set Virtualbox
* Use efi
* Boot and choose menu
```
Arch Linux install medium (x86_64, UEFI)
```

## pre-install
### Check network
```
ping google.com
```
### Make partitions & mount
```
lsblk
cfdisk
# make boot partition with 1GB & EFI System type ( /dev/sda1 )
# make root partition ( /dev/sda2 )
mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/sda2
# mounting
mount /dev/sda2 /mnt
mkdir -p /mnt/boot/efi
mount /dev/sda1 /mnt/boot
```
### etc
```
pacstrap /mnt base base-devel linux linux-firmware vim nano
genfstab -U /mnt >> /mnt/etc/fstab
cat /mnt/etc/fstab
arch-chroot /mnt
```

## root
### locale
```
ln -sf /usr/share/zoneinfo/Asia/Seoul
hwclock --systohc
mv /etc/locale.gen /etc/locale.gen.old
echo en_US.UTF-8 UTF-8 > /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf
echo LANGUAGE=en_US >> /etc/locale.conf
echo LC_ALL=C >> /etc/locale.conf
echo KEYMAP=us >> /etc/vconsole.conf
```
### hostname & root pw
```
echo "arch" > /etc/hostname
passwd
```
### bootloader
```
pacman -S grub efibootmgr dosfstools openssh os-prober mtools
exit
umount /dev/sda1
mount /dev/sda1 /mnt/boot/efi
arch-chroot /mnt
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
bootctl install
```
### arch.conf
```
blkid
# memo PARTUUID ...
echo title Arch Linux > /boot/efi/loader/entries/arch.conf
echo linux /vmlinuz-linux >> /boot/efi/loader/entries/arch.conf
echo initrd /initramfs-linux.img >> /boot/efi/loader/entries/arch.conf
echo options root=PARTUUID=... quiet loglevel=3 rw >> /boot/efi/loader/entries/arch.conf
```
### network
```
pacman -S dhcpcd networkmanager network-manager-applet
systemctl enable dhcpcd.service
systemctl enable NetworkManager.service
echo 127.0.0.1    localhost.localdomain   localhost >> /etc/hosts
echo ::1          localhost.localdomain   localhost >> /etc/hosts
echo 127.0.0.1    arch.localdomain    arch >> /etc/hosts
```
### reboot
```
exit
umount -a
reboot
```

## user : osboxes
### adduser in root
```
pacman -S sudo
adduser -m osboxes
passwd osboxes
mv /etc/sudoers /etc/sudoers.old
echo osboxes ALL=(ALL:ALL) ALL >> /etc/sudoers
exit
```
### login osboxes
```
sudo mv /etc/pacman.conf /etc/pacman.conf.old
sudo echo color >> /etc/pacman.conf
sudo pacman -S iw wpa_supplicant dialog intel-ucode git reflector lshw unzip micro figlet screenfetch
sudo pacman -S wget pulseaudio alsa-utils alsa-plugins pavucontrol pasystray xdg-user-dirs
sudo pacman -S gtop htop file-roller
sudo pacman -S xorg-server xorg-apps xorg-xinit
sudo pacman -S i3-gaps i3blocks i3lock numlockx xclip xterm alacritty feh scrot rofi firefox vlc picom
sudo pacman -S lxappearance
sudo pacman -S papirus-icon-theme arc-gtk-theme
sudo pacman -S noto-fonts-cjk
sudo pacman -Syu
reboot
startx
```

## start i3
### default terminal
```
cd ~
echo export TERMINAL=/usr/bin/alacritty >> ~/.profile
```
### yay
```
mkdir ~/git
cd git
git clone https://aur.archlinux.org/yay-git.git
chmod 777 ./yay-git
cd yay-git
makepkg -si
```
### ysy pkg (example)
```
yay -S sampler
```
## kime
```
cd
yay -S kime
sudo micro /etc/environment
# export GTK_IM_MODULE=kime
# export QT_IM_MODULE=kime
# export XMODIFIERS=@im=kime
mkdir -p ~/.config/kime
cp /usr/share/doc/kime/default_config.yaml ~/.config/kime/config.yaml
micro ~/.config/kime/config.yaml
# Change shortcuts
kime-check
```
### Font : D2Coding
```
sudo wget -O /usr/share/fonts/truetype/D2Coding.zip https://github.com/naver/d2codingfont/releases/download/VER1.3.2/D2Coding-Ver1.3.2-20180524.zip
sudo unzip /usr/share/fonts/truetype/D2Coding.zip -d /usr/share/fonts/truetype/
sudo rm /usr/share/fonts/truetype/D2Coding.zip
```
### Font : D2Coding Nerd Font
```
sudo mkdir -p /usr/share/fonts/truetype/D2CodingNerd
sudo wget -O /usr/share/fonts/truetype/D2CodingNerd/D2CodingNerd.ttf https://github.com/kelvinks/D2Coding_Nerd/raw/master/D2Coding%20v.1.3.2%20Nerd%20Font%20Complete.ttf
sudo fc-cache -f -v
```
### zsh, oh-my-zsh
```
sudo pacman -S zsh
chsh -s `which zsh`
curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
git clone https://github.com/romkatv/powerlevel10k.git $HOME/.oh-my-zsh/custom/themes/powerlevel10k
sudo rboot now
# p10k configure
```
### copy dotfiles
```
cd git
git clone https://github.com/dymaxionkim/MyArchLinux.git

mv $HOME/.zshrc $HOME/.zshrc.old
cp $HOME/git/MyArchLinux/_zshrc $HOME/.zshrc

mv $HOME/.p10k.zsh $HOME/.p10k.zsh.old
cp $HOME/git/MyArchLinux/_p10k.zsh $HOME/.p10k.zsh

mv $HOME/.config/alacritty $HOME/.config/alacritty.old
cp -r $HOME/git/MyArchLinux/_config/alacritty/ $HOME/.config/alacritty/

mv $HOME/.config/i3 $HOME/.config/i3.old
cp -r $HOME/git/MyArchLinux/_config/i3/ $HOME/.config/i3/

mv $HOME/.config/i3status $HOME/.config/i3status.old
cp -r $HOME/git/MyArchLinux/_config/i3status/ $HOME/.config/i3status/

mv $HOME/.config/kime $HOME/.config/kime.old
cp -r $HOME/git/MyArchLinux/_config/kime/ $HOME/.config/kime/

mv $HOME/.config/picom $HOME/.config/picom.old
cp -r $HOME/git/MyArchLinux/_config/picom/ $HOME/.config/picom/

mv $HOME/Pictures/Wallpaper $HOME/Pictures/Wallpaper.old
cp -r $HOME/git/MyArchLinux/Wallpaper $HOME/Pictures/

cd
reboot
```
### git
```
git config --global user.email "...@gmail.com"
git config --global user.name "..."
git config --global color.ui auto
git config --global core.editor 'micro'
git config --global credential.helper cache
git config --global push.default matching
```
