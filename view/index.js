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

  var dir, viewsDir, stylesheetsDir, templatesDir, localesDir,
      viewName,
      fileName,
      temp;

  var VIEWS_PATH = 'src/scripts/views/',
      STYLESHEETS_PATH = 'src/stylesheets/',
      TEMPLATES_PATH = 'src/templates/',
      LOCALES_PATH = 'src/locales/';

  // "board/stage/stage menu"
  temp = this.name.split('/');
  if (temp.length > 1) {
    // "stage menu"
    this.name = temp.pop();
    // "board/stage"
    dir = temp.join('/');
  }

  temp = this.name.split(' ');
  // "stage-menu"
  this.fileName = fileName = this._.slugify(this.name);
  // StageMenu
  this.viewName = viewName = temp.map(function (part) {
    return part.substring(0, 1).toUpperCase() + part.substring(1)
  }).join('');
  this.viewNameName = this.viewName.substring(0, 1).toLowerCase() + this.viewName.substring(1)

  viewsDir = VIEWS_PATH + dir;
  stylesheetsDir = STYLESHEETS_PATH + dir;
  templatesDir = TEMPLATES_PATH + dir + '/' + fileName;
  localesDir = LOCALES_PATH + dir + '/' + fileName;
  this.templatesDir = dir + '/' + fileName;

  // "src/scripts/views/board/stage"
  this.mkdir(viewsDir);
  // "src/stylesheets/board/stage/stage-menu"
  this.mkdir(stylesheetsDir);
  // "src/templates/board/stage/stage-menu"
  this.mkdir(templatesDir);
  // "src/locales/board/stage/stage-menu"
  this.mkdir(localesDir);

  this.template('_view.coffee', viewsDir + '/' + fileName + '.coffee');
  this.copy('_style.less', stylesheetsDir + '/' + fileName + '.less')
  this.copy('templates/_basic.html', templatesDir + '/' + 'basic.html')
  this.copy('locales/zh.json', localesDir + '/' + 'zh.json')
  this.copy('locales/zh.json', localesDir + '/' + 'en.json')

  Updater.updateConstructors(dir + '/' + fileName);
  Updater.updateMainLess(dir + '/' + fileName);
  Updater.updateLocales(dir + '/' + fileName);
};
