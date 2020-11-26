# ctrlz

JSON Edit History Manager for Undo / Redo Functionality, powered by operational transform. Keep state and support undo for anything that can be expressed / stored by JSON!


# Install

include required js file:

```
    <script src="path-to-your-ctrlz-bundle.js"></script>
```

ctrlz uses `@plotdb/json0` as a dependency. `ctrlz.bundle.min.js` already includes it but for a separate file, use `ctrlz.mins.js` instead, and include `@plotdb/json0` separately downloaded from [its repo](https://github.com/plotdb/json0).


## Usage


```
    /* init directly in constructor */
    mananger = new ctrlz({obj: obj});

    /* or alternatively, reset anytime after initialized */
    manager.reset({obj: obj});

    /* when obj is updated */
    manager.update(obj);

    /* if you have ot to apply: */ 
    manager.apply({op: op});

    /* undo, return a undo-ed object */
    ret = manager.undo();

    /* redo, return a redo-ed object */
    ret = manager.redo();

    /* clean history */
    mananger.clear();
```


## License

MIT.
