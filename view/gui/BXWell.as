package bloxley.view.gui {

    import flash.events.MouseEvent;
    
    import bloxley.controller.game.BXInterface;
    import bloxley.view.gui.*;
    import bloxley.controller.pen.*;

    public class BXWell extends BXGuiElement {

        static var FullSize         = 48.0;
        static var MaxDraggableSize = 36.0;

        var dragObject:BXDragObject;
        public var wellKey:String;
        var settings:Object;

        public function BXWell(controller:BXInterface, wellKey:String, settings:Object) {
            super(controller, false);
            this.wellKey = wellKey;
            this.settings = settings;

            addSpriteLayer("DragWell");
        }

        public function attach(dragKey:String, clipName:String, frameName:String, isCentered:Boolean) {
            // dragObject = new BXDragObject(dragKey, clipName, frameName, isCentered);
            // 
            // dragObject.centerAt(centerX(), centerY());
            // dragObject.resizeTo(BXWell.MaxDraggableSize * fraction);
        }

        /****************
        *               *
        * Event Methods *
        *               *
        ****************/
        
        override public function onMouseDown(event:MouseEvent) {
            // this.dragObject.attach();
            //if (dragObject) controller.respondTo(wellKey + "Drag", [ dragObject ]);
            if (dragObject != null) {
                var bpEvent = new BXMouseEvent(owner);

                bpEvent.attach(dragObject);
                this.dragObject = null;

                bpEvent.downOnWell(this);
            }
        }

        override public function onMouseUp(event:MouseEvent) {
            if (mouse() != null) {
                mouse().upOnWell(this);
            }
        }
    }
    
}