package bloxley.controller.game {

    import bloxley.base.BXObject;
    import bloxley.view.gui.*;
    
    public class BXInterface extends BXObject {
        
        var interfaceId:Number;
        var allInterfaceElements:Array;
    	var interfaceElements:Object; // *Named* user interface elements ...
    	var interfaceBanks:Object;
        var currentBank:BXBank;
        
        // var interfaceLoader:BXInterfaceLoader;


        public function BXInterface() {
        	this.interfaceElements = new Object();
        	this.interfaceBanks = new Object();
            this.allInterfaceElements = new Array();

    		// createInterface();
    		later("createInterface");
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

    	public function setBank(bankName:String) {
    	    if (interfaceElements[bankName] == null)
    	        interfaceElements[bankName] = new BXBank(bankName);

    	    currentBank = interfaceElements[bankName];
    	}

    	public function register(element:BXGuiElement) {
    	    if (currentBank) {
		        currentBank.addGuiElement(element);
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

        public function hideBank(bankName = null, options = null) {
            var bank = (bankName == null) ? currentBank : interfaceElements[bankName];
            if (bank) return bank.hide(options);
        }

        public function showBank(bankName = null, options = null) {
            var bank = (bankName == null) ? currentBank : interfaceElements[bankName];
            if (bank) return bank.show(options);
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