'use strict';
var util = require('util');
var path = require('path');
var yeoman = require('yeoman-generator');


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

  // have Yeoman greet the user.
  console.log(this.yeoman);

};
