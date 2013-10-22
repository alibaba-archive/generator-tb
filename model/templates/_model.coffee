define([
  'model'
], (
  Model
) ->
  class <%= modelName %>Model extends Model
    name: '<%= modelNameName %>'
    defaults: {
    }
)