package bloxley.controller.game {
    
    import bloxley.model.game.*;
    import bloxley.model.collection.*;
    import bloxley.controller.game.*;
    import bloxley.controller.pen.*;
    import bloxley.controller.event.*;
    import bloxley.view.gui.*;
    import bloxley.view.sprite.BXSprite;
    import bloxley.view.layout.BXLayout;
    
    import bloxley.util.BXInterfaceHelper;
    
    public class BXEditorController extends BXController {
        
        var layout:BXLayout;
        var focusRing:BXSprite;
        
        public function BXEditorController(game:BXGame) {
            super("Editor", game);
            
            focusRing = new BXSprite("FocusRing", { layer: "interface", visible: false });
        }

        override public function onStart() {
            showBank("Pen Buttons");
            switchToPen("Patch");
        }

        override public function onFinish() {
            hideBank("Pen Buttons");
            switchToPen(null);
        }
        
        override public function createPens() {
            trace("createPens()");
            
            var actorPen = new BXActorPen(this);
            actorPen.setName("Actor");
            
            var patchPen = new BXPatchPen(this, game.patchController());
            
            new BXColorPen(this);
        }

        override public function createInterface() {
            createPenButtons();
            
            createPatchButtons();
        }

        function createPenButtons():BXButtonArray {
            setBank("Pen Buttons");
                var buttons = penButtons();
                var array = new BXButtonArray(this, [ buttons ]);
                array.resize([32.0 * buttons.length, 32.0]);
                trace("setting button array length to " + 32.0 * buttons.length);
                trace("but will return " + array.get("width"));
                game.layout().place( array, "Controls", 2 );

            return null;
        }
        
        function createPatchButtons():BXButtonArray {
            setBank("Patch Pen Controls");
                var buttons = game.patchController().buttons();
                var array = new BXButtonArray(this, [ buttons ]);
                
                array.resize([32.0 * buttons.length, 32.0]);
                game.layout().place( array, "Controls", 3 );

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
        
        public function selectActor(actor:BXActor) {
            
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

        // public function animateFocusAction(action:BXFocusAction, actor:BXActor) {
        public function animateFocusAction(action:BXAction, actor:BXActor) {
            var sprite = actor.actorController().spriteForActor( actor );
                        
            return [
                focusRing.show(),
//                focusRing.show({ wait: true }),
                focusRing.goto([ sprite.get("x"), sprite.get("y") ]),
//                focusRing.goto([ sprite.get("x"), sprite.get("y") ], { wait: true }),
                focusRing.resize([ sprite.get("width"), sprite.get("height") ])
//                focusRing.resize([ sprite.get("width"), sprite.get("height") ], { wait: true })
            ];
        }

    }
}
