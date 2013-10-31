'use strict';
var util = require('util');
var path = require('path');
var yeoman = require('yeoman-generator');
var _ = require('underscore');

var DIRECTORIES;

DIRECTORIES = [
  'views',
  'views/web',
  'views/mobile-web',
  'routes',
  'src',
  'src/apps',
  'src/apps/web',
  'src/apps/mobile-web',
  'src/components',
  'src/components/models',
  'src/components/collections',
  'src/components/views',
  'src/locales'
];

var TbGenerator = module.exports = function TbGenerator(args, options, config) {
  yeoman.generators.Base.apply(this, arguments);

  this.on('end', function () {
    this.installDependencies({ skipInstall: options['skip-install'] });
  });

  this.pkg = JSON.parse(this.readFileAsString(path.join(__dirname, '../package.json')));
};

util.inherits(TbGenerator, yeoman.generators.Base);

TbGenerator.prototype.askFor = function askFor() {
  var cb = this.async();

  var prompts = [{
    name: 'appName',
    message: 'What do you want to call your app',
    default: this.appname
  }];

  this.prompt(prompts, function (props) {
    this.appName = props.appName;

    cb();
  }.bind(this));
};

TbGenerator.prototype.app = function app() {
  var self = this;

  _.each(DIRECTORIES, function(directory) {
    self.mkdir(directory);
  });

  this.template('_app.coffee', 'app.coffee');

  this.copy('routes/_index.coffee', 'routes/index.coffee');

  this.copy('views/_layout.jade', 'views/web/layout.jade');
  this.copy('views/_development.jade', 'views/web/development.jade');
  this.copy('views/_ga.jade', 'views/web/ga.jade');
  this.copy('views/_build.jade', 'views/web/build.jade');
  this.copy('views/_production.jade', 'views/web/production.jade');
  this.copy('views/_layout.jade', 'views/mobile-web/layout.jade');
  this.copy('views/_development.jade', 'views/mobile-web/development.jade');
  this.copy('views/_ga.jade', 'views/mobile-web/ga.jade');
  this.copy('views/_build.jade', 'views/mobile-web/build.jade');
  this.copy('views/_production.jade', 'views/mobile-web/production.jade');

  this.copy('src/apps/_main.coffee', 'src/apps/web/main.coffee');
  this.copy('src/apps/_router.coffee', 'src/apps/web/router.coffee');
  this.copy('src/apps/_main.less', 'src/apps/web/main.less');

  this.copy('src/apps/_main.coffee', 'src/apps/mobile-web/main.coffee');
  this.copy('src/apps/_router.coffee', 'src/apps/mobile-web/router.coffee');
  this.copy('src/apps/_main.less', 'src/apps/mobile-web/main.less');

  this.copy('src/lib/_model.coffee', 'src/lib/model.coffee');
  this.copy('src/lib/_collection.coffee', 'src/lib/collection.coffee');
  this.copy('src/lib/_view.coffee', 'src/lib/view.coffee');
  this.copy('src/lib/_hotkey.coffee', 'src/lib/hotkey.coffee');
  this.copy('src/lib/_warehouse.coffee', 'src/lib/warehouse.coffee');

  this.copy('src/locales/_zh.json', 'src/locales/zh.json');
  this.copy('src/locales/_en.json', 'src/locales/en.json');

  this.copy('src/components/models/user/_index.coffee', 'src/components/models/user/index.coffee');
  this.copy('src/components/models/user/locales/_en.json', 'src/components/models/user/locales/en.json');
  this.copy('src/components/models/user/locales/_zh.json', 'src/components/models/user/locales/zh.json');

  this.copy('src/components/views/hello/locales/_en.json', 'src/components/views/hello/locales/en.json');
  this.copy('src/components/views/hello/locales/_zh.json', 'src/components/views/hello/locales/zh.json');
  this.copy('src/components/views/hello/templates/_basic.html', 'src/components/views/hello/templates/basic.html');
  this.copy('src/components/views/hello/_index.coffee', 'src/components/views/hello/index.coffee');
  this.copy('src/components/views/hello/_style.less', 'src/components/views/hello/style.less');

  this.template('_package.json', 'package.json');
  this.template('_bower.json', 'bower.json');
};

TbGenerator.prototype.projectfiles = function projectfiles() {
  this.copy('editorconfig', '.editorconfig');
  this.copy('bowerrc', '.bowerrc');
  this.copy('jshintrc', '.jshintrc');
};