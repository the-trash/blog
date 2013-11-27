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
