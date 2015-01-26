package fr.tbaudon ;

import flash.display.Stage;
import flash.events.Event;
import openfl.display.Sprite;
import openfl.events.ErrorEvent;
import openfl.events.FocusEvent;
import openfl.events.KeyboardEvent;
import openfl.events.ProgressEvent;
import openfl.Lib;
import openfl.system.Capabilities;
import openfl.system.System;

import openfl.utils.JNI;

class AndroidWebView extends AbstractWebView{
	
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
	private static var create_jni = JNI.createStaticMethod("fr.tbaudon.OpenFLWebView", "create", "(Lorg/haxe/lime/HaxeObject;IIZ)Lfr/tbaudon/OpenFLWebView;");
	private static var getRealHeight_jni = JNI.createStaticMethod("fr.tbaudon.OpenFLWebView", "getRealHeight", "()I");
	private static var getRealWidth_jni = JNI.createStaticMethod("fr.tbaudon.OpenFLWebView", "getRealWidth", "()I");
	
	// MEMBER METHOD
	private static var add_jni = JNI.createMemberMethod("fr.tbaudon.OpenFLWebView", "onAdded", "()V");
	private static var remove_jni = JNI.createMemberMethod("fr.tbaudon.OpenFLWebView", "onRemoved", "()V");
	private static var loadUrl_jni = JNI.createMemberMethod("fr.tbaudon.OpenFLWebView", "loadUrl", "(Ljava/lang/String;)V");
	private static var setPos_jni = JNI.createMemberMethod("fr.tbaudon.OpenFLWebView", "setPosition", "(II)V");
	private static var setDim_jni = JNI.createMemberMethod("fr.tbaudon.OpenFLWebView", "setDim", "(II)V");
	private static var setVerbose_jni = JNI.createMemberMethod("fr.tbaudon.OpenFLWebView", "setVerbose", "(Z)V");
	private static var dispose_jni = JNI.createMemberMethod("fr.tbaudon.OpenFLWebView", "dispose", "()V");
	
	/*************************************************************/
	
	// Members
	var mJNIInstance : Dynamic;

    /** Queue WebView call untill the webView isn't ready **/
	var mQueue : Array<{func : Dynamic, params : Array<Dynamic>}>;
	var mWebViewReady : Bool;
	
	public function new(defaultUrl : String = "http://www.baudon.me", w : Float = 400, h : Float = 400, close : Bool = false) {
        mJNIInstance = create_jni(this, mWidth, mHeight, close);
        mQueue = new Array<{func : Dynamic, params : Array<Dynamic>}>();
        mWebViewReady = false;

        super(defaultUrl, w, h);
	}
	
	override public function setVerbose(verbose : Bool) {
		setVerbose_jni(mJNIInstance, verbose);
	}

    override public function loadUrl(url : String) {
		if (mWebViewReady)
			loadUrl_jni(mJNIInstance, url);
		else
			addToQueue(loadUrl_jni, [mJNIInstance, url]);
	}

    override public function addCloseBtn(){
        trace("Nothing happens.,,");
    }
	
	function onWebViewInited() {
		mWebViewReady = true;
		while (mQueue.length > 0)
		{
			var call = mQueue.shift();
			Reflect.callMethod(Type.getClass(this), call.func, call.params);
		}
	}
	
	function onJNIEvent(event : String, param : Dynamic ) {
		switch(event) {
			case 'progress' :
				var progress : Int = param;
				dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, progress, 100));
				if (progress == 100)
					dispatchEvent(new Event(Event.COMPLETE)); 
			case 'error' :
				var description : String = param;
				dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, description));
			case 'close' : 
				dispatchEvent(new Event('close'));
			default :
				trace(event);
		}
	}

    override function onRemovedFromStage(e:Event):Void
	{
		if (mWebViewReady)
			remove_jni(mJNIInstance);
		else
			addToQueue(remove_jni, [mJNIInstance]);
	}

    override function onAddedToStage(e:Event):Void
	{
		if (mWebViewReady)
			add_jni(mJNIInstance);
		else
			addToQueue(add_jni, [mJNIInstance]);
	}

    override function setPos(x : Float, y : Float) {	
		if (mWebViewReady)
			setPos_jni(mJNIInstance, Std.int(x), Std.int(y));
		else
			addToQueue(setPos_jni, [mJNIInstance, Std.int(x), Std.int(y)]);
	}
	
	override function applyDim(w : Float, h : Float) {
		if (mWebViewReady)
			setDim_jni(mJNIInstance, Std.int(w), Std.int(h));
		else
			addToQueue(setDim_jni, [mJNIInstance, Std.int(w), Std.int(h)]);
	}
	
	override public function dispose() {
		if(mJNIInstance != null){
				
			dispose_jni(mJNIInstance);
				
			mJNIInstance = null;
			mQueue = null;
			
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			Lib.current.stage.removeEventListener(Event.RESIZE, computeScale);
			
			System.gc();
		}
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
	
	override function computeScale(e : Event = null)
    {
		var screenWidth : Int = getRealWidth_jni();
		var screenHeight : Int = getRealHeight_jni();
		
        var ratio = Lib.current.stage.stageWidth / Lib.current.stage.stageHeight;
        var screenRatio = screenWidth / screenHeight;

        trace(ratio, screenRatio);

        var displayWidth : Float;
        var displayHeight : Float;

        // landscape app
        if(screenRatio >= 1){
            displayWidth = screenWidth;
            displayHeight = displayWidth / ratio;
            if(displayHeight >= screenHeight){
                displayHeight = screenHeight;
                displayWidth = displayHeight * ratio;
            }

            mOffsetX = (screenWidth - displayWidth) / 2;
            mOffsetY = (screenHeight - displayHeight) / 2;
        }else {
            displayHeight = screenHeight;
            displayWidth = displayHeight * ratio;
            if(displayWidth >= screenWidth){
                displayWidth = screenWidth;
                displayHeight = screenWidth / ratio;
            }

            mOffsetX = (screenWidth - displayWidth) / 2;
            mOffsetY = (screenHeight - displayHeight) / 2;
        }

        mScaleX = displayWidth / Lib.current.stage.stageWidth;
        mScaleY = displayHeight / Lib.current.stage.stageHeight;
		
		trace(displayWidth, screenWidth, displayHeight, screenHeight);

        if (e != null)
        {
            setDim(cast width, cast height);
            x = x;
            y = y;
        }
    }
	
}