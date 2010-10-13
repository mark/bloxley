package bloxley.controller.game {
    
    import bloxley.view.clock.BXTimer;
    import bloxley.controller.mailbox.BXMessage;
    import bloxley.controller.pen.*;
    import bloxley.model.data.BXDirection;
    import bloxley.model.game.BXActor;
    import bloxley.controller.event.*;
    import bloxley.controller.phase.*;
    
    public class BXPlayController extends BXController {

        var gameLoop:BXGameLoop;
        
        public function BXPlayController(name: String, game:BXGame) {
            super(name, game);
            
            gameLoop = new BXGameLoop(this);
            
            createPhases();
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
    	
    	public function setInitialPhase(phaseName:String) {
            gameLoop.setInitialPhase(phaseName);
    	}
    	
    	// This contains the built in game loop, useful for Sokoban-type games
    	// But not useful for more complex kinds of games.
    	// Override if necessary...

    	public function createPhases() {
    	    phase("Starting Game", { call: "startGame"    }).after("User Input");
    	    phase("User Input"                             ).after("Heartbeat",    "waitForInput", validUserActions());
    	    phase("Heartbeat",     { call: "heartbeat"    }).after("Test For Win", "waitForEvent");
    	    phase("Test For Win",  { call: "didBeatLevel" }).pass("Win" ).fail("Test For Lose");
    	    phase("Test For Lose", { call: "didLoseLevel" }).pass("Lose").fail("User Input"   );
    	    
    	    setInitialPhase("Starting Game");
    	}
    	
    	public function phase(name:String, options:Object):BXPhase {
    	    var newPhase = new BXPhase(name, gameLoop, options);
    	    gameLoop.addPhase( newPhase );

    	    return newPhase;
    	}
    	
    	// These are the user input actions which will trigger a phase transition
    	public function validUserActions():Array {
    	    return [ "moveCharacter" ];
    	}
    	
    	/*************************
    	*                        *
    	* Built-In Phase Methods *
    	*                        *
    	*************************/

    	public function startGame() {
    	    // OVERRIDE ME!
    	}
    	
    	public function heartbeat() {
    	    // OVERRIDE ME!
    	}
    	
    	public function didBeatLevel():Boolean {
    	    // OVERRIDE ME!
    	    return false;
    	}
    	
    	public function beatLevel() {
    	    // OVERRIDE ME!
    	}
    	
    	public function didLoseLevel():Boolean {
    	    // OVERRIDE ME!
    	    return false;
    	}
    	
    	public function lostLevel() {
    	    // OVERRIDE ME!
    	}
    	
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