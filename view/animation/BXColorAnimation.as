package bloxley.view.animation {

    import flash.geom.ColorTransform;

    import bloxley.model.data.BXColor;
    import bloxley.view.animation.BXAnimation;
    import bloxley.view.sprite.BXSprite;
    
    public class BXColorAnimation extends BXAnimation {
        
        var sprite:BXSprite;
        var color:BXColor;
        
        public function BXColorAnimation(sprite:BXSprite, color:BXColor, options:Object = null) {
            super();
            
            this.sprite = sprite;
            this.color = color;
            
            this.wait = options.wait;
        }
        
        override public function start(...rest) {
            var graphics = sprite.getGraphics();
            var colorTransform:ColorTransform = graphics.transform.colorTransform;
            
            colorTransform.color = color.hex;
            graphics.transform.colorTransform = colorTransform;
            
            later("finish");
        }

    }

}