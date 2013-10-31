'use strict';
require('coffee-script');
var Updater = require('../lib/updater');
var util = require('util');
var yeoman = require('yeoman-generator');

var ViewGenerator = module.exports = function ViewGenerator(args, options, config) {
  // By calling `NamedBase` here, we get the argument to the subgenerator call
  // as `this.name`.
  yeoman.generators.NamedBase.apply(this, arguments);
};

util.inherits(ViewGenerator, yeoman.generators.NamedBase);

ViewGenerator.prototype.files = function files() {

  var temp;
  var VIEWS_PATH = 'src/components/views';

  this.dest = '';

  // board/stage/stage menu
  temp = this.name.split('/');
  if (temp.length > 1) {
    // stage menu
    this.name = temp.pop();
    // board/stage
    this.dest = temp.join('/');
  }

  // Stage Menu
  this.Title = this._.titleize(this.name);
  // stage-menu
  this.slugName = this._.slugify(this.name);
  // StageMenu
  this.ViewName = this._.classify(this.name) + 'View';
  // stageMenu
  this.viewName = this._.camelize(this.name);
  // src/components/views/board/stage/stage-menu
  this.dir = VIEWS_PATH + '/' + this.dest + '/' + this.slugName;
  // src/components/views/board/stage/stage-menu/locales
  this.localesDir = this.dir + '/locales';
  // src/components/views/board/stage/stage-menu/templates
  this.templatesDir = this.dir + '/templates';

  this.mkdir(this.dir);
  this.mkdir(this.localesDir);
  this.mkdir(this.templatesDir);

  this.template('_index.coffee', this.dir + '/index.coffee');
  this.template('_style.less', this.dir + '/style.less');
  this.template('locales/_en.json', this.localesDir + '/en.json');
  this.template('locales/_zh.json', this.localesDir + '/zh.json');
  this.template('templates/_basic.html', this.templatesDir + '/basic.html');

  Updater.updateLocales(this.localesDir);
};
