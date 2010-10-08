package bloxley.controller.io {
    
    public class BXTile {

    	var _frame:String;

    	var _key:String;

    	var xmlChars:String;

    	public function BXTile(key:String, xmlChars:String, frame:String) {
    		this._key = key;
    		this.xmlChars = xmlChars;
    		this._frame = frame == null ? key : frame;
    	}

    	public function key() {
    		return _key;
    	}

    	public function frame() {
    		return _frame;
    	}

    	public function actsAsTile(tile:String):Boolean {
    		return xmlChars.indexOf(tile) != -1;
    	}

    	public function toXml():String {
    		return xmlChars.charAt(0);
    	}

    }

}
