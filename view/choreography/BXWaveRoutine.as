package bloxley.view.choreography {

    import bloxley.view.animation.BXSchedulable;
    import bloxley.view.choreography.BXRoutine;

    public class BXWaveRoutine extends BXRoutine {

        var lastWave:Array;
        
        public function BXWaveRoutine() {
            super();
        }

        public function addWave(animations:Array) {
            if (lastWave) {
                for (var i = 0; i < animations.length; i++) {
                    for (var j = 0; j < lastWave.length; j++) {
                        sequence( lastWave[j], animations[i] );
                    }
                }
            } else {
                for (var k = 0; k < animations.length; k++) {
                    startWith( animations[k] );
                }
            }
            
            lastWave = animations;
        }    

        public function wave(...animations) {
            addWave( animations );
        }

    }
    
}
