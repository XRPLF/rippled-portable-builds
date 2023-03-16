#!/bin/bash

# This script should only be run on a fresh system


[[ $EUID -ne 0 ]] && echo "This script must be run as root or sudo" && exit 1

if ! command -v gpg >/dev/null || ! command -v curl >/dev/null; then
  echo "Error: One or more of the required dependencies (gpg, curl) is not installed. Please install the missing dependencies and try again."
  exit 1
fi

if id -u rippled > /dev/null 2>&1; then
  echo "User rippled exists. This script can only be run on a fresh system"
  exit 1
fi


BASE_DIR=/opt/ripple

if [ -d "$BASE_DIR" ]; then
    echo "The directory $BASE_DIR already exists. Please delete and try again."
    exit 1
fi

mkdir $BASE_DIR
mkdir $BASE_DIR/bin
mkdir $BASE_DIR/etc
mkdir -p /var/log/rippled
mkdir -p /var/lib/rippled/db
mkdir $BASE_DIR/downloads

# set the repository URLs and folder path

repo_url="https://github.com/XRPLF/rippled-portable-builds/raw/main/releases"
key_url="https://github.com/XRPLF/rippled-portable-builds/raw/main/xrplf-binary-packages-public.gpg"

# fetch the list of files in the releases folder and extract the name of the latest file
latest_file=$(curl -sSL "$repo_url" | grep -Eo 'rippled-portable-[0-9]+\.[0-9]+\.[0-9]+' | sort -Vr | head -n 1)
latest_sig_file="$latest_file.sig"

echo "Downloading the public GPG key (xrplf-binary-packages-public.gpg)..."
curl -sSL -o "xrplf-binary-packages-public.gpg" "$key_url"
echo "Importing key..."
gpg --import xrplf-binary-packages-public.gpg


# download the latest file and signature file
echo "Downloading the latest file ($latest_file)..."
curl -sSL -o "$BASE_DIR/downloads/$latest_file" "$repo_url/$latest_file"

echo "Downloading the signature file ($latest_sig_file)..."
curl -sSL -o "$BASE_DIR/downloads/$latest_sig_file" "$repo_url/$latest_sig_file"

# verify the signature of the file using the public GPG key
echo "Verifying the signature of the file using the public GPG key..."
if ! gpg --verify "$latest_sig_file" "$latest_file"; then
    echo "Signature verification failed, exiting..."
    rm -rf $BASE_DIR
    rm -rf /var/log/rippled
    rm -rf /var/lib/rippled
    
    exit 1
fi

ln -snf $BASE_DIR/downloads/$latest_file $BASE_DIR/bin/rippled

echo "Downloading configuration files..."
curl -sSL -o /opt/ripple/etc/rippled.cfg https://raw.githubusercontent.com/XRPLF/rippled-portable-builds/main/bootstrap/rippled.cfg
curl -sSL -o /opt/ripple/etc/validators.txt https://raw.githubusercontent.com/XRPLF/rippled-portable-builds/main/bootstrap/validators.txt

# Create rippled user
echo "Creating user rippled..."
useradd --system --no-create-home --shell /bin/false rippled &> /dev/null
echo "Creating symlinks..."
mkdir -p /etc/opt/ripple
ln -s /opt/ripple/etc/rippled.cfg /etc/opt/ripple/rippled.cfg
ln -s /opt/ripple/etc/validators.txt /etc/opt/ripple/validators.txt
ln -s /opt/ripple/bin/rippled /usr/local/bin/rippled

chown -R rippled:rippled /opt/ripple
chown -R rippled:rippled /var/lib/rippled
chown -R rippled:rippled /var/log/rippled
chmod +x "$BASE_DIR/downloads/$latest_file"
if [[ $(systemctl) ]]; then
  curl -sSL -o /lib/systemd/system/rippled.service https://raw.githubusercontent.com/XRPLF/rippled-portable-builds/main/bootstrap/rippled.service
  systemctl daemon-reload
  systemctl enable rippled.service
  echo "Your system supports systemd. You can start rippled with.."
  echo "sudo systemctl start rippled.service"
else
  echo "Your system does not support systemd. You need to start/stop rippled manually"
fi
echo "Installation complete!"
exit 0
