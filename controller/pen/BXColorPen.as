package bloxley.controller.pen {
    
    import bloxley.controller.event.*;
    import bloxley.controller.game.BXEditorController;
    import bloxley.controller.pen.*;
    import bloxley.model.data.BXColor;
    import bloxley.model.collection.BXRegion;

    public class BXColorPen extends BXPen {
        
        static var PATCH_LAYER = 100;
        static var ACTOR_LAYER = 200;
        
        var layer:int;
        var attribute:String;
        var color:BXColor;
        
        public function BXColorPen(controller:BXEditorController) {
            super("Paint", controller);
        }
        
        public function setLayer(layer:int) {
            this.layer = layer;
        }
        
        public function setAttribute(attribute:String) {
            this.attribute = attribute;
        }
        
        public function setColor(color:BXColor) {
            this.color = color;
        }

        /********************
        *                   *
        * Interface Actions *
        *                   *
        ********************/
        
        override public function down(mouse:BXMouseEvent) {
            if (layer == PATCH_LAYER) {
                patch().set(attribute, color);
            } else {
                actor().set(attribute, color);
            }
        }

    }
    
}