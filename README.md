Strano
======

The Github backed Capistrano deployment management UI.

Strano allows you to run any capistrano task via a clean and simple web interface.
Simply create a project from any of your Github repositories, and Strano will use
the Capistrano configuration within the repository itself. Which means you don't
have to set up Capistrano twice, and you can still run capistrano tasks from the
command line without fear of different configurations being used, causing
conflicted deploys.

All tasks are recorded, so you can look back and see a full history of who did
what and when. I also plan on creating a Capistrano plugin, that will record all
command line task activity with Strano. Which means your task history will also
include the tasks that you ran on the command line.

Strano is in production use at ShermansTravel, but is still in active development.
So I need your help to improve and ensure the code is top quality. So I enncourage
any and all pull requests. So fork away!

![Task History](https://img.skitch.com/20120119-rk61yn6u4gt73s9kic829513py.jpg)

Installation
------------

Strano is simply a Rails app with a Resque backend for processing background jobs.
Clone the repo from [Github](https://github.com/joelmoss/strano) and run:

    bundle install
    
Then create the DB:

    bundle exec rake db:setup
    
Then start the app:

    bundle exec rails s
    
**NOTE** Strano cannot be run on Heroku, as the project repositories have to cloned
to a local directory in your app at `vendors/repos`.
    

Configuration
-------------

Strano requires that you define only three configuration variables. The fourth
(`clone_path`) is set for you, but can be overridden. You can either create a
config/strano.yml configuration file and define them in there, or you can define
them in the `ENV` variable. see `config/strano.example.yml` for an example.

- Github Key and Secret

  Create a [Github application](https://github.com/account/applications) and copy
  the generated key and secret to: `github_key` and `github_secret`.

- Public SSH key
  
  In order to clone repositories from Github, it requires a public SSH key be
  defined in `public_ssh_key`.

- Repository clone location

  When creating a project in Strano, the Github repo is cloned locally to the path
  defined in `clone_path`. Default is vendor/repos.


Background Processing
---------------------

Background processing of tasks and repo management is taken care of by [Resque](https://github.com/defunkt/resque). Run
the queue like this:

    bundle exec rake QUEUE=* resque:work
  
You can then monitor your queue at `http://YOUR-STRANO-APP/resque`


Contributing
------------

Read the [Contributing][cb] wiki page first. 

Once you've made your great commits:

1. [Fork][1] Strano
2. Create a topic branch - `git checkout -b my_branch`
3. Push to your branch - `git push origin my_branch`
4. Create a [Pull Request](http://help.github.com/pull-requests/) from your branch
5. That's it!