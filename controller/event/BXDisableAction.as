package bloxley.controller.event {
    
    import bloxley.model.game.BXActor;
    import bloxley.controller.event.BXBehavior;

    public class BXDisableAction extends BXBehavior {

    	public function BXDisableAction(actor:BXActor) {
    	    super(actor);
    	    setKey("Disable");
    	}

    	override public function act() {
    		actor().disable();
    	}

    	override public function undo() {
    		actor().enable();
    	}

    }

}