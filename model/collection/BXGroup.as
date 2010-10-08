package bloxley.model.collection {
    
    import bloxley.model.collection.*;
    import bloxley.model.game.BXPatch;

    public class BXGroup extends BXSet {

    	/***************
    	*              *
    	* Constructors *
    	*              *
    	***************/

    	public function BXGroup(of:Object = null) {
    		super(of);
    	}

    	override public function another(of:Object = null):BXSet {
    		return new BXGroup(of);
    	}

    	/**************
    	*             *
    	* That Are At *
    	*             *
    	**************/

        public function thatAreAt(patch:BXPatch):BXGroup {
            return thatAre( function(actor) { return actor.whereAmI().contains(patch); } );
    	}

        public function thatAreNotAt(patch:BXPatch):BXGroup {
    		return thatAreNot( function(actor) { return actor.whereAmI().contains(patch); } );
    	}

    	/**************
    	*             *
    	* That Are In *
    	*             *
    	**************/

        public function thatAreIn(region:BXRegion):BXGroup {
    		return thatAre( function(actor) { return actor.whereAmI().overlaps(region); } );
        }

        public function thatAreNotIn(region:BXRegion):BXGroup {
            return thatAreNot( function(actor) { return actor.whereAmI().overlaps(region); } );
        }

    	/******************
    	*                 *
    	* That Are Within *
    	*                 *
    	******************/

        public function thatAreWithin(region:BXRegion):BXGroup {
            return thatAre( function(actor) { return actor.whereAmI().containedIn(region); } );
        }

        public function thatAreNotWithin(region:BXRegion):BXGroup {
            return thatAreNot( function(actor) { return actor.whereAmI().containedIn(region); } );
        }

    	/******************
    	*                 *
    	* That Are Active *
    	*                 *
    	******************/

    	public function thatAreActive():BXGroup {
    		return thatAre( function(actor) { return actor.isActive(); })
    	}

    	public function thatAreNotActive():BXGroup {
    		return thatAreNot( function(actor) { return actor.isActive(); })
    	}

    	/*********************
    	*                    *
    	* That Can Be Player *
    	*                    *
    	*********************/

    	public function thatCanBePlayer() {
    		return thatAre( function(actor) { return actor.isActive() && actor.canBePlayer(); })
    	}

    }

}