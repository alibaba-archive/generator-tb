# generator-tb 

A [Yeoman](http://yeoman.io) generator for [Teambition](https://teambition.com)'s web app.


## Getting Started

### Install Yeoman

```
$ npm install -g yo
```

### Install generator-tb

To install generator-tb from npm, run:

```
$ npm install -g generator-tb
```

### Usage

Available generators:

- yo tb:view
- yo tb:model

#### Example

```
$ yo tb:view 'today/task list'

    create src/scripts/views/today/task-list.coffee
    create src/stylesheets/today/task-list.less
    create src/templates/today/task-list/basic.html
    create src/locales/today/task-list/zh.json
    create src/locales/today/task-list/en.json
```

```
$ yo tb:model 'today event'

    create src/scripts/models/today-event.coffee
    create src/scripts/collections/today-events.coffee
```

### How to dev

- [GENERATE A GENERATOR](http://yeoman.io/generators.html) from [Yeoman](http://yeoman.io)

## License

[MIT License](http://en.wikipedia.org/wiki/MIT_License)
