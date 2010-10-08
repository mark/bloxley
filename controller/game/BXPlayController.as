package bloxley.controller.game {
    
    import bloxley.view.clock.BXTimer;
    import bloxley.controller.mailbox.BXMessage;
    import bloxley.controller.pen.*;
    import bloxley.model.data.BXDirection;
    import bloxley.model.game.BXActor;
    import bloxley.controller.event.*;
    
    public class BXPlayController extends BXController {

        public function BXPlayController(name: String, game:BXGame) {
            super(name, game);
        }
        
        override public function onStart() {
            setupTimer();
            switchToPen("Play");
        }
        
        override public function createPens() {
            var pen = new BXPlayPen(this);
            pen.setName("Play");
        }
    	
    	/****************
    	*               *
    	* Phase Methods *
    	*               *
    	****************/
    	
    	/****************
    	*               *
    	* Timer Methods *
    	*               *
    	****************/

    	function setupTimer() {
            var gameTimer = new BXTimer("Game");

            listenFor("BXTimerStart",  gameTimer, initialize);
            listenFor("BXTimerActive", gameTimer, everyFrame);
            listenFor("BXTimerTick",   gameTimer, everySecond);
    	}

    	public function initialize(message:BXMessage) {
    	    // OVERRIDE ME!
    	}

    	public function everyFrame(message:BXMessage) {
    	    // OVERRIDE ME!
    	}

    	public function everySecond(message:BXMessage) {
    	    // OVERRIDE ME!
    	}

        /*******************
        *                  *
        * Gameplay Methods *
        *                  *
        *******************/
        
        public function moveCharacter(direction:BXDirection) {
    	    if (selectedActor()) {
        	    event( new BXMoveAction( selectedActor(), direction ) );
    	    }
    	}

    }
}