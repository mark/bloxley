package bloxley.controller.phase {

    import bloxley.base.BXObject;
    import bloxley.controller.game.BXController;
    //import bloxley.controller.phase.BXGameLoop;
    import bloxley.controller.game.BXController;
    
    public class BXPhase extends BXObject {
        
        var name:String;
        var gameLoop:BXGameLoop;

        var options:Object;

        // Main Loop elements

        var _runCount:Number;
        var _lastCall;
        var _lastRun:Boolean;
        var _nextPhase:BXPhase;

        public function BXPhase(name:String, gameLoop:BXGameLoop, options:Object) {
            this.name = name;
            this.options = options;
            this.gameLoop = gameLoop;
            this._runCount = 0;
        }

        /*********************
        *                    *
        * Controller Methods *
        *                    *
        *********************/

        public function controller():BXController {
            //gameLoop.controller();
            return null;
        }

        public function executeOnController(methodName:String) {
            if (methodName == null) return;

            if (controller().respondsTo(methodName)) {
                controller()[methodName](this);
            }
        }

        /********************
        *                   *
        * Game Flow Methods *
        *                   *
        ********************/
        
        public function after(nextPhase:String, transition:String = "immediate", options = null):BXPhase {
            return this;
        }
        
        public function pass(nextPhase:String, transition:String = "immediate", options = null):BXPhase {
            return this;
        }
        
        // If this phase loops back on failure...
        public function passEarly(nextPhase:String, transition:String = "immediate", options = null):BXPhase {
            return this;
        }
        
        // If this phase loops back on failure...
        public function passLate(nextPhase:String, transition:String = "immediate", options = null):BXPhase {
            return this;
        }
        
        public function fail(nextPhase:String, transition:String = "immediate", options = null):BXPhase {
            return this;
        }
        
        // If this phase loops back on success...
        public function failEarly(nextPhase:String, transition:String = "immediate", options = null):BXPhase {
            return this;
        }
        
        // If this phase loops back on success...
        public function failLate(nextPhase:String, transition:String = "immediate", options = null):BXPhase {
            return this;
        }
        
        /*********************
        *                    *
        * Transition Methods *
        *                    *
        *********************/

        public function onEnter() {
            executeOnController( options.enter );
        }

        public function onRun() {
            _runCount++;
            _lastCall = executeOnController( options.call ) ? true : false;
        }

        public function onExit() {
            executeOnController( options.exit );
        }

        /********************
        *                   *
        * Main Loop Methods *
        *                   *
        ********************/

        public function firstRun():Boolean {
            return _runCount == 0;
        }

        public function run() {
            if (firstRun()) {
                onEnter();
            }

            onRun();
            determineNextPhase();

            if (nextPhase() != this) {
                cleanup();
                onExit();
            }
        }

        public function determineNextPhase() {
            var phaseName;

            if (options.terminal) {
                _nextPhase = null;
            } else if (_lastCall) {
                phaseName = options.success;
            } else if (_runCount == 1) {
                phaseName = options.failEarly || options.failure;
            } else {
                phaseName = options.failLate || options.failure;
            }

            _nextPhase = gameLoop.phaseNamed(phaseName);
        }

        public function nextPhase():BXPhase {
            return _nextPhase;
        }

        public function cleanup() {
            _runCount = 0;
        }
        
    }
    
}