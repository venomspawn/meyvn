# Service for browsing and creating city events

This project is an implementation of service for test task on back-end
developer position in MEYVN. It provides base interface and supports
opertations for user sign up, user log in, events creation and events browsing.
The following technologies are used:

*   [PostgreSQL](https://www.postgresql.org/) as RDBMS;
*   [Ruby](https://www.ruby-lang.org/en/) as main programming language;
*   [Puma](https://github.com/puma/puma) as HTTP-servers;
*   [Rails](https://github.com/rails/rails) as a web-application framework;
*   [RSpec](https://github.com/rspec/rspec) for tests definitions and
    launching;
*   and also some other awesome libraries, which names can be found in `Gemfile`
    of the project.

## Usage

### Provisioning and initial setup

Although it's not required, it's highly recommended to use the project in a
virtual machine. The project provides `Vagrantfile` to automatically deploy and
provision virtual machine with use of [VirtualBox](https://www.virtualbox.org/)
and [vagrant](https://www.vagrantup.com/) tool. One can use `vagrant up` in the
root directory of the cloned project to launch virtual machine and `vagrant
ssh` to enter it after boot. The following commands should be of use in the
terminal of virtual machine:

*   `bundle install` — install required libraries used by the project;
*   `bundle exec rails db:migrate` — migrate primary database (required before
    first development or production run);
*   `bundle exec rails db:seed` — seed primary database with city records and
    topic records;
*   `RAILS_ENV=test bundle exec rails db:migrate` — migrate test database
    (required before first tests run);
*   `make debug` — launch debug console application;
*   `make test` — run tests;
*   `make run` — launch service in development mode;
*   `RAILS_ENV=production make run` — launch service in production mode.

### Interface

The service provides very simple web-interface, that can be accessed in a
web-browser by typing `localhost:8080` in its address bar after service launch.
Basically the interface consists of two parts: top header with menu buttons,
which also includes informational messages, and main form, that can be log in
form, sign up form, events index form, and event creation form.

#### User management

The service requires user authentication to access events management and
provides means to user sign up. To access log in and sign up forms, one can use
buttons on the top. To sign up another user, previous user should log out
first, and that can also be achived via the buttons of the header.

#### Events management

After proper log in, events index form is shown. It includes filters block and
events table. Also, there is event creation form, that can be accessed via the
buttons in the header.

##### Filters

Filters include city of events, topic of events, and date and time of event
start. Empty values for the two first filters mean that events in any city or
of any topic will be listed. Empty value of event start means that current date
and time is used for events selecting. Filters can be saved with the
corresponding button of the form.

##### Events table

Events table represents main information about events. It can be refreshed
after filters selection by clicking on the corresponding button. It is ordered
by event start ascending, though new events, which are sent via server side
essages, appear in the bottom of the table disregarding their start dates and
times.

#### Event creation

One can use `New Event` button in the header to access event creation form.
There will be a notification to other users currently logged in about new
event, if their filters satisfy event data. If a filter value is empty, it's
ignored.

### Server side messages

The service supports server side messages for events creation, which means
the service sends notifications about new events to other users currently
logged in, if their filters satisfy event data. (If a filter value is empty,
it's ignored.) Events creation are hooked by trigger in the database and can be
verified via the following.

1.  Log in to the service and open events index.
2.  Run another terminal, change dir to the project dir and type `vagrant ssh`
    to get another connection with the virtual machine.
3.  Execute `psql` to open database console.
4.  Execute the following commands in the console to get some data about users,
    cities, and topics:

    ```
    \pset pager off
    SELECT * FROM cities;
    SELECT * FROM topics;
    SELECT * FROM users;
    ```

5.  Choose some identifiers of a city, of a topic, and of a user from the
    listed ones. Check that saved filter values of the logged in user are empty
    or satisfy the chosen values.
6.  Execute the following command in the console to create new event record:

    ```
    INSERT INTO events (title, place, start, finish, city_id, topic_id, creator_id) VALUES ('psql event', 'psql', '2018-12-12 12:12', '2018-12-12 13:12', '<city_id>', '<topic_id>', '<user_id>');

    ```

    where `<city_id>`, `<topic_id>`, `<user_id>` are values chosen in 5.

7.  Check that an event has appeared in the events index with `psql event`
    title without refreshing the page.

## Documentation

The project uses in-code documentation in [`yard`](https://yardoc.org) format.
One can invoke `make doc` command to translate the documentation to HTML (it
will appear in `doc` directory in the project).
