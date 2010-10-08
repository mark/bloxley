package bloxley.view.gui {

    import flash.events.MouseEvent;
    
    import bloxley.base.BXObject;
    import bloxley.controller.game.BXInterface;
    import bloxley.view.sprite.BXCompositeSprite;
    import bloxley.view.animation.BXBlend;
    import bloxley.view.gui.*;
    import bloxley.controller.pen.BXMouseEvent;

    public class BXGuiElement extends BXCompositeSprite {

        static var namedElements = new Object();

        var owner:BXInterface;
        
        var name:String;

        //var controller:BXController;
        var banks:Array;

        // function BXGuiElement(controller:BXController, makeBlankMovieClip:Boolean) {
        public function BXGuiElement(owner:BXInterface, options:Object = null) {
            super(options);
            this.owner = owner;
            
            // this.controller = controller;
            this.banks = new Array();
            
            hide();
        }

        /***************
        *              *
        * Name Methods *
        *              *
        ***************/

        public function setName(name:String) {
            if (namedElements[name] == null) {
                this.name = name;
                namedElements[name] = this;
            } else {
                //trace("ERROR: Duplicate name: '" + name + "'");
            }
        }

        public function isNamed(name:String):Boolean {
            return this.name == name;
        }

        public static function named(name:String):BXGuiElement {
            return namedElements[name];
        }

        /***************
        *              *
        * Bank Methods *
        *              *
        ***************/

        public function addToBank(bank:String) {
            banks.push(bank);
        }

        public function allBanks():String {
            return banks.join(",");
        }

        /****************
        *               *
        * Event Methods *
        *               *
        ****************/

        public function onMouseDown(event:MouseEvent) { }
        public function onMouseUp(event:MouseEvent) { }
        public function onMouseMove(event:MouseEvent) { }
        public function onMouseOut(event:MouseEvent) { }
        public function onMouseOver(event:MouseEvent) { }

        function addMouseEvents() {
            var g = getGraphics();

            g.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
            g.addEventListener(MouseEvent.MOUSE_UP,   onMouseUp  );
            g.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
            g.addEventListener(MouseEvent.MOUSE_OUT,  onMouseOut );
            g.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
            
        }

        function removeMouseEvents() {
            var g = getGraphics();

            g.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
            g.removeEventListener(MouseEvent.MOUSE_UP,   onMouseUp  );
            g.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
            g.removeEventListener(MouseEvent.MOUSE_OUT,  onMouseOut );
            g.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
        }

        function mouse():BXMouseEvent {
            return BXMouseEvent.currentMouseEvent;
        }
        
        /******************
        *                 *
        * Display Methods *
        *                 *
        ******************/

        override public function hide(options = null):BXBlend { removeMouseEvents(); return super.hide(options); }
        override public function show(options = null):BXBlend { addMouseEvents();    return super.show(options); }

    }
    
}
