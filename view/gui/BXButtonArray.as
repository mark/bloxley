package bloxley.view.gui {

    import flash.utils.Dictionary;
    import flash.events.MouseEvent;
    
    import bloxley.controller.game.BXInterface;
    import bloxley.view.gui.*;

    public class BXButtonArray extends BXGuiElement {

        var buttons:Array;
        var buttonLayers:Dictionary;

        var currentButton:Object;

        var buttonGroups:Object;
        var currentButtonInGroup:Object;

        static var ButtonBackground = [
            "Center", "Center",   "Center",      "Center",
            "Center", "TopLeft",  "BottomLeft",  "Left",
            "Center", "TopRight", "BottomRight", "Right",
            "Center", "Top",      "Bottom",      "Single"
        ];

        public function BXButtonArray(owner:BXInterface, buttons:Array, options = null) {
            super( owner, options );

            this.buttons = buttons;
            this.buttonLayers = new Dictionary();
            
            this.buttonGroups = new Object();
            this.currentButtonInGroup = new Object();

            for (var y = 0; y < buttons.length; y++) {
                for (var x = 0; x < buttons[y].length; x++) {
                    var button = buttons[y][x];

                    if (button != null) {
                        var iconX = 48.0 * x;
                        var iconY = 48.0 * y;
                        
                        var bkgnd = addSpriteLayer(button.backgroundSet());
                        bkgnd.frame( nameForButton(x, y) + "Up" );
                        bkgnd.goto( [iconX, iconY] );
                        
                        var icon = addSpriteLayer( button.iconSet() );
                        icon.frame( button.icon() );
                        icon.goto( [iconX + 24.0, iconY + 24.0] );
                        
                        var highlight = addSpriteLayer( "Button Highlight" );
                        highlight.goto( [iconX, iconY] );
                        highlight.fade(0.3);

                        buttonLayers[ button ] = bkgnd;
                        
                        if (button.group()) {
                            addButtonToGroup(x, y, button.group());
                        }
                    }
                }
            }
        }

        /*********************
        *                    *
        * Responds to Events *
        *                    *
        *********************/
        
        public function setOwner(owner) {
            for (var y = 0; y < buttons.length; y++) {
                for (var x = 0; x < buttons[y].length; x++) {
                    var button = buttons[y][x];

                    if (button != null) {
                        button.setOwner(owner);
                    }
                }
            }
        }
        
        /***************
        *              *
        * Mouse Events *
        *              *
        ***************/
        
        override public function onMouseDown(event:MouseEvent) {
            var buttonY = Math.floor((event.stageY) / this.buttonSize());
            var buttonX = Math.floor((event.stageX) / this.buttonSize());
            
            this.press(buttonX, buttonY);
        }


        override public function onMouseMove(event:MouseEvent) {
            var buttonY = Math.floor((event.stageY) / this.buttonSize());
            var buttonX = Math.floor((event.stageX) / this.buttonSize());

            this.move(buttonX, buttonY);
        }

        override public function onMouseUp(event:MouseEvent) {
            var buttonY = Math.floor((event.stageY) / this.buttonSize());
            var buttonX = Math.floor((event.stageX) / this.buttonSize());

            this.release(buttonX, buttonY);
        }

        function press(x:Number, y:Number) {
            var button = buttons[y][x];

            if (button) {
                currentButton = { x:x, y:y };
                setButtonState(x, y, true);

                if (button.callOnDown()) {
                    button.call();
                }
            }
        }

        function move(x:Number, y:Number) {
            if (currentButton) {
                setButtonState(currentButton.x, currentButton.y, currentButton.x == x && currentButton.y == y);
            }
        }

        function release(x:Number, y:Number) {
            setButtonState(currentButton.x, currentButton.y, false);

            if (currentButton.x == x && currentButton.y == y) {
                // Actual button press

                if (! buttons[y][x].callOnDown()) {
                    buttons[y][x].call();
                }

                if (buttons[y][x].group()) {
                    var group = buttons[y][x].group();

                    currentButtonInGroup[group] = [x, y];

                    for (var i = 0; i < buttonGroups[group].length; i++) {
                        var button = buttonGroups[group][i];

                        setButtonState(button[0], button[1], false);
                    }
                }
            }

            currentButton = null;
        }

        function nameForButton(x:Number, y:Number) {
            var button = buttons[y][x];        
             if (button.background() != null) return button.background();

            var index = 0;

            if (buttons[y-1] == null || buttons[y-1][x] == null) index += 1;
            if (buttons[y+1] == null || buttons[y+1][x] == null) index += 2;
            if (buttons[y][x-1] == null) index += 4;
            if (buttons[y][x+1] == null) index += 8;

            return ButtonBackground[index];
        }    

        function setButtonState(x:Number, y:Number, down:Boolean) {
            var button = buttons[y][x];
            var group = button.group();
            var sprite = buttonLayers[ button ];
            var state:String;
            
            if (group != null && currentButtonInGroup[group] != null && currentButtonInGroup[group][0] == x && currentButtonInGroup[group][1] == y) {
                state = down ? "Down" : "Toggle";
            } else {
                state = down ? "Down" : "Up";
            }
            
            var frame = nameForButton(x, y) + state;
            
            sprite.frame(frame).start();
        }

        function addButtonToGroup(x:Number, y:Number, group:String) {
            if (buttonGroups[group] == null) buttonGroups[group] = new Array();

            buttonGroups[group].push([x, y]);
        }

        function buttonSize():Number {
            return 48.0;
        }

        override public function toString():String { return "Button Array:" + id(); }

        /*****************
        *                *
        * Helper methods *
        *                *
        *****************/

        /*
        
        static function loadFromXml(controller:BXController, xml:XML) {
            var buttons = new Array();

            for (var i = 0; i < xml.childNodes.length; i++) {
                var row = xml.childNodes[i];

                if (row.nodeName == "button-row") {
                    var rowArray = new Array();

                    for (var j = 0; j < row.childNodes.length; j++) {
                        var btn = row.childNodes[j];

                        if (btn.nodeName == "button") {
                            var button = BXButton.loadFromXml(btn);

                            rowArray.push(button);
                        }

                        if (btn.nodeName == "blank") {
                            rowArray.push(null);
                        }
                    }

                    buttons.push(rowArray);
                }
            }

            return new BXButtonArray(controller, buttons);
        }

        function toXml(bank:String) {
            var s = new String();

            s += "<button-array bank='" + allBanks() + "' left='" + left + "' top='" + top + "' scale='" + fraction + "'>\n";

            for (var i = 0; i < buttons.length; i++) {
                s += "<button-row>\n";

                for (var j = 0; j < buttons[i].length; j++) {
                    if (buttons[i][j])
                        s += buttons[i][j].toXml();
                    else
                        s += "<blank />\n";
                }

                s += "</button-row>\n"
            }

            s += "</button-array>\n";

            return s;
        }

        */

    }

}
