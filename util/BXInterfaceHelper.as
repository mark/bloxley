package bloxley.util {
    
    import bloxley.view.gui.BXButton;
    
    public class BXInterfaceHelper {

    	public static var PlayButton         = new BXButton("playGame",  null, { iconSet: "StandardIcons" });
    	public static var EditButton         = new BXButton("editLevel", null, { iconSet: "StandardIcons" });

        public static var HandButton         = new BXButton("grabHand",  null, { iconSet: "StandardIcons", group: "EditorPens" });
        public static var PatchButton        = new BXButton("patchHand", null, { iconSet: "StandardIcons", group: "EditorPens" });
        public static var RectButton         = new BXButton("rectHand",  null, { iconSet: "StandardIcons", group: "EditorPens" });

        public static var CropButton         = new BXButton("cropRect",     null, { iconSet: "StandardIcons" });
        public static var InsertTopButton    = new BXButton("insertTop",    null, { iconSet: "StandardIcons" });
        public static var InsertBottomButton = new BXButton("insertBottom", null, { iconSet: "StandardIcons" });
        public static var InsertLeftButton   = new BXButton("insertLeft",   null, { iconSet: "StandardIcons" });
        public static var InsertRightButton  = new BXButton("insertRight",  null, { iconSet: "StandardIcons" });

        public static var PrevLevelButton    = new BXButton("previousLevel", null, { iconSet: "StandardIcons" });
        public static var NextLevelButton    = new BXButton("nextLevel",     null, { iconSet: "StandardIcons" });

        public static var SaveButton         = new BXButton("saveBoard",  null, { iconSet: "StandardIcons" });
        public static var ClearButton        = new BXButton("clearBoard", null, { iconSet: "StandardIcons" });

        public static var UndoButton         = new BXButton("undo",  null, { iconSet: "StandardIcons" });
        public static var ResetButton        = new BXButton("reset", null, { iconSet: "StandardIcons" });

        public static function buttonForPatchKey(patchKey:String):BXButton {
    	    return new BXButton("drawPatch", patchKey, { group: "PatchPen" });
    	}
        
        // function buttonForActorKey(options):BXButton {
    	//     return new BXButton("addActor", key(options), { onDown: true });
    	// }
    	
    }
	
}