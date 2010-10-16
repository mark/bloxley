package bloxley.view.choreography {
    
    import bloxley.base.BXObject;
    import bloxley.view.choreography.BXRoutine;
    
    public class BXSequencer extends BXObject {
        
        var currentRoutine:BXRoutine;
        var waitingRoutines:Array;
        
        public function BXSequencer() {
            waitingRoutines = new Array();
        }
        
        public function add(routine:BXRoutine) {
            waitingRoutines.push(routine);
            
            if (currentRoutine == null) {
                advance();
            }
        }
        
        public function run(routine:BXRoutine) {
            currentRoutine = routine;
            listenFor("BXFinishAnimation", currentRoutine, advance);

            currentRoutine.start();
        }
        
        public function advance(...rest) {
            if (waitingRoutines.length > 0) {
                var nextRoutine = waitingRoutines.shift();
                run(nextRoutine);
            } else {
                currentRoutine = null;
            }
        }
        
    }
}