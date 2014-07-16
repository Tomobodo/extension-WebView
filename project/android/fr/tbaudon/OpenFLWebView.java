package fr.tbaudon;

import org.haxe.lime.GameActivity;
import org.haxe.lime.HaxeObject;

import android.app.ActionBar.LayoutParams;
import android.app.Activity;
import android.util.Log;
import android.webkit.WebView;

public class OpenFLWebView implements Runnable{	
	
	private int mWidth;
	private int mHeight;
	
	private int mX;
	private int mY;
	
	private boolean mVerbose;

	private State mState;

	private WebView mWebView;
	private Activity mActivity;
	private HaxeObject mObject;
	
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
		
		if(mWebView != null) runState(State.UPDATE);
	}
	
	public void setDim(int w, int h){
		mWidth = w;
		mHeight = h;
		
		if(mWebView != null) runState(State.UPDATE);
	}
	
	public void loadUrl(String url){
		mWebView.loadUrl(url);
	}
	
	public void onAdded() {
		runState(State.ADD);
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
		mWebView.getSettings().setJavaScriptEnabled(true);
		mWebView.getSettings().setJavaScriptCanOpenWindowsAutomatically(true);
		mWebView.setBackgroundColor(0x00000000);
		mObject.call0("onWebViewInited");		
		if(mVerbose)
			Log.i("trace","WebView : Created new webview.");
	}
	
	private void add(){
		mActivity.addContentView(mWebView, new LayoutParams(mWidth,mHeight));
		mWebView.setX(mX);
		mWebView.setY(mY);
		if(mVerbose)
			Log.i("trace","WebView : Added webview.");
	}
	
}