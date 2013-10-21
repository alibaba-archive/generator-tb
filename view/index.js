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
  var dir, templateDir,
      viewName,
      fileName,
      temp

  var VIEW_PATH = 'src/scripts/views/'
  temp = this.name.split(' ')
  this.fileName = fileName = this._.slugify(this.name)
  dir = VIEW_PATH + temp.join('/')
  templateDir = dir + '/template'

  this.viewName = viewName = temp.map(function (part) {
    return part.substring(0, 1).toUpperCase() + part.substring(1)
  }).join('')

  this.mkdir(dir)
  this.mkdir(templateDir)
  this.template('_view.coffee', dir + '/' + fileName + '.coffee')
  this.copy('_style.less', dir + '/' + fileName + '.less')
  this.copy('template/_basic.html', templateDir + '/' + 'basic.html')
};
