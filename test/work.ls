require! <[ot-json0 ../src/ctrlz]>

apply = (ops) -> ops.map (opo, i) -> hist.apply opo
print = -> console.log JSON.stringify(hist.get!)
lc = {obj: (obj = {root: ""})}
hist = new ctrlz {obj: lc.obj}

apply [
 * {op: [si: \a, p: [\root, 0]], src: true}
 * {op: [si: \1, p: [\root, 1]], src: false}
 * {op: [si: \b, p: [\root, 2]], src: true}
 * {op: [si: \2, p: [\root, 3]], src: false}
 * {op: [si: \c, p: [\root, 4]], src: true}
 * {op: [si: \3, p: [\root, 5]], src: false}
 * {op: [si: \4, p: [\root, 2]], src: false}
]

print!
hist.undo!
print!
hist.undo!
print!
hist.redo!
print!


apply [
 * {op: [sd: \3, p: [\root, 5]], src: false}
]
print!

hist.redo!
print!

/*
hist.undo!
print!

apply [
 * {op: [sd: \4, p: [\root, 1]], src: false}
]
print!

hist.redo!
print!
*/
