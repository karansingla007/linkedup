import 'package:flutter/cupertino.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketIo {
  IO.Socket socket;

  initSocket({@required String url}) async {
    socket = IO.io(url, <String, dynamic>{
      'transports': ['websocket']
    });
    socket.connect();

    socket.on('connect', (data) {});
    socket.on('disconnect', pprint);
  }

  listenSocketErrorEvent(socketErrorCallback) {
    socket.on('error', (data) {
      socketErrorCallback();
    });
    socket.on('connect_error', (data) {
      socketErrorCallback();
    });
    socket.on('connect_timeout', (data) {
      socketErrorCallback();
    });
  }

  listenSocketReConnectedEvent(socketConnectedCallback) {
    socket.on('reconnect', (data) {
      socketConnectedCallback();
    });
  }

  listenEvent(event, messageReceivedCallback) {
    socket.on(event, (data) {
      print(data);
      messageReceivedCallback(data);
    });
  }

  emitEvent(event, List message) {
    if (socket != null) {
      socket.emit(event, message);
    }
  }

  disconnectSocket() {
    socket.disconnect();
  }

  pprint(data) {
    print(data);
  }
}
