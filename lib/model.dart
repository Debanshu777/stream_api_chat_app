import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:start_jwt/json_web_signature.dart';
import 'package:start_jwt/json_web_token.dart';
import 'package:stream_api_chat_app/api.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ChatModel extends ChangeNotifier {
  ChatModel() {
    /*tokenProvider: helps to specify a function that will take our secret key
          and use it to create a JSON web token to send back to API
      */
    _client = Client(
      APIKEY,
      logLevel: Level.SEVERE,
      tokenProvider: provider,
    );
  }

  Client get client => _client;
  Client _client; //main access to the API gives us Access to http events
  String _channelName;
  Channel _currentChannel;
  String get channelNmae => _channelName;
  set channeLName(String value) {
    _channelName = value;
    notifyListeners();
  }

  set currentChannel(Channel channel) {
    _currentChannel = channel;
    notifyListeners();
  }
}

Future<String> provider(String id) async {
  /*To create our Json Web token we set up using JsonWebSignatureCodec*/
  final JsonWebTokenCodec jwt = JsonWebTokenCodec(secret: SECRECTKEY);
  final payload = {
    "user_id": id, //basically username
  };
  return jwt.encode(payload);
}
