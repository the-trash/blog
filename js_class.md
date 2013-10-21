```javascript
function User(){
    this.fname = "John";
    return this;
}

obj = User();

console.log(obj); // obj == window
console.log(window.fname);
```
