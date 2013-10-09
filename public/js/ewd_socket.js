var ewd_sockets = (function () {
  var ewd={};
  ewd.messageTag = '#chat-log';
  ewd.socket = null;

  function addMessage(msg) {
    $(ewd.messageTag).append("<p>" + msg + "</p>");
  };

  ewd.connect = function connect(host, message_tag) {
    try {
      ewd.socket = new WebSocket(host);
      ewd.messageTag = message_tag;

      addMessage("Socket State: " + ewd.socket.readyState);

      ewd.socket.onopen = function() {addMessage("Socket Status: " + ewd.socket.readyState + " (open)");}
      ewd.socket.onclose = function() {addMessage("Socket Status: " + ewd.socket.readyState + " (closed)");}
      ewd.socket.onmessage = function(msg) {addMessage("Received: " + msg.data);}

    } catch(exception) {
      addMessage("Error: " + exception);
    }
  };

  ewd.disconnect = function(){
    ewd.socket.close();
  };


  ewd.send = function (text) {
    try {
      ewd.socket.send(text);
      addMessage("Sent: " + text);
    } catch(exception) {
      addMessage("Failed To Send");
    }
  };

  return ewd;
}());

