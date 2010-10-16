package bloxley.controller.game {
    
    import bloxley.view.clock.BXTimer;
    import bloxley.controller.mailbox.BXMessage;
    import bloxley.controller.pen.*;
    import bloxley.model.data.BXDirection;
    import bloxley.model.game.BXActor;
    import bloxley.controller.event.*;
    import bloxley.controller.phase.*;
    
    public class BXPlayController extends BXController {

        var monitoringEvent:Boolean;
        var eventsToMonitor:Array;
        
        var gameLoop:BXGameLoop;
        
        public function BXPlayController(name: String, game:BXGame) {
            super(name, game);
            
            gameLoop = new BXGameLoop(this);
            monitoringEvent = false;
            
            createPhases();
        }
        
        override public function onStart() {
            setupTimer();
            switchToPen("Play");
            gameLoop.mainLoop();
        }
        
        override public function createPens() {
            var pen = new BXPlayPen(this);
            pen.setName("Play");
            
            var pen1 = new BXGameOverPen(this);
            pen1.setName("GameOver");
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
    	
    	public function phase(name:String, options:Object = null):BXPhase {
    	    var newPhase = new BXPhase(name, gameLoop, options);
    	    gameLoop.addPhase( newPhase );

    	    return newPhase;
    	}
    	
    	// These are the user input actions which will trigger a phase transition
    	public function validUserActions():Array {
    	    return [ "moveCharacter" ];
    	}
    	
        /********************
        *                   *
        * Monitoring Events *
        *                   *
        ********************/
        
        public function monitorEvent() {
            monitoringEvent = true;
        }

        public function monitorEvents(events:Array) {
            eventsToMonitor = events;
        }
        
        override public function respondTo(meth:String, args:Array = null) {
            if (eventsToMonitor && eventsToMonitor.indexOf(meth) != -1) {
                monitorEvent();
            }

            super.respondTo(meth, args);
            
            // In case no event is created...
            monitoringEvent = false;
        }
        
        override public function handleEvent(milestone:Boolean, events:Array) {
            var newEvent = new BXEvent(this, milestone);
            
            newEvent.handle(events);
            
            if (monitoringEvent) {
                eventsToMonitor = null;
                monitoringEvent = false;

                gameLoop.eventToMonitor(newEvent);
            }
        }
        
        public function nothing() {
            eventsToMonitor = null;
            monitoringEvent = false;

            gameLoop.eventToMonitor(null);
        }

    	/*************************
    	*                        *
    	* Built-In Phase Methods *
    	*                        *
    	*************************/

    	public function startGame() {
    	    var firstPlayer = board().allActors().thatCanBePlayer().theFirst();
    	    selectPlayer( firstPlayer );
    	}
    	
    	public function heartbeat() {
    	    // OVERRIDE ME!
    	    nothing();
    	}
    	
    	public function didBeatLevel():Boolean {
    	    // OVERRIDE ME!
            return false;
    	}
    	
    	public function beatLevel() {
    	    trace("beatLevel");
    	    switchToPen("GameOver");
    	    // minorEvent( new BXEndOfLevelAction(this, true), new BXSwitchPenAction(this, "GameOver") );
    	}
    	
    	public function didLoseLevel():Boolean {
    	    // OVERRIDE ME!
    	    return false;
    	}
    	
    	public function lostLevel() {
    	    switchToPen("GameOver");
    	    // minorEvent( new BXEndOfLevelAction(this, false), new BXSwitchPenAction(this, "GameOver") );
    	}
    	
    	/*****************************
    	*                            *
    	* Built-In Animation Methods *
    	*                            *
    	*****************************/
    	
    	public function animateBeatLevel(action:BXAction) {
    	    // OVERRIDE ME!
    	}
    	
    	public function animateLostLevel(action:BXAction) {
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
        
        public function selectPlayer(character:BXActor) {
    	    minorEvent( new BXSelectAction(this, character) );
        }
        
        public function selectNextPlayer() {
            var nextPlayer = board().allActors().thatCanBePlayer().theNextAfter(selectedActor());
            selectPlayer( nextPlayer );
        }
        
        public function moveCharacter(direction:BXDirection, steps:int = 1) {
    	    if (selectedActor()) {
        	    event( new BXMoveAction( selectedActor(), direction, steps ) );
    	    }
    	}

    }
}