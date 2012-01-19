Strano
======

The Capistrano and Github backed deployment management UI.

Strano allows you to run capistrano tasks via a clean and simple web interface.
Projects are created from your Github repositories, and use the Capistrano
configuration within the repository itself. Which means you don't have to set up
Capistrano twice.

All tasks are recorded, so you can look back and see a full history of who did
what and when.


Installation
------------

- Github Key and Secret

  Create a [Github application](https://github.com/account/applications) and copy
  the generated key and secret to: `ENV['STRANO_GITHUB_KEY']` and
  `ENV['STRANO_GITHUB_SECRET']`.

- Public SSH key
  
  In order to clone repositories from Github, it requires a public SSH key be
  defined in `ENV['STRANO_PUBLIC_SSH_KEY']`.

- Repository clone location

  When creating a project in Strano, the Github repo is cloned locally to the path
  defined in `ENV['STRANO_CLONE_PATH']`. Default is vendor/repos.


Background Processing
---------------------

Background processing of task is taken care of by the Resque gem. Run the queue like this:

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