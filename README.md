YARD-Bundler: A YARD extension for Bundler
=========================================

NOTE: This extension is currently under development. At the current moment,
the plugin is not fully featured or compliant with all of Bundler and Gemfile features.
However, please feel free to fork the project and take a look around.

Synopsis
--------

YARD-Bundler is a YARD extension that processes Bundler Gemfile and Gemfile.lock
files and includes them in the documentation output.

Features (Example)
--------

Take a look at [example output](http://recursivegames.com/yard-bundler/file.Gemfile.html)
generated with the yard-bundler plugin.

**1. Gemfile.lock and Gemfile are parsed and [included in your file list](http://recursivegames.com/yard-bundler/file_list.html).

**2. Gemfile formatted with all dependencies shown in a [TOC](http://recursivegames.com/yard-bundler/file.Gemfile.html).

**3. Gem description contains direct links to [documentation](http://rubydoc.info) and [rubygem's description](http://rubygems.org)

**4. Gems with Github projects will have a direct link to Github.

Installation
------------

*Build the gem yourself:*

    $ git clone https://github.com/burtlo/yard-bundler
    $ cd yard-bundler
    $ gem build yard-bundler.gemspec
    $ gem install --local yard-bundler-X.X.X.gem

Usage
-----

YARD supports for automatically including gems with the prefix `yard-`
as a plugin. To enable automatic loading yard-cucumber.

1. Edit `~/.yard/config` and insert the following line:

    load_plugins: true

2. Run `yardoc`, use the rake task, or run `yard server`, as would [normally](https://github.com/lsegal/yard).

An example with the rake task:

    require 'yard'

    YARD::Rake::YardocTask.new do |t|
      t.files   = ['lib/**/*.rb' 'Gemfile.lock']
      t.options = ['--debug'] # optional arguments
    end


Possible Feature Ideas
-------------

* Show the latest gem version
* Show the number of version differences between the current and the latest

LICENSE
-------

(The MIT License)

Copyright (c) 2011 Franklin Webber

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.