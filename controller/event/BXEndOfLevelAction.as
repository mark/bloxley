package bloxley.controller.event {
    
    import bloxley.controller.event.BXAction;
    import bloxley.controller.game.BXPlayController;

    public class BXEndOfLevelAction extends BXAction {

        var controller:BXPlayController;
        var didWin:Boolean;
        
    	public function BXEndOfLevelAction(controller:BXPlayController, didWin:Boolean) {
            this.controller = controller;
            this.didWin = didWin;
    	}

    	override public function animate() {
    	    return didWin ? controller.animateBeatLevel(this) : controller.animateLostLevel(this);
    	}

    	override public function animateUndo() {
    	    return didWin ? controller.animateUndoBeatLevel(this) : controller.animateUndoLostLevel(this);
    	}

        override public function description():String {
            return "EndOfLevel";
        }

    }
    
}