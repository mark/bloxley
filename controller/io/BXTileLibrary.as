package bloxley.controller.io {
    
    import bloxley.controller.io.BXTile;

    public class BXTileLibrary {

    	var tiles:Array;

    	public function BXTileLibrary(tiles:Array) {
    		this.tiles = tiles;
    	}

    	public function addTile(tile:BXTile) {
    	    tiles.push(tile);
    	}

    	public function defaultKey():String {
    		return tiles[0].key();
    	}

    	public function keyForTile(tile:String):String {
    	    // If we don't know what kind of tile it is yet:
    	    if (tile == null) return defaultKey();
    	    
    	    // Try to match a tile we know about:
    		for (var i = 0; i < tiles.length; i++) {
    			if (tiles[i].actsAsTile(tile)){
    				return tiles[i].key();
    			}
    		}
    		
    		// If it didn't match a known tile:
    		return defaultKey();
    	}

    	public function frameForKey(key:String):String {
    		for (var i = 0; i < tiles.length; i++) {
    			if (tiles[i].key() == key)
    				return tiles[i].frame();
    		}

    		return null;
    	}

    	public function tileForKey(key:String):String {
    		for (var i = 0; i < tiles.length; i++) {
    			if (tiles[i].key() == key)
    				return tiles[i];
    		}

    		return null;
    	}

        public function orderTiles(tileOrder) {
            var newTiles = [];
            
            for (var i = 0; i < tileOrder.length; i++) {
        		for (var j = 0; j < tiles.length; j++) {
        			if (tiles[j].key() == tileOrder[i])
        				newTiles.push( tiles[j] );
        		}
            }
            
            tiles = newTiles;
        }
        
        public function keys():Array {
            var ary = [];
            
            for (var i = 0; i < tiles.length; i++) {
                ary.push( tiles[i].key() );
            }
            
            return ary;
        }

        public function count():int {
            return tiles.length;
        }
    }

}