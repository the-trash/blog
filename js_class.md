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

Вызов new приводит к созданию объекта и установке свойств

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

console.log(author); // Author {book: "Magick of JS", fname: "John"}
```
