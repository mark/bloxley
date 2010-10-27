package bloxley.controller.game {
    
    import flash.utils.Dictionary;
    
    import bloxley.base.BXObject;
    import bloxley.controller.event.*;
    import bloxley.controller.game.*;
    import bloxley.model.data.*;
    import bloxley.model.game.*;
    import bloxley.model.collection.BXRegion;
    import bloxley.view.animation.BXAnimation;
    import bloxley.view.sprite.*;

    public class BXActorController extends BXObject {

        var name:String;
    	var game:BXGame;

    	// Saving / Loading representations

    	var boardString:String;

    	var attributeHash:Object;

    	// Sprites for the actors

    	var sprites:Object;

    	public function BXActorController(name:String, game:BXGame) {
    	    this.name = name;
    		this.game = game;

    		boardString = "";

    		sprites = new Dictionary();
    	}

    	public function board():BXBoard {
    		return game.board();
    	}

        /*******************************
        *                              *
        * Basic Actor Property Methods *
        *                              *
        *******************************/
        
    	public function key(options = null):String {
    	    // OVERRIDE ME!
    		return null;
    	}

    	public function canBePlayer(actor:BXActor):Boolean {
    		return false;
    	}

    	public function isGood(actor:BXActor):Boolean {
    	    return false;
    	}

        /*******************
        *                  *
        * Creation Methods *
        *                  *
        *******************/
        
        // Override this if you want to use a BXActor subclass...
        public function createActor(options):BXActor {
    		return new BXActor(this, key(options), options);
    	}

        public function createActorFromBoard(tile:String):BXActor {
            if (canLoadFromBoard(tile)) {
                return createActor({ tile: tile});
            } else {
                return null;
            }
        }
        
    	public function initializeActor(actor) {
    	    // SUBCLASS ME!
    	}

        /***************************
        *                          *
        * Sprite Attribute Methods *
        *                          *
        ***************************/
        
    	public function graphicsName(actor:BXActor):String { return key(); }

    	public function frameName(actor:BXActor):String { return null; }

    	public function regionForActorAtLocation(actor:BXActor, location:BXPatch):BXRegion {
    		return new BXRegion([ actor.location() ]);
    	}

        public function regionForActor(actor:BXActor):BXRegion {
            return regionForActorAtLocation( actor, actor.location() );
        }
        
    	public function dimensions(actor:BXActor):Array {
    		return [ 1.0, 1.0 ];
    	}

    	public function registrationAtCenter(actor:BXActor):Boolean {
    	    return false;
    	}

        /*****************
        *                *
        * Sprite Methods *
        *                *
        *****************/

        public function spriteForActor(actor:BXActor):BXSprite {
            // Note that this might return null, if one does not exist...
            if (sprites[actor] == null) {
                trace("No sprite for " + actor);
            }
            return sprites[ actor ];
        }

        public function renderActorSprite(actor:BXActor, sprite:BXCompositeSprite):BXCompositeSprite {
            // Store it as the sprite for the provided actor...
            sprites[ actor ] = sprite;

            displaySprite(actor, sprite);
            resizeSprite(actor, sprite);
            initializeSprite(actor, sprite);

            return sprite;
        }

        // Set it to the correct clip and frame
        function displaySprite(actor:BXActor, sprite:BXCompositeSprite) {
            sprite.addSpriteLayer(graphicsName(actor), { centered: registrationAtCenter(actor) } );

            if (frameName(actor)) sprite.frame( frameName(actor) );
        }

        function resizeSprite(actor:BXActor, sprite:BXSprite) {
            // Resize the sprite to the current screen size...
    		sprite.resize(dimensions(actor));
        }

    	public function initializeSprite(actor:BXActor, sprite:BXSprite) { 
    		// OVERRIDE ME!
    	}

        /****************
        *               *
        * Event Methods *
        *               *
        ****************/
        
    	public function resolveEvent(action:BXAction, eventType:String, source:BXActor, target:BXActor):Boolean {
    		return callCascade([ "can" + eventType + target.key(), "can" + eventType ], [ action, source, target ])
    	}

        /*********************
        *                    *
        * Default Animations *
        *                    *
        *********************/

        public function defaultSpeed():Number {
            return 8.0;
        }
        
        public function animateMove(actor:BXActor, action:BXMoveAction) {
    	    return spriteForActor(actor).goto(action.newPosition, { speed: defaultSpeed() });
    	}

        public function animateUndoMove(actor:BXActor, action:BXMoveAction) {
    	    return spriteForActor(actor).goto(action.oldPosition, { instant: true });
        }


        public function animateSelect(actor:BXActor, action:BXSelectAction) {
            // OVERRIDE ME!
        }
        
        public function animateDisable(actor:BXActor, action:BXDisableAction) {
            return spriteForActor(actor).hide({ seconds: 0.5 });
        }
        
        public function animateUndoDisable(actor:BXActor, action:BXDisableAction) {
            return spriteForActor(actor).show();
        }
        
    	/************************
    	*                       *
    	* Default Event methods *
    	*                       *
    	************************/

    	// Active form
    	public function canStepOn(action:BXAction, source:BXActor, target:BXActor)        { action.succeed(); }

    	// Passive form
    	public function canBeSteppedOnBy(action:BXAction, source:BXActor, target:BXActor) { action.fail();    }

    	// Active form
    	public function canLeave(action:BXAction, source:BXActor, target:BXActor)         { action.succeed(); }

    	// Passive form
    	public function canBeLeftBy(action:BXAction, source:BXActor, target:BXActor)      { action.succeed(); }
        
        /*************************
        *                        *
        * Representation Methods *
        *                        *
        *************************/

        public function setBoardString(boardString:String) {
            this.boardString = boardString;
        }

        public function attributes(attributeHash:Object) {
            this.attributeHash = attributeHash;
        }

        /******************
        *                 *
        * Loading Methods *
        *                 *
        ******************/

        function canLoadFromBoard(tile:String):Boolean {
            return boardString.indexOf(tile) != -1;
        }
        
        /*
        
    	function loadActorFromXml(board:BXBoard, properties:Array):BXActor {
    	    var x:Number, y:Number;
    	    var options = new Object();

    	    var includeLocation = attributeHash.location === null || attributeHash.location === true;

    	    for (var k = 0; k < properties.length; k++) {
    			var key = properties[k].nodeName;
    			var value = properties[k].childNodes[0].nodeValue;

    			if (key == "x" && includeLocation) {
    			    x = Number(value);
    			} else if (key == "y" && includeLocation) {
    			    y = Number(value);
    			} else if (attributeHash[key] == "Number") {
    			    options[key] = Number(value);
    			} else if (attributeHash[key] == "Boolean") {
    			    options[key] = (value == "yes");
    			} else if (attributeHash[key] == "Color") {
    			    options[key] = BXColor.getColor(value);
    			} else if (attributeHash[key] == "String") {
    			    options[key] = value;
    			} else if (attributeHash[key] == "Direction") {
    			    options[key] = BXDirection[value];
    			}
    		}

    	    if (includeLocation) {
    	        var patch = board.getPatch(x, y);

    	        return loadActor(patch, options);
    	    } else {
    	        return loadActor(board, options);
    	    }
    	}

        */
        
    	/*****************
    	*                *
    	* Saving Methods *
    	*                *
    	*****************/

    	function includeOnBoard(actor:BXActor) {
    		return boardString.length > 0;
    	}

        /*
        
    	function toXml(actor:BXActor):String {
    	    if (includeOnBoard(actor)) return boardString.charAt(0);

            var xml = "\t<" + actor.key() + ">\n";

            if (attributeHash.location == null || attributeHash.location == true) {
                xml += "\t\t<x>" + actor.location.x() + "</x>\n";
                xml += "\t\t<y>" + actor.location.y() + "</y>\n";
            }

            for (var attr in attributeHash) {
                if (attr != "location") {
                    if (attributeHash[attr] == "Boolean") {
                        xml += "\t\t<" + attr + ">" + (actor.get(attr) ? "yes" : "no") + "</" + attr + ">\n";
                    } else if (attributeHash[attr] == "Color") {
                        xml += "\t\t<" + attr + ">" + actor.get(attr).name + "</" + attr + ">\n";
                    } else {
                        xml += "\t\t<" + attr + ">" + actor.get(attr) + "</" + attr + ">\n";
                    }
                }
            }

            xml += "\t</" + actor.key() + ">\n";

            return xml;
    	}

        */
        
    	/*****************
    	*                *
    	* Utlity Methods *
    	*                *
    	*****************/

    	public function getDescriptionString(actor:BXActor):String {
    		return "";
    	}

    }

}