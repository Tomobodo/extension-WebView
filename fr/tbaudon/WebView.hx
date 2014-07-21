package fr.tbaudon ;

#if android
typedef WebView = AndroidWebView;
#elseif ios
typedef WebView = IOsWebView;
#else
class WebView extends AbstractWebView{
    public function new(defaultUrl : String = "http://www.google.com", w : Float = 400, h : Float = 400){
        super(defaultUrl, w, h);
    }
}
#end


