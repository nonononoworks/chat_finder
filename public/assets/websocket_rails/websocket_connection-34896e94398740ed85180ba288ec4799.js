(function(){var t={}.hasOwnProperty,n=function(n,o){function e(){this.constructor=n}for(var r in o)t.call(o,r)&&(n[r]=o[r]);return e.prototype=o.prototype,n.prototype=new e,n.__super__=o.prototype,n};WebSocketRails.WebSocketConnection=function(t){function o(t,n){this.url=t,this.dispatcher=n,o.__super__.constructor.apply(this,arguments),this.url.match(/^wss?:\/\//)?console.log("WARNING: Using connection urls with protocol specified is depricated"):this.url="https:"===window.location.protocol?"wss://"+this.url:"ws://"+this.url,this._conn=new WebSocket(this.url),this._conn.onmessage=function(t){return function(n){var o;return o=JSON.parse(n.data),t.on_message(o)}}(this),this._conn.onclose=function(t){return function(n){return t.on_close(n)}}(this),this._conn.onerror=function(t){return function(n){return t.on_error(n)}}(this)}return n(o,t),o.prototype.connection_type="websocket",o.prototype.close=function(){return this._conn.close()},o.prototype.send_event=function(t){return o.__super__.send_event.apply(this,arguments),this._conn.send(t.serialize())},o}(WebSocketRails.AbstractConnection)}).call(this);