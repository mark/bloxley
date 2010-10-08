package bloxley.view.animation {

    import bloxley.view.sprite.*;
    import bloxley.view.animation.*;

    public class BXFrameAnimation extends BXAnimation {

        var sprite:BXSprite;

        var sequence:Array;

        var nextFrame:Number;
        var nextChange:Number;

        var rate:Number;

        var instant:Boolean;
        var continuous:Boolean;

        public function BXFrameAnimation(sprite:BXSprite, sequence:Array, options) {
            super();

            this.sprite     = sprite;
            this.sequence   = sequence;

            this.duration   = options.seconds;
            this.rate       = options.speed;
            this.instant    = (isNaN(options.speed) && isNaN(options.seconds)) || changes() == 0;
            this.continuous = options.continuous;
        }

        public function changes():Number {
            return sequence.length - 1;
        }

        override public function setup() {
            if (instant) {
                listenFor("BXAnimationStart", this, finish);
            } else {
                if (isNaN(duration)) duration = rate * changes();
                if (isNaN(rate)) rate = duration / changes();

                nextFrame = 1;
                nextChange = rate;

                if (continuous) {
                    duration = NaN;
                }
            }

            setFrame(0);
        }

        override public function animate(completion:Number) {
            if (elapsed() >= nextChange) {
                nextChange += rate;
                setFrame(nextFrame);
                nextFrame++;

                if (continuous && nextFrame == sequence.length) nextFrame = 0;
            }
        }

        override public function cleanup() {
            setFrame(sequence.length - 1);
        }

        public function setFrame(index) {
            sprite.set("frame", sequence[index]);
        }
    }
}
