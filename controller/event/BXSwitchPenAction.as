package bloxley.controller.event {
    
    import bloxley.controller.event.BXAction;
    import bloxley.controller.game.BXController;

    public class BXSwitchPenAction extends BXAction {

        var controller:BXController;
        
        var oldPen:String;
        var newPen:String;

    	public function BXSwitchPenAction(controller:BXController, newPen:String) {
            this.controller = controller;
            this.newPen = newPen;
    	}

    	override public function act() {
    	    oldPen = controller.pen().name();
    	    controller.switchToPen(newPen);
    	}

    	override public function undo() {
    	    trace("switching back to pen " + oldPen)
            controller.switchToPen(oldPen);
    	}

        override public function description():String {
            return "SwitchPen";
        }

    }
    
}