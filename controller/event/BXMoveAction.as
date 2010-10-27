package bloxley.controller.event {
    
    import bloxley.model.data.BXDirection;
    import bloxley.model.game.*;
    import bloxley.controller.event.*;

    public class BXMoveAction extends BXBehavior {

    	var _direction:BXDirection;
    	var _steps:Number;

    	public var oldPosition:BXPatch;
    	public var newPosition:BXPatch;

    	public function BXMoveAction(actor:BXActor, _direction:BXDirection, _steps:Number = NaN) {
    		super(actor);
    		setKey("Move");

    		this._direction = _direction;
    		this._steps = isNaN(_steps) ? 1 : _steps;
    	}

        public function direction():BXDirection {
            return _direction;
        }
        
        public function steps():int {
            return _steps;
        }

    	override public function act() {
    		oldPosition = actor().location();
    		newPosition = oldPosition.inDirection(_direction, _steps);

    		actor().placeAt(newPosition);
    	}

    	override public function undo() {
    		actor().placeAt(oldPosition);
    	}

        override public function description():String {
            return key() + "<" + actor().key() + ">";
        }

    }
    
}