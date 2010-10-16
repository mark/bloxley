package bloxley.controller.game {

    import bloxley.base.BXObject;
    import bloxley.view.gui.*;
    
    public class BXInterface extends BXObject {
        
        var interfaceId:Number;
        var allInterfaceElements:Array;
    	var interfaceElements:Object; // *Named* user interface elements ...
        var currentBank:String;
        
        // var interfaceLoader:BXInterfaceLoader;


        public function BXInterface() {
        	this.interfaceElements = new Object();
            this.allInterfaceElements = new Array();

    		createInterface();
        }
        
        /****************
        *               *
        * Event Methods *
        *               *
        ****************/
        
        public function passToPen(meth:String, args:Array = null) {
            // OVERRIDE ME!
        }
        
        public function respondTo(meth:String, args:Array = null) {
            if (args == null) args = [];
            
            return callResolve(meth, [ this ], args);
        }
        
        /********************
        *                   *
        * Interface Methods *
        *                   *
        ********************/

        public function createInterface() {
            // OVERRIDE ME!
        }

        public function place(...args):BXButtonArray {
            var buttons = new Array();

            for (var i = 0; i < args.length; i++) {
                if (args[i] is Array)
                    buttons.push(args[i]);
                else
                    buttons.push( [ args[i] ]);
            }

            var buttonArray = new BXButtonArray(this, buttons);
            buttonArray.setOwner(this);
            
            register(buttonArray);

            return buttonArray;
        }

    	// Interface banks

    	public function setBank(bank:String) {
    	    if (interfaceElements[bank] == null)
    	        interfaceElements[bank] = new Array();

    	    currentBank = bank;
    	}

    	public function register(element) {
    	    if (currentBank) {
    	        if (interfaceElements[currentBank]) {
    		        interfaceElements[currentBank].push(element);
		        }
		        
		        element.addToBank(currentBank);
    	    }


    		for (var i = 0; i < allInterfaceElements.length; i++) {
    		    if (element == allInterfaceElements[i]) return;
    		}

    		allInterfaceElements.push(element);
    	}

    	public function elementNamed(name:String) {
    		for (var i = 0; i < allInterfaceElements.length; i++) {
    		    var element = allInterfaceElements[i];
    		    if (element.isNamed(name)) return element;
    		}

    		return null;
    	}

    	public function elementOfClass(klass:Class):BXGuiElement {
    		for (var i = 0; i < allInterfaceElements.length; i++) {
    		    var element = allInterfaceElements[i];
    		    if (element is klass) return element;
    		}

    		return null;
    	}

        public function hideBank(bank) {
            if (bank == null) bank = currentBank;
            var elements = interfaceElements[bank];

            if (elements) {
                for (var i = 0; i < elements.length; i++) {
                    elements[i].hide();
                }
            }
        }

        public function showBank(bank) {
            if (bank == null) bank = currentBank;
            
            var elements = interfaceElements[bank];
            
            if (elements) {
                for (var i = 0; i < elements.length; i++) {
                    interfaceElements[bank][i].show();
                }
            }
        }

        /* 
        function loadInterface(interfaceId:Number) {
            interfaceLoader.load(interfaceId);
        }

        function interfaceLoaded(interfaceId:Number) {
            this.interfaceId = interfaceId;

            post("BXInterfaceLoaded");
        }

        // Interface XML generators

        function interfaceToXml() {
            var s = new String();

            for (var i = 0; i < allInterfaceElements.length; i++) {
                var element = allInterfaceElements[i];

                s += allInterfaceElements[i].toXml();
            }

            for (var i = 0; i < pens.length; i++) {
                s += pens[i].toXml(currentPen == pens[i]);
            }

            return s;
        }
        
        */

    }
}