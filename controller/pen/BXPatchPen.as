package bloxley.controller.pen {
    
    import bloxley.controller.event.*;
    import bloxley.controller.game.BXEditorController;
    import bloxley.controller.game.BXPatchController;
    import bloxley.controller.pen.*;
    import bloxley.model.collection.BXRegion;

    public class BXPatchPen extends BXPen {

    	var key:String;
    	var keyedButtons:Object;
        
    	public function BXPatchPen(controller:BXEditorController, patchController:BXPatchController) {
            super("Patch", controller);
            
            keyedButtons = patchController.keyedButtons();
    	}

    	public function setKey(key:String) {
    		this.key = key;

    		var button = keyedButtons[ key ];
    		if (button) button.highlight();
    	}

    	/********************
    	*                   *
    	* respondTo Methods *
    	*                   *
    	********************/

    	public function drawPatch(key:String) {
            setKey(key);
        }

        public function press_F(key:String, shift, alt, ctrl) {
            var selection = controller.selectedRegion();
            var fillRegion = selection ? selection : board().allPatches();
            
            controller.respondTo("fillRegion", [ fillRegion, key ]);
        }

        /********************
        *                   *
        * Interface Actions *
        *                   *
        ********************/

        override public function down(mouse:BXMouseEvent) {
            if (key != null && patch() != null) {
                controller.respondTo("changePatch", [ patch(), key ]);
            }
        }

    }

}