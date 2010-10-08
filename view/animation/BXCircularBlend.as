package bloxley.view.animation {

    import bloxley.view.sprite.BXSprite;
    import bloxley.view.animation.*;

    public class BXCircularBlend extends BXBlend {

        var isClockwise:Boolean;
        var isCounterclockwise:Boolean;

        public function BXCircularBlend(sprite:BXSprite, methods, options) {
            super(sprite, methods, options);

            this.isClockwise = options.clockwise;
            this.isCounterclockwise = options.counterclockwise;
        }

        override public function setup() {
            var clockwise:Boolean;

            // Get the initial value
            if (isNaN(initial)) initial = sprite.get(method);

            // Set to within 0-360
            while (initial > 360.0) initial -= 360.0;
            while (initial < 0.0)   initial += 360.0;

            // Figure our which direction we're actually rotating
            if (isClockwise) {
                clockwise = isClockwise;
            } else if (isCounterclockwise) {
                clockwise = ! isCounterclockwise;
            } else {
                clockwise = (initial > final) == Math.abs(initial - final) > 180.0;
            }

            // Make sure that we have a straight shot to the final, and the sign for rate is correct
            if (clockwise) {
                if (! isNaN(by))
                    final = initial + by;
                else
                    while (initial > final) final += 360.0;

                rate = Math.abs(rate);
            } else {
                if (! isNaN(by))
                    final = initial - by;
                else
                    while (initial < final) final -= 360.0;

                rate = -Math.abs(rate);
            }

            if (isNaN(duration)) duration = Math.abs(final - initial) / Math.abs(rate);
        }

    }
    
}
