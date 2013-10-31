# generator-tb

A [Yeoman](http://yeoman.io) generator for [Teambition](https://teambition.com)'s web app.


## Getting Started

### Install Yeoman

```
$ npm install -g yo
```

### Link Teambition Generator

```
$ git clone https://github.com/teambition/generator-tb.git
$ cd generator-tb
$ npm link
```

### Using the Generator

Available generators:

- yo tb
- yo tb:view
- yo tb:model

#### Example

```
$ mkdir app && cd app
$ yo tb

  create app.coffee
  create routes/index.coffee
  create views/web/layout.jade
  create views/web/development.jade
  create views/web/ga.jade
  create views/web/build.jade
  create views/web/production.jade
  create views/mobile-web/layout.jade
  create views/mobile-web/development.jade
  create views/mobile-web/ga.jade
  create views/mobile-web/build.jade
  create views/mobile-web/production.jade
  create src/apps/web/main.coffee
  create src/apps/web/router.coffee
  create src/apps/web/main.less
  create src/apps/mobile-web/main.coffee
  create src/apps/mobile-web/router.coffee
  create src/apps/mobile-web/main.less
  create src/lib/model.coffee
  create src/lib/collection.coffee
  create src/lib/view.coffee
  create src/lib/hotkey.coffee
  create src/lib/warehouse.coffee
  create src/locales/zh.json
  create src/locales/en.json
  create src/components/models/user/index.coffee
  create src/components/models/locales/en.json
  create src/components/models/locales/zh.json
  create src/components/views/hello/locales/en.json
  create src/components/views/hello/locales/zh.json
  create src/components/views/hello/templates/basic.html
  create src/components/views/hello/index.coffee
  create src/components/views/hello/style.less
  create package.json
  create bower.json
  create .editorconfig
  create .bowerrc
  create .jshintrc
```

```
$ yo tb:view 'board/stage menu'

  create src/components/views/board/stage-menu/index.coffee
  create src/components/views/board/stage-menu/style.less
  create src/components/views/board/stage-menu/locales/en.json
  create src/components/views/board/stage-menu/locales/zh.json
  create src/components/views/board/stage-menu/templates/basic.html
```

```
$ yo tb:model 'today event'

  create src/components/models/today-event/index.coffee
  create src/components/models/today-event/locales/en.json
  create src/components/models/today-event/locales/zh.json
  create src/components/collections/today-events/index.coffee
  create src/components/collections/today-events/locales/en.json
  create src/components/collections/today-events/locales/zh.json
```

### How to dev

- [GENERATE A GENERATOR](http://yeoman.io/generators.html) from [Yeoman](http://yeoman.io)

## License

[MIT License](http://en.wikipedia.org/wiki/MIT_License)
