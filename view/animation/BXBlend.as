package bloxley.view.animation {

    import bloxley.view.sprite.BXSprite;
    import bloxley.view.animation.*;
    import bloxley.view.clock.BXClock;

    public class BXBlend extends BXAnimation {

        // Data object variables
        var sprite:BXSprite;
        var update:Object;

        // Animation parametric values

        var initial:Number;
        var by:Number;
        var final:Number;
        var rate:Number;

        var method:String;
        var blend:Function;

        var instant:Boolean;

        // Current Status
        var startNow:Boolean;
        var isEnded:Boolean;

        /**************
        *             *
        * Constructor *
        *             *
        **************/

        function BXBlend(sprite:BXSprite, method:String, options) {
            super();
    		this.method    = method;

            this.sprite    = sprite;
            this.update    = new Object();

            this.initial   = options.from;
            this.final     = (options.to == null) ? options.via : options.to;
            this.by        = options.by;
            this.rate      = options.speed;
            this.duration  = options.seconds;
            this.wait      = options.wait;
            this.instant   = (options.instant == null) ? (options.speed == null && options.seconds == null) : options.instant;
            this.blend     = blendingFunction(options.blend);

            if (isNaN(this.final)) this.final = options.control;
        }

        function blendingFunction(fcn):Function {
            if (fcn is Function)
                return fcn;
            else if (fcn)
                return BXBlend[fcn];
            else
                return linear;
        }

        /****************
        *               *
        * Clock Methods *
        *               *
        ****************/

        override public function isInstantaneous():Boolean {
            return super.isInstantaneous() && (rate == 0.0 || isNaN(rate));
        }

        function value(completion:Number):Number {
            return initial + (final - initial) * completion;
        }

        function blendedCompletion(timeCompletion:Number):Number {
            return blend.call(null, timeCompletion);
        }

        /******************
        *                 *
        * Animation Frame *
        *                 *
        ******************/

        override public function setup() {
            if (isNaN(initial)) initial = sprite.get(method);
            if (! isNaN(by))      final = initial + by;

            if (isNaN(duration)) duration = Math.abs(final - initial) / rate;
        }

        override public function animate(completion:Number) {
            var comp = blendedCompletion(completion);

            sprite.set(method, value(comp));
        }

        /*********************
        *                    *
        * Blending Functions *
        *                    *
        *********************/

        static function linear(input:Number):Number { return input; }    

        static function smooth(input:Number):Number { return 0.5 * (1.0 - Math.cos(Math.PI * input)); }

        static function   snap(input:Number):Number { return Math.sqrt(input); }

        static function  accel(input:Number):Number { return Math.pow(input, 2.0); }

        static function bounce(input:Number):Number { return 4.0 * input * (1.0 - input); }

        /******************
        *                 *
        * Utility methods *
        *                 *
        ******************/

        // function toString():String {
        //     return "Blend{ " + sprite + " : " + method + " }";
        // }

        // function start()  { super.start();  }
        // function finish() { super.finish(); }
    }

}
