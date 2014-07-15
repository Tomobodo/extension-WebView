package fr.tbaudon;

import org.haxe.lime.HaxeObject;
import org.haxe.lime.GameActivity;

import android.app.AlertDialog;
import android.app.ActionBar.LayoutParams;
import android.app.AlertDialog.Builder;
import android.content.Intent;
import android.os.Bundle;
import android.os.Looper;
import android.util.Log;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.LinearLayout;
import android.widget.TextView;

/* 
	You can use the Android Extension class in order to hook
	into the Android activity lifecycle. This is not required
	for standard Java code, this is designed for when you need
	deeper integration.
	
	You can access additional references from the Extension class,
	depending on your needs:
	
	- Extension.assetManager (android.content.res.AssetManager)
	- Extension.callbackHandler (android.os.Handler)
	- Extension.mainActivity (android.app.Activity)
	- Extension.mainContext (android.content.Context)
	- Extension.mainView (android.view.View)
	
	You can also make references to static or instance methods
	and properties on Java classes. These classes can be included 
	as single files using <java path="to/File.java" /> within your
	project, or use the full Android Library Project format (such
	as this example) in order to include your own AndroidManifest
	data, additional dependencies, etc.
	
	These are also optional, though this example shows a static
	function for performing a single task, like returning a value
	back to Haxe from Java.
*/
public class OpenFLWebView {	
	
	public static WebView webView;
	
	public static void init(HaxeObject listenerClass, boolean withPopup)
	{
		try {
			
			GameActivity.getInstance().runOnUiThread(new Runnable() {
				
				@Override
				public void run() {
					GameActivity activity = GameActivity.getInstance();
					WebView webview = new WebView(activity);
					webview.loadUrl("http://www.baudon.me");
					GameActivity.pushView(webview);
				}
			});
		}catch (Exception e){
			trace(e.getMessage());
		}

	}
	
	public static void trace(String s){
		Log.i("trace",s);
	}
	
}