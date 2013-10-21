'use strict';
var util = require('util');
var yeoman = require('yeoman-generator');

var ViewGenerator = module.exports = function ViewGenerator(args, options, config) {
  // By calling `NamedBase` here, we get the argument to the subgenerator call
  // as `this.name`.
  yeoman.generators.NamedBase.apply(this, arguments);
};

util.inherits(ViewGenerator, yeoman.generators.NamedBase);

ViewGenerator.prototype.files = function files() {
  /**
  this.name                 viewName        fileName                path
  post                      Post            post.coffee             post/
  post creator              PostCreator     post-creator.coffee     post-creator/
  settings/project settings ProjectSettings project-settings.coffee setttings/
  */
  var dir = '.', templateDir,i18nDir,
      viewName,
      fileName,
      temp;

  var VIEW_PATH = 'src/scripts/views/';

  temp = this.name.split('/');
  // settings/project settings
  if (temp.length > 1) {
    this.name = temp.pop();
    dir = temp.join('/');
  }
  dir = VIEW_PATH + dir;

  temp = this.name.split(' ');
  this.fileName = fileName = this._.slugify(this.name);
  dir = dir + '/' + fileName;
  templateDir = dir + '/templates';
  i18nDir = dir + '/locales';

  this.viewName = viewName = temp.map(function (part) {
    return part.substring(0, 1).toUpperCase() + part.substring(1)
  }).join('');

  this.mkdir(dir);
  this.mkdir(templateDir);

  this.template('_view.coffee', dir + '/' + fileName + '.coffee');

  this.copy('_style.less', dir + '/' + fileName + '.less')

  this.copy('templates/_basic.html', templateDir + '/' + 'basic.html')

  this.copy('locales/zh.json', i18nDir + '/' + 'zh.json')
  this.copy('locales/zh.json', i18nDir + '/' + 'en.json')
};
