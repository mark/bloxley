package bloxley.model.game {
    
    import bloxley.controller.game.BXGame;
    import bloxley.model.collection.*;
    import bloxley.model.game.*;
    import bloxley.base.BXObject;

    public class BXBoard extends BXObject{

        // What games does this board belong to?
    	var game:BXGame;

    	// How big is the board (in cells), not set until loading a level
    	var patchesHigh = 0;
    	var patchesWide = 0;

    	// What does the floor look like?
    	//  Includes empty, pit, wall, exit
    	//  As a 2D array of patches
    	var patches:Array;
    	var patchSet:BXRegion;

    	// What GameObject are on this gameboard?
    	var objectSet:BXGroup;

    	// Server information for loading & saving
    	static var ServerURL:String;

    	var serverName:String;
    	var serverId = -1;    // By default, -1 means new & unsaved
        var serverIndex = -1;

    	// Has loading been finished?
    	var gameIsStarted;

    	/*******************************
    	*                              *
    	* Constructors and Destructors *
    	*                              *
    	*******************************/

    	// Create a GameBoard, with the given geometry
    	// Does not specify the width or height, or any data.
    	function BXBoard(game:BXGame) {
            this.game = game;

            // Initialize the patch array & region
            clearPatches();

    		// Initialize the objects group
    		objectSet = new BXGroup();

    		// Game hasn't been loaded yet...
    		gameIsStarted = false;
    	}

    	// Clear all of the movieclips associated with this board,
    	// For when loads fail, or when we're going to load a
    	// new level.
    	public function destroy() {
    		allPatches().each( function(patch) { patch.destroy(); } );

    		while (allActors().areThereAny()) {
    			allActors().theFirst().destroy();
    		}
    	}

    	/***************************
    	*                          *
    	* Server Parameter Methods *
    	*                          *
    	***************************/

    	// Set the id that this gameboard is on the server.
    	function setServerId(serverId) {
    		this.serverId = Number(serverId);
    	}

    	// What id is this on the server?
    	function getServerId() {
    	    return serverId;
    	}

    	function setServerIndex(serverIndex) {
    	    this.serverIndex = Number(serverIndex);
    	}

    	function getServerIndex() {
    	    return serverIndex;
    	}

    	function setServerName(serverName) {
    	    this.serverName = serverName;
    	}

    	function getServerName() {
    	    return serverName;
    	}

    	/****************
    	*               *
    	* Patch methods *
    	*               *
    	****************/

    	public function clearPatches():Array {
    	    if (allPatches() != null) {
        	    allPatches().each( function(patch) { patch.destroy(); } );
    	    }
    	    
    	    var oldPatches = patches;

    	    patches = new Array();
    	    patchSet = new BXRegion();
    	    patchesWide = 0;
    	    patchesHigh = 0;

    	    return oldPatches;
    	}

    	// Get the floor patch at the given location.
    	public function getPatch(locationX:Number, locationY:Number):BXPatch {
    		if ((locationX >= 0) && (locationX < width()) && (locationY >= 0) && (locationY < height()))
    			return patches[locationY][locationX];
    		else 
    			return null;
    	}

        // Set the patch's location to the given location.
    	public function attachPatch(patch:BXPatch, locationX:Number, locationY:Number) {
        	if (patches[locationY] == null) patches[locationY] = new Array();
        	patches[locationY][locationX] = patch;
            
    		patchSet.insert(patch);
    		patch.attach(this, locationX, locationY);
            
    		patchesWide = Math.max(patchesWide, locationX + 1);
    		patchesHigh = Math.max(patchesHigh, locationY + 1);
    		
    		post("BXPatchAttached", patch);
    	}

    	// How many cells wide is this board?
    	public function width():int {
    		return patchesWide;
    	}

    	// How many cells tall is this board?
    	public function height():int {
    		return patchesHigh;
    	}

        public function setDimensions(width:int, height:int) {
            patchesWide = width;
            patchesHigh = height;
        }
        
    	// Returns the grid region corresponding to the
    	// whole board.  Useful if you want to do something to
    	// every cell or patch.
    	public function allPatches():BXRegion {
    		return patchSet;
    	}

        /****************
        *               *
        * Actor Methods *
        *               *
        ****************/
        
    	// If possible, adds a GameObject to the gameboard at the given location
    	public function attachActor(actor:BXActor, location:BXPatch) {
    		objectSet.insert(actor);
    		actor.setBoard(this);
    		actor.placeAt(location);
    		
    		post("BXActorAttached", actor);
    	}

    	// Removes the object from the objects array
    	public function removeActor(actor:BXActor) {
    		objectSet.remove(actor);
    	}

        // A solution set of all the objects on the board.  Needed
        // all over the place to figure out which moves are valid, etc.
    	public function allActors():BXGroup {
    		return objectSet;
    	}

        // Only the active objects on the board.  Technically, this one is called more
        // than the previous (by outside objects).
        // It may be worthwhile to keep track of these, rather than generating a new one every time?
        public function allActiveObjects():BXGroup { return BXGroup(allActors().thatAre('isActive')); }

    	/*****************
    	*                *
    	* Player methods *
    	*                *
    	*****************/

        public function firstPlayer():BXActor {
            return objectSet.thatCanBePlayer().theFirst();
        }

    	public function nextPlayer(currentPlayer:BXActor):BXActor {
    		return objectSet.thatCanBePlayer().theNextAfter(currentPlayer);
    	}
        
       	/******************
       	*                 *
       	* Utility methods *
       	*                 *
       	******************/

        // Quick string representation, for debugging.
    	override public function toString():String { return "[" + width() + "x" + height() + "]"; }

    }

}
