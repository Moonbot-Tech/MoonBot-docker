FROM ghcr.io/linuxserver/baseimage-kasmvnc:debianbookworm

# Optional: set preferred apt mirror
# RUN sed -i 's/deb.debian.org/mirror.corbina.net/g' /etc/apt/sources.list

# Install Wine & deps
RUN apt-get update && apt-get install -y dialog xfce4 xfce4-terminal wget curl mc htop ttf-mscorefonts-installer fonts-noto unzip; sed -i 's/openbox/xfce4/' /defaults/startwm.sh
RUN dpkg --add-architecture i386; mkdir -pm755 /etc/apt/keyrings; wget -O - https://dl.winehq.org/wine-builds/winehq.key | gpg --dearmor -o /etc/apt/keyrings/winehq-archive.key -
RUN wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/bookworm/winehq-bookworm.sources && apt-get update && apt-get install -y --install-recommends winehq-stable
RUN apt-get purge -y openbox; apt-get autoremove --purge -y; apt-get clean all

# Optional: restore original mirror
# RUN sed -i 's/mirror.corbina.net/deb.debian.org/g' /etc/apt/sources.list

# Optional: su to abc
# USER abc

# Pick one: fetch payload archive or use local file
RUN wget -O /tmp/MoonBotDemo.zip "https://moon-bot.com/files/MoonBotDemo.zip";
# COPY MoonBotDemo.zip /tmp

# Install payload with run script
RUN mkdir -p /config/Desktop/MoonBot; cd /config/Desktop/MoonBot; unzip /tmp/MoonBotDemo.zip; rm -f /tmp/MoonBotDemo.zip
RUN echo "#!/bin/bash\n" > /config/Desktop/MoonBot/moonbot.sh; echo 'WINEDLLOVERRIDES="*d3d10,*d3d10_1,*d3d10core,*d3d11,*dxgi=d" wine MoonBot.exe' >> /config/Desktop/MoonBot/moonbot.sh; chmod +x /config/Desktop/MoonBot/moonbot.sh
RUN chown -R abc:abc /config/Desktop /config/.cache
