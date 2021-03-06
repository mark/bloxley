package bloxley.controller.game {
    
    import flash.utils.Dictionary;
    
    import bloxley.base.BXObject;
    import bloxley.model.game.*;
    import bloxley.controller.event.*;
    import bloxley.controller.game.*;
    import bloxley.controller.io.BXTile;
    import bloxley.controller.io.BXTileLibrary;
    import bloxley.view.sprite.*;
    import bloxley.view.gui.BXButton;

    public class BXPatchController extends BXObject {

        var name:String;
        
        protected var game:BXGame;
        
        var sprites:Dictionary;
        
    	var tileLibrary:BXTileLibrary;

        var buttonHash:Object;
        
    	function BXPatchController(game:BXGame) {
    	    this.name = "Patch";
    		this.game = game;
    		this.sprites = new Dictionary();
        }

    	/***********************
    	*                      *
    	* Tile Library Methods *
    	*                      *
    	***********************/

    	public function tile(key:String, xmlChars:String, frame:String = null) {
    	    if (tileLibrary == null) tileLibrary = new BXTileLibrary([]);

    	    var newTile = new BXTile(key, xmlChars, frame);
    	    tileLibrary.addTile(newTile);
    	}

        public function tiles(object:Object) {
            for (var k in object) {
                tile( k, object[k] );
            }
        }
        
        public function orderTiles(...tileOrder) {
            tileLibrary.orderTiles(tileOrder);
        }
        
    	public function library():BXTileLibrary {
    		return tileLibrary;
    	}

        /*******************
        *                  *
        * Creation Methods *
        *                  *
        *******************/
        
    	public function createPatch(char:String) {
    		var key = tileLibrary.keyForTile(char);
    		var newPatch = new BXPatch(this, key, { tile: char });

            // Note that at this point the patch does not have a location:
    		initializePatch(newPatch);

    		return newPatch;
    	}

    	public function initializePatch(patch:BXPatch) {
    		// OVERRIDE ME!
    	}

        /***************************
        *                          *
        * Sprite Attribute Methods *
        *                          *
        ***************************/
        
    	// This can be overridden, but probably shouldn't be.
    	public function graphicsName(patch:BXPatch):String { return "Patch"; }

    	public function frameName(patch:BXPatch):String { return library().frameForKey(patch.key()); }

        public function registrationAtCenter(patch:BXPatch):Boolean {
            return false;
        }
        
        /*****************
        *                *
        * Sprite Methods *
        *                *
        *****************/
        
        public function spriteForPatch(patch:BXPatch):BXSprite {
            return sprites[ patch ];
        }
        
        public function renderPatchSprite(patch:BXPatch, sprite:BXCompositeSprite):BXCompositeSprite {
            sprites[ patch ] = sprite;
            
            displaySprite(patch, sprite);
            resizeSprite(patch, sprite);
            initializeSprite(patch, sprite);
            
            return sprite;
        }
        
        // Set it to the correct clip and frame
        function displaySprite(patch:BXPatch, sprite:BXCompositeSprite) {
            var layer = sprite.addSpriteLayer( graphicsName(patch) );
            var frame = frameName(patch);
            
            if (frame)
                sprite.frame( frameName(patch) );
        }

        function resizeSprite(patch:BXPatch, sprite:BXSprite) {
            // Resize the sprite to the current screen size...
            if (sprite is BXCompositeSprite) {
                (sprite as BXCompositeSprite).layer(0).resize([ 1.0, 1.0 ]);
                // sprite.resize([ 1.0, 1.0 ]);
            } else {
                sprite.resize([ 1.0, 1.0 ]);
            }
        }
        
    	public function initializeSprite(patch:BXPatch, sprite:BXSprite) { 
    		// OVERRIDE ME!
    	}

        /**************************
        *                         *
        * Event-cascading Methods *
        *                         *
        **************************/

    	public function resolveEvent(action:BXAction, eventType:String, source:BXActor, target:BXPatch):Boolean {
    		return callCascade([
    		    "can" + source.key() + eventType + target.key(),
    		    "can" + eventType + target.key(),
    		    "can" + source.key() + eventType,
    		    "can" + eventType
    		], [ action, source, target ]);
    	}

    	public function canEnter(action, source:BXActor, target:BXPatch) {
    		action.succeed();
    	}

    	public function canExit(action, source:BXActor, target:BXPatch) {
    		action.succeed();
    	}
        
        /****************************
        *                           *
        * Default Animation Methods *
        *                           *
        ****************************/
        
        public function animatePatchChange(patch:BXPatch, action:BXPatchChangeAction) {
            return spriteForPatch(patch).frame(action.newKey, { wait: true });
        }

        public function animateUndoPatchChange(patch:BXPatch, action:BXPatchChangeAction) {
            return spriteForPatch(patch).frame(action.oldKey);
        }
        
    	/*****************
    	*                *
    	* Saving Methods *
    	*                *
    	*****************/

        /*
        
    	public function exportPatch(patch:BXPatch):String {
    		var tile = tiles().tileForKey(patch.key());

    		return tile.toXml();
    	}

        */
        
        /*****************
        *                *
        * Helper Methods *
        *                *
        *****************/
        
        public function keyedButtons():Object {
            if (buttonHash == null) {
                buttonHash = new Object();
                var keys = tileLibrary.keys();

                for (var i = 0; i < keys.length; i++) {
                    buttonHash[ keys[i] ] = new BXButton( "drawPatch", keys[i], { iconSet: "GameIcons", group: "Patch Buttons" } );
                }
            }
            
            return buttonHash;
        }

        public function buttons():Array {
            if (buttonHash == null) keyedButtons();
            
            var keys = tileLibrary.keys();
            var ary = [];
            
            for (var i = 0; i < keys.length; i++) {
                ary.push( buttonHash[ keys[i] ] );
            }
            
            return ary;
        }
    }

}
