(->
  mj = do
    tomd: (v) ->
      return v.str or ""
      try
        return (v.section or []).map(->it.raw).join(\\n)
      catch e
        return ""
    tojson: (v) -> 
      return {str: v}
      {
        section: v.split(/\n#/g)
          .map (d,i) -> if i => {raw: "\##d", id: i} else {raw: d, id: i}
          .filter(->it.raw.length)
      }
      
  submit = (op) ->
    if lc.doc and op => lc.doc.submitOp op

  window.ot-json0 = require("ot-json0")
  lc = {json: {}, text: ""}
  md = require("md-2-json")
  hist = new ctrlz!
  view = new ldView do
    root: document.body
    handler: do
      view: ({node}) ->
        node.innerHTML = marked lc.text
      json: ({node}) ->
        node.innerText = JSON.stringify(lc.json, null, 4)
      
    action: do
      click: do
        undo: ({node}) ->
          {obj, op} = hist.undo!
          lc.json = json = obj
          lc.text = mj.tomd json
          view.get(\text).value = lc.text
          view.render!
          submit op
        redo: ({node}) ->
          {obj, op} = hist.redo!
          lc.json = obj
          lc.text = mj.tomd lc.json
          view.get(\text).value = lc.text
          view.render!
          submit op

      input: do
        text: ({node}) ->
          try
            json = mj.tojson(lc.text = (node.value or ''))
          catch e
            console.log e
            return
          {obj, op} = hist.update(lc.json = json)
          submit op
          view.render!

  try
    json = md.parse(lc.text = (view.get(\text).value or ''))
    hist.update lc.json = json
    view.render!
  catch e

  try
    sdb = new sharedb-wrapper url: {scheme: \http, domain: \localhost:3005}
    watch = ->
      #lc.json = lc.doc.data
      #lc.text = mj.tomd lc.json
      #view.get(\text).value = lc.text
      #view.render!
    if !/share.html/.exec(window.location.href) => return
    sdb.get {id: \ctrlz-v3, watch: watch}
      .then (doc) ->
        console.log "sharedb doc prepared: ", doc

        console.log mj.tojson(lc.text)
        lc.doc = doc; watch!
        lc.json = JSON.parse(JSON.stringify(lc.doc.data))
        lc.text = mj.tomd lc.json
        view.get(\text).value = lc.text
        view.render!
        hist.reset {obj: lc.json}
        # init
        # {obj, op} = hist.update(lc.json = {str: ""}, false)
        # submit op
        doc.on \op, (op, src) ->
          if !src => hist.apply {op, src: false}
          lc.json = hist.get!
          lc.text = mj.tomd lc.json
          view.get(\text).value = lc.text
          view.render!

  catch e
    console.log e
    console.log "conenct to sharedb server failed. run in standalone mode. "
  window.lc = lc
)!
