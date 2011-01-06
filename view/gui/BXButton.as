package bloxley.view.gui {

    // import bloxley.base.JSON;
    import bloxley.view.gui.*;

    public class BXButton {

        public static var DEFAULT_BUTTON_ICON_SET = "ButtonIcons";
        public static var DEFAULT_BUTTON_BACKGROUND_SET = "ButtonBackground";

        // Position of the button in an array...
        var buttonArray:BXButtonArray;
        var xPos:int;
        var yPos:int;
        
        var method:String;

        var objects:Array;

        var options:Object;
        
        var owner:Object;

        public function BXButton(method, objects, options:Object = null) {
            this.method = method;

            if (objects is Array)
                this.objects = objects;
            else if (objects)
                this.objects = [ objects ];
            else
                this.objects = [];

            this.options = options;
        }

        public function icon():String {
            if (options.icon)
                return options.icon;            
            else if (objects[0])
                return objects[0].toString();
            else
                return method;            
        }

        public function iconSet():String {
            if (options.iconSet)
                return options.iconSet;
            else
                return DEFAULT_BUTTON_ICON_SET;
        }

        public function background():String {
            if (options.background)
                return options.background;
            else
                return null;
        }

        public function backgroundSet():String {
            if (options.backgroundSet)
                return options.backgroundSet;
            else
                return DEFAULT_BUTTON_BACKGROUND_SET;
        }

        public function group():String {
            return options.group;
        }

        public function callOnDown():Boolean {
            return options.onDown;
        }
        
        public function setOwner(owner) {
            this.owner = owner;
        }
        
        public function call() {
            owner.respondTo(method, objects);
        }

        /***********************
        *                      *
        * Button Array Methods *
        *                      *
        ***********************/
        
        public function setPosition(buttonArray:BXButtonArray, xPos:int, yPos:int) {
            this.buttonArray = buttonArray;
            this.xPos = xPos;
            this.yPos = yPos;
        }
        
        public function x():int { return xPos; }
        
        public function y():int { return yPos; }
        
        public function highlight() {
            buttonArray.highlightButtonInGroup(this);
        }
        
        /*****************
        *                *
        * Helper Methods *
        *                *
        *****************/
        
        public function toString():String { return "<Button: " + method + ">"; }

    }
    
}
