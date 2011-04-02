package bloxley.view.layout {

    import bloxley.base.BXObject;
    import bloxley.view.gui.BXGuiElement;
    import bloxley.view.layout.BXAnchor;
    
    public class BXLayout extends BXObject {

        /*
            Implements an L shaped button interface, with the board in the center.
            Elements can be added to the following groups:
                [Controllers] [Pens] [Pen Controls] along the top
                [Flow] [File] along the left side
                [Board] in the center
        */

        var border:Number;
        var spacer:Number;
        
        var anchors:Object;
        
        public function BXLayout(border:Number, spacer:Number) {
            this.border  = border;
            this.spacer  = spacer;
            this.anchors = new Object();
            
            setupAnchors();
        }

        function createAnchor(name:String, leftAnchor:String, leftBorder:Number, topAnchor:String, topBorder:Number) {
            anchors[name] = new BXAnchor(name, anchors[leftAnchor], leftBorder, anchors[topAnchor], topBorder);
        }
        
        public function setupAnchors() {
            createAnchor("Controls", null, border, null, border);
            
            createAnchor("Flow", null, border, "Controls", spacer);
            createAnchor("File", null, border, "Flow", spacer);
            
            createAnchor("Board", "Flow", border, "Controls", border);
        }
        
        public function place(element:BXGuiElement, anchor:String, priority:int = 1) {
            if (anchors[anchor]) {
                anchors[anchor].addElement(element, priority);
            } else {
                throw new Error("Layout does not contain a '" + anchor + "' anchor.");
            }
        }
        
    }
}