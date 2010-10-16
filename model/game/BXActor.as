package bloxley.model.game {
    
    import bloxley.base.BXObject;
    import bloxley.controller.event.*;
    import bloxley.controller.game.BXActorController;
    import bloxley.model.game.*;
    import bloxley.model.collection.BXRegion;
    import bloxley.view.gui.BXGrid;
    import bloxley.view.sprite.BXSprite;

    public class BXActor extends BXObject {

    	// What board is this object on?
    	var gameboard:BXBoard;

    	// What controls this actor?
    	var controller:BXActorController;

    	var info:Object;

    	// Where is this actor located?
    	var anchorPoint:BXPatch;
    	var region:BXRegion;

    	// Where was the actor at the start of this event?
    	var lastLocation:BXPatch;

    	// Is the registration point in the top left corner
    	// of the movie clip, or the middle?
    	var rectWidth:Number;
    	var rectHeight:Number;

    	// Is this object currently in play?
    	var active:Boolean;

    	/*******************************
    	*                              *
    	* Constructors and Destructors *
    	*                              *
    	*******************************/

    	function BXActor(controller:BXActorController, key:String, info:Object) {
    		this.controller = controller;

    		this.info = (info == null) ? new Object() : info;
    		setKey(key);

    		active = true;
    		
    		controller.initializeActor(this);
    	}

    	// Get rid of this object
    	function destroy() {
    		disable(true);
    		gameboard.removeActor(this);
    	}

        /****************
        *               *
        * Board Methods *
        *               *
        ****************/

    	public function board():BXBoard {
    		return gameboard;
    	}

    	public function setBoard(gameboard:BXBoard) {
    		this.gameboard = gameboard;
    	}

        public function gameIsStarted():Boolean {
            return gameboard.gameIsStarted;
        }

        /*****************
        *                *
        * Sprite Methods *
        *                *
        *****************/
        
        public function sprite():BXSprite {
            return controller.spriteForActor(this);
        }
        
        /*******************
        *                  *
        * Position Methods *
        *                  *
        *******************/

        public function location():BXPatch {
            return anchorPoint;
        }

    	// Place this object at the given grid anchorPoint
    	public function placeAt(newLocation:BXPatch) {
    		anchorPoint = newLocation;
    		region = null; // Don't generate region until needed...
    	}

    	/*****************
    	*                *
    	* Region methods *
    	*                *
    	*****************/

    	// What region of the board do I take up?
    	public function whereAmI():BXRegion {
    	    if (region == null) region = controller.regionForActor(this);
    		return region;
    	}

    	// Am I on the given space?
    	public function amIAt(newPatch:BXPatch):Boolean { 
    	    return whereAmI().contains(newPatch);
    	}

    	public function amIIn(newRegion:BXRegion):Boolean {
    		return whereAmI().overlaps(newRegion);
    	}

    	public function amIWithin(newRegion:BXRegion):Boolean {
    		return whereAmI().containedIn(newRegion);
    	}

    	public function amIStandingOn(patchKey:String):Boolean {
    		return whereAmI().areAllOfType(patchKey);
    	}

    	/*********************
    	*                    *
    	* Activation methods *
    	*                    *
    	*********************/

    	public function enable() {
    		active = true;
    		sprite().show();
    	}

    	public function disable(hide:Boolean) {
    		active = false;
    		region = null;

    		if (hide) sprite().hide();
    	}

    	public function isActive() {
    		return active;
    	}

    	// Make this the currently active player
    	public function makePlayer(current:Boolean) {
    		// SUBCLASS ONLY
    	}

    	public function canBePlayer():Boolean {
    		return controller.canBePlayer(this);
    	}

    	/**********************
    	*                     *
    	* Interaction methods *
    	*                     *
    	**********************/

    	// This object receives the beat
    	// SUBCLASS ONLY
    	public function beat() {}


    	/****************
    	*               *
    	* Event methods *
    	*               *
    	****************/

    	public function stepEvent(action:BXAction, actor:BXActor) {
    		// Active
    		actor.controller.resolveEvent(action, BXEvent.STEP_EVENT, actor, this);

    		// Passive
    		controller.resolveEvent(action, BXEvent.STEPPED_ON_EVENT, this, actor);
    	}

    	public function leaveEvent(action:BXAction, actor:BXActor) {
    		// Active
    		controller.resolveEvent(action, BXEvent.LEAVE_EVENT, actor, this);

    		// Passive
    		controller.resolveEvent(action, BXEvent.LEFT_EVENT, this, actor);
    	}

    	public function startingLocation():BXPatch {
    		return lastLocation;
    	}

    	/***************
    	*              *
    	* Info methods *
    	*              *
    	***************/

    	public function key():String {
    		return info.key;
    	}

    	public function setKey(theKey:String) {
    		info.key = theKey;
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

    	/*********************
    	*                    *
    	* Controller methods *
    	*                    *
    	*********************/

        public function actorController():BXActorController {
            return controller;
        }
        
    	public function ask(methodName) {
    	    controller[methodName].apply(controller, arguments.splice(0, 1, this));
    	}

    	public function good():Boolean {
    	    return controller.isGood(this);
    	}

    	/*****************
    	*                *
    	* Saving methods *
    	*                *
    	*****************/

        /*
        
        // Should this object be included on the board itself?
        function includeOnBoard() { return controller.includeOnBoard(this); }

    	// Create an xml representation of this object
    	// SUBCLASS ONLY
    	function toXml():String{
    		return controller.toXml(this);
    	}

        */
        
    	/******************
    	*                 *
    	* Utility methods *
    	*                 *
    	******************/

    	// Create a string representation of this object, for debugging purposes
    	override public function toString():String {
    		var str = getDescriptionString();

    		if (str == "")
    			return "#<" + key() + ":" + id() + " @ " + anchorPoint + ">";
    		else
    			return "#<" + key() + ":" + id() + " @ " + anchorPoint + ", { " + getDescriptionString() + " }>";
    	}

    	function getDescriptionString():String {
    		return controller.getDescriptionString(this);
    	}

    }

}
