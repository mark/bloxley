package bloxley.view.gui {

    import bloxley.base.BXObject;
    import bloxley.view.choreography.BXRoutine;

    public class BXBank extends BXObject {
        
        var name:String;
        var elements:Array;
        
        public function BXBank(name:String) {
            this.name = name;
            this.elements = new Array();
        }
        
        /**********************
        *                     *
        * Gui Element Methods *
        *                     *
        **********************/
        
        public function addGuiElement(gui:BXGuiElement) {
            elements.push(gui);
        }
        
        /********************
        *                   *
        * Animation Methods *
        *                   *
        ********************/
        
        public function passToElements(fcn:Function):BXRoutine {
            var routine = new BXRoutine();
            
            for (var i = 0; i < elements.length; i++) {
                var animation = fcn(elements[i]);
                routine.startWith( animation );
            }
            
            return routine;
        }

        public function goto(where, options = null):BXRoutine {
            return passToElements( function(gui) { return gui.goto(where, options) });
        }

        public function shift(how_much, options):BXRoutine {
            return passToElements( function(gui) { return gui.shift(how_much, options) });
        }

        public function hide(options = null):BXRoutine {
            return passToElements( function(gui) { return gui.hide(options) });
        }

        public function show(options = null):BXRoutine {
            return passToElements( function(gui) { return gui.show(options) });
        }

        public function fade(to:Number, options = null):BXRoutine {
            return passToElements( function(gui) { return gui.fade(to, options) });
        }

        public function rotate(direction, options = null):BXRoutine {
            return passToElements( function(gui) { return gui.rotate(direction, options) });
        }

        public function turn(direction, options = null):BXRoutine {
            return passToElements( function(gui) { return gui.turn(direction, options) });
        }

        public function resize(dimensions:Array, options = null):BXRoutine {
            return passToElements( function(gui) { return gui.resize(dimensions, options) });
        }

        public function scale(fraction:Number, options = null):BXRoutine {
            return passToElements( function(gui) { return gui.scale(fraction, options) });
        }
     
        override public function toString():String {
            return "#<" + className() + ": " + id() + " name=" + name + ">";
        }
    }
}