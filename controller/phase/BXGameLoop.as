package bloxley.controller.phase {

    import bloxley.base.BXObject;
    import bloxley.controller.game.BXPlayController;
    import bloxley.controller.phase.BXPhase;
    import bloxley.controller.event.BXEvent;
    
    public class BXGameLoop extends BXObject {
                
        var gameController:BXPlayController;
        var phases:Object;
        var initialPhase:BXPhase;

        // Main Loop elements

        var __currentPhase:BXPhase;
        var waitCount:int;

        public function BXGameLoop(gameController:BXPlayController) {
            this.gameController = gameController;
            this.phases = new Object();
            this.waitCount = 0;
            
            addPhase( new BXPhase("Win",  this, { call: "beatLevel" }) );
            addPhase( new BXPhase("Lose", this, { call: "lostLevel" }) );
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

        /***************************
        *                          *
        * Monitoring Event Methods *
        *                          *
        ***************************/
        
        public function waitForAnimations(animations:Array) {
            waitCount = 0;
            
            if (animations.length == 0) {
                later( "mainLoop" );
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
                later( "mainLoop" );
            }
        }
        
        /****************
        *               *
        * Main Run Loop *
        *               *
        ****************/

        public function mainLoop(...rest) {
            // In case we were from a previous possible transition...
            controller().finishMonitoringUserEvents();
            
            if (__currentPhase == null) __currentPhase = initialPhase;

            trace(__currentPhase.name);
            __currentPhase.run();
            
            var transition        = __currentPhase.transition();
            var transitionOptions = __currentPhase.transitionOptions();
            
            __currentPhase = __currentPhase.nextPhase();
            
            if (transition == "terminal") {
                // Do nothing, game has ended...
            } else if (transition == "immediate") {
                later( "mainLoop" );
            } else if (transition == "waitForInput") {
                controller().startMonitoringUserEvents( transitionOptions );
            } else if (transition == "waitForEvent") {
                // Current phase has already ran, so we can get the events that need to be monitored...
                controller().pushEvents();
            }
        }
        
    }
    
}