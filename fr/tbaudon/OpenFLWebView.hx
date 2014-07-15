package fr.tbaudon ;

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
	
	public static function init(caller : Dynamic, popup:Bool = false) {
		#if android
		init_jni(caller, popup);
		#end
	}
	
	#if (android && openfl)
	private static var init_jni = JNI.createStaticMethod("fr.tbaudon.OpenFLWebView", "init", "(Lorg/haxe/lime/HaxeObject;Z)V");
	#end
	
}