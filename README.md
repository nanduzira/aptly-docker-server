# Aptly Docker server

## Initialization

### Setup release key

```shell
❯ /opt/aptly-scripts/keys-gen.sh "First Last" "your@email.com" "Password"
```

### Setup htpasswd

```shell
❯ ./gen-htpasswd.sh "admin" "passwd"
❯ curl -u admin:passwd http://<YOUR_HOST_FOR_APTLY>/api/version
```

## Run the server

```shell
# Start the server
❯ docker compose up -d --build

# Stop the server
❯ docker compose down --remove-orphans
```

## Create a repository

```shell
❯ aptly repo create -comment="Debian packages for <XYZ> components" --architectures="amd64" -component="main" -distribution="bionic" <REPO_NAME>

# Add deb-packages to index from `<DEBIAN_FILES_DIR>`
❯ aptly repo add <REPO_NAME> <DEBIAN_FILES_DIR>

# Publish updates
❯ aptly publish repo --component="main" --distribution="bionic" --architectures="amd64" <REPO_NAME> s3:test:
```

## Setup a client for use your repo

```shell
❯ sudo apt install apt-transport-s3 gnupg2

❯ echo "AccessKeyId = <ACCESS_KEY_ID>
SecretAccessKey = <>SECRET_ACCESS_KEY>
Region = '<AWS_REGION>'" | sudo tee /etc/apt/s3auth.conf

❯ curl -sL http://<YOUR_HOST_FOR_APTLY>/repo_signing.key | gpg2 --dearmor | sudo tee /etc/apt/trusted.gpg.d/<HOST_REPO>.gpg >/dev/null

❯ sudo apt update

```
