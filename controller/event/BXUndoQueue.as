package bloxley.controller.event {
    
    import bloxley.base.BXObject;
    import bloxley.controller.event.*;

    public class BXUndoQueue extends BXObject {
    	var undos:Array;

    	public function BXUndoQueue() {
    		undos = new Array();
    	}

    	public function undo() {
    	    var milestone = false;
    	    
    	    while (! milestone) {
        		if (undos.length == 0) return;

        		var mostRecent = undos.pop();

        		mostRecent.undo();
        		
        		milestone = mostRecent.isMilestone();
    	    }
    	}

    	public function postEvent(event:BXEvent) {
    		undos.push(event);
    	}

    	public function depth():Number {
    		return undos.length;
    	}

    	public function reset() {
    		while (depth() > 0) {
    			undo();
    		}
    	}

        public function lastEvent():BXEvent {
            return undos[ undos.length - 1 ];
        }

    }

}