import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stream_api_chat_app/model.dart';
import 'package:stream_api_chat_app/wigits.dart';
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
            CustomForm(
              controller: _controller,
              formKey: _formKey,
              hintText: "Enter username",
            ),
            SizedBox(
              height: 50,
            ),
            CustomButton(
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
              text: "Submit",
            )
          ],
        ),
      ),
    );
  }
}

class ChannelView extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final channels = List<Channel>();

  Future<List<Channel>> getChannels(StreamChatState state) async {
    final filter = {
      "type": "Mobile_Chat",
    };

    final sort = [
      SortOption(
        "last_message_at",
        direction: SortOption.DESC,
      ),
    ];

    return await state.client
        .queryChannels(
          filter: filter,
          sort: sort,
        )
        .first;
  }

  @override
  Widget build(BuildContext context) {
    final streamchat = StreamChat.of(context);
    final client = streamchat.client;
    final provider = Provider.of<ChatModel>(context);
    var list = [
      "https://cdn3.iconfinder.com/data/icons/avatars-9/145/Avatar_Penguin-512.png",
      "https://cdn3.iconfinder.com/data/icons/avatars-9/145/Avatar_Panda-512.png",
      "https://cdn3.iconfinder.com/data/icons/avatars-9/145/Avatar_Dog-512.png",
      "https://cdn3.iconfinder.com/data/icons/avatars-9/145/Avatar_Alien-512.png",
      "https://cdn3.iconfinder.com/data/icons/avatars-9/145/Avatar_Robot-512.png",
      "https://cdn3.iconfinder.com/data/icons/avatars-9/145/Avatar_Pumpkin-512.png",
      "https://cdn3.iconfinder.com/data/icons/avatars-9/145/Avatar_Pig-512.png"
    ];
    return Scaffold(
        appBar: AppBar(
          title: Text("Channel List"),
          backgroundColor: Colors.blueGrey,
          leading: Container(
            padding: const EdgeInsets.all(10),
            child: Hero(
              tag: "logo",
              child: Image.asset("assets/images/logo.png"),
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: FutureBuilder(
                future: getChannels(streamchat),
                builder: (_, AsyncSnapshot<List<Channel>> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  // clear list to avoid duplicates
                  channels.clear();
                  // repopulate list
                  channels.addAll(snapshot.data);
                  if (snapshot.data.length == 0) {
                    return Container();
                  }

                  return ListView(
                    scrollDirection: Axis.vertical,
                    children: createListOfChannels(snapshot.data, context),
                  );
                },
              ),
            ),
            CustomForm(
              controller: _controller,
              formKey: _formKey,
              hintText: "Enter a Channel name",
            ),
            CustomButton(
              onTap: () async {
                if (_formKey.currentState.validate()) {
                  final channelName = _controller.text;
                  final channelTitles = channels.map((e) => e.cid).toList();
                  _controller.clear();
                  var randomItem = (list.toList()..shuffle()).first;
                  final channel = client
                      .channel("Mobile_Chat", id: channelName, extraData: {
                    "image": "$randomItem",
                  });
                  if (!channelTitles.contains("Mobile_Chat:$channelName")) {
                    await channel.create();
                  }
                  await channel.watch();
                  provider.currentChannel = channel;
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => StreamChannel(
                        child: ChatPage(),
                        channel: channel,
                      ),
                    ),
                  );
                }
              },
              text: "Open Channel",
            )
          ],
        ));
  }
}

List<Widget> createListOfChannels(List<Channel> channels, context) {
  final provider = Provider.of<ChatModel>(context);
  return channels
      .asMap()
      .map((idx, chan) => MapEntry(
          idx,
          ListTile(
            title: Text(
                "Channel Title: ${chan.cid.replaceFirstMapped("Mobile_Chat:", (match) => "")}"),
            subtitle: Text("Last Message at: ${chan.lastMessageAt}"),
            trailing: Text("Peers: ${chan.state.members.length}"),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(chan.extraData["image"] ??
                  "https://cdn3.iconfinder.com/data/icons/avatars-9/145/Avatar_Penguin-512.png"),
            ),
            onLongPress: () async {
              provider.currentChannel = chan;
              await chan.delete();
            },
          )))
      .values
      .toList();
}

class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
