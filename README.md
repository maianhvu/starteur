# Starteur Web Application #

This repository hosts both the Starteur Web Application and the Starteur Educators Application.
You may find the latter in the `educators` sub-domain.

### How do I get set up? ###

This application will require PostgreSQL to function correctly, so please have a local Postgres
server at the ready. For OS X, you may obtain the utility at [this website](http://postgresapp.com/).

Set up your local machine before running the application. We are using Ruby v2.1.3 specifically.
```sh
$ bundle
$ rake db:setup
```

Spring has been disabled for this repo, so if you want to preload binstubs please
install [Zeus](https://github.com/burke/zeus).

### Questions? ###

Contact [vu@reactor.sg](mailto:vu@reactor.sg).
