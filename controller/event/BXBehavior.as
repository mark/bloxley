package bloxley.controller.event {
    
    import bloxley.model.collection.BXRegion;
    import bloxley.model.game.BXActor;
    import bloxley.controller.event.*;
    import bloxley.controller.mailbox.*;

    public class BXBehavior extends BXAction {

    	var _actor:BXActor;

    	public function BXBehavior(actor:BXActor) {
    	    setKey("_Behavior");

    		this._actor = actor;
    	}

    	public function actor():BXActor { return _actor; }

    	/********************
    	*                   *
    	* Animation Methods *
    	*                   *
    	********************/

    	override public function animate() {
    	    var actorController = actor().actorController();
    	    return actorController["animate" + key()](actor(), this);
    	}

    	/***************************
    	*                          *
    	* Event Resolution methods *
    	*                          *
    	***************************/

    	override public function resolve() {
    		var oldRegion = _actor.whereAmI();

    		performed = true;

    		act();

    		var newRegion = _actor.whereAmI();

    		actorEntersRegion(_actor, oldRegion, newRegion);
    	}

    	public function actorEntersRegion(actor:BXActor, oldRegion:BXRegion, newRegion:BXRegion) {
    		var self = this;

    		// Validity check -- can't walk off the board
                
    			if (! newRegion.isValid()) return fail();

        	// Now we have to test for the actors

        	var oldActors = actor.board().allActors().thatAreIn(oldRegion);
        	var newActors = actor.board().allActors().thatAreIn(newRegion);

        	// Actors that you're stepping on

        		var steppedActors = newActors.minus(oldActors);

        		steppedActors.each( function(other) { if (! self.failed && actor != other) other.stepEvent(self, actor); } );

        	// Actors that you're leaving

        		var leftActors = oldActors.minus(newActors);

        		leftActors.each( function(other) { if (! self.failed && actor != other) other.leaveEvent(self, actor); } );

    		// Patches that you're entering into

    			var enteredPatches = newRegion.minus(oldRegion);

    			enteredPatches.each( function(patch) { if (! self.failed) patch.enterEvent(self, actor); } );

    		// Patches that you're exiting from

    			var exitedPatches = oldRegion.minus(newRegion);

    			exitedPatches.each( function(patch) { if (! self.failed) patch.exitEvent(self, actor); } );

    	}

    }

}