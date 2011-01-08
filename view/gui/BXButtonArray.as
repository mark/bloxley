package bloxley.view.gui {

    import flash.utils.Dictionary;
    import flash.events.MouseEvent;
    
    import bloxley.controller.game.BXInterface;
    import bloxley.view.gui.*;

    public class BXButtonArray extends BXGuiElement {

        var buttons:Array;
        var buttonLayers:Dictionary;

        var currentButton:BXButton;

        var buttonGroups:Object;
        var currentButtonInGroup:Object;

        static var ButtonBackground = [
            "Center", "Center",   "Center",      "Center",
            "Center", "TopLeft",  "BottomLeft",  "Left",
            "Center", "TopRight", "BottomRight", "Right",
            "Center", "Top",      "Bottom",      "Single"
        ];

        public function BXButtonArray(owner:BXInterface, buttons:Array, options = null) {
            this.buttons = buttons;
            super( owner, options );

            this.buttonLayers = new Dictionary();
            
            this.buttonGroups = new Object();
            this.currentButtonInGroup = new Object();

            for (var y = 0; y < buttons.length; y++) {
                for (var x = 0; x < buttons[y].length; x++) {
                    var button = buttons[y][x];

                    if (button != null) {
                        button.setPosition(this, x, y);

                        var iconX = buttonSize() * x;
                        var iconY = buttonSize() * y;
                        
                        var bkgnd = addSpriteLayer( button.backgroundSet() );
                        bkgnd.frame( nameForButton(x, y) + "Up" );
                        bkgnd.goto( [iconX, iconY] );
                        
                        var icon = addSpriteLayer( button.iconSet() );
                        icon.frame( button.icon() );
                        icon.goto( [iconX + buttonSize() * 0.5, iconY + buttonSize() * 0.5] );
                        
                        var highlight = addSpriteLayer( "ButtonHighlight" );
                        highlight.goto( [iconX, iconY] );
                        highlight.fade(0.3);

                        buttonLayers[ button ] = bkgnd;
                        
                        if (button.group()) {
                            addButtonToGroup(button, button.group());
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
        
        override public function setOwner(owner) {
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
        
        function buttonX():int {
            return Math.floor(getGraphics().mouseX / this.buttonSize());
        }
        
        function buttonY():int {
            return Math.floor(getGraphics().mouseY / this.buttonSize());
        }
        
        override public function onMouseDown(event:MouseEvent) {
            this.press(buttonX(), buttonY());
        }

        override public function onMouseMove(event:MouseEvent) {
            this.move(buttonX(), buttonY());
        }

        override public function onMouseUp(event:MouseEvent) {
            this.release(buttonX(), buttonY());
        }

        function press(x:Number, y:Number) {
            var button = buttons[y][x];

            if (button) {
                currentButton = button;
                setButtonState(x, y, true);

                if (button.callOnDown()) {
                    button.call();
                }
            }
        }

        function move(x:Number, y:Number) {
            if (currentButton) {
                setButtonState(currentButton.x(), currentButton.y(), currentButton.x() == x && currentButton.y() == y);
            }
        }

        function release(x:Number, y:Number) {
            setButtonState(currentButton.x(), currentButton.y(), false);

            if (currentButton.x() == x && currentButton.y() == y) {
                // Actual button press

                if (! buttons[y][x].callOnDown()) {
                    buttons[y][x].call();
                }

                highlightButtonInGroup( buttons[y][x] );
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
            
            if (group != null && button != null && currentButtonInGroup[group] == button) {
                state = down ? "Down" : "Toggle";
            } else {
                state = down ? "Down" : "Up";
            }
            
            var frame = nameForButton(x, y) + state;
            
            sprite.frame(frame).start();
        }

        function buttonSize():Number {
            return 48.0;
        }

        /***********************
        *                      *
        * Button Group Methods *
        *                      *
        ***********************/
        
        function addButtonToGroup(button:BXButton, group:String) {
            if (buttonGroups[group] == null) buttonGroups[group] = new Array();

            buttonGroups[group].push( button );
        }

        public function highlightButtonInGroup(button:BXButton) {
            if (button.group()) {
                var group = button.group();

                currentButtonInGroup[group] = button;

                for (var i = 0; i < buttonGroups[group].length; i++) {
                    var groupedButton = buttonGroups[group][i];

                    setButtonState(groupedButton.x(), groupedButton.y(), false);
                }
            }
            
        }
        
        /*****************
        *                *
        * Helper Methods *
        *                *
        *****************/
        
        override public function toString():String { return "Button Array:" + id(); }

    }

}
