package bloxley.controller.game {
    
    import bloxley.base.BXObject;
    import bloxley.controller.io.*;
    import bloxley.controller.event.*;
    import bloxley.controller.game.*;
    import bloxley.controller.mailbox.BXMailbox;
    import bloxley.controller.pen.*;
    import bloxley.model.game.*;
    import bloxley.view.clock.*;
    import bloxley.view.choreography.*;
    import bloxley.view.gui.*;

    public class BXController extends BXInterface {

        public var name:String;
        var game:BXGame;

    	var currentPen; // Keep untyped for now...
    	var pens:Array;

        var currentSelection:BXObject; // What the pens are selecting... (actor/region mostly)
        var cursor; // The display element for the current selection

        protected var queue:BXUndoQueue;   // Undo Queues are controller-specific
        
        var sequencer:BXSequencer;
        
    	/**************
    	*             *
    	* Constructor *
    	*             *
    	**************/

        public function BXController(name:String, game:BXGame) {
            this.name = name;
            this.game = game;
            
    		pens = new Array();

            allInterfaceElements = new Array();

    		// Initialization methods

    		createPens();

    		queue = new BXUndoQueue();
    		
    		sequencer = new BXSequencer();
        }

        /*************************
        *                        *
        * Start and Stop Methods *
        *                        *
        *************************/
        
        public function onStart() {
            // OVERRIDE ME!
        }
        
        public function start() {
            game.showBank("Main");
            onStart();
        }
        
        public function onFinish() {
            // OVERRIDE ME!
        }
        
        public function finish() {
            onFinish();
        }
        
        /*************
        *            *
        * Respond To *
        *            *
        *************/

        override public function respondTo(meth:String, args:Array = null) {
            if (args == null) args = [];

            callResolve(meth, [ this, currentPen ], args);
        }

        /*********************
        *                    *
        * Undo Queue Methods *
        *                    *
        *********************/
        
        public function undoQueue():BXUndoQueue {
            return queue;
        }
        
        public function undo() {
            queue.undo();
        }

        public function reset() {
            queue.reset();
        }

        /**************
        *             *
        * Pen Methods *
        *             *
        **************/

        public function pen():BXPen {
            return currentPen;
        }
        
        public function createPens() {
            // OVERRIDE ME!!!
        }

        public function registerPen(pen:BXPen) {
            pens.push(pen);
        }

        public function switchToPen(name:String) {
            for (var i = 0; i < pens.length; i++) {
                var pen = pens[i];

                if (pen.name() == name) {
                    if (currentPen) currentPen.unset();

                    currentPen = pen;
                    currentPen.set();

                    return;
                }
            }
        }

        /********************
        *                   *
        * Selection methods *
        *                   *
        ********************/

        public function select(newSelection:BXObject) {
            currentSelection = newSelection;
        }

        public function selection():BXObject {
            return currentSelection;
        }

        public function selectedActor():BXActor {
            if (selection() is BXActor) {
                return selection() as BXActor;
            } else {
                return null;
            }
        }
        
        /****************
        *               *
        * Mouse Methods *
        *               *
        ****************/

        // The only one that matters is the onMouseUp method, so that if the mouse gets released when it is not on
        // a BXGrid or a BXWell, the mouse event gets cancel()-ed.

        public function onMouseUp() {
            // if (mouse() == null) return;
            // 
            // for (var i = 0; i < allInterfaceElements.length; i++) {
            //     var element = allInterfaceElements[i];
            //     if ((element instanceof BXWell || element instanceof BXGrid) && element.isHit())
            //         return;
            // }
            // 
            // mouse().upOnNothing();
        }

        public function onMouseMove() {
            // if (mouse() == null) return;
            // 
            // for (var i = 0; i < allInterfaceElements.length; i++) {
            //     var element = allInterfaceElements[i];
            //     if ((element instanceof BXWell || element instanceof BXGrid) && element.isHit())
            //         return;
            // }
            // 
            // mouse().dragOnNothing();
        }

        /****************
        *               *
        * Event Methods *
        *               *
        ****************/
        
        public function choreographer():BXChoreographer {
            return new BXChoreographer();
        }
        
        public function handleEvent(milestone:Boolean, events):BXEvent {
            var newEvent = new BXEvent(this, milestone);
            
            if (events[0] is Array)
                newEvent.handle([ new BXGroupAction(events[0], "safely") ]);
            else
                newEvent.handle(events);
            
            return newEvent;
        }
        
        public function minorEvent(...events):BXEvent {
            return handleEvent(false, events);
        }
        
        public function event(...events):BXEvent {
            return handleEvent(true, events);
        }
        
        public function eventSucceeded(event:BXEvent):BXRoutine {
    		if (queue) queue.postEvent(event);
    		
    		var newChoreographer = choreographer();
            var routine = newChoreographer.choreographEvent(event);
            
            sequencer.add( routine );
            
            return routine;
        }
        
        public function previousEvent(milestone:Boolean = false):BXEvent {
            return queue.lastEvent();
        }
        
        /*****************
        *                *
        * Helper Methods *
        *                *
        *****************/

        public function board():BXBoard {
            return game.board();
        }
        
        override public function toString():String {
            return className();
        }

    }

}
