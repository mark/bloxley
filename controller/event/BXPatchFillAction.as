package bloxley.controller.event {
    
    import flash.utils.Dictionary;
    
    import bloxley.model.collection.BXRegion;
    import bloxley.controller.event.BXAction;
    import bloxley.controller.game.BXEditorController;
    
    public class BXPatchFillAction extends BXAction {
        var editor:BXEditorController;
        var region:BXRegion;
        
        public var newKey:String;
        var oldKeys:Dictionary;
        
        public function BXPatchFillAction(editor:BXEditorController, region:BXRegion, newKey:String) {
    	    setKey("PatchPen");

            this.editor  = editor;
    		this.region  = region;
    		this.newKey  = newKey;
    		this.oldKeys = new Dictionary();
    	}

    	override public function act() {
    	    region.each( function(patch) {
    	        oldKeys[ patch ] = patch.key();
    	        patch.setKey(newKey);
    	    });
    	}

    	override public function undo() {
    	    region.each( function(patch) {
    	        patch.setKey( oldKeys[ patch ] );
    	    });
    	}

        override public function animate() {
            var anims = [];
            var self = this;
            
            region.each( function(patch) {
                anims.push( editor.animatePatchKeyChange(self, patch, "key", oldKeys[ patch ], newKey) ); 
            });
            
            return anims;
        }

        override public function animateUndo() {
            var anims = [];
            var self = this;
            
            region.each( function(patch) {
                anims.push( editor.animateUndoPatchKeyChange(self, patch, "key", oldKeys[ patch ], newKey) ); 
            });
            
            return anims;
        }
    	
    }
}