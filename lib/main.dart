import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Credentials {
  String token = 'initial token';
}

class User extends ChangeNotifier {
  Credentials token = Credentials();

  void setToken(Credentials t) {
    token = t;
    notifyListeners();
  }
}

typedef ReadUser = User Function();

class HttpService {
  static void init(ReadUser read) => _singleton.read = read;

  // static void init(User user) {
  //   _singleton.user = user;
  // }

  static final _singleton = HttpService._();

  HttpService._();

  factory HttpService() => _singleton;

  // User user;
  ReadUser read;
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ChangeNotifierProvider<User>(
        create: (context) {
          final user = User();
          return user;
        },
        child: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final random = Random();

  final chars = <String>['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k'];

  @override
  void initState() {
    super.initState();
    HttpService.init(context.read);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('The user token is'),
            const SizedBox(height: 20),
            Consumer<User>(
              builder: (context, user, child) {
                return Text(user.token.token);
              },
            ),
            const SizedBox(height: 20),
            RaisedButton(
              onPressed: () {
                var c = chars[random.nextInt(chars.length - 1)];
                var newToken = c + c + c + c;
                final currentToken = context.read<User>().token.token;
                while (newToken == currentToken) {
                  c = chars[random.nextInt(chars.length - 1)];
                  newToken = c + c + c + c;
                }
                context.read<User>().setToken(Credentials()..token = newToken);
              },
              child: Text('change token'),
            ),
            const SizedBox(height: 20),
            RaisedButton(
              onPressed: () {
                print(HttpService().read().token.token);
              },
              child: Text('print token'),
            )
          ],
        ),
      ),
    );
  }
}
