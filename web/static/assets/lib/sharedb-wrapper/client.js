// Generated by LiveScript 1.3.1
(function(){
  var diff, sharedbWrapper;
  diff = function(o, n, dostr){
    dostr == null && (dostr = true);
    return json0OtDiff(o, n, dostr ? diffMatchPatch : null);
  };
  sharedbWrapper = function(arg$){
    var url;
    url = arg$.url;
    this.socket = new WebSocket((url.scheme === 'http' ? 'ws' : 'wss') + "://" + url.domain + "/ws");
    this.connection = new sharedb.Connection(this.socket);
    return this;
  };
  sharedbWrapper.prototype = import$(Object.create(Object.prototype), {
    json: {
      diff: function(o, n, dostr){
        dostr == null && (dostr = true);
        return diff(o, n, dostr);
      }
    },
    get: function(arg$){
      var id, watch, create, this$ = this;
      id = arg$.id, watch = arg$.watch, create = arg$.create;
      return new Promise(function(res, rej){
        var doc;
        doc = this$.connection.get('doc', id);
        return doc.fetch(function(e){
          doc.subscribe(function(ops, source){
            return res(doc);
          });
          if (watch != null) {
            doc.on('op', function(ops, source){
              return watch(ops, source);
            });
          }
          if (!doc.type) {
            return doc.create((create ? create() : null) || {});
          }
        });
      });
    }
  });
  if (typeof module != 'undefined' && module !== null) {
    module.exports = sharedbWrapper;
  }
  if (typeof window != 'undefined' && window !== null) {
    return window.sharedbWrapper = sharedbWrapper;
  }
})();
function import$(obj, src){
  var own = {}.hasOwnProperty;
  for (var key in src) if (own.call(src, key)) obj[key] = src[key];
  return obj;
}