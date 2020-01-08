require! <[ot-json0]>
lc = {obj: (obj = {root: ""})}
ops = 
 * {op: [si: \a, p: [\root, 0]], src: true}
 * {op: [si: \1, p: [\root, 1]], src: false}
 * {op: [si: \b, p: [\root, 2]], src: true}
 * {op: [si: \2, p: [\root, 3]], src: false}
 * {op: [si: \c, p: [\root, 4]], src: true}
 * {op: [si: \3, p: [\root, 5]], src: false}
 * {op: [si: \4, p: [\root, 2]], src: false}

for op in ops =>
  obj = ot-json0.type.apply obj, op.op
console.log JSON.stringify(obj)

ops-undo = ops.filter -> it.src
ops-redo = []

undo = ->
  op = ops-undo.pop!
  idx = ops.indexOf(op)
  o = ot-json0.type.invert op.op
  for i from idx + 1 til ops.length =>
    o = ot-json0.type.transform o, ops[i].op, \left
  lc.obj = ot-json0.type.apply lc.obj, o
  ops.push op = {op: o, src: true}
  ops-redo.push op

redo = ->
  op = ops-redo.pop!
  idx = ops.indexOf(op)
  o = ot-json0.type.invert op.op
  for i from idx + 1 til ops.length =>
    o = ot-json0.type.transform o, ops[i].op, \left
  lc.obj = ot-json0.type.apply lc.obj, o
  ops.push op = {op: o, src: true}
  ops-undo.push op

apply = (op) ->
  for o in op =>
    ops.push o
    lc.obj = ot-json0.type.apply lc.obj, o.op


undo!
console.log ">", lc.obj
undo!
console.log ">", lc.obj

redo!
console.log ">", lc.obj

apply [{op: [si: \5, p: [\root, 5]], src: false}]
console.log lc.obj

redo!
console.log ">", lc.obj

undo!
console.log ">", lc.obj
/*
undo = ot-json0.type.invert ops.2.op
undo = ot-json0.type.transform undo, ops.3.op, \left
undo = ot-json0.type.transform undo, ops.4.op, \left
undo = ot-json0.type.transform undo, ops.5.op, \left

obj = ot-json0.type.apply obj, undo
console.log obj

redo = ot-json0.type.invert undo
obj = ot-json0.type.apply obj, redo
console.log obj
*/
