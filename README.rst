##############
Docker Recipes
##############

This is pretty incomplete and stitched together from different projects at
current.

Docker moves fairly fast in their updates and aren't afraid to make drastic
changes. It's very easy to read a guide that's 3 years old and may not be
current best practice or using commands that have been since renamed.

Project Structure
=================

Typically you'll put your Dockerfile(s) in the root of your project/repo
directory for smaller projects/apps.

It's common to have a Dockerfile.dev (or Dockerfile-dev) and a Dockerfile
.prod (or Dockerfile-prod). The dot or dash is just a preference convention.
I prefer dashes to simplify string searching / regexps.

For more advanced setups you may have a docker directory with
sub-directories for different components of each container

This is typically because when you use COPY / ADD commands in Docker
it's easier to use relative paths.

Example layout for typical apps:

project_directory/
-- .git/
-- logs/
-- scripts/
-- src/
-- .dockerignore
-- .gitignore
-- docker-compose.yml
-- Dockerfile
-- README.rst

Advanced example:

/project_directory/
-- .git/
-- logs/
-- docker/
   |-- apache/
      |-- apache.conf
   |-- postgres/
      |-- schema.sql
   |-- Dockerfile.dev
   |-- Dockerfile.prod
   |-- docker-compose.dev.yml
   |-- docker-compose.prod.yml
-- scripts/
-- src/
-- .dockerignore
-- .gitignore
-- README.rst

Docker basics
=============

Two main components to docker, images and containers.

``docker image``

is the root command for dealing with creating, inspecting, or removing images.

In older tutorials you'll see ``docker build``, which was moved away from
for clarity reasons, but still works as they made it an alias for docker
image build.

Create images with ``docker image build``.

Display images with ``docker image ls`` or ``docker image ls --all``.

danging images are images that are superseded by newer builds when changes are
made.

Remove dangling with ``docker image prune``.
Remove dangling and unused images with ``docker image prune --all``.
Add --force to remove confirmation prompt.

Remove an image with ``docker image rm``.

Notes

You can use ``.env`` files, and then reference them in the Dockerfile with
standard shell variable substitution ($TZ, $LANG, etc...).

Docker advanced
===============

docker compose is an advanced way to manage container setup, and is
especially useful for setting up containers that depend on other containers.

A common setup is to have one container running a database server like
Postgres and a container for the application.

docker compose uses a ``docker-compose.yml`` file.

Docker compose introduces a concept of ``services`` which is a series of
interconnected containers, and a service refers to all containers needed by
the service.

Most items in the docker-compose.yml file are not implemented until AFTER
the images are built. So environment variables and networking information
will not be in place until after they are built.

docker-compose.yml notes:

Making ``container_name`` and ``hostname`` the same simplifies networking and
other factors. Don't remember what all, google it until I fill this out more.

You can use ``.env`` files, and then reference them in the Dockerfile or
docker-compose.yml  with standard shell variable substitution ($TZ, $LANG,
etc...).
