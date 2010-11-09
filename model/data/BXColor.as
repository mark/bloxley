package bloxley.model.data {
    
    public class BXColor {

    	public var name:String;
    	public var cap:String;
    	public var lower:String;
    	public var hex:Number;

    	public static var Colors = new Array();
    	       static var Lookup = new Object();

    	public function BXColor(name, cap, lower, hex) {
    		this.name = name;
    		this.cap = cap;
    		this.lower = lower;
    		this.hex = hex;

    		if (name != "No Color") {
    		    Colors.push(this);
    		    Lookup[cap]   = this;
    		    Lookup[lower] = this;
    		    Lookup[name]  = this;
    		}
    	}

    	public static var Red     = new BXColor("Red",	    "R", "r", 0xDD0000);
    	public static var Orange  = new BXColor("Orange",   "O", "o", 0xFF6600);
    	public static var Yellow  = new BXColor("Yellow",   "Y", "y", 0xFFFF33);
    	public static var Green   = new BXColor("Green",    "G", "g", 0x00DD00);
    	public static var Cyan    = new BXColor("Cyan",     "C", "c", 0x00FFFF);
    	public static var Blue    = new BXColor("Blue",	    "B", "b", 0x0000DD);
    	public static var Purple  = new BXColor("Purple",   "P", "p", 0x990099);
    	public static var Black   = new BXColor("Black",    "K", "k", 0x000000);
    	public static var Grey    = new BXColor("Grey",     "E", "e", 0x999999);
    	public static var White   = new BXColor("White",    "W", "w", 0xFFFFFF);

    	public static var NoColor = new BXColor("No Color", "-", "-", 0xFFFFFF);

    	public static function getColor(by:String):BXColor {
    		var found = Lookup[by];
    		
    		return found ? found : NoColor; // No color found
    	}

    	public function toString():String {
    		return "Color{" + name + ": #" + hex + "}"
    	}

        public static function upperCases():String {
            var string = "";
            
    		for (var i = 0; i < Colors.length; i++) {
    		    string += Colors[i].cap;
		    }
		    
		    return string;
        }

        public static function lowerCases():String {
            var string = "";
            
    		for (var i = 0; i < Colors.length; i++) {
    		    string += Colors[i].lower;
		    }
		    
		    return string;
        }
        
        public static function bothCases():String {
		    return upperCases() + lowerCases();
        }
        
    }

}