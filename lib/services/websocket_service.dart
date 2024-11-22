import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:chat_app/config/api_config.dart';

class WebSocketService {
  WebSocketChannel? _channel;
  Function(dynamic)? _messageHandler;

  void connect(String token) {
    final wsUrl = Uri.parse('${ApiConfig.wsUrl}?token=$token');
    _channel = WebSocketChannel.connect(wsUrl);
    _listen();
  }

  void _listen() {
    _channel?.stream.listen(
      (message) {
        if (_messageHandler != null) {
          _messageHandler!(message);
        }
      },
      onError: (error) {
        print('WebSocket Error: $error');
        reconnect();
      },
      onDone: () {
        print('WebSocket Connection Closed');
        reconnect();
      },
    );
  }

  void setMessageHandler(Function(dynamic) handler) {
    _messageHandler = handler;
  }

  void sendMessage(dynamic message) {
    _channel?.sink.add(message);
  }

  void reconnect() {
    disconnect();
    connect(ApiConfig.token);
  }

  void disconnect() {
    _channel?.sink.close();
    _channel = null;
  }
}