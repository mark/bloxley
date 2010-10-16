package bloxley.controller.event {
    
    import bloxley.base.BXObject;
    import bloxley.model.game.BXActor;
    import bloxley.controller.event.BXAction;
    import bloxley.controller.game.BXController;

    public class BXSelectAction extends BXAction {

        var controller:BXController;
        
        var oldSelection:BXObject;
        var newSelection:BXObject;

    	public function BXSelectAction(controller:BXController, newSelection:BXObject) {
            this.controller = controller;
            this.newSelection = newSelection;
    	}

    	override public function act() {
    	    oldSelection = controller.selection();
    	    controller.select(newSelection);
    	}

    	override public function undo() {
            controller.select(oldSelection);
    	}

        override public function animate() {
            if (newSelection is BXActor) {
                var actor:BXActor = newSelection as BXActor;
                
                return actor.actorController().animateSelect(actor, this);
            }
        }
        
        override public function description():String {
            return "Select"
        }

    }
    
}