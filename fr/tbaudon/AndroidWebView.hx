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
	
	var mUrlToLoad : String;
	
	var mWebViewReady : Bool;
	
	public function new(defaultUrl : String = "http://www.baudon.me", width : UInt = 400, height : UInt = 400) {
		super();
		
		mWebViewReady = false;
		mJNIInstance = create_jni(this, width, height);
		mUrlToLoad = defaultUrl;
		
		addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
	}
	
	public function loadUrl(url : String) {
		mUrlToLoad = url;
		if(mWebViewReady)
			loadUrl_jni(mJNIInstance, url);
	}
	
	private function onWebViewInited() {
		mWebViewReady = true;
		loadUrl(mUrlToLoad);
	}
	
	private function onRemovedFromStage(e:Event):Void 
	{
		
	}
	
	private function onAddedToStage(e:Event):Void 
	{
		add_jni(mJNIInstance);
	}
	
}