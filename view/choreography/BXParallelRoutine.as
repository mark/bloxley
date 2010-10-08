/*
    This class isn't really necessary, since it's just a single call to .startWith(...) on a plain BXRoutine
    It just exists to demonstrate how to write a custom routine.
*/

package bloxley.view.choreography {

    import bloxley.view.animation.BXSchedulable;
    import bloxley.view.choreography.BXRoutine;

    public class BXParallelRoutine extends BXRoutine {

        public function BXParallelRoutine(animations:Array = null) {
            super();
            
            if (animations != null) addAnimations(animations);
        }

        public function addAnimations(animations:Array) {
            for (var i = 0; i < animations.length; i++) {
                startWith( animations[i] );
            }
        }    

    }

}
