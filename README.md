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
  mWebView.addEventlistener(ProgressEvent.PROGRESS, onProgress);
  mWebView.addEventlistener(Event.COMPLETE, onLoadComplete);
  mWebView.addEventlistener(ErrorEvent.ERROR, onLoadError);
  //later
  mWebView.loadUrl("newUrl");
  //remove
  removeChild(mWebView);
  // destroy
  mWebView.dispose();
  mWebView = null;
  ```
Please note that event if it looks like it's a displayObject, it won't respect the display hierarchy as it's basicaly a WebView on top of the game mainView. 
So it will always appear on top of your game, whatever you do.

  
##RoadMap
* Move the webview // done 
* Remove the webView // done
* Destroy the webView // done
* Event for error, page not found, page loaded ect. // done
* iOS
