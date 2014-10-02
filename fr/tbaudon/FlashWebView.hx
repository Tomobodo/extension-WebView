package fr.tbaudon;
import cocktail.api.CocktailView;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;

import cocktail.api.Cocktail;

/**
 * ...
 * @author Thomas B
 */
class FlashWebView extends Sprite
{
	var mCocktailView:CocktailView;
	
	var mW : Float;
	var mH : Float;
	var mClose:Bitmap;
	var mUrl:String;

	public function new(defaultUrl : String, w : Float = 400, h : Float = 400, close : Bool = false) 
	{
		super();
		mUrl = defaultUrl;
		mCocktailView = new CocktailView();
		mCocktailView.loadURL(defaultUrl);
		mCocktailView.viewport = { x : 0, y : 0, width : cast w, height : cast h };
		addChild(mCocktailView.root);
		
		
		mW = w;
		mH = h;
		
		if (close)
			addCloseBtn();
	}
	
	public function loadUrl(url : String) {
		if(url != mUrl){
			mCocktailView.loadURL(url);
			mUrl = url;
		}
	}
	
	public function addCloseBtn(){
        mClose = new Bitmap(Assets.getBitmapData("webviewui/close_mdpi.png"));
		addChild(mClose);
		var a :Sprite = new Sprite();
		a.x = mW - mClose.width * 0.75;
		a.y = -mClose.height * 0.25;
		a.addChild(mClose);
		addChild(a);
		a.addEventListener(MouseEvent.CLICK, onCloseClicked);
    }
	
	function onCloseClicked(e:MouseEvent) 
	{
		dispatchEvent(new Event("close"));
	}

}