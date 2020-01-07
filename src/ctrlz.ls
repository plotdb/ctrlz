require! <[ot-json0 json0-ot-diff diff-match-patch]>
(->
  ctrlz = (opt = {}) ->
    @ <<< cur: (opt.obj or {}), idx: 0, stack: []
    @

  ctrlz.prototype = Object.create(Object.prototype) <<< do
    clear: ->
      @idx = 0
      @stack.splice 0

    reset: ({obj}) ->
      @ <<< cur: obj, idx: 0, stack: []

    update: (obj) -> @apply {obj}
    apply: ({obj, op}) ->
      if !op and obj => op = json0-ot-diff @cur, obj, diff-match-patch
      if @idx < @stack.length - 1 => @stack.splice @idx
      @stack.push op
      @cur = ot-json0.type.apply(@cur, op)
      @idx = @stack.length - 1
      return @cur

    undo: ->
      if @idx == -1 => return @cur
      op = @stack[@idx]
      @cur = ot-json0.type.apply(@cur, ot-json0.type.invert(op))
      @idx--
      return @cur

    redo: ->
      if @idx >= @stack.length - 1 => return @cur
      @idx++
      op = @stack[@idx]
      @cur = ot-json0.type.apply(@cur, op)
      return @cur

  if module? => module.exports = ctrlz
  if window? => window.ctrlz = ctrlz
)!
