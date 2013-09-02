# Module pattern

# The is Namespace
@The = @The || {}

# Module is Self-Invoking Anonymous Function
The.Teacher = do ->
  name = 'Ilya N. Zykin'
  say  = (speech = 'Hello World!') -> speech

  # initializer
  init = (new_name) ->
    do private_method
    @name = new_name

  # private
  private_method = ->
    console.log "Hello I'm just private method!"

  # public
  _public =
    init: init
    name: name
    say:  say

  return _public

$ ->
  # Default behaviour
  console.log The.Teacher.name
  console.log The.Teacher.say()

  # Init Module
  The.Teacher.init('Nikolay Viktorov')
  console.log The.Teacher.name

  console.log The.Teacher.say('Hello folks!')