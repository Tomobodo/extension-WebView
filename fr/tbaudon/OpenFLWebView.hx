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
	
	
	public static function sampleMethod (inputValue:Int):Int {
		
		#if (android && openfl)
		
		var resultJNI = openflwebview_sample_method_jni(inputValue);
		var resultNative = openflwebview_sample_method(inputValue);
		
		if (resultJNI != resultNative) {
			
			throw "Fuzzy math!";
			
		}
		
		return resultNative;
		
		#else
		
		return openflwebview_sample_method(inputValue);
		
		#end
		
	}
	
	
	private static var openflwebview_sample_method = Lib.load ("openflwebview", "openflwebview_sample_method", 1);
	
	#if (android && openfl)
	private static var openflwebview_sample_method_jni = JNI.createStaticMethod ("fr.tbaudon.OpenFLWebView", "sampleMethod", "(I)I");
	#end
	
	
}