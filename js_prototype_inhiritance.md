#### Наследование на прототипах в JS


```coffeescript
  class Person
    first_name:  "Ivan"
    second_name: "Ivanov"

  class Emplorer extends Person
    job: "Programmer"

  joe = new Emplorer
  
  # Emplorer {
  #   job         = "Programmer",
  #   first_name  = "Ivan",
  #   second_name = "Ivanov",
  #   constructor = Emplorer()
  # }

  log joe
  log joe.first_name
  log joe.second_name
  log joe.job
```

Вот такой простой код превращается в следующий JS:

```javascript
// Переменные и методы для реализации наследования
var _ref;

var __hasProp = {}.hasOwnProperty;

var __extends = function(child, parent) {
  for (var key in parent){
    if (__hasProp.call(parent, key)) child[key] = parent[key];
  }

  function ctor() { this.constructor = child; }
  ctor.prototype  = parent.prototype;
  child.prototype = new ctor();
  child.__super__ = parent.prototype;
  return child;
};

// Пользовательские переменные
var Emplorer, Person, joe;

Person = (function() {
  function Person() {}

  Person.prototype.first_name = "Ivan";
  Person.prototype.second_name = "Ivanov";
  return Person;
})();

Emplorer = (function(_super) {
  __extends(Emplorer, _super);

  function Emplorer() {
    _ref = Emplorer.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  Emplorer.prototype.job = "Programmer";
  return Emplorer;
})(Person);

joe = new Emplorer;
```
