package fr.tbaudon;

import org.haxe.lime.GameActivity;
import org.haxe.lime.HaxeObject;

import android.app.Activity;
import android.util.Log;
import android.view.View;
import android.webkit.WebView;
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
	
	private static WebView webView;
	private static Activity activity;
	
	private static String urlToLoad;
	
	public static void init()
	{
		trace("init OpenFLWebView");
		activity = GameActivity.getInstance();
		activity.runOnUiThread(new Runnable() {
			@Override
			public void run() {
				webView = new WebView(activity);
			}
		});
	}
	
	public static void trace(String s){
		Log.i("trace",s);
	}
	
	public static void show(String url){
		
		urlToLoad = url;
		
		activity.runOnUiThread(new Runnable() {
			@Override
			public void run() {
				webView.loadUrl(urlToLoad);
				GameActivity.pushView(webView);
			}
		});
	}
	
}