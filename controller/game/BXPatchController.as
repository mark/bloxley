package bloxley.controller.game {
    
    import flash.utils.Dictionary;
    
    import bloxley.base.BXObject;
    import bloxley.model.game.*;
    import bloxley.controller.event.BXAction;
    import bloxley.controller.game.*;
    import bloxley.controller.io.BXTile;
    import bloxley.controller.io.BXTileLibrary;
    import bloxley.view.sprite.*;

    public class BXPatchController extends BXObject {

        var name:String;
        
        var game:BXGame;
        
        var sprites:Dictionary;
        
    	var tileLibrary:BXTileLibrary;

    	function BXPatchController(name:String, game:BXGame) {
    	    this.name = name;
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
    		var newPatch = new BXPatch(this, key);

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
    	function graphicsName(patch:BXPatch):String { return "Patch"; }

    	function frameName(patch:BXPatch):String { return library().frameForKey(patch.key()); }

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
            sprite.addSpriteLayer( graphicsName(patch) );
            sprite.frame( frameName(patch) );
        }

        function resizeSprite(patch:BXPatch, sprite:BXSprite) {
            // Resize the sprite to the current screen size...
            sprite.resize([ 1.0, 1.0 ]);
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
    }

}
