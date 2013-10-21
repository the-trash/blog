### SOLID

Пять базовых принципов дизайна классов в ОО Проектировании

* **Single responsibility** - На каждый объект должна быть возложена одна единственная обязанность.
* **Open-closed** - Программные сущности должны быть открыты для расширения, но закрыты для изменения.
* **Liskov substitution** -  Подстановка. Объекты в программе могут быть заменены их наследниками без изменения свойств программы. (Контракты)
* **Interface segregation** - Разделение интерфейса. Много специализированных интерфейсов лучше, чем один универсальный.
* **Dependency inversion** - Инверсия зависимостей. Абстракции не должны зависеть от деталей. Детали должны зависеть от абстракций.

### Объектный литерал

**Объектный литерал** - это способ описания объектов, с использованием пар ключ/значение внутри  фигурных скобок.

Объектный литерал не требует инстанцирования через **new**

Объектный литерал может быть расширен путем определения нового свойства следующим способом:

**myModule.newField = value;**

```coffeescript
  user =
    fname: 'John'
    lname: 'Smith'
    voice: -> "Hello people!"

  user.dance = -> "Move to the left, Move to the right"

  log user
  log user.voice()
  log user.dance()
```

### Функцинональный литерал

Способ опрделения функции. Функция создается анонимной и сохраняется в переменной

```coffeescript
summ = (a, b) -> a + b
```

Вызов функции объявленной таким образом до её объявления вызовет ошибку. Поскольку происходит обращение к не объявленной переменной.

```
f() // Ошибка исполнения
var f = function () {}
```

При обычном определении функции мы получаем undefined

```
f() // undefined
function f(){};
```

### Constructor

Конструктор - метод устанавливающий первоначальные значения в объект при его создании.

В JS почти все является объектом, вот почему у нас есть причина задуматься о конструкторах.

Есть 3 базовых способа создать объект:

```coffeescript
newObject = {}

newObject = new Object()

newObject = Object.create(null)
```

Есть 4 базовых способа установить/получить значение полей объекта:

Через точку

```coffeescript
newObject.someKey = "Hello World"
log newObject.someKey
```

Через квадратные скобки

```coffeescript
newObject['someKey'] = "Hello World"
log newObject['someKey']
```

Посредством метода defineProperty

https://kangax.github.io/es5-compat-table

```coffeescript
Object.defineProperty newObject, "someKey",
  value: "for more control of the property's behavior"
  writable: true
  enumerable: true
  configurable: true
```

Посредством метода defineProperties

```coffeescript
Object.defineProperties newObject,   
  "someKey": 
    value: "Hello World"
    writable: true 

  "anotherKey":
    value: "Foo bar"
    writable: false
```

JS не поддерживает классов, в нем есть спеиальные функции-конструкторы, которые работают с объектами.

Простым добавлением оператора new перед именем Функции мы момжем попросить JS вызвать специальную функцию, которая инстанцирует новый объект.

Внутри конструктора **this** обозначает создаваемый объект

```coffeescript
User = (fname = 'John' , lname = 'Smith', words = 'Yo Ho Ho!') ->
  @fname = fname
  @lname = lname
  @words = words
  @voice = -> @words    
  @

u = new User
log u
log u.voice()
```

Или так:

```
User = (@fname = 'John' , @lname = 'Smith', @words = 'Yo Ho Ho!') ->
  @voice = -> @words    
  @

u = new User
log u
log u.voice()
```

Обязательно возвращать из функции **@** (this), иначе CS вернет последнее выражение определенное внутри функции. А нам потребуется именно **this**

Здесь мы видим, что реализация наследования в JS может сопровождаться определенными трудностями.

Кроме того, общие методы будут определены для каждого нового объекта. Что не очень хорошо, поскольку общая функция должна быть определена на уровне класса, а не каждого объекта.

Однако, есть ряд альтернатив, которые помогут решить эти проблемы.
  
### Модуль

Модули это неотьемлимая часть всякой сложной и надежной системы. Они позволяют аккуратно организовать код.

Модули основаны на объектных литералах.

Шаблон модуль использует возвращение объектного литерала из определеющей функции.

Шаблон модуль появлися из попытки использовать в JS понятие публичных и частных методов класса.

Шаблон очень похож на немебленно вызываемую функцию, за исключением того, что возвращается не функция а объект.

Этот шаблон широко известен с 2003 года.

```coffeescript
  User = do ->
    fname = 'John'
    lname = 'Smith'
    voice = -> "Hello people!"

    fname: fname
    lname: lname
    voice: voice
    double_voice: -> [voice(), voice()].join ' '

  log User
  log User.fname
  log User.lname
  log User.voice
  log User.double_voice()
```

Импорт зависимости

```coffeescript
  User = do (JQ = $) ->
    fname = 'John'
    lname = 'Smith'
    voice = -> "Hello people!"
    select_body = -> JQ 'body'

    fname: fname
    lname: lname
    voice: voice
    double_voice: -> [voice(), voice()].join ' '
    select_body:  -> select_body()

  log User.select_body()
```

#### Плюсы

* Предоставляет открытое API для взаимодействия
* Ограничение области видимости функций, что уменшит вероятность конликта имен.
* Защита внутреннего функционала от внешнего воздействия.
* Легкое понимание и принятие программистами с опытом ООП.
* Позволяет исключить утечку переменных в глобальную область.

#### Минусы

* Мы не можем получить доступ к приватным методам при последующем расширения модуля.
* Нет возможности создать тесты для приватных методов
* Теряем гибкость при работе с приватными методами.

#### Хитрость 

* Для различных окружений можно вернуть различный набор API
* Отладка будет проще, если называть функции API теми же именами, что используются в защищенном разделе

### "Явный" модуль

В базовом случае интерфейсные функции определяются непосредственно в возвращаемом объекте.

Как вариант можно рассмотреть паттерн, в котором в возвращаемом объекте возвращаются ссылки на приватные методы.

```coffeescript
  User = do (JQ = $) ->
    fname = 'John'
    lname = 'Smith'
    voice = -> "Hello people!"
    select_body = -> JQ 'body'
    double_voice = -> [voice(), voice()].join ' '
      
    return {
      getBody:     select_body
      doubleVoice: double_voice
    }
```

Такой вариант значительно проще для чтения понимания, однако грозит сложностями переопределения функций. Поскольку все методы, которые вы бы хотели "подправить" по сути являются приватным.

### Singlton

Singleton — порождающий шаблон, гарантирующий что в однопоточном приложении будет единственный экземпляр класса с глобальной точкой доступа.

Синглтон может быть полезен, когда в системе необходим один объект влияющий на другие компоненты системы. Не стоит злоупотреблять этим шаблоном.

Синглтон создается только в момент непосредственного использования. Без потребности ресурсов до этого момента.
Поэтому он имеет преимущество по сравнению с обычным объектом порожденным от какого-либо класса.
Кроме того, за переменной требуется следить, что бы она была создана к тому моменту, когда будет впервые вызвана.

```coffeescript
superMan = do ->
  init = ->
    getRand = -> Math.random()

    return {
      fname: "Clark"
      lname: "Kent"
      uid:   getRand()
      getRand: -> getRand()
    }

  getInstance: -> @instance ?= init()
  
log superMan.getInstance().uid
log superMan.getInstance().getRand()
```

или так:

```coffeescript
@superMan = do ->
  init = (abilities = {stell_skin: true}) ->
    getRand = -> Math.random()

    return {
      fname: "Clark"
      lname: "Kent"
      uid:   getRand()
      getRand: -> getRand()
      abilities: abilities
    }

  getInstance: (abilities) ->
    @instance ?= init(abilities)


# log superMan.getInstance().abilities
log superMan.getInstance({ laser_view: true }).abilities
```

#### Плюсы

* Контролируемый доступ к единственному экземпляру.

#### Минусы

* Нарушение контроля. Синглтон нарушает SRP (Single Responsibility Principle) — контролирует кол-во объектов
* Сложность поддержки. Трудно отследить зависимость от синглтона. Вызывается внутри методов и обычно не передается в качестве аргумента. Скрытый публичный контракт.
* Глобальное состояние. Неявная зависимость подсистем. Мы не знаем текущее состояние объекта, кто и когда его менял, и это состояние может быть вовсе не таким, как ожидается. Корректность работы с синглтоном зависит от порядка обращений к нему.
* Снижение тестируемости. Вместо синглтона нельзя подпихнуть Mock-объект. Если синглтон имеет интерфейс для изменения своего состояния, то тесты начинают зависеть друг от друга.

#### Использование

* Должен быть ровно один экземпляр некоторого класса, легко доступный всем клиентам
* Единственный экземпляр должен расширяться путем порождения подклассов, и клиентам нужно иметь возможность работать с расширенным экземпляром без модификации своего кода. (?)

### Observer

Обозреватель (субъект/сервер) контролирует список подчиненных объектов (объектов/клиентов) и уведомляет их об изменении своего состояния.

Клиенты могут подписаться на отслеживание состояний сервера и отписаться, когда им это потребуется.

Сервер обладает списком клиентов и методвами добавления и удаления клиентов
Сервер обладает методом уведомления клиентов об изменении состояния
У клиентов есть ссылка на наблюдаемый объект

```coffeescript
## COMMON
extend_obj = (obj, extension) ->
  for key of extension
    obj[key] = extension[key]

## OBSERVER LIST
@ObserverList = ->
  @observerList = []
  @

@ObserverList::Add = (obj) ->
  @observerList.push obj

@ObserverList::Empty = ->
  @observerList = []

@ObserverList::Count = ->
  @observerList.length

@ObserverList::Get = (index) ->
  @observerList[index]

@ObserverList::Insert = (obj, index) ->
  pointer = -1
  if index is 0
    @observerList.unshift obj
    pointer = index
  else if index is @observerList.length
    @observerList.push obj
    pointer = index
  pointer

@ObserverList::IndexOf = (obj, startIndex) ->
  i = startIndex
  pointer = -1
  while i < @observerList.length
    pointer = i  if @observerList[i] is obj
    i++
  pointer

@ObserverList::RemoveAt = (index) ->
  if index is 0
    @observerList.shift()
  else
    @observerList.pop() if index is ObserverList.length - 1

## SUBJECT
@Subject = ->
  @observers = new ObserverList()
  @

@Subject::AddObserver = (observer) ->
  @observers.Add observer

@Subject::RemoveObserver = (observer) ->
  @observers.RemoveAt @observers.IndexOf(observer, 0)

@Subject::Notify = (msg) ->
  observerCount = @observers.Count()
  i = 0
  while i < observerCount
    @observers.Get(i).Update msg
    i++

## Observer
@Observer = -> @
@Observer::Update = (msg) ->
  @html msg

$ =>
  # Build server
  @kontrol = $ '#kontrol'
  extend_obj(@kontrol, new Subject)

  # Build clients
  for i in [1..4]
    @watcher = $ "#watcher_#{i}"
    extend_obj(@watcher, new Observer)

    # Add client to Server 
    @kontrol.AddObserver @watcher

  # Notify clients about server changes
  @kontrol.on 'click', =>
    @kontrol.Notify('Button was clicked!')
```

### Publisher/Subscriber

Паттерн Обозреватель (Observer) похож на паттерн Издатель/Подписчик (Publisher-Subscriber) однако есть одно существенное отличие. Обсервер сам контролирует список тех, кто хочет получить он него сообщение, а паттерн Издатель-Подписчик старается сделать эти объекты не зависымими друг от друга и обеспечить канал по в потором хранится необходимая информация о произошедшем событии.

Издатель не знает, кто его слушает. Подписчики могут слушать и обрабатывать сообщения, не имея никакого отношения к самому издателю.

```coffeescript
if a is b
  publish "EVENT_NAME", data
else
  publish "EVENT2_NAME", data

subscribe "EVENT_NAME", (data) ->
  # do anything
  
subscribe "EVENT_NAME", (data) ->
  # do anything again
  
subscribe "EVENT2_NAME", (data) ->
  # do anything with event 2
```

### Mediator (посредник)

Посредник - нейтральная сторона, которая помогает в решении разногласий и конфликтов. Помогает нескольким объектам "договариваться".

Посредник используется там, где возникает слишком тесная связь между элементами системы.

Посредник способствует уменьшению связей между объектами и централизации этих связей. Так же он может помочь нам в решении задачи повторного использования кода.

Посредник, как и диспетчерская башня в аэропорту, собирает всю информацию от самолетов и управляет их поведением. Это намного более выгодно, чем предоставить самолетам общаться между собой самостоятельно.

```coffeescript
@mediator = do ->
  # Storage for topics that can be broadcast or listened to
  topics = {}
  
  # Subscribe to a topic, supply a callback to be executed
  # when that topic is broadcast to
  subscribe = (topic, fn) ->
    topics[topic] = [] unless topics[topic]
    topics[topic].push
      context:  @
      callback: fn
    @

  # Publish/broadcast an event to the rest of the application
  publish = (topic) ->
    return false unless topics[topic]
    args = undefined
    
    i    = 0
    len  = topics[topic].length
    args = Array::slice.call(arguments, 1)

    while i < len
      subscription = topics[topic][i]
      subscription.callback.apply subscription.context, args
      i++
    @

  publish:   publish
  subscribe: subscribe
  installTo: (obj) ->
    obj.subscribe = subscribe
    obj.publish   = publish

$ ->
  mediator.subscribe "alert_event", (data = {}) ->
    log "alert!", data

  mediator.publish "alert_event", {text: "Hello world!"}
  mediator.publish "alert_event", {text: "it's me"}
  mediator.publish "alert_event", {text: "YAhoo!"}
  mediator.publish "alert_event"

```

#### Плюсы

Главным преимуществом посредника является то, что он существенно снижает сложность в системах с большим кол-вом взаимосвязей. Особенно это заметно в системах с использованием связей один-ко-многим, многие-ко-многим.

#### Минусы

Главный минус в том, что в системе появляется единая точка отказа.

Появляется некоторое снижение производительности из-за дополнительного звена, через которое взаимодействуют объекты.

Из-за природы слабой связи трубно предсказать, как система будет себя вести в момент подачи широковещательного сообщения.
