package bloxley.controller.game {

    import flash.display.Stage;
    
    import bloxley.base.BXSystem;
    import bloxley.controller.io.*;
    // import bloxley.controller.event.*;
    import bloxley.controller.game.*;
    import bloxley.controller.mailbox.BXMailbox;
    // import bloxley.controller.pen.*;
    import bloxley.model.game.*;
    import bloxley.view.clock.*;
    import bloxley.view.gui.*;
    
    public class BXGame extends BXInterface {

        // Controllers:
        
        var gameControllers:Array;
        var pController:BXPatchController;
        var actorControllers:Array;
        
        var _currentGameController:BXController;
        
        var gameboard:BXBoard; // The currently loaded level
        
        var globalGuiElements:Array;

        // var levelLoader:BXLevelLoader;
        
        public function BXGame(stage:Stage) {
            BXSystem.initialize(stage);
            
            gameControllers  = new Array();
            actorControllers = new Array();
            
            super();
        }
        
        /*********************
        *                    *
        * Controller Methods *
        *                    *
        *********************/
        
        public function controllers(classHash:Object) {
            for (var key in classHash) {
                var klass = classHash[key];
                var controller = new klass(key, this);
                
                if (controller is BXPatchController) {
                    this.pController = controller;
                } else if (controller is BXController) {
                    this.gameControllers.push( controller );
                } else if (controller is BXActorController) {
                    this.actorControllers.push( controller );
                }
            }
        }
        
        public function patchController():BXPatchController {
            return pController;
        }
        
        public function actorControllerForTile(tile:String):BXActorController {
            for (var i = 0; i < actorControllers.length; i++) {
                var controller = actorControllers[i];

                if (controller.canLoadFromBoard(tile)) {
                    return controller;
                }
            }
            
            // No controller can handle this tile:
            return null;
        }
        
        // function actorControllerFor(key:String, options):BXActorController {
        //     for (var i = 0; i < actorControllers.length; i++) {
        //         if (key.toLowerCase() == actorControllers[i].key(options).toLowerCase())
        //             return actorControllers[i];
        //     }
        // 
        //     return null;
    	// }
    	
    	/*******************
    	*                  *
    	* Game Controllers *
    	*                  *
    	*******************/
    	
    	public function currentGameController():BXController {
    	    return _currentGameController;
    	}
    	
    	public function setCurrentGameController(name:String) {
    	    var nextGameController:BXController = null;
    	    
    	    for (var i = 0; i < gameControllers.length; i++) {
    	        if (gameControllers[i].name == name) nextGameController = gameControllers[i];
    	    }

    	    if (currentGameController() != null && nextGameController != currentGameController()) currentGameController().finish();
    	    
    	    if (nextGameController) {
        	    _currentGameController = nextGameController;
        	    currentGameController().start();
    	    }
    	}
    	
    	/****************
    	*               *
    	* Event Methods *
    	*               *
    	****************/
    	
        override public function respondTo(meth:String, args:Array = null) {
            if (args == null) args = [];
            
            if (this.respondsTo(meth)) {
                this[meth].apply(this, args);
            } else if (currentGameController()) {
                currentGameController().respondTo(meth, args);
            }
        }
        
        /***************
        *              *
        * GUI Elements *
        *              *
        ***************/
        
        override public function createInterface() {
            setBank("Main");
                var grid = new BXGrid(this, { gridSize: defaultGridSize() });
                register( grid );
                grid.setBoard( board() );
        }
        
        public function defaultGridSize():Number {
            return 32.0;
        }
        
        /****************
        *               *
        * Board Methods *
        *               *
        ****************/
        
        // Can be overridden, but probably doesn't need to be
        public function createBoard() {
            setBoard( new BXBoard(this) );
        }

        public function board():BXBoard {
            if (gameboard == null) createBoard();

            return gameboard;
        }

        function setBoard(board:BXBoard) {
    		if (gameboard != null) gameboard.destroy();

    		gameboard = board;
    	}

    	function attachBoardToGrid(board:BXBoard = null, grid:BXGrid = null) {
    	    if (board == null) board = this.board();
    	    if (board == null) return;

    	    if (grid  == null) grid  = this.grid();
    	    if (grid  == null) return;

    	    //trace("attachBoardToGrid(" + board + ", " + grid + ")");

            grid.setBoard(board);
    	}

        /***************
        *              *
        * Grid Methods *
        *              *
        ***************/
        
        public function grid():BXGrid {
            return elementOfClass( BXGrid ) as BXGrid;
        }

        /******************
        *                 *
        * Loading Methods *
        *                 *
        ******************/
        
        function loadPatch(tile:String, placeX:int, placeY:int):BXPatch {
            var newPatch = patchController().createPatch(tile);
            board().attachPatch(newPatch, placeX, placeY);
            
            return newPatch;
        }
        
        function loadActorFromBoard(tile:String, location:BXPatch) {
            for (var i = 0; i < actorControllers.length; i++) {
                var actorController = actorControllers[i];
                var newActor = actorController.createActorFromBoard(tile);
                
                if (newActor) {
                    board().attachActor(newActor, location);
                }
            }
        }
        
        /*********************
        *                    *
        * Saving and Loading *
        *                    *
        *********************/
        
        public function previousLevel() {
            // loadLevel(board().getServerIndex() - 1);
        }

        public function nextLevel() {
            // loadLevel(board().getServerIndex() + 1);
        }

        public function saveBoard() {
            //saveOnServer();
            //trace("Board:\n" + toXml());
        }

        function createLevel(width:Number, height:Number, callback:Function) {
        	createBoard();

            board().setDimensions( width, height );

        	for (var row = 0; row < height; row++) {
        		for (var col = 0; col < width; col++) {
        		    // Just use the default patch kind:
        			loadPatch(null, col, row);
        		}
        	}

        	callback.call(board());

        	attachBoardToGrid();
        }
        
        public function loadLevel(rows:Array, objects:Array = null) {
            for (var i = 0; i < rows.length; i++) {
            	for (var j = 0; j < rows[i].length; j++) {
            	    var char = rows[i].charAt(j);
            	    
            		var patch = loadPatch(char, j, i);

            		loadActorFromBoard(char, patch);
            	}
            }
        }
    }

}
