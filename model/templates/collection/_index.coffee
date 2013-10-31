define([
  'collection'
  'models/<%= slugModelName %>'
], (
  Collection
  <%= ModelName %>
) ->
  class <%= CollectionName %> extends Collection
    name: '<%= collectionName %>'
    model: <%= ModelName %>
)