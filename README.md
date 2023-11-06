# Project Testing with Ruby, Hotwire, and Kamal

Welcome to our project, which combines the power of Ruby, Hotwire, and Kamal to create a dynamic web application and streamline deployment. This repository is not just a codebase; it's a practical demonstration of how these technologies can work together effectively. Our project is inspired by the tutorial available at [Hotrails.dev](https://www.hotrails.dev/).

## Prerequisites

Before you dive into this project, make sure you have the necessary tools installed on your system:

- **Docker**: If you haven't already, you can download and install Docker from [Docker's official website](https://www.docker.com/get-started).
- **Foreman**: Foreman is crucial for process management. You can easily install it using the package manager `gem`:

   ```bash
   gem install foreman
   ```

## Execution

Follow these steps to set up and run your project:

### Installation

1. Create an `.env.dev` file in the project's root directory by copying the example file from `.env.dev.example`.

2. Build the Docker containers:

   ```bash
   docker-compose build
   ```

3. Start the containers:

   ```bash
   docker-compose up -d
   ```

4. Create the Rails database:

   ```bash
   docker-compose exec web bundle
   docker-compose exec web bundle exec rails db:create
   ```

### Running

To launch your project, use Foreman with the provided Docker Procfile:

```bash
foreman start -f Procfile.docker
```

## Deployment

To deploy your project, you'll need a virtual machine. For instance, you can rent an Ubuntu VM on [DigitalOcean](https://www.digitalocean.com/). Ensure that you can connect to it via SSH.

### Prerequisites for Ubuntu OS

#### Configure Deployment

1. Navigate to the file `config/deploy.yml` and replace `146.190.149.32` with your VM's IP address.

#### Enable Only SSH, HTTP, and HTTPS Ports

Secure your VM by opening only essential ports: 22 (SSH), 80 (HTTP), and 443 (HTTPS).

```bash
sudo ufw allow 'ssh'
sudo ufw allow 'http'
sudo ufw allow 'https'
sudo ufw enable 
```

#### Docker Installation

Install the Docker service on your VM (Kamal can self-install, but we'll create a Docker network beforehand):

```bash
sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
apt-cache policy docker-ce
```

#### Create a Docker Network for Internal Communication

Create a Docker network to facilitate internal communication between all the Docker containers:

```bash
docker network create kamal_network
```

#### Set Environment Variables

Create a `.env` file in the project's root directory based on the `.env.example` file, making sure to update values like `KAMAL_REGISTRY_PASSWORD`, `RAILS_MASTER_KEY`, and `POSTGRES_PASSWORD` with your own secure values.

#### Kamal Setup

Now, let's set up Kamal:

```bash
kamal setup
```

Kamal will configure the server and all the necessary dependencies, including Postgres, Redis, and Traefik. After running this, you should see four Docker containers running when you check with:

```bash
docker ps
```

#### Let's Encrypt Certification

To secure your project with a TLS certificate from Let's Encrypt, point your domain to your VM's IP address using an `A` record. Then, go to the `config/deploy.yml` file and modify the value of `traefik.http.routers.hotwire.rule` to match your domain name.

On the VM server, run the following commands (according to [Kamal Discussions](https://github.com/basecamp/kamal/discussions/112)):

```bash
mkdir -p /letsencrypt && touch /letsencrypt/acme.json && chmod 600 /letsencrypt/acme.json
```

Then, reboot the Traefik Docker container:

```bash
kamal traefik reboot
```

After following these steps, when you connect to your domain, you should see the TLS certification in place, just like on [Kamal's website](https://kamal.website).