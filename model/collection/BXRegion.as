package bloxley.model.collection {
    
    import bloxley.model.collection.*;
    import bloxley.model.data.BXDirection;
    import bloxley.model.game.BXBoard;

    public class BXRegion extends BXSet {

        var valid:Boolean;
        
    	/**********************
    	*                     *
    	* Constructor methods *
    	*                     *
    	**********************/

    	public function BXRegion(of:Object = null) {
    		valid = true;
    		super(of);
    	}

    	override public function another(of:Object = null):BXSet {
    		return new BXRegion(of);
    	}

    	public function board():BXBoard {
    	    return theFirst().board();
    	}

        override public function insert(what:Object) {
            if (what)
                super.insert(what);
            else
                valid = false;
    	}
    	
    	/*****************
    	*                *
    	* Region methods *
    	*                *
    	*****************/

        public function isValid():Boolean {
            return valid;
        }
        
    	public function inDirection(direction:BXDirection):BXRegion {
    		return map( function(patch) { return patch.inDirection(direction); } );
    	}

    	public function overlaps(other:BXRegion):Boolean {
    		return intersection(other).areThereAny();
    	}

    	public function containedIn(other:BXRegion):Boolean {
    		return intersection(other).howMany() == howMany();
    	}

    	public function bounds() {
    	    var b = { left: theFirst().x(), right: theFirst().x(), top: theFirst().y(), bottom: theFirst().y() };

    	    each( function(patch) {
    	       b.left   = Math.min(b.left,   patch.x());
    	       b.right  = Math.max(b.right,  patch.x());
    	       b.top    = Math.min(b.top,    patch.y());
    	       b.bottom = Math.max(b.bottom, patch.y());
    	    });

    	    return b;
    	}

        /*****************
        *                *
        * Helper Methods *
        *                *
        *****************/

        override public function toString():String {
            return super.toString() + (isValid() ? "" : "<*>");
        }

    }

}
