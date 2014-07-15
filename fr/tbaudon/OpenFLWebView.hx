package fr.tbaudon ;
import flash.display.Stage;
import flash.events.Event;
import openfl.events.KeyboardEvent;

#if cpp
import cpp.Lib;
#elseif neko
import neko.Lib;
#end

#if (android && openfl)
import openfl.utils.JNI;
#end


class OpenFLWebView {
	
	/*
	 * jni type cheat sheet :
	 * parameter type beetween (), return type after ()
	 * nonBasicObject : Lpath/to/class;
	 * void : V
	 * bool : Z
	 */
	
	private static var inited : Bool;
	private static var showing : Bool;
	private static var stage : Stage;
	
	public static function init(stage : Stage) {
		OpenFLWebView.stage = stage;
		if (!inited) {
			inited = true;
			#if android
			init_jni();
			#end
		}
	}
	
	public static function show(url : String) {
		if (!showing) {
			showing = true;
			#if android
			show_jni(url);
			#end
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
	}
	
	static private function onKeyUp(e:Event):Void 
	{
		e.stopPropagation();
		e.stopImmediatePropagation();
		trace("ferme pas");
	}
	
	#if (android && openfl)
	private static var init_jni = JNI.createStaticMethod("fr.tbaudon.OpenFLWebView", "init", "()V");
	private static var show_jni = JNI.createStaticMethod("fr.tbaudon.OpenFLWebView", "show", "(Ljava/lang/String;)V");
	#end
	
}