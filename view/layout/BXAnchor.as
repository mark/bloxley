package bloxley.view.layout {
    
    import bloxley.controller.mailbox.BXMessage;
    import bloxley.base.BXObject;
    import bloxley.view.gui.BXGuiElement;
    
    public class BXAnchor extends BXObject {
        
        static var SPACING = 32.0;
        
        var name:String;
        
        var leftAnchor:BXAnchor;
        var leftBorder:Number;
        
        var topAnchor:BXAnchor;
        var topBorder:Number;
        
        var elements:Array;
        
        var top:Number;
        var left:Number;
        
        var width:Number;
        var height:Number;
        
        public function BXAnchor(name:String, leftAnchor:BXAnchor, leftBorder:Number, topAnchor:BXAnchor, topBorder:Number) {
            this.name       = name;
            
            this.leftAnchor = leftAnchor;
            this.leftBorder = leftBorder;
            
            this.topAnchor  = topAnchor;
            this.topBorder  = topBorder;
            
            this.elements   = new Array();
            
            this.width = 0.0;
            this.height = 0.0;
            
            calculatePosition();
            
            // if (leftAnchor) listenFor("BXAnchorMoved", leftAnchor, rearrange);
            // if (topAnchor ) listenFor("BXAnchorMoved", topAnchor,  rearrange);
        }

        public function addElement(guiElement:BXGuiElement, priority:int) {
            var reference = { element: guiElement, priority: priority, insertOrder: elements.length };
            elements.push(reference);
            elements.sortOn([ "priority", "insertOrder" ], Array.NUMERIC);
            
            calculateDimensions();
            rearrange();
            
            // listenFor("BXSpriteUpdated", guiElement, rearrangeLater);
            listenFor("BXSpriteVisibilityChanged", guiElement, rearrangeLater);
        }
        
        public function right():Number {
            return left + width;
        }
        
        public function bottom():Number {
            return top + height;
        }
        
        function calculatePosition() {
            this.left  = ( leftAnchor ? leftAnchor.right() : 0.0 ) + leftBorder;
            this.top   = ( topAnchor  ? topAnchor.bottom() : 0.0 ) + topBorder;
        }
        
        function calculateDimensions() {
            var newWidth = 0.0;
            var newHeight = 0.0;
            
            for (var i = 0; i < elements[i].length; i++) {
                var guiElement = elements[i].element;
                
                if (guiElement.get("alpha") > 0.1) {
                    newWidth += guiElement.get("width");
                    if (i > 0) newWidth += SPACING;

                    if (guiElement.get("height") > newHeight) {
                        newHeight = guiElement.get("height");
                    }
                }
                
            }
            
            var resized = width != newWidth || height != newHeight;

            width = newWidth;
            height = newHeight;
            
            // if (resized) post("BXAnchorMoved");
        }
        
        function placeElement(element:BXGuiElement) {
            element.goto([left, top], { ignoreGeometry: true });
        }
        
        public function rearrangeLater(message:BXMessage) {
            later(rearrange);
        }
        
        public function rearrange(...rest) {
            trace("rearrange");
            calculatePosition();
            var offset = left;
            
            for (var i = 0; i < elements.length; i++) {
                var element = elements[i].element;
                
                element.goto([offset, top], { ignoreGeometry: true });
                offset += element.get("width") + SPACING;
            }
            
            //post("BXAnchorMoved");
        }

    }
    
}