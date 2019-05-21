# Taiga-Docker

A fat container with everything required to run Taiga.  
Note: This container uses Ubuntu 18.04. Every so often this will need to be updated as old versions get EOLed.

## Usage
The process of deploying this container is quite simple:
1. Install docker (of course!)
2. Create a volume for your postgres library if you want persistent data:
    ```bash
    docker volume create taiga-db
    ```
3. Edit local.py and conf.json (Taiga settings) as appropriate
4. Build and deploy the container:
    ```bash
    docker build -t taiga-full .
    docker run --name taiga-full -v taiga-db:/var/lib/postgresql/10/main -p 8001:8001 taiga-full 
    ```
5. You will now be able to access the frontend via http://localhost:8001, and the API via http://localhost:8001/api/v1/
6. (optional) Set up your choice of web server/proxy to point to port 8001 for visitors to your Taiga instance.

## Updating
In order to update to the latest version of Taiga, you will simply need to clone the latest versions of the code. You
can do this by repeating the build from step 15.
