# Running Legacy OpenERP with Docker

## 📋 Overview

The legacy version of OpenERP we use is no longer compatible with Ubuntu 20.04 and later, mainly due to its dependency on Python 2, which is deprecated. Instead of modifying system repositories, we can encapsulate OpenERP and its dependencies in a Docker container for easy deployment and compatibility.

## 🔧 Prerequisites

Ensure that Docker is installed on your system before proceeding.

### Install Docker Engine

Refer to the official Docker installation guide: [Docker Engine Installation](https://docs.docker.com/engine/install/). **Do not use Docker Desktop.**

Alternatively, follow these instructions for Ubuntu or Debian:

### Install Docker on Ubuntu (Alternative Method)

```bash
sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu jammy stable"
sudo apt update
sudo apt install docker-ce
```

### Install Docker on Debian (Alternative Method)

```bash
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --prienergeticacoop/openerp-energetica) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt install docker-ce
```

### Verify Installation

To check if Docker is installed correctly, run:

```bash
docker --version
```

Ensure the Docker daemon is running:

```bash
sudo systemctl status docker
```

## 🖥️ Running OpenERP Client

### Create a Shared Directory for SIPS files

```bash
mkdir -p $HOME/openerp/sips
```

### Make the Execution Script Executable

The execution script `erpclient.sh` is already included in the repository. You only need to make it executable:

```bash
chmod +x erpclient.sh
```

### Allow access to the X server

OpenERP is a GUI application that needs to access the X server. To set up access to the host If you experience issues with the application not displaying correctly, modify your SSH configuration:

```bash
sudo nano /etc/ssh/ssh_config
```

Uncomment or add the following line:

```bash
ForwardX11 yes
```

Please note that this won't work if you are using Docker Desktop.

## 🚀 Running OpenERP

To launch OpenERP, execute:

```bash
./erpclient.sh
```

## 🐋 Building the Image Manually (Optional)

If you need to build the image locally instead of using the prebuilt one, follow these steps:

1. Clone the repository containing the `Dockerfile`:
   ```bash
   git clone https://github.com/energeticacoop/openerp-docker
   cd openerp-docker
   ```
2. Build the Docker image:
   ```bash
   docker build -t energeticacoop/openerp-energetica:latest .
   ```
3. Run OpenERP using the locally built image:
   ```bash
   docker run --tty --interactive --network=host --ipc=host \
     --env DISPLAY=$DISPLAY \
     --volume $HOME/.Xauthority:/root/.Xauthority \
     --volume $HOME/.openerprc:/root/.openerprc \
     --volume $HOME/openerp/sips:/root/sips:rw \
     energeticacoop/openerp-energetica:latest
   ```

### Pushing the Image to Docker Hub (Optional)

If you want to push your locally built image to Docker Hub or another registry, follow these steps:

1. Log in to Docker Hub:
   ```bash
   docker login
   ```
2. Tag the image with your Docker Hub username and repository:
   ```bash
   docker tag energeticacoop/openerp-energetica:latest your-dockerhub-username/openerp-energetica:latest
   ```
3. Push the image to Docker Hub:
   ```bash
   docker push energeticacoop/openerp-energetica:latest
   ```
4. To pull and use the image on another machine:
   ```bash
   docker pull energeticacoop/openerp-energetica:latest
   ```

## 🐝 Add an direct access icon in Ubuntu

### 1. Create a `.desktop` file for the Application

The `.desktop` file is used to define how the application will appear in your application menu and how it will behave when launched. In this example, we will create a `.desktop` file for the OpenERP application.

Run the following command to open the `.desktop` file in a text editor:

```bash
nano $HOME/.local/share/applications/openERP.desktop
```

Inside the editor, you will define the following parameters in the `.desktop` file:

```ini
[Desktop Entry]
Type=Application
Icon=som
Name=OpenERP
Exec=/home/<user>/.openerp/erpclient.sh
Terminal=true
Hidden=false
OnlyShowIn=GNOME;
```

### 2. Move the Icon Image to the Appropriate Directory

To ensure the system can find and use the icon, move the image (`som.png`) to the appropriate icons directory:

```bash
sudo mv som.png /usr/share/icons/
```

### 4. Refresh the Application Database

To ensure the system picks up the new `.desktop` file and icon, you may need to refresh the application database. Run the following command:

```bash
update-desktop-database ~/.local/share/applications
```
