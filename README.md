OpenFLWebView
=============

Display a web page in your openfl game.

##Use

add OpenFLWebView in your haxelib.
Then :

  ```haxe
  var mWebView = new WebView("http://wwww.myWebSite.net", 800,800);
  mWebView.x = 200;
  mWebView.y = 100;
  addChild(mWebView);
  //later----
  mWebView.loadUrl("newUrl");
  ```
##RoadMap
* Move the webview
* Remove the webView
* iOS
