package bloxley.view.sprite {

    import bloxley.view.animation.BXFrameAnimation;
    import bloxley.view.sprite.*;

    public class BXCompositeSprite extends BXSprite {

        var nextDepth:int;
        var elements:Array;

        var mainLayer:BXSprite;

        public function BXCompositeSprite(options:Object = null) {
            super(null, options);

            elements = new Array();
            nextDepth = 0;
        }

        public function layer(depth:int):BXSprite {
            return elements[depth];
        }

        public function addSpriteLayer(clip:String, opts:Object = null):BXSprite {
            var options = copyOptions(opts);
            options.depth = getNewDepth(options.depth);
            options.parent = this;

            var newSprite   = new BXSprite(clip, options);
            elements[depth] = newSprite;

            if (mainLayer == null) mainLayer = newSprite;

            return newSprite;
        }

        public function addEmptyLayer(opts:Object = null):BXCompositeSprite {
            var options = copyOptions(opts);
            options.depth = getNewDepth(options.depth);
            options.parent = this;
 
            var newSprite   = new BXCompositeSprite(options);
            
            elements[depth] = newSprite;

            if (mainLayer == null) mainLayer = newSprite;

            return newSprite;
        }

        public function setLayer(sprite:BXSprite, depth:int):BXSprite {
            return sprite;
        }

        function getNewDepth(givenDepth:Number):Number {
            if (isNaN(givenDepth)) {
                return nextDepth++;
            } else {
                if (givenDepth >= nextDepth) nextDepth = givenDepth + 1;

                return givenDepth;
            }
        }

        /****************
        *               *
        * Layer Methods *
        *               *
        ****************/
        
        public function swapLayers(first:int, second:int) {
            getGraphics().swapChildrenAt(first, second);
        }
        
        /*********************
        *                    *
        * Main Layer Methods *
        *                    *
        *********************/

        // Composite sprites don't have frames, so calls to change the frame get sent to the main layer instead.
        // By default, the main layer is the first defined sprite layer, but that can be changed.

        public function setMainLayer(newMainLayer:BXSprite) {
            mainLayer = newMainLayer;
        }

        // Intercept the animation call and pass it on to the main layer...

        override public function frame(frame_or_sequence, options = null):BXFrameAnimation {
            return mainLayer.frame(frame_or_sequence, options);
        }

    }

}
