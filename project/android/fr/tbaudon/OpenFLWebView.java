package fr.tbaudon;

import org.haxe.lime.GameActivity;
import org.haxe.lime.HaxeObject;

import android.widget.LinearLayout.LayoutParams;
import android.widget.LinearLayout;
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
		mWebView.getSettings().setJavaScriptEnabled(true);
		mWebView.getSettings().setJavaScriptCanOpenWindowsAutomatically(true);
		mWebView.setBackgroundColor(0x00000000);
		mObject.call0("onWebViewInited");
		
		if(mVerbose)
			Log.i("trace","WebView : Created new webview.");
	}
	
	private void add(){
		mWebView.setX(mX);
		mWebView.setY(mY);
		mActivity.addContentView(mWebView, mLayoutParams);
		
		if(mVerbose)
			Log.i("trace","WebView : Added webview.");
	}
	
	private void update() {
		mWebView.setX(mX);
		mWebView.setY(mY);
		if(mLayoutParams.width < mWidth + mX)
			mLayoutParams.width = mWidth + mX;
		if(mLayoutParams.height < mHeight + mY)
			mLayoutParams.height = mHeight + mY;
	}
	
}