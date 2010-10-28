package bloxley.controller.phase {

    import bloxley.base.BXObject;
    import bloxley.controller.game.BXPlayController;
    import bloxley.controller.phase.BXPhase;
    import bloxley.controller.event.BXEvent;
    import bloxley.controller.event.BXChangePhaseAction;
    
    public class BXGameLoop extends BXObject {
                
        var gameController:BXPlayController;
        var phases:Object;
        var initialPhase:BXPhase;

        // Main Loop elements

        var __currentPhase:BXPhase;
        var waitCount:int;
        var lastTransitionType:Array;
        var pendingTransitionType:Array;
        
        public function BXGameLoop(gameController:BXPlayController) {
            this.gameController = gameController;
            this.phases = new Object();
            this.waitCount = 0;
            this.lastTransitionType = [ "immediate", null ];
            
            addPhase( new BXPhase("Win",  this, { call: "beatLevel" }) );
            addPhase( new BXPhase("Lose", this, { call: "lostLevel" }) );
            
            // For delayed phase transitions...
            listenFor("BXGameLoopRepeat", this, run);
        }

        /*********************
        *                    *
        * Controller Methods *
        *                    *
        *********************/
        
        public function controller():BXPlayController {
            return gameController;
        }
        
        /************************
        *                       *
        * Initial Phase Methods *
        *                       *
        ************************/
        
        public function setInitialPhase(phaseName:String) {
            initialPhase = phaseNamed(phaseName);
        }
        
        /****************
        *               *
        * Phase Methods *
        *               *
        ****************/
        
        public function addPhase(phase:BXPhase) {
            var name = phase.name;
            phases[name] = phase;
        }

        public function phaseNamed(name:String):BXPhase {
            return phases[name];
        }

        public function currentPhase():BXPhase {
            return __currentPhase;
        }
        
        public function switchToPhase(newPhase:BXPhase) {
            __currentPhase = newPhase;
        }
        
        /***************************
        *                          *
        * Monitoring Event Methods *
        *                          *
        ***************************/
        
        public function waitForAnimations(animations:Array) {
            waitCount = 0;
            
            if (animations.length == 0) {
                later( "run" );
            } else {
                for (var i = 0; i < animations.length; i++) {
                    if (! animations[i].isFinished()) {
                        waitCount++;
                        listenFor("BXFinishAnimation", animations[i], animationFinished);
                    }
                }
            }
        }
        
        public function animationFinished(...rest) {
            waitCount--;
            
            if (waitCount == 0) {
                later( "run" );
            }
        }
        
        /****************
        *               *
        * Main Run Loop *
        *               *
        ****************/

        public function run(...rest) {
            // In case we were from a previous possible transition...
            controller().finishMonitoringUserEvents();
            
            if (__currentPhase == null) __currentPhase = initialPhase;

            // Uncomment the next line to track the game loop:
            // trace(__currentPhase.name);
            
            __currentPhase.run();

            var nextPhase         = __currentPhase.nextPhase();
            var transition        = __currentPhase.transition();
            var transitionOptions = __currentPhase.transitionOptions();
            
            lastTransitionType = [ transition, transitionOptions ];
            
            
            if (__currentPhase != nextPhase) {
                controller().minorEvent( new BXChangePhaseAction(this, nextPhase, transition, transitionOptions) );
            } else if (transition) {
                transitionPhase(transition, transitionOptions);
            }
        }
        
        public function transitionPhase(transition:String, transitionOptions) {
            if (transition == "terminal") {
                // Do nothing, game has ended...
            } else if (transition == "immediate") {
                later( "run" );
            } else if (transition == "waitForInput") {
                controller().startMonitoringUserEvents( transitionOptions );
            } else if (transition == "waitForEvent") {
                // Current phase has already ran, so we can get the events that need to be monitored...
                controller().pushEvents();
            } else if (transition == "delay") {
                // Will trigger the state transition after transitionOptions seconds..
                postLater("BXGameLoopRepeat", transitionOptions);
            }
        }
        
        public function holdTransitionPhase(transition:String, transitionOptions) {
            pendingTransitionType = [ transition, transitionOptions ];
        }
        
        public function releaseTransitionPhase() {
            if (pendingTransitionType) {
                transitionPhase( pendingTransitionType[0], pendingTransitionType[1] );
            }
        }
        
        public function lastTransition():Array {
            return lastTransitionType;
        }
        
    }
    
}