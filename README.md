# [klubbdinmamma.com](https://klubbdinmamma.com)

[![Build Status](https://travis-ci.org/klubbdinmamma/klubbdinmamma.github.io.svg?branch=dev)](https://travis-ci.org/klubbdinmamma/klubbdinmamma.github.io)

## Tools

[Ruby](https://www.ruby-lang.org/en/) and [Jekyll](https://jekyllrb.com/) (required)

> Transform your plain text into static websites and blogs.

Install:

    gem install bundler
    bundle install

Start for development:

    bin/serve
    bin/rebuild

Browse to [http://localhost:4000/](http://localhost:4000/).

### List facebook albums

Install [`jq`](https://stedolan.github.io/jq/):

    brew install jq

List:

    bin/list-facebook-albums

### Update photo page with new facebook albums

1. Update the list in `_config.yml`
1. Deploy, the auto-deploy will download latest Facebook data needed

Force update of files in `_data/facebook`:

1. Rebuild the site with: `FORCE_FACEBOOK_DATA_DOWNLOAD=true bin/build`
   new `albums.json` and new `photos_*.json` files will be downloaded
1. Commit the files

### Browser auto-reloading

[Live Server](https://github.com/tapio/live-server) (optional)

> A simple development http server with live reload capability.

Install:

    npm install -g live-server

Start:

    bin/live

`bin/live` will bundle, start Jekyll and open the page in Google Chrome Canary, it will automatically reload when something is changed.

## Notes

`_sass/_variables_do_not_change.scss` is not used, it is just here as a convenience, to easily see what the exact name of a Bootstrap variable is, when we need to override it in `_sass/_colors.scss`.

## Setup

### `_config_secrets.yml`

```yaml
---
facebook:
  app_secret: secret-token-goes-here
```

## Links

* https://jekyllrb.com/docs/assets/
* https://github.com/twbs/bootstrap-sass
* https://github.com/benbalter/jekyll-bootstrap-sass
* http://markdotto.com/2014/09/25/sass-and-jekyll/
* http://blog.davepoon.net/2015/01/19/setting-up-sass-with-jekyll/
* https://github.com/jekyll/jekyll-sass-converter/tree/master/example

<!-- -->

* https://pages.github.com/versions/
* http://jekyllrb.com/docs/continuous-integration/
* http://garthdb.com/writings/i-am-a-jekyll-god/

* http://tongueroo.com/articles/how-to-use-any-jekyll-plugins-on-github-pages-with-circleci/
