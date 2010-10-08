package bloxley.view.gui {
    
    import flash.events.MouseEvent;
    
    import bloxley.model.game.*;
    import bloxley.controller.game.BXInterface;
    import bloxley.controller.pen.BXMouseEvent;
    import bloxley.view.gui.*;
    import bloxley.view.sprite.BXCompositeSprite;
    import bloxley.controller.mailbox.BXMessage;

    public class BXGrid extends BXGuiElement {

        var geom:BXGeometry;

        var layers:Object;

        var board:BXBoard;

        static var LAYERS = [ "underlayLayer", "patchLayer", "innerLayer", "actorLayer", "overlayLayer" ];

        public function BXGrid(owner:BXInterface, options:Object) {
            super( owner, options );

            this.geom = new BXGeometry( this, options.gridSize );

            this.layers = new Object();

            for (var i = 0; i < LAYERS.length; i++) {
                layers[ LAYERS[i] ] = addEmptyLayer(i);
            }
        }

        function geometry():BXGeometry {
            return geom;
        }

        public function layerNamed(layerName:String):BXCompositeSprite {
            return layers[layerName];
        }

        /*
        static function loadFromXml(controller:BXController, xml:XML):BXGrid {
            var geom:BXGeometry;

            for (var i = 0; i < xml.childNodes.length; i++) {
                var child = xml.childNodes[i];

                if (child.nodeName == "geometry") {
                    geom = BXGeometry.loadFromXml(child);
                }

                // No more children for now...
            }

            var grid = new BXGrid(controller, geom);

            return grid;
        }

        */
        
        public function setBoard(board:BXBoard) {
            this.board = board;
            var that = this;
            
            board.allPatches().each( function(patch:BXPatch) {
                attachPatch(patch);
            });
            
            listenFor("BXPatchAttached", board, patchAdded);
            listenFor("BXActorAttached", board, actorAdded);
        }

        /****************
        *               *
        * Patch Methods *
        *               *
        ****************/
        
        public function attachPatch(patch:BXPatch) {
            var controller = patch.patchController();
            var sprite = layerNamed("patchLayer").addEmptyLayer({ centered: controller.registrationAtCenter(patch) });
            
            sprite.setGeometry( geometry() );
            sprite.goto( patch );
            
            controller.renderPatchSprite(patch, sprite);
        }
        
        function patchAdded(message:BXMessage) {
            var patch = message.info;
            attachPatch(patch);
        }
        
        /****************
        *               *
        * Actor Methods *
        *               *
        ****************/
        
        public function attachActor(actor:BXActor) {
            var controller = actor.actorController();
            var sprite = layerNamed("actorLayer").addEmptyLayer({ centered: controller.registrationAtCenter(actor) });
            
            sprite.setGeometry( geometry() );
            sprite.goto( actor.location() );
            
            controller.renderActorSprite(actor, sprite);
        }

        function actorAdded(message:BXMessage) {
            var actor = message.info;
            attachActor(actor);
        }
        
        /****************
        *               *
        * Mouse Methods *
        *               *
        ****************/

        function patchHit(xMouse:Number, yMouse:Number):BXPatch {
            var x = geometry().screenToGridX(xMouse);
            var y = geometry().screenToGridY(yMouse);
        
            return board.getPatch(x, y);
        }

        override public function onMouseDown(event:MouseEvent) {
            var mouseEvent = new BXMouseEvent(owner);
            mouseEvent.downOnGrid(patchHit(event.stageX, event.stageY));
        }

        override public function onMouseMove(event:MouseEvent) {
            if (mouse()) {
                var patch = patchHit(event.stageX, event.stageY);
            
                mouse().dragOnGrid(patchHit(event.stageX, event.stageY),
                    geometry().xCenterForPatch(patch) + getGraphics().x, geometry().yCenterForPatch(patch) + getGraphics().y);
            }
        }

        override public function onMouseUp(event:MouseEvent) {
            if (mouse()) {
                mouse().upOnGrid(patchHit(event.stageX, event.stageY));
            }
        }

        // override public function onMouseOver(event:MouseEvent) {
        //     if (mouse()) {
        //         
        //     }
        // }
    }

}
