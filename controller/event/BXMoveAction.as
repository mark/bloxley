package bloxley.controller.event {
    
    import bloxley.model.data.BXDirection;
    import bloxley.model.game.*;
    import bloxley.controller.event.*;

    public class BXMoveAction extends BXBehavior {

    	var _direction:BXDirection;
    	var steps:Number;

    	var oldPosition:BXPatch;
    	public var newPosition:BXPatch;

    	public function BXMoveAction(actor:BXActor, _direction:BXDirection, steps:Number = NaN) {
    		super(actor);
    		setKey("Move");

    		this._direction = _direction;
    		this.steps = isNaN(steps) ? 1 : steps;
    	}

        public function direction():BXDirection {
            return _direction;
        }
        
    	override public function act() {
    		oldPosition = actor().location();
    		newPosition = oldPosition.inDirection(_direction, steps);

    		actor().placeAt(newPosition);
    	}

    	override public function undo() {
    		actor().placeAt(oldPosition);
    	}

        override public function animateUndo() {
            actor().sprite().goto(oldPosition);
        }

        override public function description():String {
            return key() + "<" + actor().key() + ">";
        }

    }
    
}