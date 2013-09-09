### Defered объекты в JQuery

Defered объекты -- средство отделить реализацию обработчиков (callbacks), от вызовов основной логики.

Кроме того, использование Defered объектов позволяет выстраивать обработчики в очередь, что бывает весьма полезно.

- pending
- rejected
- resolved

### Суть техники

1) В некой функции создается Defered объект.

По-умолчанию состояние у такого объекта - **pending**.

```coffeescript
asynk_fu = ->
  defer = $.Deferred()
  console.log defer.state() # => pending
```

2) В функции **asynk_fu** оформляется некий вызов (для наглядности асинхронный **setTimeout**), которая в результате выполнения должна перевести объект **defer** в состоняие **rejected** или **resolved**

```coffeescript
setTimeout ->
  defer.resolve()
, 4000
```

3) Функция **asynk_fu** должна вернуть **defer.promise()** в результате своего исполнения

```coffeescript
asynk_fu = ->
  return defer.promise()
```

4) К возвращенному функцией **asynk_fu** объекту **defer.promise()** прикрепляются обработчики.

**Итого:**

```coffeescript
$ ->
  async_fu = ->
    defer = $.Deferred()
    console.log defer.state()

    setTimeout ->
      defer.resolve()
      console.log defer.state()
    , 4000

    defer.promise()

  action = async_fu()

  action.done ->
    console.log 'Method finished'
    console.log action.state()
```

В рузультате в консоли получим следующий вывод.

```
pending
Method finished
resolved
resolved
```