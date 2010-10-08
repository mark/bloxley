package bloxley.util {
    
    import bloxley.view.gui.BXButton;
    
    public class BXInterfaceHelper {

    	public static var PlayButton         = new BXButton("playGame",  null, { iconSet: "Standard Icons" });
    	public static var EditButton         = new BXButton("editLevel", null, { iconSet: "Standard Icons" });

        public static var HandButton         = new BXButton("grabHand",  null, { iconSet: "Standard Icons", group: "EditorPens" });
        public static var PatchButton        = new BXButton("patchHand", null, { iconSet: "Standard Icons", group: "EditorPens" });
        public static var RectButton         = new BXButton("rectHand",  null, { iconSet: "Standard Icons", group: "EditorPens" });

        public static var CropButton         = new BXButton("cropRect",     null, { iconSet: "Standard Icons" });
        public static var InsertTopButton    = new BXButton("insertTop",    null, { iconSet: "Standard Icons" });
        public static var InsertBottomButton = new BXButton("insertBottom", null, { iconSet: "Standard Icons" });
        public static var InsertLeftButton   = new BXButton("insertLeft",   null, { iconSet: "Standard Icons" });
        public static var InsertRightButton  = new BXButton("insertRight",  null, { iconSet: "Standard Icons" });

        public static var PrevLevelButton    = new BXButton("previousLevel", null, { iconSet: "Standard Icons" });
        public static var NextLevelButton    = new BXButton("nextLevel",     null, { iconSet: "Standard Icons" });

        public static var SaveButton         = new BXButton("saveBoard",  null, { iconSet: "Standard Icons" });
        public static var ClearButton        = new BXButton("clearBoard", null, { iconSet: "Standard Icons" });

        public static var UndoButton         = new BXButton("undo",  null, { iconSet: "Standard Icons" });
        public static var ResetButton        = new BXButton("reset", null, { iconSet: "Standard Icons" });

        public static function buttonForPatchKey(patchKey:String):BXButton {
    	    return new BXButton("drawPatch", patchKey, { group: "PatchPen" });
    	}
        
        function buttonForActorKey(options):BXButton {
    	    return new BXButton("addActor", key(options), { onDown: true });
    	}
    	
    }
	
}