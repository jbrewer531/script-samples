#!/bin/bash

# Define paths for Lightdm, LXDE menu
CONFIG_FILE="/etc/lightdm/lightdm.conf"
TARGET_DIR="/home/$user/.config/menus"
OUTPUT_FILE="$TARGET_DIR/lxde-applications.menu"

# Ensure required directories exist
mkdir -p "$TARGET_DIR" "/home/$user/Desktop"

# Remove Kiosk files
rm -f /usr/share/xsessions/Kiosk.desktop
rm -rf /home/$user/.config/lxsessions/Kiosk

# Set execution permission for lxpanel
chmod +x /usr/bin/lxpanel

# Update LightDM session
sed -i 's/user-session=Kiosk/user-session=LXDE/' "$CONFIG_FILE"

# Install LibreOffice
if ! dpkg -l | grep -q libreoffice; then
    add-apt-repository ppa:libreoffice -y
    apt update && apt install libreoffice -y
fi
#Set default browser to chrome
xdg-settings set default-web-browser google-chrome.desktop

# Function to create a desktop file for web links
create_desktop_file() {
    local name="$1"
    local url="$2"
    local desktop_file_path="/home/$user/Desktop/${name}.desktop"

    cat <<EOF > "$desktop_file_path"
[Desktop Entry]
Version=1.0
Name=$name
Comment=Open $name
Exec=xdg-open $url
Icon=web-browser
Terminal=false
Type=Application
Categories=Network;WebBrowser;
EOF

    chmod +x "$desktop_file_path"
    echo "Created: $desktop_file_path"
}

# Web links that will be added to the desktop
declare -A weblinks=(
    ["icon_name1"]="URL1"
    ["icon_name2"]="URL2"
    ["icon_name3"]="URL3"
    ["icon_name4"]="URL4"
)

# Generate web link desktop files
for name in "${!weblinks[@]}"; do
    create_desktop_file "$name" "${weblinks[$name]}"
done

# Generate LXDE applications menu structure
cat <<EOF > "$OUTPUT_FILE"
<!DOCTYPE Menu PUBLIC "-//freedesktop//DTD Menu 1.0//EN"
 "http://www.freedesktop.org/standards/menu-spec/1.0/menu.dtd">

<Menu>
    <Name>Applications</Name>
    <Directory>lxde-menu-applications.directory</Directory>
    <DefaultAppDirs/>
    <DefaultDirectoryDirs/>
    <DefaultMergeDirs/>

    <Menu>
        <Name>Debian</Name>
        <Directory>lxde-debian.directory</Directory>
        <MergeFile>debian-menu.menu</MergeFile>
    </Menu>

    <Menu>
        <Name>Accessories</Name>
        <Directory>lxde-utility.directory</Directory>
        <Include>
            <And>
                <Category>Utility</Category>
                <Not><Category>Accessibility</Category></Not>
                <Not><Category>System</Category></Not>
            </And>
        </Include>
    </Menu>

    <Menu>
        <Name>Graphics</Name>
        <Directory>lxde-graphics.directory</Directory>
        <Include>
            <And>
                <Category>Graphics</Category>
                <Not><Category>Utility</Category></Not>
            </And>
        </Include>
    </Menu>

    <Menu>
        <Name>Internet</Name>
        <Directory>lxde-network.directory</Directory>
        <Include>
            <And>
                <Category>Network</Category>
            </And>
        </Include>
    </Menu>

    <Menu>
        <Name>Multimedia</Name>
        <Directory>lxde-audio-video.directory</Directory>
        <Include>
            <And>
                <Category>AudioVideo</Category>
            </And>
        </Include>
    </Menu>

    <Menu>
        <Name>Office</Name>
        <Directory>lxde-office.directory</Directory>
        <Include>
            <And>
                <Category>Office</Category>
            </And>
        </Include>
    </Menu>

    <Layout>
        <Merge type="files"/>
        <Merge type="menus"/>
        <Separator/>
        <Menuname>DesktopSettings</Menuname>
    </Layout>
</Menu>
EOF

echo "Generated: $OUTPUT_FILE"

# Define the Printer icon file path
DESKTOP_FILE="/home/$user/Desktop/Printers.desktop"

# Create the Printers desktop entry
cat <<EOF > "$DESKTOP_FILE"
[Desktop Entry]
Type=Link
Name=Printers
Icon=printer
URL=/usr/share/applications/system-config-printer.desktop
EOF

# Makes the Printer icon executable
chmod +x "$DESKTOP_FILE"

echo "Desktop entry created at $DESKTOP_FILE"

