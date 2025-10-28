Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
choco install chocolatey-core.extension -y
choco install brave --version 1.77.100 -y
choco install protonpass --version 1.29.3 -y
choco install notepadplusplus.install --version 8.7.9 -y
choco install 7zip.install -y
choco install discord.install --version 1.0.9188 -y
choco install sumatrapdf --version 3.5.2 -y
choco install spotify --version 1.2.61.443 -y
choco install vlc --version 3.0.21 -y
choco install wiztree --version 4.25.0 -y
choco install vcredist-all --version 1.0.1 -y
choco install directx --version 9.29.1974.20210222 -y
choco install steam --version 3.10.91.91241028 -y
choco install ea-app --version 13.428.0.5941 -y
choco install ubisoft-connect -y
choco install greenshot -y
