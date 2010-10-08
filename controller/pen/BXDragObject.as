package bloxley.controller.pen {
    
    import bloxley.base.BXObject;
    import bloxley.view.gui.BXGeometry;
    import bloxley.view.sprite.BXCompositeSprite;

    public class BXDragObject extends BXObject {

        // How to identify what is being dragged

        var dragKey:String;

        // How big the movie clip is at 100% size

        var originalWidth:Number;
        var originalHeight:Number;

        // Where it is currently located

        var centerX:Number;
        var centerY:Number;
        var maxSize:Number;

        // Where it's being held (during a drag)

        var mouseDX:Number;
        var mouseDY:Number;

        public function BXDragObject(dragKey:String, clipName:String, frameName:String, isCentered:Boolean) {
            super();
            // { centered: isCentered });
        }

        public function centerAt(centerX:Number, centerY:Number) {
            position(centerX, centerY, maxSize);
        }

        public function resizeTo(maxSize:Number) {
            position(centerX, centerY, maxSize);
        }

        public function position(centerX:Number, centerY:Number, maxSize:Number) {
        }

        public function storePosition(centerX:Number, centerY:Number, maxSize:Number) {
        }

        public function attach() {
        }

        public function detatch() {
        }

        public function followMouse() {
        }

        public function stopFollowingMouse() {
        }
        
    }

}