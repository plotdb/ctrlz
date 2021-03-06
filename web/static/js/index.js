(function(){
  var mj, submit, lc, md, hist, view, json, e, sdb, watch;
  mj = {
    tomd: function(v){
      var e;
      return v.str || "";
      try {
        return (v.section || []).map(function(it){
          return it.raw;
        }).join('\n');
      } catch (e$) {
        e = e$;
        return "";
      }
    },
    tojson: function(v){
      return {
        str: v
      };
      return {
        section: v.split(/\n#/g).map(function(d, i){
          if (i) {
            return {
              raw: "#" + d,
              id: i
            };
          } else {
            return {
              raw: d,
              id: i
            };
          }
        }).filter(function(it){
          return it.raw.length;
        })
      };
    }
  };
  submit = function(op){
    if (lc.doc && op) {
      return lc.doc.submitOp(op);
    }
  };
  lc = {
    json: {},
    text: ""
  };
  md = require("md-2-json");
  hist = new ctrlz();
  view = new ldView({
    root: document.body,
    handler: {
      view: function(arg$){
        var node;
        node = arg$.node;
        return node.innerHTML = marked(lc.text);
      },
      json: function(arg$){
        var node;
        node = arg$.node;
        return node.innerText = JSON.stringify(lc.json, null, 4);
      }
    },
    action: {
      click: {
        undo: function(arg$){
          var node, ref$, obj, op, json;
          node = arg$.node;
          ref$ = hist.undo(), obj = ref$.obj, op = ref$.op;
          lc.json = json = obj;
          lc.text = mj.tomd(json);
          view.get('text').value = lc.text;
          view.render();
          return submit(op);
        },
        redo: function(arg$){
          var node, ref$, obj, op;
          node = arg$.node;
          ref$ = hist.redo(), obj = ref$.obj, op = ref$.op;
          lc.json = obj;
          lc.text = mj.tomd(lc.json);
          view.get('text').value = lc.text;
          view.render();
          return submit(op);
        }
      },
      input: {
        text: function(arg$){
          var node, json, e, ref$, obj, op;
          node = arg$.node;
          try {
            json = mj.tojson(lc.text = node.value || '');
          } catch (e$) {
            e = e$;
            console.log(e);
            return;
          }
          ref$ = hist.update(lc.json = json), obj = ref$.obj, op = ref$.op;
          submit(op);
          return view.render();
        }
      }
    }
  });
  try {
    json = md.parse(lc.text = view.get('text').value || '');
    hist.update(lc.json = json);
    view.render();
  } catch (e$) {
    e = e$;
  }
  try {
    sdb = new sharedbWrapper({
      url: {
        scheme: 'http',
        domain: 'localhost:3005'
      }
    });
    watch = function(){};
    if (!/share.html/.exec(window.location.href)) {
      return;
    }
    sdb.get({
      id: 'ctrlz-v3',
      watch: watch
    }).then(function(doc){
      console.log("sharedb doc prepared: ", doc);
      console.log(mj.tojson(lc.text));
      lc.doc = doc;
      watch();
      lc.json = JSON.parse(JSON.stringify(lc.doc.data));
      lc.text = mj.tomd(lc.json);
      view.get('text').value = lc.text;
      view.render();
      hist.reset({
        obj: lc.json
      });
      return doc.on('op', function(op, src){
        if (!src) {
          hist.apply({
            op: op,
            src: false
          });
        }
        lc.json = hist.get();
        lc.text = mj.tomd(lc.json);
        view.get('text').value = lc.text;
        return view.render();
      });
    });
  } catch (e$) {
    e = e$;
    console.log(e);
    console.log("conenct to sharedb server failed. run in standalone mode. ");
  }
  return window.lc = lc;
})();