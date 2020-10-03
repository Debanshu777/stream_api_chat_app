import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stream_api_chat_app/model.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ChatModel>(
        create: (context) => ChatModel(),
        child: MaterialApp(
          home: MyHome(),
          theme: ThemeData(
            scaffoldBackgroundColor: Color(0xff1F1F1F),
            fontFamily: "OverpassRegular",
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          debugShowCheckedModeBanner: false,
        ));
  }
}

class MyHome extends StatelessWidget {
  final TextEditingController _controller = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var list = [
    "https://cdn3.iconfinder.com/data/icons/avatars-9/145/Avatar_Penguin-512.png",
    "https://cdn3.iconfinder.com/data/icons/avatars-9/145/Avatar_Panda-512.png",
    "https://cdn3.iconfinder.com/data/icons/avatars-9/145/Avatar_Dog-512.png",
    "https://cdn3.iconfinder.com/data/icons/avatars-9/145/Avatar_Alien-512.png",
    "https://cdn3.iconfinder.com/data/icons/avatars-9/145/Avatar_Robot-512.png",
    "https://cdn3.iconfinder.com/data/icons/avatars-9/145/Avatar_Pumpkin-512.png",
    "https://cdn3.iconfinder.com/data/icons/avatars-9/145/Avatar_Pig-512.png"
  ];

  /// Construct a color from a hex code string, of the format #RRGGBB.
  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ChatModel>(context);
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Hero(
                tag: "logo",
                child: Container(
                  width: 200.0,
                  child: Image.asset("assets/images/logo.png"),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _controller,
                style: TextStyle(
                  color: Colors.white,
                ),
                keyboardType: TextInputType.text,
                validator: (input) {
                  if (input.isEmpty) {
                    return "Enter some Text";
                  }
                  if (input.contains(RegExp(r"^([A-Za-z0-9]){4,20}$"))) {
                    return null;
                  }
                  return "Can't contain special character or space";
                },
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(5.0),
                    borderSide: BorderSide(color: Colors.white70),
                  ),
                  focusedBorder: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(5.0),
                    borderSide: BorderSide(color: Colors.white70),
                  ),
                  labelText: "Enter a username",
                  labelStyle: TextStyle(
                    color: Colors.white70,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            GestureDetector(
              onTap: () async {
                if (_formKey.currentState.validate()) {
                  final user = _controller.text;
                  final client = provider.client;
                  var randomItem = (list.toList()..shuffle()).first;
                  await client
                      .setUserWithProvider(User(id: "id_$user", extraData: {
                    "name": "$user",
                    "image": "$randomItem",
                  }));
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (_) => StreamChat(
                      child: ChannelView(),
                      client: client,
                    ),
                  ));
                }
              },
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    hexToColor("#7991ad"),
                    hexToColor("#6b839f"),
                  ]),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "Submit",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChannelView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
