'use strict';
require('coffee-script');
var Updater = require('../lib/updater');
var util = require('util');
var yeoman = require('yeoman-generator');
var pluralize = require('../lib/pluralize');
var lingo = require('lingo');

var ModelGenerator = module.exports = function ModelGenerator(args, options, config) {
  // By calling `NamedBase` here, we get the argument to the subgenerator call
  // as `this.name`.
  yeoman.generators.NamedBase.apply(this, arguments);
};

util.inherits(ModelGenerator, yeoman.generators.NamedBase);

ModelGenerator.prototype.files = function files() {
  var MODEL_PATH = 'src/components/models/',
      COLLECTION_PATH = 'src/components/collections/';

  // Hidden Task Group
  this.Title = this._.titleize(this.name);
  // hidden-task-group
  this.slugModelName = this._.slugify(this.name);
  // hidden-task-groups
  this.slugCollectionName = this._.slugify(lingo.en.pluralize(this.name));
  // hiddenTaskGroup
  this.modelName = this._.camelize(this.name);
  // HiddenTaskGroupModel
  this.ModelName = this._.classify(this.name) + 'Model';
  // hiddenTaskGroups
  this.collectionName = this._.camelize(lingo.en.pluralize(this.name));
  // HiddenTaskGroupsCollection
  this.CollectionName = this._.classify(lingo.en.pluralize(this.name)) + 'Collection';

  // src/components/models/hidden-task-group
  this.modelDir = MODEL_PATH + this.slugModelName;
  // src/components/models/hidden-task-group/locales;
  this.modelLocalesDir = this.modelDir + '/locales';
  // src/components/collections/hidden-task-groups
  this.collectionDir = COLLECTION_PATH + this.slugCollectionName;
  // src/components/collections/hidden-task-groups/locales
  this.collectionLocalesDir = this.collectionDir + '/locales';

  this.mkdir(this.modelDir);
  this.mkdir(this.modelLocalesDir);
  this.mkdir(this.collectionDir);
  this.mkdir(this.collectionLocalesDir);

  this.template('model/_index.coffee', this.modelDir + '/index.coffee');
  this.template('model/locales/_en.json', this.modelLocalesDir + '/en.json');
  this.template('model/locales/_zh.json', this.modelLocalesDir + '/zh.json');
  this.template('collection/_index.coffee', this.collectionDir + '/index.coffee');
  this.template('collection/locales/_en.json', this.collectionLocalesDir + '/en.json');
  this.template('collection/locales/_zh.json', this.collectionLocalesDir + '/zh.json');

};
