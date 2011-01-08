package bloxley.controller.game {
    
    import bloxley.model.game.*;
    import bloxley.model.collection.*;
    import bloxley.controller.game.*;
    import bloxley.controller.pen.*;
    import bloxley.controller.event.*;
    import bloxley.view.gui.*;
    
    import bloxley.util.BXInterfaceHelper;
    
    public class BXEditorController extends BXController {
        
        public function BXEditorController(game:BXGame) {
            super("Editor", game);
        }

        override public function onStart() {
            // showBank("Pen Buttons");
            switchToPen("Patch");
        }

        override public function createPens() {
            trace("createPens()");
            
            var actorPen = new BXActorPen(this);
            actorPen.setName("Actor");
            
            var patchPen = new BXPatchPen(this);
        }

        override public function createInterface() {
            trace("createInterface");
         
            createPenButtons();
            
            createPatchButtons();
        }

        function createPenButtons():BXButtonArray {
            setBank("Pen Buttons");
            return null;
        }
        
        function createPatchButtons():BXButtonArray {
            setBank("Patch Pen Controls");
                var buttons = game.patchController().buttons();
                var array = new BXButtonArray(this, [ buttons ]);
                array.resize([32.0 * buttons.length, 32.0]);
                array.goto([4.0, 4.0]);

            return array;
        }

        /*****************
        *                *
        * Editor Methods *
        *                *
        *****************/
        
        public function changePatch(patch:BXPatch, newKey:String) {
            event( new BXPatchTouchAction(this, patch, "key", newKey) );
        }
        
        public function fillRegion(region:BXRegion, newKey:String) {
            event( new BXPatchFillAction(this, region, newKey) );
        }
        
        /********************
        *                   *
        * Animation Methods *
        *                   *
        ********************/
        
        public function animatePatchKeyChange(action:BXAction, patch:BXPatch, attribute:String, oldValue, newValue) {
            var sprite = patch.patchController().spriteForPatch( patch );
            
            return sprite.frame( newValue, { wait: true });
        }

        public function animateUndoPatchKeyChange(action:BXAction, patch:BXPatch, attribute:String, oldValue, newValue) {
            var sprite = patch.patchController().spriteForPatch( patch );

            return sprite.frame( oldValue );
        }

    }
}
