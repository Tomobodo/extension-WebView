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
	
	private static var inited : Bool;
	
	public static function init() {
		if (!inited) {
			inited = true;
			#if android
			init_jni();
			#end
		}
	}
	
	public static function show(url : String) {
		#if android
		show_jni(url);
		#end
	}
	
	#if (android && openfl)
	private static var init_jni = JNI.createStaticMethod("fr.tbaudon.OpenFLWebView", "init", "()V");
	private static var show_jni = JNI.createStaticMethod("fr.tbaudon.OpenFLWebView", "show", "(Ljava/lang/String;)V");
	#end
	
}