package bloxley.controller.phase {

    import bloxley.base.BXObject;
    import bloxley.controller.game.BXController;
    //import bloxley.controller.phase.BXGameLoop;
    import bloxley.controller.game.BXPlayController;
    
    public class BXPhase extends BXObject {
        
        var name:String;
        var gameLoop:BXGameLoop;

        var options:Object;

        // Main Loop elements

        var _runCount:Number;
        var _lastCall;
        var _lastRun:Boolean;

        var _nextPhase:BXPhase;
        var _transition:String;
        var _transitionOptions;

        public function BXPhase(name:String, gameLoop:BXGameLoop, options:Object) {
            this.name = name;
            this.options = (options == null) ? new Object() : options;
            this.gameLoop = gameLoop;
            this._runCount = 0;
        }

        /*********************
        *                    *
        * Controller Methods *
        *                    *
        *********************/

        public function controller():BXPlayController {
            return gameLoop.controller();
        }

        public function executeOnController(methodName:String) {
            if (controller() && methodName && controller().respondsTo(methodName)) {
                return controller()[methodName]();
            }
        }

        /********************
        *                   *
        * Game Flow Methods *
        *                   *
        ********************/
        
        public function after(nextPhase:String, transition:String = "immediate", opts = null):BXPhase {
            options.after = [ nextPhase, transition, opts ];
            return this;
        }
        
        public function pass(nextPhase:String, transition:String = "immediate", opts = null):BXPhase {
            options.pass = [ nextPhase, transition, opts ];
            return this;
        }
        
        // If this phase loops back on failure...
        public function passEarly(nextPhase:String, transition:String = "immediate", opts = null):BXPhase {
            options.passEarly = [ nextPhase, transition, opts ];
            return this;
        }
        
        // If this phase loops back on failure...
        public function passLate(nextPhase:String, transition:String = "immediate", opts = null):BXPhase {
            options.passLate = [ nextPhase, transition, opts ];
            return this;
        }
        
        public function fail(nextPhase:String, transition:String = "immediate", opts = null):BXPhase {
            options.fail = [ nextPhase, transition, opts ];
            return this;
        }
        
        // If this phase loops back on success...
        public function failEarly(nextPhase:String, transition:String = "immediate", opts = null):BXPhase {
            options.failEarly = [ nextPhase, transition, opts ];
            return this;
        }
        
        // If this phase loops back on success...
        public function failLate(nextPhase:String, transition:String = "immediate", opts = null):BXPhase {
            options.failLate = [ nextPhase, transition, opts ];
            return this;
        }
        
        /*********************
        *                    *
        * Transition Methods *
        *                    *
        *********************/

        public function onEnter() {
            if (options.enter)
                executeOnController( options.enter );
        }

        public function onRun() {
            _runCount++;
            
            if (options.call) {
                _lastCall = executeOnController( options.call ) ? true : false;
            }
        }

        public function onExit() {
            if (options.exit)
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

            controller().startMonitoringEvents();
            onRun();
            
            // Calculate next state:
            var nextPhaseInfo = determineNextPhase();
            
            _nextPhase         = gameLoop.phaseNamed( nextPhaseInfo[0] );
            _transition        = nextPhaseInfo[1];
            _transitionOptions = nextPhaseInfo[2];

            if (nextPhase() != this) {
                cleanup();
                onExit();
            }
        }

        protected function determineNextPhase():Array {
            if (_lastCall) {
                if (firstRun() && options.passEarly != null) {
                    return options.passEarly;
                } else if (! firstRun() && options.passLate != null) {
                    return options.passLate;
                } else if (options.pass) {
                    return options.pass;
                }
            } else {
                if (firstRun() && options.failEarly != null) {
                    return options.failEarly;
                } else if (! firstRun() && options.failLate != null) {
                    return options.failLate;
                } else if (options.fail) {
                    return options.fail;
                }
            }
            
            // No Pass or Fail related transitions...
            if (options.after) {
                return options.after;
            }

            // Terminal state (no phase transitions specified)
            return [null, "terminal"];
        }

        public function nextPhase():BXPhase {
            return _nextPhase;
        }
        
        public function transition():String {
            return _transition;
        }
        
        public function transitionOptions() {
            return _transitionOptions;
        }

        public function cleanup() {
            _runCount = 0;
        }
        
        public function phaseName():String {
            return name;
        }
        
    }
    
}