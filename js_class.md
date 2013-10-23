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

console.log(author_1 instanceof User);   // true
console.log(author_1 instanceof Author); // true

Author.prototype = new User('Alex');
author_2 = new Author;

console.log(author_1 instanceof User);   // true
console.log(author_1 instanceof Author); // false

console.log(author_2 instanceof User);   // true
console.log(author_2 instanceof Author); // true

console.log(author_1.__proto__); // User {fname: "John"}
console.log(author_2.__proto__); // User {fname: "John"}

console.log(author_1); // User {book: "Magick of JS", fname: "John"}
console.log(author_2); // User {book: "Magick of JS", fname: "John"}
```

**Вывод:** переустановка свойства **prototype** ломает определение текущего класса.
