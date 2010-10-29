/*
    This class isn't really necessary, since it's just a single call to .sequence(...) on a plain BXRoutine
    It just exists to demonstrate how to write a custom routine.
*/

package bloxley.view.choreography {

    import bloxley.view.animation.BXSchedulable;
    import bloxley.view.choreography.BXRoutine;

    public class BXSerialRoutine extends BXRoutine {

        public function BXSerialRoutine(animations:Array = null) {
            super();
            
            if (animations != null) addAnimations(animations);
        }

        public function addAnimations(animations:Array) {
            var prev = animations[0];
            if (prev) startWith( prev );
            
            for (var i = 1; i < animations.length; i++) {
                var animation:BXSchedulable = animations[i];

                sequence(prev, animation);
                
                prev = animation;
            }
        }    

    }

}
