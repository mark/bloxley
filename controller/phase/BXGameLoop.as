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

        public function BXGameLoop(gameController:BXPlayController) {
            this.gameController = gameController;
            this.phases = new Object();
            
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
        
        public function eventToMonitor(event:BXEvent) {
            later( "mainLoop" );
        }
        
        /****************
        *               *
        * Main Run Loop *
        *               *
        ****************/

        public function mainLoop(...rest) {
            if (__currentPhase == null) __currentPhase = initialPhase;

            trace(__currentPhase.name);
            __currentPhase.run();
            var transition = __currentPhase.transition();
            var transitionOptions = __currentPhase.transitionOptions();
            
            __currentPhase = __currentPhase.nextPhase();
            
            if (transition == "terminal") {
                // Do nothing...
            } else if (transition == "immediate") {
                later( "mainLoop" );
            } else if (transition == "waitForInput") {
                controller().monitorEvents( transitionOptions );
            } else if (transition == "waitForEvent") {
                controller().monitorEvent();
            }
        }
        
    }
    
}