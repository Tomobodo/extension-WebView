package fr.tbaudon;


import openfl.Lib;
import openfl.events.Event;
import openfl.display.Sprite;
import openfl.system.Capabilities;

class IOsWebView extends AbstractWebView {

    /**************************************************
    / CPP LINKING
    */

    static var openflwebview_create = cpp.Lib.load("openflwebview", 'openflwebview_create', 3);
    static var openflwebview_onAdded = cpp.Lib.load("openflwebview", "openflwebview_onAdded", 1);
    static var openflwebview_onRemoved = cpp.Lib.load("openflwebview", "openflwebview_onRemoved", 1);
    static var openflwebview_setPos = cpp.Lib.load("openflwebview", "openflwebview_setPos", 3);
    static var openflwebview_setDim = cpp.Lib.load("openflwebview", "openflwebview_setDim", 3);
    static var openflwebview_dispose = cpp.Lib.load("openflwebview", "openflwebview_dispose", 1);
    static var openflwebview_loadUrl = cpp.Lib.load("openflwebview", "openflwebview_loadUrl", 2);
    static var openflwebview_addCloseBtn = cpp.Lib.load("openflwebview", "openflwebview_addCloseBtn", 1);
    static var openflwebview_setCallback = cpp.Lib.load("openflwebview", "openflwebview_setCallback", 1);

    /**************************************************
    * Members
    **/
    var mId : Int;

    public function new(defaultUrl : String = "http://www.baudon.me", w : Float = 400, h : Float = 400, close : Bool = false) {
        mId = openflwebview_create(defaultUrl, w, h);
        super(defaultUrl, w, h);
        if(close) addCloseBtn();
        openflwebview_setCallback(onIosEvent);
    }

    function onIosEvent(name : String, params : String){
        trace(name, params);
        switch(name){
            case "close" :
                dispatchEvent(new Event('close'));
        }
    }

    override public function setVerbose(verbose : Bool){
        trace("iOs setVerbose not done yet.");
    }

    override public function setPos(x : Float, y : Float){
        openflwebview_setPos(mId, x, y);
    }

    override public function loadUrl(url : String){
        openflwebview_loadUrl(mId, url);
    }

    override public function addCloseBtn(){
        openflwebview_addCloseBtn(mId);
    }

    override public function applyDim(w : Float, h : Float){
        openflwebview_setDim(mId,w,h);
    }

    override public function dispose(){
        openflwebview_dispose(mId);
    }

    override function onAddedToStage(e : Event){
        openflwebview_onAdded(mId);
        x = x;
        y = y;
    }

    override function onRemovedFromStage(e : Event){
        openflwebview_onRemoved(mId);
    }

    /*override function computeScale(e : Event = null)
    {
        var ratio = Lib.current.stage.stageWidth / Lib.current.stage.stageHeight;
        var screenRatio = Capabilities.screenResolutionY / Capabilities.screenResolutionX;

        var displayWidth : Float;
        var displayHeight : Float;

        if(screenRatio < ratio)
            if (ratio >= 1) {
                displayWidth = Capabilities.screenResolutionY;
                displayHeight = displayWidth / ratio;

                mOffsetX = (Capabilities.screenResolutionY - displayWidth) / 2;
                mOffsetY = (Capabilities.screenResolutionX - displayHeight) / 2;
            }else {
                displayWidth = Capabilities.screenResolutionX;
                displayHeight = displayWidth / ratio;

                mOffsetX = (Capabilities.screenResolutionX - displayWidth) / 2;
                mOffsetY = (Capabilities.screenResolutionY - displayHeight) / 2;
            }
        else
            if (ratio >= 1) {

                displayHeight = Capabilities.screenResolutionX;
                displayWidth = displayHeight * ratio;

                mOffsetX = (Capabilities.screenResolutionY - displayWidth) / 2;
                mOffsetY = (Capabilities.screenResolutionX - displayHeight) / 2;
                trace("landscape");
            }else {
                displayWidth = Capabilities.screenResolutionX;
                displayHeight = displayWidth * ratio;

                mOffsetX = (Capabilities.screenResolutionX - displayWidth) / 2;
                mOffsetY = (Capabilities.screenResolutionY - displayHeight) / 2;
                trace("portrait");
            }

        mScaleX = displayWidth / Lib.current.stage.stageWidth;
        mScaleY = displayHeight / Lib.current.stage.stageHeight;

        if (e != null)
        {
            setDim(cast width, cast height);
            x = x;
            y = y;
        }
    }*/
}