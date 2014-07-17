package fr.tbaudon ;

import flash.display.Stage;
import flash.events.Event;
import openfl.display.Sprite;
import openfl.events.FocusEvent;
import openfl.events.KeyboardEvent;
import openfl.Lib;
import openfl.system.Capabilities;

import openfl.utils.JNI;

class AndroidWebView extends Sprite{
	
	/**************************************************************/
	// JNI LINKING
	/*
	 * jni type cheat sheet :
	 * parameter type beetween (), return type after ()
	 * nonBasicObject : Lpath/to/class;
	 * void : V
	 * bool : Z
	 * int : I
	 * Sample : (Ljava/lang/String;I)Z = function(String, Int) : bool
	 */
	// STATIC METHOD
	private static var create_jni = JNI.createStaticMethod("fr.tbaudon.OpenFLWebView", "create", "(Lorg/haxe/lime/HaxeObject;II)Lfr/tbaudon/OpenFLWebView;");
	
	// MEMBER METHOD
	private static var add_jni = JNI.createMemberMethod("fr.tbaudon.OpenFLWebView", "onAdded", "()V");
	private static var loadUrl_jni = JNI.createMemberMethod("fr.tbaudon.OpenFLWebView", "loadUrl", "(Ljava/lang/String;)V");
	private static var setPos_jni = JNI.createMemberMethod("fr.tbaudon.OpenFLWebView", "setPosition", "(II)V");
	private static var setDim_jni = JNI.createMemberMethod("fr.tbaudon.OpenFLWebView", "setDim", "(II)V");
	private static var setVerbose_jni = JNI.createMemberMethod("fr.tbaudon.OpenFLWebView", "setVerbose", "(Z)V");
	
	/*************************************************************/
	
	// Members
	var mJNIInstance : Dynamic;
	var mQueue : Array<{func : Dynamic, params : Array<Dynamic>}>;
	
	var mUrlToLoad : String;
	
	var mWebViewReady : Bool;
	
	//var mWidth : UInt;
	//var mHeight : UInt;
	
	/**
	 * If a fixed window size is set, openfl will scale the game to fit the screen so the coordinate passed
	 * to android webView won't be corresponding. We need to multiply every coordinate passed by this ratio.
	 */
	var mScaleX : Float;
	var mScaleY : Float;
	var mOffsetX : Float;
	var mOffsetY : Float;
	var mWidth : Int;
	var mHeight : Int;
	
	public function new(defaultUrl : String = "http://www.baudon.me", w : UInt = 400, h : UInt = 400) {
		super();
		
		computeScale();
		
		mWidth = cast w * mScaleX;
		mHeight = cast h * mScaleY;
		
		mQueue = new Array<{func : Dynamic, params : Array<Dynamic>}>();
		
		mWebViewReady = false;
		mJNIInstance = create_jni(this, mWidth, mHeight);
		
		loadUrl(defaultUrl);
		
		addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		
		Lib.current.stage.addEventListener(Event.RESIZE, computeScale);
		
		x = 0;
		y = 0;
	}
	
	public function setVerbsoe(verbose : Bool) {
		setVerbose_jni(mJNIInstance, verbose);
	}
	
	public function loadUrl(url : String) {
		if (mWebViewReady) {
			mUrlToLoad = url;
			loadUrl_jni(mJNIInstance, url);
		}
		else
			addToQueue(loadUrl_jni, [mJNIInstance, url]);
	}
	
	private function onWebViewInited() {
		mWebViewReady = true;
		while (mQueue.length > 0)
		{
			var call = mQueue.shift();
			Reflect.callMethod(Type.getClass(this), call.func, call.params);
		}
	}
	
	private function onRemovedFromStage(e:Event):Void 
	{
		
	}
	
	private function onAddedToStage(e:Event):Void 
	{
		if (mWebViewReady)
			add_jni(mJNIInstance);
		else
			addToQueue(add_jni, [mJNIInstance]);
	}
	
	private function setPos(x : Int, y : Int) {
		x *= cast mScaleX;
		y *= cast mScaleY;
		x += cast mOffsetX;
		y += cast mOffsetY;
		
		if (mWebViewReady)
			setPos_jni(mJNIInstance, x, y);
		else
			addToQueue(setPos_jni, [mJNIInstance, x, y]);
	}
	
	public function setDim(w : Int, h : Int) {
		w *= cast mScaleX;
		h *= cast mScaleY;
		mWidth = w;
		mHeight = h;
		if (mWebViewReady)
			setDim_jni(mJNIInstance, w, h);
		else
			addToQueue(setDim_jni, [mJNIInstance, w, h]);
	}
	
	override public function set_x(x : Float) : Float {
		setPos(cast x,cast y);
		return super.set_x(x);
	}
	
	override public function set_y(y : Float) : Float {
		setPos(cast x,cast y);
		return super.set_y(y);
	}
	
	override public function get_width() : Float {
		return mWidth / mScaleX;
	}
	
	override public function get_height() : Float {
		return mHeight / mScaleY;
	}
	
	function addToQueue(object : Dynamic, array:Array<Dynamic>) 
	{
		// don't push the same method twice, change the params instead
		var canPush : Bool = true;
		for (obj in mQueue) {
				if (obj.func == object){
					canPush = false;
					obj.params = array;
					break;
				}
		}
		if(canPush)
			mQueue.push( { func:object, params:array } );
	}
	
	function computeScale(e : Event = null)
	{
		var ratio = Lib.current.stage.stageWidth / Lib.current.stage.stageHeight;
		
		var displayWidth : Float;
		var displayHeight : Float;
		
		if (Lib.current.stage.stageWidth>=Lib.current.stage.stageHeight) {
			displayHeight = Capabilities.screenResolutionY;
			displayWidth = displayHeight * ratio;
			mOffsetX = (Capabilities.screenResolutionX - displayWidth) / 2;
			mOffsetY = 0; 
			trace("LANDSCAPE");
		}else {
			displayWidth = Capabilities.screenResolutionX;
			displayHeight = displayWidth / ratio;
			mOffsetX = 0;
			mOffsetY = (Capabilities.screenResolutionY - displayHeight) / 2;
			trace("PORTRAIT");
		}
		
		mScaleX = displayWidth / Lib.current.stage.stageWidth;
		mScaleY = displayHeight / Lib.current.stage.stageHeight;
		
		if (e != null)
		{
			setDim(cast width, cast height);
			x = x;
			y = y;
		}
	}
	
}