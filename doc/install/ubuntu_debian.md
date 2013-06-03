Installing Strano on Debian or Ubuntu
=====================================

The following instructions will guide you through running Strano on Debian or Ubuntu Linux, using [Nginx](http://wiki.nginx.org/Main) and [Puma](http://puma.io)/

These instructions assume you will be running Strano as user `deploy`, with Strano installed to `/home/deploy/strano`. If this is not the case, edit `/etc/init.d/strano`, and `config/puma.rb`, and the Nginx configuration accordingly.

(It is probably possible with some minor tweaking to run under another web server, such as Apache, or Linux distro, such as CentOS or RHEL. If you have done so, it would be appreciated if you could provide instructions for your setup. Fork the project and submit a pull request with complete installation instructions.)


TODO
----

Document creating SSH key, adding to Github, configuring strano.yml.


Install Dependencies
--------------------

    sudo apt-get update
    sudo apt-get install redis-server nginx

(On Debian, `sudo` is not installed by default; run `apt-get install sudo` as root if necessary).


Create deploy User
------------------

Create user `deploy` for running Strano with the following command:

    sudo adduser --disabled-login --gecos 'Deploy' deploy

Since this user will be used to deploy your applications, add it to the web server group (such as `www-data`):

    sudo usermod -a -G www-data deploy


Create GitHub Application
-------------------------

Strano will use GitHub to authenticate users and to access your project source code. 

1. Log on to Github

2. For personal projects, [create a new developer application](https://github.com/settings/applications/new).

    For organization projects, go to https://github.com/organizations/MY-ORGANIZATION/settings/applications/new .

3. Enter the following:

    **Application Name:** Strano

    **Main URL:** http://strano.myserver.com/

    **Callback URL:** http://strano.myserver.com/

    Substitute the hostname you will use to access Strano. You may also serve it via HTTPS. This need not be a public server. It can be behind a firewall, with a private DNS name, if you wish.

4. Note the **Client ID** and **Client Secret**. You will need these later to configure Strano.


Install Ruby
------------

Strano requires Ruby 1.9.3. The recommended way to install Ruby is with [RVM](https://rvm.io):

    sudo su - deploy
    \curl -L https://get.rvm.io | bash -s stable --ruby=1.9.3

This will take several minutes. When in completes, install [Bundler](http://gembundler.com):

    source /home/deploy/.rvm/scripts/rvm
    gem install bundler


Install Strano
--------------

    # switch to deploy user, if necessary
    sudo su - deploy

    git clone git://github.com/joelmoss/strano.git
    cd strano

    bundle install

(If you get an error message about `debugger-linecache`, run `bundle update debugger`, then re-run `bundle install`).

Precompile Rails assets (otherwise, you'll get an error like `ActionView::Template::Error (application.css isn't precompiled):` when running Strano):

    rake assets:precompile

Create the production database. **Be sure to run this command only once, or you'll overwrite your Strano database**:

    bundle exec rake db:setup RAILS_ENV=production


Configure Strano
----------------

Strano needs a database to store its data. For now, we'll simply use Sqlite, but for production, you should switch to another database, such as MySQL or PostgreSQL.

    cp config/database.example.yml config/database.yml
    cp config/strano.example.yml config/strano.yml

Edit `config/strano.yml`, and set these values:

    public_ssh_key: MYPUBLICKEY
    github_key: <Client ID from GitHub application created earlier>
    github_secret: <Client Secret from GitHub application created earlier>


Install Init Script
-------------------

    sudo cp script/init.d/strano /etc/init.d/
    sudo chmod +x /etc/init.d/strano
    sudo update-rc.d strano defaults 21


Configurate Nginx
-----------------

Other web servers may also be used, though these instructions assume you will be running Nginx.

Create a file named `/etc/nginx/sites-enabled/strano` with the following content (substitute your web hostname for `strano.myserver.com`):

    upstream strano {
      server unix:/home/deploy/strano/tmp/sockets/strano.socket;
    }

    server {
      listen *:80 default_server;
      server_name strano.myserver.com;
      root /home/deploy/strano/public;

      access_log  /var/log/nginx/strano_access.log;
      error_log   /var/log/nginx/strano_error.log;

      location / {
        try_files $uri $uri/index.html $uri.html @strano;
      }

      location @strano {
        proxy_read_timeout 300;
        proxy_connect_timeout 300; 
        proxy_redirect     off;

        proxy_set_header   X-Forwarded-Proto $scheme;
        proxy_set_header   Host              $http_host;
        proxy_set_header   X-Real-IP         $remote_addr;

        proxy_pass http://strano;
      }
    }

Enable this Nginx site:

    cd /etc/nginx/sites-enabled/
    sudo ln -sfn ../sites-available/strano .

Reload Nginx configuration:

    sudo service nginx reload


Run Strano
----------

    sudo service strano start

Now, test the application by going to http://strano.myhost.com . You should be able to log on using your GitHub credentials, and import any of your Github projects into Strano.
