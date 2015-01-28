package fr.tbaudon;

import org.haxe.extension.Extension;

import org.haxe.lime.HaxeObject;

import fr.tbaudon.openflwebview.R;
import android.app.Activity;
import android.graphics.BitmapFactory;
import android.graphics.Point;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.View;

import android.webkit.WebChromeClient;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.RelativeLayout.LayoutParams;

public class OpenFLWebView extends Extension implements Runnable{
	
	private int mWidth;
	private int mHeight;
	
	private int mX;
	private int mY;
	
	private boolean mVerbose;
	private boolean mAddClose;
	private boolean mWebViewAdded;

	private State mState;

	private WebView mWebView;
	private ImageView mClose;
	private RelativeLayout mLayout;
	private Activity mActivity;
	private HaxeObject mObject;
	private LayoutParams mLayoutParams;
	private LayoutParams mCloseLayoutParams;
	
	private int mCloseOffsetX;
	private int mCloseOffsetY;

	
	public static OpenFLWebView create(HaxeObject object, int width, int height, boolean closeBtn){
		return new OpenFLWebView(object, width, height, closeBtn);
	}
	
	public static int getRealHeight(){
		int height = 100;
		try {
			Point size = new Point();
			mainActivity.getWindowManager().getDefaultDisplay().getRealSize(size);
			height = size.y;
		}catch (NoSuchMethodError e){
			mainActivity.getWindowManager().getDefaultDisplay().getHeight();
		}
		return height;
	}
	
	public static int getRealWidth(){
		int width = 100;
		try {
			Point size = new Point();
			mainActivity.getWindowManager().getDefaultDisplay().getRealSize(size);
			width = size.x;
		}catch (NoSuchMethodError e){
			mainActivity.getWindowManager().getDefaultDisplay().getHeight();
		}
		return width;
	}
	
	public OpenFLWebView() {
		super();
	}
	
	public OpenFLWebView(HaxeObject object, int width, int height, boolean closeBtn){
		super();
		setDim(width, height);
		setPosition(0, 0);
		setVerbose(false);
		
		mWebViewAdded = false;
		
		mObject = object;
		mAddClose = closeBtn;
		
		mActivity = mainActivity;
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
	
	public void loadUrl(final String url){
		mainActivity.runOnUiThread(new Runnable() {
			public void run() {
				mWebView.loadUrl(url);
			}
		});
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
		runState(State.DESTROY);
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
			case DESTROY : 
				destroy();
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
		
		DisplayMetrics metrics = new DisplayMetrics();
		mActivity.getWindowManager().getDefaultDisplay().getMetrics(metrics);
		
		mLayoutParams = new LayoutParams(mWidth,mHeight);
		mLayout = new RelativeLayout(mActivity);
		
		mActivity.addContentView(mLayout, new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT));
		
		// close button
		
		mClose = new ImageView(mainContext);
		
		mClose.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View arg0) {
				mObject.call2("onJNIEvent", "close", null);
			}
		});
		
		RelativeLayout closeLayout = new RelativeLayout(mainContext);
		LayoutParams closeLP = new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT);
		mWebView.addView(closeLayout, closeLP);
		
		mCloseLayoutParams = new LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT);
		mCloseLayoutParams.addRule(RelativeLayout.ALIGN_PARENT_RIGHT);
		mClose.setLayoutParams(mCloseLayoutParams);
		
		mClose.setImageResource(R.drawable.close);
		
		if(mAddClose)
			closeLayout.addView(mClose);
		
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
		
		if(!mWebViewAdded){
			mLayout.addView(mWebView, mLayoutParams);
			mWebViewAdded = true;
		}
					
		if(mVerbose)
			Log.i("trace","WebView : Added webview.");
	}
	
	private void remove(){
		if(mVerbose)
			Log.i("trace","WebView : Removed webview.");
		mLayout.removeAllViews();
		mWebViewAdded = false;
	}
	
	private void update() {
		mLayoutParams.setMargins(mX, mY, 0, 0);
		mLayoutParams.width = mWidth;
		mLayoutParams.height = mHeight;
		
		mLayout.requestLayout();
		if(mVerbose)
			Log.i("trace","WebView : Update webview transformation : ("+mX+", "+mY+", "+mWidth+", "+mHeight+")");
	}
	
	private void destroy() {
		remove();
		
		mObject = null;
		mWebView.destroy();
		mWebView = null;
		mLayout = null;
		
		System.gc();
		
		if(mVerbose)
			Log.i("trace","WebView : Dispose.");
	}
	
}