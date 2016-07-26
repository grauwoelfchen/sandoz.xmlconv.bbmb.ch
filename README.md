# sandoz.xmlconv.bbmb.ch

The xml converter files for Sandoz Switzerland.

A graphical overview:

![sandozxmlconv](https://raw.githubusercontent.com/zdavatz/sandoz.xmlconv.bbmb.ch/master/sandozxmlconv.jpeg)

## Repository

https://github.com/zdavatz/sandoz.xmlconv.bbmb.ch

## Requirements

* xmlconv
* sbsm
* odba
* soap4r
* yus (runtime)

## Install

```bash
$ git clone https://github.com/zdavatz/sandoz.xmlconv.bbmb.ch.git
$ mkdir -p log var/output
```

## Setup

* bundle install
* create and adapt etc/polling.yml
* create and adapt etc/config.yml
* integrate it with apache mod_ruby
* setup yus (authentication) server

```bash
# xmlconvd
$ bundle exec xmlconvd config=/path/to/etc/config.yml

# yusd
$ bundle exec yusd config=/path/to/etc/yus.yml
```

## Testing

```bash
# feature test using watir (rspec)
$ bundle exec rake spec

# unit-test and integration test (minitest)
$ bundle exec rake test
```

## Developers

* Zeno R.R. Davatz
* Masaomi Hatakeyama
* Hannes Wyss (up to Version 1.0.0)
* Niklaus Giger (ported to Ruby 2.3)

## License

* GPLv2
