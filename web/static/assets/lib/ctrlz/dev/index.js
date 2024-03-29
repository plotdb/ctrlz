(function(){
  var json0, ctrlz;
  json0 = (typeof window != 'undefined' && window !== null) && window.json0 != null
    ? window.json0
    : require("json0");
  ctrlz = function(opt){
    opt == null && (opt = {});
    this.cur = opt.obj || {};
    this.stack = {
      all: [],
      undo: [],
      redo: []
    };
    return this;
  };
  ctrlz.prototype = import$(Object.create(Object.prototype), {
    get: function(){
      return this.cur;
    },
    clear: function(){
      var this$ = this;
      return ['all', 'undo', 'redo'].map(function(it){
        return this$.stack[it].splice(0);
      });
    },
    reset: function(arg$){
      var obj;
      obj = arg$.obj;
      this.cur = obj;
      return this.clear();
    },
    update: function(obj, src){
      src == null && (src = true);
      return this.apply({
        obj: obj,
        src: src
      });
    },
    apply: function(arg$){
      var obj, op, src, opo;
      obj = arg$.obj, op = arg$.op, src = arg$.src;
      src = src != null ? src : true;
      if (!op && obj) {
        op = json0.diff(this.cur, obj);
      }
      if (!op.length) {
        return {
          obj: this.cur,
          op: null
        };
      }
      opo = {
        op: op,
        src: src
      };
      this.stack.all.push(opo);
      if (src) {
        this.stack.redo.splice(0);
        this.stack.undo.push(opo);
      }
      this.cur = json0.type.apply(this.cur, op);
      return {
        obj: this.cur,
        op: op
      };
    },
    undo: function(){
      var opo, idx, op, i$, to$, i;
      opo = this.stack.undo.pop();
      if (!opo) {
        return {
          obj: this.cur,
          op: null
        };
      }
      idx = this.stack.all.indexOf(opo);
      op = json0.type.invert(opo.op);
      for (i$ = idx + 1, to$ = this.stack.all.length; i$ < to$; ++i$) {
        i = i$;
        if (!this.stack.all[i].src) {
          op = json0.type.transform(op, this.stack.all[i].op, 'left');
        }
      }
      this.cur = json0.type.apply(this.cur, op);
      opo = {
        op: op,
        src: true
      };
      this.stack.all.push(opo);
      this.stack.redo.push(opo);
      return {
        obj: this.cur,
        op: op
      };
    },
    redo: function(){
      var opo, idx, op, i$, to$, i;
      opo = this.stack.redo.pop();
      if (!opo) {
        return {
          obj: this.cur,
          op: null
        };
      }
      idx = this.stack.all.indexOf(opo);
      op = json0.type.invert(opo.op);
      for (i$ = idx + 1, to$ = this.stack.all.length; i$ < to$; ++i$) {
        i = i$;
        if (!this.stack.all[i].src) {
          op = json0.type.transform(op, this.stack.all[i].op, 'left');
        }
      }
      this.cur = json0.type.apply(this.cur, op);
      opo = {
        op: op,
        src: true
      };
      this.stack.all.push(opo);
      this.stack.undo.push(opo);
      return {
        obj: this.cur,
        op: op
      };
    }
  });
  if (typeof module != 'undefined' && module !== null) {
    module.exports = ctrlz;
  }
  if (typeof window != 'undefined' && window !== null) {
    window.ctrlz = ctrlz;
  }
  function import$(obj, src){
    var own = {}.hasOwnProperty;
    for (var key in src) if (own.call(src, key)) obj[key] = src[key];
    return obj;
  }
}).call(this);
