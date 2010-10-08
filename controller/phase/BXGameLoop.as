package bloxley.controller.phase {

    import bloxley.controller.game.BXController;
    import bloxley.controller.phase.BXPhase;
    
    public class BXGameLoop {
                
        var controller:BXController;
        var phases:Object;
        var initalPhase:BXPhase;

        // Main Loop elements

        var __currentPhase:BXPhase;

        public function BXGameLoop(controller:BXController) {
            this.controller = controller;
            this.phases = new Object();
            
        }

        /****************
        *               *
        * Phase Methods *
        *               *
        ****************/

        function addPhase(phase:BXPhase) {
            var name = phase.name;
            phases[name] = phase;
            phase.setPhaseTable(this);

            if (phase.initial) {
                initialPhase = phase;
            }
        }

        function phaseNamed(name:String):BXPhase {
            return phases[name];
        }

        /****************
        *               *
        * Main Run Loop *
        *               *
        ****************/

        function mainLoop() {
            if (__currentPhase == null) __currentPhase = initialPhase;

            __currentPhase.run();
            var transition = __currentPhase.transition();
            __currentPhase = __currentPhase.nextPhase();

            if (transition == BXPhase.STOP) {
                // Do nothing... loop execution stops...
            } else if (transition == BXPhase.IMMEDIATE) {
                later('mainLoop');
            } else {
                var nextPhaseTimer = new BXTimer("Main Loop Timer", transition);
                listenFor("BXTimerStop", nextPhaseTimer, mainLoop);
            }
        }
        
    }
    
}