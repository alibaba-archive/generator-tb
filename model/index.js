'use strict';
var util = require('util');
var yeoman = require('yeoman-generator');
var pluralize = require('../lib/pluralize');

var ModelGenerator = module.exports = function ModelGenerator(args, options, config) {
  // By calling `NamedBase` here, we get the argument to the subgenerator call
  // as `this.name`.
  yeoman.generators.NamedBase.apply(this, arguments);
};

util.inherits(ModelGenerator, yeoman.generators.NamedBase);

ModelGenerator.prototype.files = function files() {
  var temp;

  var MODEL_PATH = 'src/scripts/models/',
      COLLECTION_PATH = 'src/scripts/collections/';
  // hidden task group
  // [hidden, task, group]
  temp = this.name.split(' ');
  this.modelFileName = this._.slugify(this.name);
  this.modelName = temp.map(function (part) {
    return part.substring(0, 1).toUpperCase() + part.substring(1)
  }).join('');
  this.modelNameName = this.modelName.substring(0, 1).toLowerCase() + this.modelName.substring(1)

  temp[temp.length - 1] = pluralize(temp[temp.length - 1]);
  this.collectionFileName = temp.join('-');
  this.collectionName = temp.map(function (part) {
    return part.substring(0, 1).toUpperCase() + part.substring(1)
  }).join('');
  this.collectionNameName = this.collectionName.substring(0, 1).toLowerCase() + this.collectionName.substring(1)

  this.template('_model.coffee', MODEL_PATH + this.modelFileName + '.coffee');
  this.template('_collections.coffee', COLLECTION_PATH + this.collectionFileName + '.coffee');
};
