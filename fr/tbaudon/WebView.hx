package fr.tbaudon ;

#if android
typedef WebView = AndroidWebView;
#else
class WebView extends AbstractWebView{
    public new(defaultUrl : String, w : Float = 400, h : Float = 400){
        super();
    }
}
#end


