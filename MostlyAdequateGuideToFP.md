## Chapter 8

### Difference between `Promise` and `Future`
* Promises are invoked instantly (constructor calls promise)

```
console.log('start');
const foo = new Promise((res, rej) => {
  console.log('promise');
  // stuff
})
console.log('end');
// start
// promise
// end
```
```
console.log('start');
const foo = new Future((res, rej) => {
  console.log('future');
  // stuff
})
console.log('end');
// start
// end
foo.get() // or foo.fork() or whatever API is
// future
```

When `foo` is instantiated, if it's a promise, the callback has already run.