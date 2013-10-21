define([
  'model'
], (
  Model
) ->
  class <%= modelName %>Model extends Model
    name: '<%= fileName %>'
    defaults: {
    }
)