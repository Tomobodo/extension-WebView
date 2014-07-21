package fr.tbaudon ;

import openfl.events.Event;
import openfl.Lib;
import openfl.display.Sprite;
import openfl.system.Capabilities;

class AbstractWebView extends Sprite {

    /** WebView true width **/
    var mWidth : Float;
    /** WebView true height **/
    var mHeight : Float;

    /**
	 * If a fixed window size is set, openfl will scale the game to fit the screen so the coordinate passed
	 * to android webView won't be corresponding. We need to multiply every coordinate passed by this ratio.
	 */
    var mScaleX : Float;
    var mScaleY : Float;
    var mOffsetX : Float;
    var mOffsetY : Float;

    /**
    *   @param defaultUrl : String default url to load
    *   @param w : Float width of the window
    *   @param h : Float height of the window
    **/
    function new(defaultUrl : String, w : Float = 400, h : Float = 400){
        super();

        computeScale();

        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
        Lib.current.stage.addEventListener(Event.RESIZE, computeScale);

        x = 0;
        y = 0;
		setDim(w, h);
		loadUrl(defaultUrl);
    }

    /**
    *   Compute the scale factor of openfl stage
    *   of the view width and height when openfl strech
    *   the game to fit the screen
    **/
    function computeScale(e : Event = null)
    {
        var ratio = Lib.current.stage.stageWidth / Lib.current.stage.stageHeight;

        var displayWidth : Float;
        var displayHeight : Float;

        if (Capabilities.screenResolutionX>=Capabilities.screenResolutionY) {
            displayHeight = Capabilities.screenResolutionY;
            displayWidth = displayHeight * ratio;
            mOffsetX = (Capabilities.screenResolutionX - displayWidth) / 2;
            mOffsetY = 0;
        }else {
            displayWidth = Capabilities.screenResolutionX;
            displayHeight = displayWidth / ratio;
            mOffsetX = 0;
            mOffsetY = (Capabilities.screenResolutionY - displayHeight) / 2;
        }

        mScaleX = displayWidth / Lib.current.stage.stageWidth;
        mScaleY = displayHeight / Lib.current.stage.stageHeight;

        if (e != null)
        {
            setDim(cast width, cast height);
            x = x;
            y = y;
        }
    }

    /**
    *   Executed when the webView is removed from the game.
    **/
    function onRemovedFromStage(e : Event){
        throw 'onRemovedFromStage is not overridden.';
    }

    /**
    *   Executed when the webView is added to the game.
    **/
    function onAddedToStage(e : Event){
        throw 'onAddedToStage is not overridden.';
    }

    /**
     *  Set the webView position
     *  @param x : Float
     *  @param y : Float
     */
    function setPos(x : Float, y : Float){
        throw 'setPos is not overridden.';
    }

    /**
     *  Apply the the width and height to the webView
     *  @param w : Float
     *  @param h : Float
     */
    function applyDim(w : Float, h : Float){
        throw 'applyDim is not overridden.';
    }

    /**
     * Set the x position
     * @param x : Float
     */
    override function set_x(x : Float) : Float {
        setPos(x * mScaleX + mOffsetX, y * mScaleY + mOffsetY);
        return super.set_x(x);
    }

    /**
     * Set the y position
     * @param y : Float
     */
    override function set_y(y : Float) : Float {
        setPos(x * mScaleX + mOffsetX, y * mScaleY + mOffsetY);
        return super.set_y(y);
    }

    /**
     * @return width : Float
     */
    override function get_width() : Float {
        return mWidth / mScaleX;
    }

    /**
     * @return height : Float
     */
    override function get_height() : Float {
        return mHeight / mScaleY;
    }

    /**
    *   Set the webview to verbose mode so that you can check what's happening
    **/
    public function setVerbose(verbose : Bool){
        throw 'setVerbose is not overridden.';
    }

    /**
    *   Load the specified url
    *   @param url : String the url to load
    **/
    public function loadUrl(url : String){
        throw 'loadUrl is not overridden.';
    }

    /**
     * Set the webView's dimmensions
     * @param w : Float width
     * @param h : Float height
     */
    public function setDim(w : Float, h : Float){
        w *= mScaleX;
        h *= mScaleY;
        mWidth = w;
        mHeight = h;
        applyDim(w,h);
    }

    /**
     *  Free the webView from memory
     */
    public function dispose(){
        throw 'dispose is not overridden.';
    }

}