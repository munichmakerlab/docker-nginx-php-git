# docker-nginx-php-gitautopull
Based on docker-nginx-php-git a Docker container that pulls every repo from the MunichMakerLab Organisation on Github that has the webintern Topic set.

Currently most of the repo stuff is hardcoded so there is no configuration on that at the moment.

## Configuration

### Available Configuration Parameters

The following flags are a list of all the currently supported options that can be changed by passing in the variables to docker with the -e flag.

 - **ERRORS** : Set to 1 to display PHP Errors in the browser
 - **SHORT_TAG** : Set to 1 to enable PHP SHORT_TAG
 - **TEMPLATE_NGINX_HTML** : Enable by setting to 1 search and replace templating to happen on your code
 - **HIDE_NGINX_HEADERS** : Disable by setting to 0, default behaviour is to hide nginx + php version in headers
 - **PHP_MEM_LIMIT** : Set higher PHP memory limit, default is 128 Mb
 - **PHP_POST_MAX_SIZE** : Set a larger post_max_size, default is 100 Mb
 - **PHP_UPLOAD_MAX_FILESIZE** : Set a larger upload_max_filesize, default is 100 Mb

### Templating
**NOTE: You now need to enable templates see below**
This container will automatically configure your web application if you template your code.
### Using environment variables
For example if you are using a MySQL server, and you have a config.php file where you need to set the MySQL details include $$_MYSQL_HOST_$$ style template tags.

Example config.php::
```
<?php
database_host = $$_MYSQL_HOST_$$;
database_user = $$_MYSQL_USER_$$;
database_pass = $$_MYSQL_PASS_$$
...
?>
```

To set the variables simply pass them in as environmental variables on the docker command line.

Example:
```
sudo docker run -d -e 'GIT_REPO=git@git.ngd.io:ngineered/ngineered-website.git' -e 'SSH_KEY=base64_key' -e 'TEMPLATE_NGINX_HTML=1' -e 'GIT_BRANCH=stage' -e 'MYSQL_HOST=host.x.y.z' -e 'MYSQL_USER=username' -e 'MYSQL_PASS=supper_secure_password' richarvey/nginx-php-fpm
```

This will expose the following variables that can be used to template your code.
```
MYSQL_HOST=host.x.y.z
MYSQL_USER=username
MYSQL_PASS=password
```
### Template anything
Yes ***ANYTHING***, any variable exposed by the **-e** flag lets you template your configuration files. This means you can add redis, mariaDB, memcache or anything you want to your application very easily.
## Logging and Errors
### Logging
All logs should now print out in stdout/stderr and are available via the docker logs command:
```
docker logs <CONTAINER_NAME>
```

## Thanks to
* [ngineered/nginx-php-fpm](https://github.com/ngineered/nginx-php-fpm) - Base Docker image and Git push/pull functionalities


