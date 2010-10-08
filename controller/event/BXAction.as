package bloxley.controller.event {
    
    import bloxley.base.BXObject;
    import bloxley.controller.event.*;
    import bloxley.view.animation.*;
    import bloxley.view.choreography.BXParallelRoutine;

    public class BXAction extends BXObject {

    	var event:BXEvent;

        // Choreography

        var _key:String;

    	// Causality

    	var cause:BXAction;
    	var causeKey:String;

    	public var effects:Array;

    	var performed:Boolean;
    	var animated:Boolean;
    	var cancelled:Boolean;
        var failed:Boolean;

    	// Animation

    	var _animation:BXSchedulable;

    	/**************
    	*             *
    	* Constructor *
    	*             *
    	**************/

    	public function BXAction() {
    		effects = new Array();
    		setKey("_Action");

    		performed = false;
    		animated = false;
    		cancelled = false;
    		failed = false;
    	}

    	/**************
    	*             *
    	* Key methods *
    	*             *
    	**************/

    	public function key():String {
    	    return _key;
    	}

    	public function isA(k:String):Boolean {
    	    return key() == k;	    
    	}

    	public function setKey(newKey:String) {
    	    _key = newKey;
    	}

    	/*******************************
    	*                              *
    	* Event Initialization methods *
    	*                              *
    	*******************************/

    	// public function wait(immediateMode:Boolean = false):BXAction {
    	// 	event = new BXEvent();
        // 
    	// 	if (immediateMode) { event.immediately(); }
        // 
    	// 	event.postAction(this);
        // 
    	// 	return this;
    	// }
        // 
    	// public function start(postToUndoQueue:Boolean = true):Boolean {
    	// 	if (event == null) wait();
        // 
    	// 	return event.start(postToUndoQueue);
    	// }

    	/**********************
    	*                     *
    	* Event Chain methods *
    	*                     *
    	**********************/

    	public function originalCause() {
    		return event.originalCause();
    	}

    	public function cancelEffects() {
    		for (var i = 0; i < effects.length; i++)
    			effects[i].stopAction();
    	}

    	public function stopAction() {	
    		cancelled = true;

    		cancelEffects();

    		if (performed) undo();
    	}

    	public function resolve() {
    		performed = true;

    		act();
    	}

    	/**************************
    	*                         *
    	* Failure Cascade methods *
    	*                         *
    	**************************/

    	public function safelyFailed(effect:BXAction) {
    		// This is for actions that you don't want to fail out the entire event chain.
    		// You probably don't want to overwrite this.  If you want something different,
    		// Then give it a custom cause key
    	}

    	public function effectFailed(effect:BXAction) {
    		// This is the catch-all effect failure method.
    		// You probably don't want to overwrite this.  If you want something different,
    		// Then give it a custom cause key
    		fail();
    	}

        /****************
        *               *
        * State Methods *
        *               *
        ****************/
        
        public function didPerform():Boolean {
            return performed;
        }
        
    	public function didAnimate():Boolean {
    	    return animated;
    	}
    	
    	public function didCancel():Boolean {
    	    return cancelled;
    	}
    	
        public function didFail():Boolean {
            return failed;
        }
    	
    	/***************************
    	*                          *
    	* Event Resolution methods *
    	*                          *
    	***************************/

    	public function succeed() {
    		// This is for code readability & debugging purposes, for now (?)
    	}

    	public function fail() {
    	    failed = true;
    		stopAction();

    		if (cause != null) {
    			var fcn = cause[causeKey + "Failed"];
    			if (fcn == null) fcn = cause["effectFailed"];

    			fcn.call(cause, this);
    		} else {
    			event.failed();
    		}
    	}

    	public function causes(other:BXAction, causeKey:String = "effect"):BXAction {
    		other.cause = this;
    		other.causeKey = causeKey;

    		effects.push(other);
    		event.postAction(other);

    		return other;
    	}

    	// Helper methods

    	public function safelyCauses(other:BXAction) {
    	    causes(other, "safely");
    	}

    	public function require(condition:Boolean, action:BXAction) {
    		if (condition) {
    			succeed();
    		} else {
    			if (action == null)
    				fail();
    			else
    				causes(action);
    		}
    	}

    	/********************
    	*                   *
    	* Animation Methods *
    	*                   *
    	********************/

    	public function animate() {
    		// SUBCLASS ONLY!
    		return null; // <--- generates an empty animation
    	}

    	public function animateUndo() {
    	    // SUBCLASS ONLY!
    	    return null; // <-- generates nothing
    	}

    	// This should be part of the choreographer...
    	public function animation():BXSchedulable {
    	    if (_animation == null) {
        	    var animation = animate();

        	    if (animation is Array) {
                    _animation = new BXParallelRoutine(animation);
                } else if (animation == null) {
                    _animation = new BXEmptyAnimation();
                } else {
                    _animation = animation;
                }

                // _animation.wait();
    	    }

    	    animated = true;
    	    return _animation;
    	}

    	/********************
    	*                   *
    	* Command functions *
    	*                   *
    	********************/

    	public function act() {
    		// SUBCLASS ONLY!
    	}

    	public function undo(){
    		// SUBCLASS ONLY!
    	}

        public function revert() {
            undo();

            if (animated) {
                animateUndo();
            }
        }

    	/******************
    	*                 *
    	* Utility Methods *
    	*                 *
    	******************/

    	public function description():String {
    	    return key();
    	}

    	override public function toString():String {
    	    var string = (failed ? '*' : '') + description();

    	    if (effects.length > 1) {
    	        string += " => [ ";

        	    for (var i = 0; i < effects.length; i++) {
        	        string += effects[i];

        	        if (i < (effects.length - 1)) string += ", ";
        	    }

        	    string += "]";
    	    } else if (effects.length == 1) {
    	        string += " => " + effects[0];
            }

    	    return string;
    	}	

    }

}