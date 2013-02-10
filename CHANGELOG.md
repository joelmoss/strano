## Strano 1.0.0 (unreleased) ##

* Can restrict who can sign in to Strano using a whitelist. *@hyfn*
* Can now create non-Github repositories.  *@goodtouch*
* Remote cache strategy with rsync.  *@goodtouch*
* Can now choose which branch to deploy from. *@joelmoss*
* Fixed default verbosity (vvv). *@joelmoss*
* Replaced Resque with the more efficient Sidekiq. *@joelmoss*
* Refactored task processing, which now logs output in real time, and handles errors much more gracefully. *@joelmoss*
* Errors loading project Capfile's are now a thing of the past, but you will still know about it. *@joelmoss*
* Upgraded to Twitter Bootstrap 2. *@joelmoss*
* Repo updating/pulling now happens via ajax, so a page reload is not necessary. *@joelmoss*