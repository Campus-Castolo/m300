# Docker WordPress build

## WordPress Doccker-compose
to run the docker compose do the following:
```bash
docker-compose -f docker/docker-compose-wordpress.yaml up -d
```
> note: this will only deploy a wordpress instance WITHOUT a database to add a database to it add the following:
```yaml
services:
  db:
    # We use a mariadb image which supports both amd64 & arm64 architecture
    image: mariadb:10.6.4-focal
    # you can replace the image with any database docker image compatible with wordpress, for example make sure its supported!
    # image: mysql:8.0.27
    command: '--default-authentication-plugin=mysql_native_password'
    volumes:
      - db_data:/var/lib/mysql
    restart: always
    environment:
      - MYSQL_ROOT_PASSWORD=veryhighsecurerootpasswordanddefinetlynotunsecure
      - MYSQL_DATABASE=wp
      - MYSQL_USER=wpuser
      - MYSQL_PASSWORD=genericaahpassword
    expose:
      - 3306
      - 33060
  # continue here with the wordpress segment

  volumes: # define docker volumes acting as PV
    wp_data: # PV for wordpress like before
    db_data: # make sure to add this or else it wont have a PV
```
When following best practice its crucial to replace sensitive cleartext information e.g. password, db_name, users etc.
> note: this is crucial when publishing your dockerbuilds online especially when your published build is publicly available

to create a secret you can execute the following commands in your terminal:
```bash
echo "isnert wpuser name" | docker secret create wp_db_user &&
echo "insert genericaahpassword" | docker secret create wp_db_password &&
echo "insert wp database name" | docker secret create wp_db_name
```

then modify your `docker-compose-wordpress.yaml` file to include the secrets. Here's an example of how to do that:
```yaml
version: '3.1'

services:
  wordpress:
    image: wordpress:latest
    volumes:
      - wp_data:/var/www/html
    ports:
      - 8080:80
    restart: always
    environment:
      - WORDPRESS_DB_HOST=db
      - WORDPRESS_DB_USER_FILE=/run/secrets/wp_db_user
      - WORDPRESS_DB_PASSWORD_FILE=/run/secrets/wp_db_password
      - WORDPRESS_DB_NAME_FILE=/run/secrets/wp_db_name
    secrets:
      - wp_db_user
      - wp_db_password
      - wp_db_name

volumes:
  wp_data:

secrets:
  wp_db_user:
    external: true
  wp_db_password:
    external: true
  wp_db_name:
    external: true
```
After making these changes, you can deploy your stack using the following command:
```bash
docker stack deploy -c docker-compose-wordpress.yaml your_stack_name
```
> Note: you can only use docker secrets when using docker swarm, not in docker standalone so be sure to use swarm