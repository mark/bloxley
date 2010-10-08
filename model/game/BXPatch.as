package bloxley.model.game {
    
    import bloxley.base.BXObject;
    import bloxley.controller.event.BXAction;
    import bloxley.controller.event.BXEvent;
    import bloxley.controller.game.*;
    import bloxley.model.data.BXDirection;
    import bloxley.model.game.*;
    import bloxley.view.gui.BXGrid;

    public class BXPatch extends BXObject {

    	// Controller

    	var controller:BXPatchController;

    	// Model

    	var gameboard:BXBoard;

    	var locationX:Number;
    	var locationY:Number;

    	var info:Object;

    	public function BXPatch(controller:BXPatchController, key:String) {
    		this.controller = controller;

    		this.info = new Object();

    		// listenFor("BXPatchAnimationCreated",   this, animationCreated);
    		// listenFor("BXPatchAnimationDestroyed", this, animationDestroyed);

    		setKey(key);
    	}

    	// Get rid of this patch, doesn't use undo
    	public function destroy() {
    		//movieClip.removeMovieClip();
    	}

        /*********************
        *                    *
        * Controller Methods *
        *                    *
        *********************/
        
        public function patchController():BXPatchController {
            return controller;
        }
        
    	/****************
    	*               *
    	* Board methods *
    	*               *
    	****************/

    	public function board():BXBoard {
    		return gameboard;
    	}

    	public function attach(gameboard:BXBoard, locationX:Number, locationY:Number) {
    		this.gameboard = gameboard;

    		this.locationX = locationX;
    		this.locationY = locationY;
    	}

    	/*******************
    	*                  *
    	* Location methods *
    	*                  *
    	*******************/

    	public function x():Number {
    		return locationX;
    	}

    	public function y():Number {
    		return locationY;
    	}

    	public function depth():Number {
    		return y() * board().width() + x();
    	}

    	public function distance(other:BXPatch):Number {
    		var dx = x() - other.x();
    		var dy = y() - other.y();

    		return Math.sqrt(dx * dx + dy * dy);
    	}

    	public function reposition(locationX:Number, locationY:Number) {
    	    this.locationX = locationX;
    	    this.locationY = locationY;
    	}

    	/*******************
    	*                  *
    	* Neighbor methods *
    	*                  *
    	*******************/

    	public function inDirection(direction:BXDirection, steps:Number = NaN):BXPatch {
    		if (isNaN(steps)) steps = 1;

    		return board().getPatch(x() + steps * direction.dx(), y() + steps * direction.dy());
    	}

    	/****************
    	*               *
    	* Event methods *
    	*               *
    	****************/

    	public function enterEvent(action:BXAction, actor:BXActor) {
    		return controller.resolveEvent(action, BXEvent.ENTER_EVENT, actor, this);
    	}

    	public function exitEvent(action:BXAction, actor:BXActor) {
    		return controller.resolveEvent(action, BXEvent.EXIT_EVENT, actor, this);
    	}

    	/*****************************
    	*                            *
    	* Saving and Loading methods *
    	*                            *
    	*****************************/

    	public function exportPatch():String {
    		return ""; // controller.exportPatch(this);
    	}

    	/***************
    	*              *
    	* Info methods *
    	*              *
    	***************/

    	public function key():String {
    		return info.key;
    	}

    	public function setKey(newKey:String) {
    		info.key = newKey;
    		// setFrame();
    	}

    	public function isA(testKey:String):Boolean {
    		return key() == testKey;
    	}

    	public function get(infoKey:String) {
    		return info[infoKey];
    	}

    	public function set(infoKey:String, value) {
    		info[infoKey] = value;
    	}

    	/******************
    	*                 *
    	* Utility methods *
    	*                 *
    	******************/

    	override public function toString():String {
    		return "(" + key() + ": " + locationX + ", " + locationY + ")";
    	}
    }
    
}