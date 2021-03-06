#### Пример 1

Обычный вызов функции приводит к добавлению свойств текущий контекст

```javascript
function User(){
    this.fname = "John";
    return this;
}

obj = User();

console.log(obj); // obj == window
console.log(obj.fname); // John
console.log(obj.prototype); // undefined
console.log(obj.__proto__); // Window
console.log(obj instanceof Window); // true
```

#### Пример 2

Функция может выполнять роль конструктора объекта. **new MyFn** приводит к созданию нового объекта и установке свойств в данный объект.

```javascript
function User(){
    this.fname = "John";
    return this;
}

obj = new User; // new User();

console.log(obj); // User {fname: "John"} 
console.log(obj.fname); // John
console.log(obj.prototype); // undefined
console.log(obj.__proto__); // User {}
console.log(obj instanceof User); // true
```

#### Пример 3

Сделаем Автора, наследником User

```javascript
function User(){
    this.fname = "John";
    return this;
}

function Author(){
    this.book = "Magick of JS";
    return this;
}

Author.prototype = new User;
author = new Author;

console.log(author instanceof User);   // true
console.log(author instanceof Author); // true

console.log(author.prototype); // undefined
console.log(author.__proto__); // User {fname: "John"} 

console.log(author); // User {book: "Magick of JS", fname: "John"}
```

#### Пример 4

Сделаем Автора, наследником User.

Но конструктор User принимает на вход аргументы.

Попробуем поиграть с prototype

```javascript
function log(){ console.log.apply(console, arguments) }

function User(_fname){
    this.fname = _fname;
    return this;
}

function Author(){
    this.book = "Magick of JS";
    return this;
}

Author.prototype = new User('John');
author_1 = new Author;

log("=======================");
log(author_1 instanceof Author);      // true
log(author_1 instanceof User);        // true
log(User.prototype);                  // User {}
log(User.isPrototypeOf(author_1));    // false
log(User.prototype.isPrototypeOf(author_1)); // true (>>>> 1) WHY? <<<<)
log(author_1.constructor);            // User(_fname)
log(author_1.__proto__);              // User { fname="John"} 
log(Object.getPrototypeOf(author_1)); // User { fname="John"}
log(author_1.constructor.prototype);  // User {}

Author.prototype = new User('Alex');
author_2 = new Author;

log("=======================");
log(author_1 instanceof Author);      // false  (>>>> 2) WHY? <<<<)
log(author_1 instanceof User);        // true
log(User.prototype.isPrototypeOf(author_1));    // true
log(author_1.constructor);            // User(_fname)
log(author_1.__proto__);              // User { fname="John"} 
log(Object.getPrototypeOf(author_1)); // User { fname="John"}
log(author_1.constructor.prototype);  // User {}

log("=======================");
log(author_2 instanceof Author);      // true
log(author_2 instanceof User);        // true
log(User.prototype.isPrototypeOf(author_2));    // true
log(author_2.constructor);            // User(_fname)
log(author_2.__proto__);              // User { fname="Alex"}
log(Object.getPrototypeOf(author_2)); // User { fname="John"}
log(author_2.constructor.prototype);  // User {}

log("=======================");
log(author_1); // User {book: "Magick of JS", fname: "John"}
log(author_2); // User {book: "Magick of JS", fname: "Alex"}
```

* http://jsfiddle.net/p88UP/

**Вывод:** переустановка свойства **prototype** ломает определение текущего класса.

#### Работа оператора new

Приблизительно оператор new работает так:

```javascript
var x = new F();                // approximately the same as this:
x = Object.create(F.prototype); // x inherits from the prototype of F
F.call(x);                      // F is called with x as 'this'
```

* https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/new

#### Пример 4

В этом примере пока не понятно, откуда author_1 знает, что он принаделжит к Авторам

```javascript
function log(){ console.log.apply(console, arguments) }

function User(_fname){
    this.fname = _fname;
    return this;
}

function Author(){
    this.book = "Magick of JS";
    return this;
}

Author.prototype = new User('John');
author_1 = new Author;

log(author_1);              // User { book="Magick of JS", fname="John"}
log(author_1.__proto__);    // User { fname="John"}
log(author_1.constructor);  // User(_fname)

log(author_1 instanceof Author); // true

// How author_1 kowns that it's an Author? Where is property?
// Can I find it in web inspector? Or it's hidden value?
```

* Свойство prototype - обычное свойство объекта
* Атрибут prototype устанавливается в момент инициализации
* Прототип объекта созданного через new - значение свойства prototype конструктора.
* Прототип объекта созданного через Object.create(ProtoName) становится первый аргумент.
* Объекты созданные через new - обычно наследуют свойство constructor (ссылка на ф-ию конструктор которая создала объект)

#### Способы получить имя прототипа

* Object.getPrototypeOf(obj) // ECMA3
* obj.constructor.prototype
