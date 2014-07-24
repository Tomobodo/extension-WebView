package fr.tbaudon;

import cpp.Lib;
import openfl.events.Event;

class IOsWebView extends AbstractWebView {

    /**************************************************
    / CPP LINKING
    */
    static var openflwebview_test = Lib.load("openflwebview", 'openflwebview_test',0);
    static var openflwebview_create = Lib.load("openflwebview", 'openflwebview_create', 3);
    static var openflwebview_onAdded = Lib.load("openflwebview", "openflwebview_onAdded", 1);
    static var openflwebview_onRemoved = Lib.load("openflwebview", "openflwebview_onRemoved", 1);

    /**************************************************
    * Members
    **/
    var mId : Int;

    public function new(defaultUrl : String = "http://www.baudon.me", w : Float = 400, h : Float = 400) {
        mId = openflwebview_create(defaultUrl, w, h);
        trace(mId);
        super(defaultUrl, w, h);
    }

    override public function setVerbose(verbose : Bool){
        trace("iOs setVerbose not done yet.");
    }

    override public function setPos(x : Float, y : Float){
        trace("iOs setPos not done yet.");
    }

    override public function loadUrl(url : String){
        trace("iOs loadUrl not done yet.");
    }

    override public function applyDim(w : Float, h : Float){
        trace("iOs applyDim not done yet.");
    }

    override public function dispose(){
        trace("iOs dispose not done yet.");
    }

    override function onAddedToStage(e : Event){
        openflwebview_onAdded(mId);
    }

    override function onRemovedFromStage(e : Event){
        openflwebview_onRemoved(mId);
    }

}