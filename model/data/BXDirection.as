package bloxley.model.data {
    
    public class BXDirection {

    	var offsetX:Number;
    	var offsetY:Number;

    	// Direction constants

    	public static var I     = new BXDirection( 0,  0);

    	public static var North = new BXDirection( 0, -1);
    	public static var South = new BXDirection( 0,  1);

    	public static var East  = new BXDirection( 1,  0);
    	public static var West  = new BXDirection(-1,  0);

    	// Numeric constants

        static var TO_DEGREE = 180.0 / Math.PI;

    	/*****************************************
    	*                                        *
    	* Constructor and Initialization methods *
    	*                                        *
    	*****************************************/

    	// This should be private
    	public function BXDirection(offsetX:Number, offsetY:Number) {
    		this.offsetX = offsetX;
    		this.offsetY = offsetY;
    	}

    	public static function getDirection(arrowKey:Number):BXDirection {
    		if (arrowKey < 37 || arrowKey > 40)
    			return I;
    		else
    			return [West, North, East, South][arrowKey - 37];
    	}

    	/*****************
    	*                *
    	* Atomic methods *
    	*                *
    	*****************/

    	public function dx():Number {
    		return offsetX;
    	}

    	public function dy():Number {
    		return offsetY;
    	}

    	/************
    	*           *
    	* Operators *
    	*           *
    	************/

    	public function inverse():BXDirection {
    		return new BXDirection(-dx(), -dy());
    	}

    	public function rotateClockwise():BXDirection {
    		return new BXDirection(-dy(), dx());
    	}

    	public function rotateCounterClockwise():BXDirection {
    		return new BXDirection(dy(), -dx());
    	}

    	/*********************
    	*                    *
    	* Comparison methods *
    	*                    *
    	*********************/

    	public function equals(other):Boolean {
    		return dx() == other.dx() && dy() == other.dy();
    	}

    	public function opposite(other):Boolean {
    		return dx() == -other.dx() && dy() == -other.dy();
    	}

    	/****************
    	*               *
    	* Angle methods *
    	*               *
    	****************/

    	public function rotationInRadians():Number {
            return Math.atan2(dy(), dx());
    	}

    	public function rotationInDegrees():Number {
            return rotationInRadians() * TO_DEGREE;
        }

    	/******************
    	*                 *
    	* Utility methods *
    	*                 *
    	******************/

    	function toString():String {
    	    if (this.equals(North)) return "North";
    	    if (this.equals(South)) return "South";
    	    if (this.equals(East))  return "East";
    	    if (this.equals(West))  return "West";

    		return "->(" + offsetX + ", " + offsetY + ")";
    	}

    }

}