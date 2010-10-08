package bloxley.view.gui {
    
    import flash.display.*;
    
    import bloxley.view.sprite.BXSprite;
    
    public class BXScreen extends BXSprite {
        
        var stage:Stage;
        
        public function BXScreen(stage:Stage) {
            super(null, new Object());
            
            this.stage = stage;
        }
        
        override public function generateGraphics(clip:String, parent, depth:int, hidden:Boolean) { return null; }
        
        override public function getGraphics() {
            return stage;
        }
    }
    
}