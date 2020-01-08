require! <[ot-json0 json0-ot-diff diff-match-patch]>
(->
  ctrlz = (opt = {}) ->
    @ <<< cur: (opt.obj or {})
    @ <<< stack: all: [], undo: [], redo: []
    @

  ctrlz.prototype = Object.create(Object.prototype) <<< do
    get: -> return @cur
    clear: -> <[all undo redo]>.map ~> @stack[it].splice 0
    reset: ({obj}) -> @cur = obj; @clear!
    update: (obj,src=true) -> @apply {obj,src}
    apply: ({obj, op, src}) ->
      src = if (src?) => src else true
      if !op and obj => op = json0-ot-diff @cur, obj, diff-match-patch
      if !op.length => return {obj: @cur, op: null}
      opo = {op, src}
      @stack.all.push opo
      if src =>
        @stack.redo.splice 0
        @stack.undo.push opo
      @cur = ot-json0.type.apply @cur, op
      return {obj: @cur, op: op}

    undo: ->
      opo = @stack.undo.pop!
      if !opo => return {obj: @cur, op: null}
      idx = @stack.all.indexOf(opo)
      op = ot-json0.type.invert opo.op
      for i from idx + 1 til @stack.all.length =>
        op = ot-json0.type.transform op, @stack.all[i].op, \left
      @cur = ot-json0.type.apply @cur, op
      opo = {op, src: true}
      @stack.all.push opo
      @stack.redo.push opo
      return {obj: @cur, op: op}

    redo: ->
      opo = @stack.redo.pop!
      if !opo => return {obj: @cur, op: null}
      idx = @stack.all.indexOf(opo)
      op = ot-json0.type.invert opo.op
      for i from idx + 1 til @stack.all.length => if !@stack.all[i].src =>
        op = ot-json0.type.transform op, @stack.all[i].op, \left
      @cur = ot-json0.type.apply @cur, op
      opo = {op, src: true}
      @stack.all.push opo
      @stack.undo.push opo
      return {obj: @cur, op: op}

  if module? => module.exports = ctrlz
  if window? => window.ctrlz = ctrlz
)!
