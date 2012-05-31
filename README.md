cuba-demo: a [Cuba](http://cuba.is/) demo app
=============================================

Introduction
------------
The aim of this dummy demo app is to show some simple design patterns and implementation techniques that real world [Cuba](http://cuba.is/) apps may follow.

Requirements
------------
1. [RVM](https://rvm.io//), the Ruby Version Manager.
2. Ruby (rvm install ruby-1.9.3-p125)
3. [Bundler](http://gembundler.com/) (the latest versions of RVM will install it for you automatically)

How to run the test suite
-------------------------
1. Clone the [repository](git://github.com/cristianrasch/cuba-demo.git) (git clone git://github.com/cristianrasch/cuba-demo.git)
2. cd to the project directory.
3. Run the bundle install command to have all the required libraries** installed
4. Run the rake command (rake:test it's the default task see the [Rakefile](https://github.com/cristianrasch/cuba-demo/blob/master/Rakefile) for details)

How to run the app
------------------
1. Once you have installed all the dependencies, simply run the rackup command to fire up Rack's default WEB server.
2. Point your browser to [this URL](http://localhost:9292/)

** If you don't have them installed already you will need to install SQLite 3 development files on your system. If you are using [Debian](http://www.debian.org/) or a derived OS such as [Ubuntu](http://www.ubuntu.com) you can simply install the libsqlite3-dev package.

Bonus points
------------
Besides learning about [Cuba](http://cuba.is/), you will also be learning how to integrate the following libraries into the mix:

* [Sequel](http://sequel.rubyforge.org/), the database toolkit for Ruby.
* [Mini::Test](http://www.ruby-doc.org/stdlib-1.9.3/libdoc/minitest/unit/rdoc/MiniTest.html), minimal (mostly drop-in) replacement for test-unit.
* [Capybara](https://github.com/jnicklas/capybara), an acceptance test framework for web applications.
