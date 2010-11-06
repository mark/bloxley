package bloxley.controller.game {
    
    import bloxley.base.BXSystem;
    import bloxley.controller.mailbox.BXMessage;
    import bloxley.controller.pen.*;
    import bloxley.model.data.BXDirection;
    import bloxley.model.game.BXActor;
    import bloxley.controller.event.*;
    import bloxley.controller.phase.*;
    import bloxley.view.choreography.BXRoutine;
    import bloxley.view.clock.BXTimer;
    import bloxley.view.gui.BXImage;
    import bloxley.view.sprite.BXSprite;
    
    
    public class BXPlayController extends BXController {

        var caughtEvents:Array;
        var eventsToMonitor:Array;
        
        var gameLoop:BXGameLoop;
        
        public function BXPlayController(name: String, game:BXGame) {
            super(name, game);
            
            gameLoop = new BXGameLoop(this);
            caughtEvents = new Array();
            
            createPhases();
        }
        
        /*************************
        *                        *
        * Initialization Methods *
        *                        *
        *************************/
        
        override public function onStart() {
            switchToPen("Play");
            gameLoop.later("run");
        }
        
        override public function createPens() {
            var pen = new BXPlayPen(this);
            pen.setName("Play");
            
            var pen1 = new BXGameOverPen(this);
            pen1.setName("GameOver");
        }
    	

    	public function createPhases() {
    	    phase("Starting Game", { call: "startGame"    }).after("User Input");
    	    phase("User Input"                             ).after("Heartbeat", "waitForInput", validUserActions());
    	    phase("Heartbeat",     { call: "heartbeat"    }).after("Test For Lose");
    	    phase("Test For Lose", { call: "didLoseLevel" }).pass("Lose").fail("Test For Win");
    	    phase("Test For Win",  { call: "didBeatLevel" }).pass("Win" ).fail("User Input"  );
    	    
    	    setInitialPhase("Starting Game");
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
    	// Override when necessary...
    	public function phase(name:String, options:Object = null):BXPhase {
    	    var newPhase = new BXPhase(name, gameLoop, options);
    	    gameLoop.addPhase( newPhase );

    	    return newPhase;
    	}
    	
    	public function loop():BXGameLoop {
    	    return gameLoop;
    	}
    	
        /********************
        *                   *
        * Monitoring Events *
        *                   *
        ********************/
        
        public function startMonitoringEvents() {
            caughtEvents = new Array();
        }
        
        public function fetchEvents():Array {
            return caughtEvents;
        }
        
        public function pushEvents() {
            // gameLoop.waitForAnimations( caughtEvents );
        }

        public function startMonitoringUserEvents(events:Array) {
            eventsToMonitor = events;
        }
        
        public function finishMonitoringUserEvents() {
            eventsToMonitor = null;
        }
        
        override public function respondTo(meth:String, args:Array = null) {
            var isMonitoringEvent = false;
            
            if (eventsToMonitor && eventsToMonitor.indexOf(meth) != -1) {
                startMonitoringEvents();
                isMonitoringEvent = true;
            }

            super.respondTo(meth, args);
            
            if (isMonitoringEvent && caughtEvents.length > 0) {
                finishMonitoringUserEvents();
                pushEvents();
                gameLoop.later("run");
            }
        }
        
        override public function eventSucceeded(event:BXEvent):BXRoutine {
            var routine = super.eventSucceeded(event);
            
            caughtEvents.push( routine );
            
            return routine;
        }
        
        /***************
        *              *
        * Undo Methods *
        *              *
        ***************/
        
        override public function undo() {
            super.undo();
            startMonitoringEvents();
            gameLoop.releaseTransitionPhase();
        }

        override public function reset() {
            super.reset();
            startMonitoringEvents();
            gameLoop.releaseTransitionPhase();
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
    	
    	// These are the user input actions which will trigger a phase transition
    	public function validUserActions():Array {
    	    return [ "moveCharacter" ];
    	}
    	
    	public function heartbeat() {
    	    // OVERRIDE ME!
    	}
    	
    	public function didBeatLevel():Boolean {
    	    // OVERRIDE ME!
            return false;
    	}
    	
    	public function beatLevel() {
    	    minorEvent( new BXEndOfLevelAction(this, true), new BXSwitchPenAction(this, "GameOver") );
    	}
    	
    	public function didLoseLevel():Boolean {
    	    // OVERRIDE ME!
    	    return false;
    	}
    	
    	public function lostLevel() {
    	    minorEvent( new BXEndOfLevelAction(this, false), new BXSwitchPenAction(this, "GameOver") );
    	}
    	
    	/*****************************
    	*                            *
    	* Built-In Animation Methods *
    	*                            *
    	*****************************/
    	
         public function animateBeatLevel(action:BXAction) {
    	    return showBank("Beat Level", { seconds: 0.5 });
        }
        
         public function animateUndoBeatLevel(action:BXAction) {
    	    return hideBank("Beat Level");
        }
        
         public function animateLostLevel(action:BXAction) {
    	    return showBank("Lost Level", { seconds: 0.5 });
        }
        
         public function animateUndoLostLevel(action:BXAction) {
    	    return hideBank("Lost Level");
        }
    	
        /*******************
        *                  *
        * Gameplay Methods *
        *                  *
        *******************/
        
        public function selectPlayer(character:BXActor) {
            if (character != selection()) {
        	    minorEvent( new BXSelectAction(this, character) );
            }
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