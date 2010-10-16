package bloxley.controller.event {
    
    import bloxley.base.BXObject;
    import bloxley.controller.game.BXController;
    import bloxley.controller.event.*;
    import bloxley.view.animation.*;
    import bloxley.view.choreography.*;

    public class BXEvent extends BXObject {

    	// Event Types

    	public static var      ENTER_EVENT = "Enter";
    	public static var       EXIT_EVENT = "Exit";

    	public static var       STEP_EVENT = "StepOn";
    	public static var STEPPED_ON_EVENT = "BeSteppedOnBy"

    	public static var      LEAVE_EVENT = "Leave";
    	public static var       LEFT_EVENT = "BeLeftBy";

    	// Instance Variables

        var controller:BXController;
        
    	var actions:Array;
    	var failure:Boolean;

        var milestone:Boolean;
        
    	public function BXEvent(controller:BXController, milestone:Boolean = true) {
    	    this.controller = controller;
    	    this.milestone = milestone;
    	    
    		actions = new Array();
    		failure = false;
    	}

        /*********************
        *                    *
        * Event Flow Methods *
        *                    *
        *********************/
        
    	public function start() {
    		var currentPosition = 0;

    		while (! failure && currentPosition < actions.length) {
    			var action = actions[currentPosition];
    			if (! action.cancelled) action.resolve();

    			currentPosition++;
    		}

            // Uncomment the following line to get a description of each event as it occurs:
            // trace(this);

            if (didSucceed()) {
                //post("BXEventSucceeded", this);
                
                controller.eventSucceeded(this);
            } else {
                post("BXEventFailed");
    		    return false;
    	    }

    	}

    	public function undo() {
    		for (var i = actions.length-1; i >= 0; i--) {
    			if (actions[i].performed) actions[i].revert();
    		}
    	}

        /*****************
        *                *
        * Action Methods *
        *                *
        *****************/
        
        public function handle(actions:Array) {
            for (var i = 0; i < actions.length; i++) {
                postAction( actions[i] );
            }
            
            start();
        }
        
    	public function originalCause():BXAction {
    		return actions[0];
    	}

    	public function postAction(action:BXAction) {
    		if (didFail() || didSucceed()) {
        		actions.push(action);
        		action.event = this;
    		}
    	}

        /*****************
        *                *
        * Status Methods *
        *                *
        *****************/
        
        public function didFail():Boolean {
            return failure;
        }
        
        public function didSucceed():Boolean {
            return ! failure;
        }
        
    	public function failed() {
    		failure = true;
    	}

        public function isMilestone():Boolean {
            return milestone;
        }
        
        /*****************
        *                *
        * Helper Methods *
        *                *
        *****************/
        
        override public function toString():String {
            return originalCause().toString();
        }

    }

}