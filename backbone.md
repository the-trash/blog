### Метод Sync

Если необходимо выполнить метод **sync** для модели Post

```coffeescript
Post = Backbone.Model.extend
  urlRoot: "/posts/"

  defaults:
    content: "Default content"
```

То необходимо или использовать вызов с полным указанием аргументов, например:

```coffeescript
post.sync("GET", post, { dataType: 'json', url: "/posts/#{post.id}" }).complete (response, status) ->
  log response
```

или переопределить этот метод в модели

```coffeescript
Post = Backbone.Model.extend
  urlRoot: "/posts/"

  defaults:
    content: "Default content"

  sync: ->
    $.ajax
      dataType: 'json'
      url: "/posts/" + @get('id')
      success: (data, status) ->
        log data
        log status
```

### Валидации

Для инициализации валидации для всех новых объектов выполним следующее

```coffeescript
Post = Backbone.Model.extend
  urlRoot: "/posts/"

  defaults:
    content: "Default content"

  initialize: (params) ->
    do @validations_init

  validations_init: ->
    @validate = ->
      return "invalid Post" if @get('id') > 3

    @on 'invalid', (model, error) ->
      log "Validation Error", model, error
```

Теперь вы видим как работают валидации каждого объекта

```coffeescript
post1 = new Post { id: 1 }
post2 = new Post { id: 2 }
post3 = new Post { id: 3 }
post4 = new Post { id: 4 }

log post1.isValid()
log post2.isValid()
log post3.isValid()
log post4.isValid()
```

И результат

```coffeescript
true
true
true
Validation Error Object { cid="c4", attributes={...} ... } invalid Post
false
```
