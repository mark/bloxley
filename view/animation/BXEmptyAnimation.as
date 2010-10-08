package bloxley.view.animation {

    import bloxley.view.animation.BXAnimation;

    public class BXEmptyAnimation extends BXAnimation {

        var seconds:Number;

        public function BXEmptyAnimation(seconds:Number = 0.0) {
            setDuration( seconds );
        }

    }
    
}

