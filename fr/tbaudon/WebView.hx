package fr.tbaudon ;

#if android
typedef WebView = AndroidWebView;
#else
import openfl.display.Sprite;

class WebView extends Sprite{
    public function new(){
        super();
    }
}
#end


