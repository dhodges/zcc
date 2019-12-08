Zendesk coding challenge.

A simple ruby command line app to search Zendesk entities.

### Install and run

To install dependencies:
```
# if you've just installed ruby (ideally v2.6.3)
# you'll need to install the bundler gem
$ gem install bundler

# then use bundler to gather any dependencies
$ bundle install
```

Thereafter, to run at any time:
```
$ bundle exec ruby app.rb
```

This app looks for three json input files (`organizations.json`, `tickets.json`, `users.json`) and assumes they exist in the root directory of this project. If you'd like to use json files from elsewhere you can specify their location on the command line:
```
$ bundle exec ruby app.rb --jsondir /tmp
```

### Usage

The target entity is entered (`organization`, `ticket` or `user`), then the field on which to search (e.g. `organization_id`). Search results are paged to screen (not shown below). 

The `TAB` key provides suggestions and completions; `help` and `quit` can be entered at any time.

![screen showing example session](https://github.com/dhodges/zcc/raw/master/screen.png)

### Testing

Rspec is used for testing, and test files exist in the `spec` directory.

To run all tests:
```
$ bundle exec rspec
```

After each full test run, test coverage will be reported in `coverage/index.html`