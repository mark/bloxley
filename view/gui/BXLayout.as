package bloxley.view.gui {

    import bloxley.view.gui.BXGuiElement;
    
    public class BXLayout {
        
        var currentX:Number;
        var currentY:Number;
        
        var orientation:String;
        
        public function BXLayout(orientation:String) {
            this.currentX = 0.0;
            this.currentY = 0.0;
            this.orientation = orientation;
        }

        public function setPosition(currentX:Number, currentY:Number) {
            this.currentX = currentX;
            this.currentY = currentY;
        }
        
        public function place(element:BXGuiElement) {
            element.goto([ currentX, currentY ], { ignoreGeometry: true });
            
            if (orientation == "horizontal") {
                currentX += element.get("width");
            } else if (orientation == "vertical") {
                currentY += element.get("height");
            }
        }
        
        public function gap(space:Number) {
            if (orientation == "horizontal") {
                currentX += space;
            } else if (orientation == "vertical") {
                currentY += space;
            }
        }

    }
}