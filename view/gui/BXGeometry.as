package bloxley.view.gui {
    
    import bloxley.model.game.BXPatch;
    import bloxley.view.sprite.BXSprite;

    public class BXGeometry {

    	var owner:BXSprite;

    	var patchSize:Number;

    	public function BXGeometry(owner:BXSprite, patchSize:Number) {
    	    this.owner = owner;
    		this.patchSize = patchSize;
    	}

        /**********************
        *                     *
        * Calculation Methods *
        *                     *
        **********************/

        function top():Number {
            return owner.getGraphics().y;
        }
        
        function left():Number {
            return owner.getGraphics().x;
        }
        
    	public function topForPatch(patch:BXPatch):Number {
    		return gridToScreenY( patch.y(), false );
    	}
        
    	public function yCenterForPatch(patch:BXPatch):Number {
    		return gridToScreenY( patch.y(), true );
    	}
        
    	public function leftForPatch(patch:BXPatch):Number {
    		return gridToScreenX( patch.x(), false );
    	}
        
    	public function xCenterForPatch(patch:BXPatch):Number {
    		return gridToScreenX( patch.x(), true );
    	}
        
    	public function screenToGridX(screenX:Number):Number {
    		return Math.floor((screenX - left()) / patchSize);
    	}

        public function gridToScreenX(gridX:Number, centered:Boolean = false):Number {
            return patchSize * (gridX + (centered ? 0.5 : 0.0));
        }
        
    	public function screenToGridY(screenY:Number):Number {
    		return Math.floor((screenY - top()) / patchSize);
    	}

        public function gridToScreenY(gridY:Number, centered:Boolean = false):Number {
            return patchSize * (gridY + (centered ? 0.5 : 0.0));
        }
        
    	public function lengthForCells(cells:Number):Number {
    		return patchSize * cells;
    	}

        public function patchBoundsToScreenBounds(bounds) {
            var screenBounds = new Object();

            screenBounds.left = patchSize * bounds.left;
            screenBounds.right = patchSize * (bounds.right + 1) - 1;
            screenBounds.top = patchSize * bounds.top;
            screenBounds.bottom = patchSize * (bounds.bottom + 1) - 1;

            return screenBounds;
        }

        public function centerInRect(top:Number, left:Number, bottom:Number, right:Number, rows:Number, columns:Number) {
            //calculate screen location based on width and height of board
    		var hfc = lengthForCells(rows);
    		var wfc = lengthForCells(columns);
    		top  = (right - left)/2 - (wfc / 2) + left;
    		left = (bottom - top)/2 - (hfc / 2) + top;
        }

        /***************************
        *                          *
        * Loading & Saving Methods *
        *                          *
        ***************************/

        /*
        
        function toXml() {
            return "<geometry type='rect' size='" + patchSize + "' />\n";
        }

        static function loadFromXml(xml:XML):BXGeometry {
            return new BXGeometry(Number(xml.attributes.top), Number(xml.attributes.left), Number(xml.attributes.size));
        }

        */
        
    }

}