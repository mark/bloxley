package bloxley.controller.pen {
    
    import bloxley.model.game.BXActor;
    import bloxley.controller.event.*;
    import bloxley.controller.game.BXEditorController;
    import bloxley.controller.pen.*;

    public class BXActorPen extends BXPen {

        var object:BXActor; // What object this pen is currently holding.

        var newObject:Boolean; // Is this a newly created object? (did it have to be added to the pen manually?)
        var dragOn:Boolean;    // Is the current object being dragged?

        public function BXActorPen(controller:BXEditorController) {
            super("Actor", controller);
        }

        public function attachActor(object:BXActor) {
            // this.object = object;
            // object.display(grid());
            // 
            // object.sprite().goto([_xmouse, _ymouse]);
            // object.startDrag();
            // this.newObject = true;
            // this.dragOn = true;
        }

    	public function detatchActor() {
    		// object.stopDrag();
    		// this.object = null;
    		// this.newObject = false;
    		// this.dragOn = false;
    	}

    	/********************
    	*                   *
    	* respondTo Methods *
    	*                   *
    	********************/

        // When you create an object from a button, use this to manually add it to the pen
        public function addActor(key:String, options:Object) {
            // var actorController = controller.game().actorControllerFor(key, options);
            // var actor = actorController.loadActor(board(), options);
            // //trace("addActor('" + key + "') => " + actor.sprite());
            // 
            // attachActor(actor);
            // 
            // currentAction = new BXAddAction(object).wait(true);
    		// currentAction.causes(new BXSelectionAction(controller));
        }

        public function actorDrag(dragObject:BXDragObject) {
            //dragObject.attach();        
        }

        override public function endDrag(mouseEvent:BXMouseEvent) {
            // var actorController = controller.actorControllerFor(mouseEvent.dragObject.dragKey); //, options);
            // var actor = actorController.loadActor(board()); //, options);
            // 
            // currentAction = new BXAddAction(object).wait(true);
    		// currentAction.causes(new BXSelectionAction(controller));
    		// currentAction.start();
        }

        /********************
        *                   *
        * Interface Actions *
        *                   *
        ********************/

        override public function down(mouse:BXMouseEvent) {
            var obj = board().allActors().thatAreAt(patch()).theFirst();
            
            if (obj != null) {
                // object = obj;
                // this.newObject = false;
                controller.respondTo("animateFocusAction", [ null, obj ]);
    		//	currentAction = new BXSelectionAction(controller).wait(true);
            }
        }

        public function move() {
            // if (isOnBoard()) {
            //     if (object != null) {
            //         currentAction.causes(new BXPlaceAction(object, patch()));
            //     }
            // 
            //     if (dragOn) {
            //         dragOn = false;
            //         object.stopDrag();
            //     }
            // } else {
            //     if (object != null) {
            //         if (! dragOn) {
            //             dragOn = true;
            //             object.startDrag();
            //         }
            //     }
            // }
        }

        override public function up(mouse:BXMouseEvent) {
            // if (currentAction == null) return;
            // 
            // if (isOnBoard()) {
    		// 	//currentAction.causes(new BXPlaceAction(object, patch()));
            // 
    		// 	currentAction.start();
    		// 	currentAction = null;
    		// 	detatchActor();
            // } else {
            //     // Should this depend on whether it is a new object or not?
    		// 	currentAction.causes(new BXDestroyAction(object));
            // 
    		// 	currentAction.start();
    		// 	currentAction = null;
    		// 	detatchActor();
            // }
            // 
            // dragOn = false;
            // newObject = false;
        }

    }
    
}