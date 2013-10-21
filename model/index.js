'use strict';
var util = require('util');
var yeoman = require('yeoman-generator');

var ModelGenerator = module.exports = function ModelGenerator(args, options, config) {
  // By calling `NamedBase` here, we get the argument to the subgenerator call
  // as `this.name`.
  yeoman.generators.NamedBase.apply(this, arguments);
};

util.inherits(ModelGenerator, yeoman.generators.NamedBase);

ModelGenerator.prototype.files = function files() {
  var modelName,
      fileName,
      temp

  var MODEL_PATH = 'src/scripts/models/',
      COLLECTION_PATH = 'src/scripts/collections/'
  temp = this.name.split(' ')
  this.fileName = fileName = this._.slugify(this.name)

  this.modelName = modelName = temp.map(function (part) {
    return part.substring(0, 1).toUpperCase() + part.substring(1)
  }).join('')

  this.modelPlural = fileName + 's'

  this.template('_model.coffee', MODEL_PATH + fileName + '.coffee')
  this.template('_collections.coffee', COLLECTION_PATH + fileName + 's.coffee')
};
