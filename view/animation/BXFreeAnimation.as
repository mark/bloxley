package bloxley.view.animation {

    import bloxley.view.animation.BXSchedulable;
    import bloxley.view.choreography.*;

    public class BXFreeAnimation extends BXSchedulable {

        var routine:BXRoutine;
        
        public function BXFreeAnimation(...animations) {
            if (animations.length == 1 && animations[0] is BXRoutine) {
                routine = animations[0];
            } else {
                routine = new BXParallelRoutine(animations);
            }
        }

        override public function start(...rest) {
            super.start();
            routine.start();
            finish();
        }

    }
    
}

