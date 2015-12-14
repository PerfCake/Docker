# Docker Image for PerfRepo

## How to run PerfRepo with Docker

* Start a DB using perfcake/perfrepo-postgresql image with container name "perfrepo-db":
```sh
$ docker run -d --name perfrepo-db perfcake/perfrepo-postgresql:v1.4
```

* Start PerfRepo container at a specific port (e.g. 5000) and link it with the previously created DB container (the link alias has to be "perfrepo-db").:
```sh
$ docker run -d -p 5000:8080 --name perfrepo --link perfrepo-db perfcake/perfrepo:v1.4
```

* Determine PerfRepo's port number:
```sh
$ docker ps
CONTAINER ID        IMAGE                               COMMAND                  CREATED             STATUS              PORTS                     NAMES
251863199f81        perfcake/perfrepo:v1.4              "/root/jboss-eap-6.4/"   4 seconds ago       Up 3 seconds        0.0.0.0:5000->8080/tcp   perfrepo
baaeacfd98f5        perfcake/perfrepo-postgresql:v1.4   "/usr/bin/postgres -D"   35 minutes ago      Up 35 minutes       5432/tcp                  perfrepo-db
```

* PerfRepo should be running on the port found in the previous step (e.g. 5000) `http://localhost:5000`. The default user and password are:
	* login: `perfrepouser`
	* password: `perfrepouser1.`