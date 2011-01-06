package bloxley.controller.pen {
    
    import bloxley.controller.event.*;
    import bloxley.controller.game.BXEditorController;
    import bloxley.controller.pen.*;
    import bloxley.model.collection.BXRegion;

    public class BXPatchPen extends BXPen {

    	var key:String;

    	public function BXPatchPen(controller:BXEditorController) {
            super("Patch", controller);

    		key = "Wall";
    	}

    	public function setKey(key:String) {
    		this.key = key;
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
            if (patch() != null) {
                controller.respondTo("changePatch", [ patch(), key ]);
            }
        }

    }

}