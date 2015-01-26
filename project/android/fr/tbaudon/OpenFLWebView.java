package fr.tbaudon;

import org.haxe.lime.GameActivity;
import org.haxe.lime.HaxeObject;

import android.app.Activity;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Point;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.WebChromeClient;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.RelativeLayout.LayoutParams;

public class OpenFLWebView implements Runnable{
	
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
			GameActivity.getInstance().getWindowManager().getDefaultDisplay().getRealSize(size);
			height = size.y;
		}catch (NoSuchMethodError e){
			height = GameActivity.getInstance().getWindowManager().getDefaultDisplay().getHeight();
		}
		return height;
	}
	
	public static int getRealWidth(){
		int width = 100;
		try {
			Point size = new Point();
			GameActivity.getInstance().getWindowManager().getDefaultDisplay().getRealSize(size);
			width = size.x;
		}catch (NoSuchMethodError e){
			width = GameActivity.getInstance().getWindowManager().getDefaultDisplay().getHeight();
		}
		return width;
	}
	
	public OpenFLWebView(HaxeObject object, int width, int height, boolean closeBtn){
		setDim(width, height);
		setPosition(0, 0);
		setVerbose(false);
		
		mWebViewAdded = false;
		
		mObject = object;
		mAddClose = closeBtn;
		
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
		
		//mLayout.addView(mWebView, mLayoutParams);
		
		mActivity.addContentView(mLayout, new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT));
		
		String dpi = "mdpi";
		
		if(metrics.densityDpi == DisplayMetrics.DENSITY_LOW)
			dpi = "ldpi";
		else if(metrics.densityDpi == DisplayMetrics.DENSITY_HIGH)
			dpi = "hdpi";
		else if(metrics.densityDpi >= 320)
			dpi = "xhdpi";
		
		// close button
		byte[] closeBytes = GameActivity.getResource("webviewui/close_"+dpi+".png");
		
		mClose = new ImageView(GameActivity.getContext());
		
		mClose.setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View arg0) {
				mObject.call2("onJNIEvent", "close", null);
			}
		});
		
		Bitmap closeBmp = BitmapFactory.decodeByteArray(closeBytes, 0, closeBytes.length);
		mClose.setImageBitmap(closeBmp);
		mCloseLayoutParams = new LayoutParams(closeBmp.getWidth(), closeBmp.getHeight());
		
		mCloseOffsetX = (int) (-closeBmp.getWidth() / 1.5);
		mCloseOffsetY = (int) (-closeBmp.getHeight() / 3);
		
		mCloseLayoutParams.setMargins(mX + mWidth + mCloseOffsetX, mY + mCloseOffsetY, 0, 0);
		if(mAddClose)
			mLayout.addView(mClose, mCloseLayoutParams);
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

		mCloseLayoutParams.setMargins(mX + mWidth + mCloseOffsetX, mY + mCloseOffsetY, 0, 0);
		
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