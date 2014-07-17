package fr.tbaudon;

import org.haxe.lime.GameActivity;
import org.haxe.lime.HaxeObject;

import android.app.Activity;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.ViewGroup;
import android.webkit.WebChromeClient;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.RelativeLayout;
import android.widget.RelativeLayout.LayoutParams;

public class OpenFLWebView implements Runnable{	
	
	private int mWidth;
	private int mHeight;
	
	private int mX;
	private int mY;
	
	private boolean mVerbose;

	private State mState;

	private WebView mWebView;
	private RelativeLayout mLayout;
	private Activity mActivity;
	private HaxeObject mObject;
	private LayoutParams mLayoutParams;
	
	public static OpenFLWebView create(HaxeObject object, int width, int height){
		return new OpenFLWebView(object, width, height);
	}
	
	public OpenFLWebView(HaxeObject object, int width, int height){
		setDim(width, height);
		setPosition(0, 0);
		setVerbose(false);
		
		mObject = object;
		
		mActivity = GameActivity.getInstance();
		runState(State.INIT);
	}
	
	public void setVerbose(boolean verbose){
		mVerbose = verbose;
	}
	
	public void setPosition(int x, int y){
		mX = x;
		mY = y;
		
		if(mVerbose)
			Log.i("trace","WebView : pos("+mX+"; "+mY+")");
		
		if(mWebView != null) runState(State.UPDATE);
	}
	
	public void setDim(int w, int h){
		mWidth = w;
		mHeight = h;
		
		if(mVerbose)
			Log.i("trace","WebView : dim("+mWidth+"; "+mHeight+")");
		
		if(mWebView != null) runState(State.UPDATE);
	}
	
	public void loadUrl(String url){
		mWebView.loadUrl(url);
	}
	
	public void onAdded() {
		runState(State.ADD);
	}
	
	public void onRemoved() {
		runState(State.REMOVE);
	}
	
	public void onOrientationChange(){
		runState(State.UPDATE);
	}
	
	public void dispose(){
		mObject = null;
		mWebView.destroy();
		mWebView = null;
		mLayout = null;
		
		System.gc();
	}

	@Override
	public void run() {
		switch (mState){
			case INIT :
				initWebView();
				break;
			case ADD :
				add();
				break;
			case REMOVE :
				remove();
				break;
			case UPDATE :
				update();
				break;
			default :
				break;
		}
	}
	
	private void runState(State state){
		mState = state;
		mActivity.runOnUiThread(this);
	}
	
	private void initWebView(){
		mWebView = new WebView(mActivity);
		mLayoutParams = new LayoutParams(mWidth,mHeight);
		mLayout = new RelativeLayout(mActivity);
		mLayout.addView(mWebView, mLayoutParams);
		
		// webChromeClient
		mWebView.setWebChromeClient(new WebChromeClient() {
			@Override
			public void onProgressChanged(WebView view, int progress) {
				mObject.call2("onJNIEvent", "progress", progress);
			}
		});
		
		// webClient
		mWebView.setWebViewClient(new WebViewClient() {
             @Override
             public void onReceivedError(WebView view, int errorCode, String description, String failingUrl)
             {
            	 mObject.call2("onJNIEvent", "error", description);
             }

             @Override
             public boolean shouldOverrideUrlLoading(WebView view, String url)
             {
                 view.loadUrl(url);
                 return true;
             }
         });
		
		mWebView.getSettings().setJavaScriptEnabled(true);
		mWebView.getSettings().setJavaScriptCanOpenWindowsAutomatically(true);
		mWebView.setBackgroundColor(0x00000000);
		mObject.call0("onWebViewInited");
		
		if(mVerbose)
			Log.i("trace","WebView : Created new webview.");
	}
	
	private void add(){
		DisplayMetrics metrics = new DisplayMetrics();
		mActivity.getWindowManager().getDefaultDisplay().getMetrics(metrics);
		mActivity.addContentView(mLayout, new LayoutParams(metrics.widthPixels, metrics.widthPixels));
		if(mVerbose)
			Log.i("trace","WebView : Added webview.");
	}
	
	private void remove(){
		if(mVerbose)
			Log.i("trace","WebView : Removed webview.");
		ViewGroup vg = (ViewGroup)(mLayout.getParent());
		vg.removeView(mLayout);
	}
	
	private void update() {
		mLayoutParams.setMargins(mX, mY, 0, 0);
		mLayoutParams.width = mWidth;
		mLayoutParams.height = mHeight;
		mLayout.requestLayout();
		if(mVerbose)
			Log.i("trace","WebView : Update webview transformation.");
	}
	
}