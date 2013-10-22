define([
  'collection'
  'models/<%= modelFileName %>'
], (
  Collection
  <%= modelName%>Model
) ->
  class <%= modelName %>Collection extends Collection
    name: '<%= collectionNameName %>'
    model: <%= modelName%>Model
)