package bloxley.controller.event {
    
    import bloxley.controller.event.BXAction;
    import bloxley.controller.phase.*;

    public class BXChangePhaseAction extends BXAction {

        var gameLoop:BXGameLoop;
        
        var newPhase:BXPhase;
        var newTransition:Array;
        
        var oldPhase:BXPhase;
        var oldTransition:Array;

    	public function BXChangePhaseAction(gameLoop: BXGameLoop, newPhase:BXPhase, transition:String, transitionOptions) {
            this.gameLoop = gameLoop;
            this.newPhase = newPhase;
            this.newTransition = [ transition, transitionOptions ];
    	}

    	override public function act() {
    	    oldPhase      = gameLoop.currentPhase();
            oldTransition = gameLoop.lastTransition();
            
    	    gameLoop.switchToPhase(newPhase);
    	    gameLoop.transitionPhase( newTransition[0], newTransition[1] );
    	    
    	}

    	override public function undo() {
            gameLoop.switchToPhase(oldPhase);
    	    gameLoop.holdTransitionPhase( oldTransition[0], oldTransition[1] );
    	}

        override public function description():String {
            return "ChangePhase<" + (newPhase ? newPhase.phaseName() : " ") + ">";
        }

    }
    
}