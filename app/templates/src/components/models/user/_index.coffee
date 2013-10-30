define([
  'model'
], (
  Model
) ->

  class UserModel extends Model
    default: {
      name: '{{__anonymous}}'
      age: 17
    }

)