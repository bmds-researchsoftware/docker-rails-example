# Setting Up a Docker Development Environment for Rails


## Setup
	Clone this repository, cd into its directory, and follow the
    remaining steps.  You may wish to copy this README.md file to a
    another directory since it will be overwritten in the On Rails
    section.


## Install Docker 
	1. See https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu

	2. $ sudo apt-get install linux-image-extra-$(uname -r) linux-image-extra-virtual

	3. $ sudo apt-get install apt-transport-https  ca-certificates  curl  software-properties-common

	4. $ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

	5. $ sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu `lsb_release -cs` stable"

	6. $ sudo apt-get update

	7. This will install the lastest stable version.  In production we'll want to install a specific version.
	   - $ sudo apt-get install docker-ce

	8. Confirm that docker is working.
	   - $ sudo docker run hello-world


## Linux Post-installation
	- See https://docs.docker.com/engine/installation/linux/linux-postinstall/
	

## Install Docker Compose
	1. See https://github.com/docker/compose/releases
	
	2. $ cd /tmp
	
	3. $ curl -L https://github.com/docker/compose/releases/download/$dockerComposeVersion/docker-compose-`uname -s`-`uname -m` > docker-compose 
		where $dockerComposeVersion is the latest version as shown on https://github.com/docker/compose/releases.

	4. $ chmod 755 docker-compose

	5. $ sudo mv docker-compose /usr/local/bin

	6. $ docker-compose --version


## On Rails
	1. Generate the Rails skeleton app
	  - $ docker-compose run web rails new . --force --database=postgresql
	  - $ sudo chown -R $USER:$USER .
	  - $ docker-compose build --force-rm

	2. Overwrite config/database.yml
	  - $ mv database.yml config/

	3. Start the app
	  - $ docker-compose up --remove-orphans

	4. In another terminal create the dataase
	  - $ docker-compose run web rails db:create

	5. Point your browser to http://localhost:3000


## It Works!
	1. Notice that there are two containers running; one that contains
	the rails app, and one that contains the database.
		- $ docker container ls.

	2. Using the appropriate container id listed in the previous
	command, run a bash shell in the rails app container
		- $ docker exec -it --detach-keys="ctrl-@" RAILS_APP_CONTAINER_ID "/bin/bash".
	The "--detach-keys" flag is required to enable C-p, C-n, and C-r
	usage to work properly. In our case use
		- $ docker exec -it --detach-keys="ctrl-@" myapp-web-container "/bin/bash".

	3. Using the appropriate container id listed in the previous
	command, run a bash shell in the database container, and then
	run psql
		- $ docker exec -it --detach-keys="ctrl-@" DATABASE_CONTAINER_ID "/bin/bash".
	In our case use
		- $ docker exec -it --detach-keys="ctrl-@" myapp-db-container "/bin/bash". Then start
	psql
		- $ psql -U postgres -d myapp_development.

	4. On your host machine, use your favorite editor to change the
      rails app's source code, reload the page in browser, and view
      the change.

	5. In another terminal, cleanly stop the application
		- $ docker-compose down.

	6. To restart the app, run
	   - $ docker-compose run web rails db:create.

	7. If things go left
	   - $ sudo rm tmp/pids/server.pid

	8. Notice that the data associated with the db service is stored
	on the host machine in /data/myapp_db_volume.  This directory is
	created when the db service starts and is owned by root.

	9. Notice that volume associated with the web service is
	myapp_web_volume, and is located in
	/var/lib/docker/volumes.  To inspect the volume use
		$ docker inspect myapp_web_volume.


## Alternative Usage
	1. In emacs you can do the following
	   - M-x compile
	   - docker-compose up --no-color --remove-orphans
	
	2. You can start the web service interactively by
		- replacing the command in the docker-compose.yml file with
			command: /bin/bash
		- typing
			$ docker-compose run --rm --service-ports web
		- starting Rails from within the Docker container by typing
			$ rails s -p 3000 -b '0.0.0.0'
	If you install an editor in the container you can work inside
	the container.
	  
	  
## TO DO
	- Docker Image Registry
	- https://cloud.docker.com/


## References
	- https://docs.docker.com/compose/rails/
	- https://docs.docker.com/compose/faq/
