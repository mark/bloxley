package bloxley.view.animation {

    import bloxley.view.sprite.BXSprite;
    import bloxley.view.animation.*;
    import bloxley.view.clock.BXClock;

    public class BX2DBlend extends BXBlend {

        var initialX:Number;
        var initialY:Number;

        var finalX:Number;
        var finalY:Number;

        var methodX:String;
        var methodY:String;

        function BX2DBlend(sprite:BXSprite, methods, options) {
            super(sprite, methods[0] + "_" + methods[1], options);
    		this.methodX   = methods[0];
            this.methodY   = methods[1];
            //super(sprite, methods[0] + "_" + methods[1], options);

            this.initialX  = options.from_x;        
            this.initialY  = options.from_y;        
                           
            this.finalX    = isNaN(options.to_x) ? options.via_x : options.to_x;
            this.finalY    = isNaN(options.to_y) ? options.via_y : options.to_y;

        }

        function valueX(completion:Number):Number {
            return initialX + (finalX - initialX) * completion;
        }

        function valueY(completion:Number):Number {
            return initialY + (finalY - initialY) * completion;
        }

        override public function setup() {
            if (isNaN(initialX)) initialX = sprite.get(methodX);
            if (isNaN(initialY)) initialY = sprite.get(methodY);

            var temp = (finalX - initialX) * (finalX - initialX) + (finalY - initialY) * (finalY - initialY);

            if (isNaN(duration)) duration = Math.sqrt(temp) / rate;
        }

        override public function animate(completion:Number) {
            var comp = blendedCompletion(completion);

            sprite.set(methodX, valueX(comp));
            sprite.set(methodY, valueY(comp));
        }

        // function toString() {
        //     return "Blend{ " + sprite + " : " + methodX + "X" + methodY + " }";
        // }

    }
    
}
