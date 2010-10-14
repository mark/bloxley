package bloxley.controller.phase {

    import bloxley.base.BXObject;
    import bloxley.controller.game.BXController;
    import bloxley.controller.phase.BXPhase;
    import bloxley.controller.event.BXEvent;
    
    public class BXGameLoop extends BXObject {
                
        var controller:BXController;
        var phases:Object;
        var initialPhase:BXPhase;

        // Main Loop elements

        var __currentPhase:BXPhase;

        public function BXGameLoop(controller:BXController) {
            this.controller = controller;
            this.phases = new Object();
            
            addPhase( new BXPhase("Win",  this, { call: "beatLevel" }) );
            addPhase( new BXPhase("Lose", this, { call: "lostLevel" }) );
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
            trace("You monitored " + event);
        }
        
        /****************
        *               *
        * Main Run Loop *
        *               *
        ****************/

        public function mainLoop() {
            if (__currentPhase == null) __currentPhase = initialPhase;

            __currentPhase.run();
            //var transition = __currentPhase.transition();
            __currentPhase = __currentPhase.nextPhase();

            // if (transition == BXPhase.STOP) {
            //     // Do nothing... loop execution stops...
            // } else if (transition == BXPhase.IMMEDIATE) {
            //     later('mainLoop');
            // } else {
            //     var nextPhaseTimer = new BXTimer("Main Loop Timer", transition);
            //     listenFor("BXTimerStop", nextPhaseTimer, mainLoop);
            // }
        }
        
    }
    
}