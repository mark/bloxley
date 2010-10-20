package bloxley.view.gui {
    
    import flash.display.*;
    
    import bloxley.view.sprite.BXSprite;
    
    public class BXScreen extends BXSprite {
        
        var stage:Stage;
        
        public function BXScreen(stage:Stage) {
            this.stage = stage;

            super(null, { parent: this, depth: 0 });
        }
                
        override public function getGraphics() {
            return stage;
        }
    }
    
}