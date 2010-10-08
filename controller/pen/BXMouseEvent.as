package bloxley.controller.pen {

    import flash.events.MouseEvent;
    
    import bloxley.base.*;
    import bloxley.model.game.BXPatch;
    import bloxley.model.collection.BXPath;
    import bloxley.controller.game.BXInterface;
    import bloxley.controller.pen.BXDragObject;
    import bloxley.view.gui.*;

    public class BXMouseEvent extends BXObject {

        public static var currentMouseEvent:BXMouseEvent;

        var path:BXPath;

        var controller:BXInterface;
        
        var isStarted:Boolean;
        var isDragging:Boolean;
        var isEnded:Boolean;

        var startingWell:BXWell; // If the drag started at a well
        var endingWell:BXWell;   // If the drag ended at a well

        var dragObject:BXDragObject;

        public function BXMouseEvent(controller:BXInterface) {
            this.controller = controller;
            this.path       = new BXPath();
            this.isStarted  = false;
            this.isDragging = false;
            this.isEnded    = false;

            BXMouseEvent.currentMouseEvent = this;

            BXSystem.screen.getGraphics().addEventListener(MouseEvent.MOUSE_UP, upOnNothing);
        }

        /**********************
        *                     *
        * Drag Object Methods *
        *                     *
        **********************/

        public function attach(dragObject:BXDragObject) {
            this.dragObject = dragObject;
            dragObject.attach();
        }

        /***************
        *              *
        * Well Methods *
        *              *
        ***************/

        public function downOnWell(well:BXWell) {
            isStarted    = true;
            isDragging   = true;
            startingWell = well;
            controller.respondTo(well.wellKey + "Drag", [this]);
        }

        public function upOnWell(well:BXWell) {
            isEnded = true;
            endingWell = well;
            controller.respondTo(well.wellKey + "Drop", [this]);

            BXMouseEvent.currentMouseEvent = null;
        }

        /***************
        *              *
        * Grid Methods *
        *              *
        ***************/

        public function downOnGrid(patch:BXPatch) {        
            isStarted = true;
            path.addStep(patch);
            controller.respondTo("down", [this]);
        }

        public function dragOnGrid(patch:BXPatch, centerX:Number, centerY:Number) {
            if (path.current() != patch) { // The pen has moved
                if (! dragging()) { // We're just starting to drag
                    isDragging = true;
                    controller.respondTo("startDrag", [this]);
                }

                path.addStep(patch);
                controller.respondTo("drag", [this]);

                if (dragObject) {
                    dragObject.centerAt(centerX, centerY);
                }
            }

        }

        public function upOnGrid(patch:BXPatch) {
            isEnded = true;

            if (dragging()) {
                controller.respondTo("endDrag", [this]);
            } else {
                controller.respondTo("up", [this]);
            }

            BXMouseEvent.currentMouseEvent = null;
        }

        /***********************
        *                      *
        * Element-less Methods *
        *                      *
        ***********************/

        public function dragOnNothing() {
            if (dragObject)
                dragObject.followMouse();
        }

        public function upOnNothing(event:MouseEvent = null) {
            if (! isEnded) {
                isEnded = true;
                controller.respondTo("cancelDrag", [this]);

                BXMouseEvent.currentMouseEvent = null;
            }
        }

        /*****************
        *                *
        * Helper Methods *
        *                *
        *****************/

        public function patch():BXPatch {
            return path.current();
        }

        public function started():Boolean {
            return isStarted;
        }

        public function dragging():Boolean {
            return isDragging;
        }

        public function ended():Boolean {
            return isEnded;
        }

    }

}