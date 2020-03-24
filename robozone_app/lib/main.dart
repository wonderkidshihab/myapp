import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(MyApp());

hexColor(String colorcode) {
  colorcode = '0xff' + colorcode;
  colorcode = colorcode.replaceAll('#', '');
  int colorint = int.parse(colorcode);
  return colorint;
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyWidgets();
  }
}

class MyWidgets extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    final Completer<WebViewController> _controller =
    Completer<WebViewController>();
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              backgroundColor: Color(hexColor("CD3955")),
              title: Text("Robozone"),
              actions: <Widget>[
                NavigationControls(_controller.future),
              ],
            ),
            body:
            Container(
                child: WebView(
                  initialUrl: 'https://robozonebd.com',
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (WebViewController webViewController) {
                    _controller.complete(webViewController);
                  },
                ))));
  }
}

class NavigationControls extends StatelessWidget {
  const NavigationControls(this._webviewcontrollerFuture);

  final Future<WebViewController> _webviewcontrollerFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _webviewcontrollerFuture,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
        final bool webViewReady =
            snapshot.connectionState == ConnectionState.done;
        final WebViewController controller = snapshot.data;
        return Row(
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: !webViewReady
                    ? null
                    : () async {
                  if (await controller.canGoBack()) {
                    controller.goBack();
                  } else {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text("Can't go back"),
                    ));
                  }
                }),
            IconButton(
                icon: Icon(Icons.arrow_forward_ios, color: Colors.white),
                onPressed: !webViewReady
                    ? null
                    : () async {
                  if (await controller.canGoForward()) {
                    controller.goForward();
                  } else {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text("Can't go Forward"),
                    ));
                  }
                }),
            IconButton(
                icon: Icon(Icons.refresh, color: Colors.white),
                onPressed: !webViewReady
                    ? null
                    : () async {
                  controller.reload();
                }),
          ],
        );
      },
    );
  }
}
