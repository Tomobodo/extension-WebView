package fr.tbaudon ;

import flash.display.Stage;
import flash.events.Event;
import openfl.display.Sprite;
import openfl.events.FocusEvent;
import openfl.events.KeyboardEvent;

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
	
	/*************************************************************/
	
	// Members
	var mJNIInstance : Dynamic;
	var mQueue : Array<{func : Dynamic, params : Array<Dynamic>}>;
	
	var mUrlToLoad : String;
	
	var mWebViewReady : Bool;
	
	public function new(defaultUrl : String = "http://www.baudon.me", width : UInt = 400, height : UInt = 400) {
		super();
		
		mQueue = new Array<{func : Dynamic, params : Array<Dynamic>}>();
		
		mWebViewReady = false;
		mJNIInstance = create_jni(this, width, height);
		
		loadUrl(defaultUrl);
		
		addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
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
		trace("inited");
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
	
}