### Defered объекты в JQuery

Defered объекты -- средство отделить реализацию обработчиков (callbacks), от вызовов основной логики.

Кроме того, использование Defered объектов позволяет выстраивать обработчики в очередь, что бывает весьма полезно.

Предопределенные состояния:

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

#### Пример

Чтобы любой функции, которая ожидает отдельных параметров, передать массив значений -- используйте **Function.apply**.

Первый аргемент этой функции - контекст исполнения. Второй - массив параметров.

Это применимо к функции **$.when**, которая обычно в примерах описывается как функция принимающая набор отдельных аргументов.

```javascript
$.when(
  $.ajax("/page1.php"),
  $.ajax("/page2.php")
).done( function(a1, a2){ ... } )
```

Что бы передать этой функции массив Defered (promise) объектов, следует сделать следующее:

```coffeescript
$.when.apply($, promises_chain).done ->
  ...
```

Какие "волшебные методы есть ещё?"

```coffeescript
.call()
.apply()
.bind()
```

**Пример**

```haml
.defered_test
  = link_to 'Загрузить страны', '#', class: :countries_download
  .countries
```

```coffeescript
@compactArray = (array) -> array.filter (e) -> return e

_iata_codes = "
  MOW
  LED
  ASB
"

@countries_data = {}
@promises_chain = []
@iata_codes     = compactArray _iata_codes.split ' '

@get_iata_name = (code) ->
  $.ajax
    url: "http://suggest.kupibilet.ru/suggest.json?term=#{code}"
    dataType: 'jsonp'
    contentType: 'application/json'
    success: (data, status, response) ->
      cname = data.data[0].name.ru
      countries_data[code] = cname
      console.log code, cname

$ ->
  $('.defered_test a').click ->
    for code in iata_codes
      promises_chain.push get_iata_name(code)

    $.when.apply($, promises_chain).done ->
      names = []
      names.push(val) for key, val of countries_data
      names = names.join ', '

      $('.defered_test .countries').html(names).slideDown()
      console.log 'Loading finished!'      
```

Как вариант. Можно заранее создать массив функций с заданным контекстом и параметрами. Для этого потребуется метод **bind**.

```
promises_chain.push get_iata_name.bind(@, code)
```

И только при необходимости выполнения, пробежаться по массиву, вызвать все методы массива и вернуть набор **defered** объектов.

```coffeescript
defs = promises_chain.map (fn) -> do fn

$.when.apply($, defs).done ->
  ...
```

**Итого:**

```coffeescript
$ ->
  for code in iata_codes
    promises_chain.push get_iata_name.bind(@, code)

  $('.defered_test a').click ->
    defs = promises_chain.map (fn) -> do fn
    
    $.when.apply($, defs).done ->
      names = []
      names.push(val) for key, val of countries_data
      names = names.join ', '

      $('.defered_test .countries').html(names).slideDown()
      console.log 'Loading finished!'
```

#### Ссылки:

http://jquery.page2page.ru/index.php5/%D0%9E%D0%B1%D1%8A%D0%B5%D0%BA%D1%82_deferred

http://jquery.page2page.ru/index.php5/%D0%9E%D0%B1%D1%80%D0%B0%D0%B1%D0%BE%D1%82%D0%BA%D0%B0_%D0%B2%D1%8B%D0%BF%D0%BE%D0%BB%D0%BD%D0%B5%D0%BD%D0%B8%D1%8F_deferred


Заметки:

Логгер

```coffeescript
window.log = -> try console.log.apply(console, arguments)
```

```javascript
window.log = function() {
  try {
    return console.log.apply(console, arguments);
  } catch (_error) {}
};
```

Шаг 1

```coffeescript
for index in [0...10]
  setTimeout ->
    log index
  , 1000
```

через секунду даст 10 чисел "10". К тому момент когда выполнится код - index будет равен 10

```javascript
var index, _i;

for (index = _i = 0; _i < 10; index = ++_i) {
  setTimeout(function() {
    return log(index);
  }, 1000);
}
```

Шаг 2

```coffeescript
for index in [0...10]
  setTimeout ->
    log index
  , 1000
```

```javascript
var index, _fn, _i;

_fn = function(index) {
  return setTimeout(function() {
    return log(index);
  }, 1000);
};
for (index = _i = 0; _i < 10; index = ++_i) {
  _fn(index);
}
```

Шаг 3

```coffeescript
for index in [0...10]
  promise = do (index) ->
    dfd = new $.Deferred()
    
    setTimeout ->
      log index
      dfd.resolve()
    , 1000

    dfd.promise()
```

```javascript
var index, promise, _i;

for (index = _i = 0; _i < 10; index = ++_i) {
  promise = (function(index) {
    var dfd;
    dfd = new $.Deferred();

    setTimeout(function() {
      log(index);
      return dfd.resolve();
    }, 1000);

    return dfd.promise();
  })(index);
}
```

Шаг 4

```
promises_ary = []

for index in [0...10]
  promise = do (index) ->
    dfd = new $.Deferred()
    
    setTimeout ->
      log index
      dfd.resolve()
    , 1000

    dfd.promise()

  promises_ary.push promise 

log promises_ary
```

```
# => [obj, obj, ...]
```

```
var index, promise, promises_ary, _i;

promises_ary = [];

for (index = _i = 0; _i < 10; index = ++_i) {
  promise = (function(index) {
    var dfd;
    dfd = new $.Deferred();

    setTimeout(function() {
      log(index);
      return dfd.resolve();
    }, 1000);

    return dfd.promise();
  })(index);

  promises_ary.push(promise);
}

log(promises_ary);
```

Шаг 5

```
promises_ary = []

for index in [0...10]
  promise = do (index) ->
    dfd = new $.Deferred()
    
    setTimeout ->
      log index
      dfd.resolve()
    , 1000

    dfd.promise()

  promises_ary.push promise 

$.when.apply($, promises_ary).done ->
  log 'Promises Ary is Done'
```

Шаг 6

```
rand = (min, max) -> Math.floor(Math.random() * (max - min + 1) + min)

promises_ary = []

for index in [0...10]
  promise = do (index) ->
    dfd = new $.Deferred()
    
    setTimeout ->
      log index
      dfd.resolve()
    , rand(1, 5) * 1000

    dfd.promise()

  promises_ary.push promise 

$.when.apply($, promises_ary).done ->
  log 'Promises Ary is Done'
```

```
var index, promise, promises_ary, _i;

rand = function(min, max) {
  return Math.floor(Math.random() * (max - min + 1) + min);
};

promises_ary = [];

for (index = _i = 0; _i < 10; index = ++_i) {
  promise = (function(index) {
    var dfd;
    dfd = new $.Deferred();
    
    setTimeout(function() {
      log(index);
      return dfd.resolve();
    }, rand(1, 5) * 1000);

    return dfd.promise();
  })(index);

  promises_ary.push(promise);
}

$.when.apply($, promises_ary).done(function() {
  return log('Promises Ary is Done');
});
```