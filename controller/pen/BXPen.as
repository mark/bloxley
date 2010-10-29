package bloxley.controller.pen {

    import flash.events.KeyboardEvent;
    
    import bloxley.base.*;
    import bloxley.controller.game.BXController;
    import bloxley.controller.event.BXUndoQueue;
    import bloxley.controller.pen.*;
    import bloxley.model.data.BXDirection;
    import bloxley.model.collection.BXGroup;
    import bloxley.model.game.*;
    import bloxley.view.gui.*;

    public class BXPen extends BXObject {

        var allowUndos:Boolean; // Do the normal keys for undo work?

        public var controller:BXController;

        var penName:String; // How thehe controller refers to this pen

        public static var currentPen;

        public function BXPen(controller:BXController) {
            this.controller = controller;

    		allowUndos = true;

    		controller.registerPen(this);
        }

        /***************
        *              *
        * Name methods *
        *              *
        ***************/

        public function setName(penName:String) {
            this.penName = penName;
        }

        public function name() {
            return penName;
        }

        /*********************
        *                    *
        * Controller Methods *
        *                    *
        *********************/
        
        public function selection():BXObject {
            return controller.selection();
        }
        
    	/**********************
    	*                     *
    	* Up and Down methods *
    	*                     *
    	**********************/

        public function set() {
            BXSystem.screen.getGraphics().addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
            // Mouse.addListener(this);
            controller.showBank(name() + " Buttons");
            BXPen.currentPen = this;
            onSet();
        }

        public function unset() {
            BXSystem.screen.getGraphics().removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
    	    // Mouse.removeListener(this);
            controller.hideBank(name() + " Buttons");
    	    onUnset();
        }

        public function onSet() {
            // OVERRIDE THIS!
        }

        public function onUnset() {
            // OVERRIDE THIS!
        }

    	/****************
    	*               *
    	* Mouse methods *
    	*               *
    	****************/

        public function mouse():BXMouseEvent {
            return BXMouseEvent.currentMouseEvent;
        }
        
    	// These may go away?  I know at least that right now they're shortcuts to the mouse event stuff.

    	public function x():Number {
    		return mouse().patch().x();
    	}

    	public function y():Number {
    		return mouse().patch().y();
    	}

    	public function isOnBoard():Boolean {
    		//var locX = x();
    		//var locY = y();
            //
    		//return locX >= 0 && locY >= 0 && locX < board().width() && locY < board().height();
    		return true; // Not sure how to handle this right now--it might not even be necessary?
    	}

    	public function patch():BXPatch {
    		return mouse().patch();
    	}

    	public function actor():BXActor {
    		return actors().theFirst();
    	}

    	public function actors():BXGroup {
    		return patch().board().allActors().thatAreAt(patch());
    	}

    	/********************
    	*                   *
    	* Basic Pen Actions *
    	*                   *
    	********************/

        public function up(mouse:BXMouseEvent) {
            // OVERRIDE THIS!
        }

        public function down(mouse:BXMouseEvent) {
            // OVERRIDE THIS!
        }

        public function startDrag(mouse:BXMouseEvent) {
            // OVERRIDE THIS!
        }

        public function drag(mouse:BXMouseEvent) {
            // OVERRIDE THIS!
        }

        public function endDrag(mouse:BXMouseEvent) {
            // OVERRIDE THIS!
        }

        public function cancelDrag(mouse:BXMouseEvent) {
            // OVERRIDE THIS!
        }

        public function press(char:String) {
            // OVERRIDE THIS!
        }

        public function arrow(direction:BXDirection, shift:Boolean, alt:Boolean, ctrl:Boolean) {
            // OVERRIDE THIS!
        }

        public function press_space(shift:Boolean, alt:Boolean, ctrl:Boolean) {
            // OVERRIDE THIS!
        }

        public function press_cmd(shift:Boolean, alt:Boolean, ctrl:Boolean) {
            // OVERRIDE THIS!
        }

        /***************
        *              *
        * Undo methods *
        *              *
        ***************/

        public function press_delete(shift:Boolean, alt:Boolean, ctrl:Boolean) {
            var meth = shift ? "reset" : "undo";
            controller.respondTo(meth);
        }

        /****************************************
        *                                       *
        * MouseListener and KeyListener methods *
        *                                       *
        ****************************************/

        public function onKeyDown(event:KeyboardEvent) {
            var keyCode = event.keyCode;
            var keyChar = String.fromCharCode(event.charCode);

            if (keyCode >= 42) {
                callCascade([ "press_" + keyChar, "press_" + keyChar.toUpperCase() + keyChar.toLowerCase(), "press" ],
                            [ keyChar, event.shiftKey, event.altKey, event.ctrlKey ]);
            }
            
            // For non-character keys

            if (keyCode > 36 && keyCode < 41) {
                arrow(BXDirection.getDirection(keyCode), event.shiftKey, event.altKey, event.ctrlKey);
            }

            if (keyCode == 32) {
                press_space(event.shiftKey, event.altKey, event.ctrlKey);
            }

            if (keyCode == 17) {
                press_cmd(event.shiftKey, event.altKey, event.ctrlKey);
            }
            
            if (keyCode == 8) {
                press_delete(event.shiftKey, event.altKey, event.ctrlKey);
            }
            
        }

        /*
        
        public function toXml(current:Boolean):String {
            var s = "<pen"

            s += " class='" + className(null, true).join('.') + "'";
            s += " name='" + name() + "'";
            s += current ? " default='true'" : "";
            s += " />\n";

            return s;
        }

        public static function loadFromXml(controller:BXController, xml:XML) {
            var classPath = xml.attributes['class'].split('.');
            var klass = BXObject.classWithName(classPath);
            var pen = new klass(controller);

            if (xml.attributes['default']) {
                controller.switchToPen(pen.name());
            }

            return pen;
        }
        */
    }

}