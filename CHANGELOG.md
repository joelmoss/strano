## Strano 1.0.0 (unreleased) ##

* Remote cache strategy with rsync
* Can now choose which branch to deploy from. *Joel Moss*
* Fixed default verbosity (vvv). *Joel Moss*
* Replaced Resque with the more efficient Sidekiq. *Joel Moss*
* Refactored task processing, which now logs output in real time, and handles errors much more gracefully. *Joel Moss*
* Errors loading project Capfile's are now a thing of the past, but you will still know about it. *Joel Moss*
* Upgraded to Twitter Bootstrap 2. *Joel Moss*
* Repo updating/pulling now happens via ajax, so a page reload is not necessary. *Joel Moss*