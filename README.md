# Starteur Web Application #

This repository hosts both the Starteur Web Application and the Starteur Educators Application.
You may find the latter in the `educators` sub-domain.

### How do I get set up? ###

This application will require PostgreSQL to function correctly, so please have a local Postgres
server at the ready. For OS X, you may obtain the utility at [this website](http://postgresapp.com/).

We are using Ruby 2.1.3 specifically. It is recommended that you use
**[rbenv](https://github.com/rbenv/rbenv)** to install a local version
of 2.1.3. The `.gitignore` has already been configured to ignore `.ruby-version`

```bash
$ rbenv install 2.1.3
$ rbenv local 2.1.3
$ ruby --version
$ # should show correct version (2.1.3)
$ gem install bundler
```

Set up your local machine before running the application.
```bash
$ bundle
$ rake db:setup
```

If you would like to run all seed files against your local database, execute:
```bash
$ rake db:seed:all
```

Spring has been disabled for this repo, so if you want to preload binstubs please
install [Zeus](https://github.com/burke/zeus).

### Questions? ###

Contact [vu@reactor.sg](mailto:vu@reactor.sg).
