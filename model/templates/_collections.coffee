define([
  'collection'
  'models/<%= fileName %>'
], (
  Collection
  <%= modelName%>Model
) ->
  class <%= modelName %>Collection extends Collection
    name: '<%= modelPlural %>'
    model: <%= modelName%>Model
)