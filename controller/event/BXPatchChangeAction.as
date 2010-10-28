package bloxley.controller.event {
    
    import bloxley.controller.event.*;
    import bloxley.model.game.BXPatch;

    public class BXPatchChangeAction extends BXAction {

    	var patch:BXPatch;

    	public var newKey:String;
    	public var oldKey:String;

    	public function BXPatchChangeAction(patch:BXPatch, newKey:String) {
    	    setKey("PatchPen");

    		this.patch = patch;
    		this.newKey = newKey;
    	}

    	override public function act() {
    		oldKey = patch.key();

    		patch.setKey(newKey);
    	}

    	override public function undo() {
    		patch.setKey(oldKey);
    	}

        override public function animate() {
            var controller = patch.patchController();
            return controller.animatePatchChange(patch, this);
        }

        override public function animateUndo() {
            var controller = patch.patchController();
            return controller.animateUndoPatchChange(patch, this);
        }
    }

}