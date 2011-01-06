package bloxley.controller.event {
    
    import bloxley.controller.game.BXEditorController;
    import bloxley.controller.event.*;
    import bloxley.model.game.BXPatch;

    public class BXPatchTouchAction extends BXAction {

        var editor:BXEditorController;
    	var pat:BXPatch;
        var attr:String;
            
        var oldValue;
        var newValue;
        
    	public function BXPatchTouchAction(editor:BXEditorController, pat:BXPatch, attr:String, newValue) {
    	    setKey("PatchPen");

            this.editor   = editor;
    		this.pat      = pat;
    		this.attr     = attr;
    		this.newValue = newValue;
    	}

    	override public function act() {
            oldValue = pat.get(attr);
            pat.set(attr, newValue);
    	}

    	override public function undo() {
            pat.set(attr, oldValue);
    	}

        override public function animate() {
            return editor.callCascade([ "animatePatch" + Attribute() + "Change", "animatePatchChange" ],
                                      [ this, pat, attr, oldValue, newValue ]);
        }

        override public function animateUndo() {
            return editor.callCascade([ "animateUndoPatch" + Attribute() + "Change", "animateUndoPatchChange" ],
                                      [ this, pat, attr, oldValue, newValue ]);
        }

        public function attribute():String { return attr;     }
        public function patch():BXPatch    { return pat;      }
        public function oldVal()           { return oldValue; }
        public function newVal()           { return newValue; }

        public function Attribute():String {
            return attr.substr(0, 1).toUpperCase() + attr.substr(1);
        }
    }

}