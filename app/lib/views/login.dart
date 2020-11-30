import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghost/blocs/api/api.dart';
import 'package:ghost/blocs/auth/auth.dart';
import 'package:ghost/repositories/api_repository.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';

class LoginView extends StatefulWidget {
  @override
  _WebViewExampleState createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<LoginView> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  String currentUrl = '';
  APIBloc _apiBloc;
  AuthBloc _authBloc;

  @override
  void initState() {
    super.initState();
    _authBloc = BlocProvider.of<AuthBloc>(context);
    _apiBloc = APIBloc(
      apiRepository: APIRepository(),
    );
  }

  @override
  void dispose() {
    _apiBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(currentUrl.toString()),
      ),
      child: BlocBuilder<APIEvent, APIState>(
        bloc: _apiBloc,
        builder: (BuildContext context, APIState state) {
          if (state is APICredentials) {
            _authBloc.dispatch(
              LogIn(
                credentials: state.credentials,
                membershipData: state.membershipData,
              ),
            );

            // if (_controller.isCompleted) {
            //   _controller.future.then((controller) {
            //     controller.clearCache();
            //   });
            // }
            return SafeArea(
              child: Text('Hello'),
            );
          }
          return SafeArea(
            // _TODO: Show loader & navigation controls
            child: WebView(
              initialUrl:
                  'https://www.bungie.net/en/oauth/authorize?client_id=27054&response_type=code',
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) async {
                final String url = await webViewController.currentUrl();
                updateUrl(url);
                _controller.complete(webViewController);
              },
              navigationDelegate: (NavigationRequest request) {
                updateUrl(request.url);
                return NavigationDecision.navigate;
              },
              javascriptChannels: <JavascriptChannel>[
                JavascriptChannel(
                  name: 'Toaster',
                  onMessageReceived: (JavascriptMessage message) {
                    _apiBloc.dispatch(
                      ReceiveCredentials(responseJson: message.message),
                    );
                  },
                )
              ].toSet(),
            ),
          );
        },
      ),
    );
  }

  void updateUrl(String url) {
    final String host = Uri.parse(url).host;
    if (host == 'ghost-companion.herokuapp.com') {
      setState(() {
        currentUrl = 'Loading...';
      });
    } else {
      if (host.isNotEmpty) {
        setState(() {
          currentUrl = host;
        });
      }
    }
  }
}
