package bloxley.view.sprite {

    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.utils.getDefinitionByName;
    
    import bloxley.base.*;
    import bloxley.model.game.BXPatch;
    import bloxley.model.data.BXColor;
    import bloxley.view.gui.BXGeometry;
    import bloxley.view.animation.*;
    import bloxley.view.sprite.*;

    import game.*; // Game-specific graphics
    
    public class BXSprite extends BXObject {

        static var ValidBlends = { x: "x", y: "y", rotation: "rotation", width: "width", height: "height", fade: "fade",
                                   x_y: ["x", "y"], w_h: ["width", "height"], dx_dy: ["dx", "dy"] };

        static var VisualAttributes  = { x: "x", y: "y", rotation: "rotation", fade: "alpha", width: "width", height: "height",
                                         dx: "dx", dy: "dy" };

        // Instance Variables

        var graphics;  // The movie clip itself
        var virtual; // Keeps track of virtual visual attributes
        var _frame:Number;       // The frame the clip is currently at

        var animations:Array;    // The animations that this sprite is currently involved in...

        public var geom:BXGeometry;
        
        // Options:

        var centered:Boolean;
        var depth:int;

        // For redrawing:

        var updates:BXSpriteChange;
        var updatedThisFrame:Boolean;

        /**************
        *             *
        * Constructor *
        *             *
        **************/

        public function BXSprite(clip:String, options:Object = null) {
            if (options == null) options = new Object();
            
            this.centered   = options.centered;
            this.animations = new Array();

            this.graphics = generateGraphics(clip, options.parent, options.depth, options.visible === false);
            this.virtual  = { dx: 0.0, dy: 0.0 };
    		this.updates  = new BXSpriteChange(this);
        }

        public function destroy() {
            // movieClip.removeMovieClip();
        }

        /******************
        *                 *
        * Visual Elements *
        *                 *
        ******************/

        public function setGeometry(geom:BXGeometry) {
            this.geom = geom;
        }
        
        public function generateGraphics(clip:String, parent, depth:int, hidden:Boolean) {
            var graphicsClass:Class;
            
            if (clip) {
                var clipName = clip.split(' ').join('');
                graphicsClass = getDefinitionByName("game." + clipName) as Class;                
            } else {
                graphicsClass = Sprite;
            }
            
            var mc = new graphicsClass();
            mc.visible = true;
    		mc.alpha = hidden ? 0.0 : 1.0;
            mc.x = 0;
            mc.y = 0;
            
            if (graphicsClass != Sprite) {
        		mc.gotoAndStop(1);
            }

            if (parent == null) parent = BXSystem.screen;

            parent.getGraphics().addChildAt(mc, depth);
            this.depth = depth;
            
    		return mc;
        }

        /*************
        *            *
        * Movie Clip *
        *            *
        *************/

        
        public function getGraphics() {
            return graphics;
        }

        public function getVirtual() {
            return virtual;
        }
        
        public function get(method) {
            var attr = VisualAttributes[method];
            
            return graphics.hasOwnProperty(attr) ? graphics[attr] : virtual[attr];
        }

        public function updated() {
            if (! updatedThisFrame) {
                updatedThisFrame = true;
                later(repaint);
            }
        }

        public function repaint(info) {
            updates.update();
            updates.clearChanges();
            updatedThisFrame = false;
        }
        
        public function set(method:String, value) {
            updates.change(method, value);
        }
        
        public function getDepth():int {
            return depth;
        }
        
        public function center() {
            centered = true;
        }
        
        public function isCentered():Boolean {
            return centered;
        }
        
        /*******************
        *                  *
        * Animation Blends *
        *                  *
        *******************/

        // The atomic animation function

        public function animate(method:String, options = null):BXBlend {
            var blend:BXBlend;

            if (ValidBlends[method]) {

                if (ValidBlends[method] is Array) blend = new BX2DBlend(this, ValidBlends[method], options);
                else if (method == "rotation") blend = new BXCircularBlend(this, ValidBlends[method], options);
                else blend = new BXBlend(this, ValidBlends[method], options);
            }
            
            return blend.autostart();
        }

        // Derived animation functions

        public function goto(where, options = null):BXBlend {
            if (options == null) options = new Object();
            if (options.geometry) setGeometry(options.geometry);

            if (where is BXPatch) {
                options.to_x = isCentered() ? geom.xCenterForPatch(where) : geom.leftForPatch(where);
                options.to_y = isCentered() ? geom.yCenterForPatch(where) : geom.topForPatch(where);
            
                if (options.speed) options.speed = geom.lengthForCells(options.speed);
            } else if (where is Array) {
                if (geom) {
                    options.to_x = geom.gridToScreenX(where[0], isCentered());
                    options.to_y = geom.gridToScreenY(where[1], isCentered());
                } else {
                    options.to_x = where[0];
                    options.to_y = where[1];
                }
            }

            return animate("x_y", options);
        }

        public function shift(how_much, options):BXBlend {
            if (options == null) options = new Object();

            options.to_x  = how_much[0];
            options.to_y  = how_much[1];

            return animate("dx_dy", options);
        }

        public function hide(options = null):BXBlend {
            return fade(0.0, options);
        }

        public function show(options = null):BXBlend {
            return fade(1.0, options);
        }

        public function fade(to:Number, options = null):BXBlend {
            var opts = copyOptions(options);
            opts.to = to;

            return animate("fade", opts);
        }

        public function rotate(direction, options = null):BXBlend {
            var opts = copyOptions(options);
            opts.to = direction;

            return animate("rotation", opts);
        }

        public function turn(direction, options = null):BXBlend {
            var opts = copyOptions(options);
            opts.by = direction;

            return animate("rotation", opts);
        }

        public function resize(dimensions:Array, options = null):BXBlend {
            var opts = copyOptions(options);
            if (opts.geometry) setGeometry(opts.geometry);

            
            if (geom) {
                opts.to_x = geom.lengthForCells(dimensions[0]);
                opts.to_y = geom.lengthForCells(dimensions[1]);
                
                opts.speed = geom.lengthForCells(opts.speed);
            } else {
                opts.to_x = dimensions[0];
                opts.to_y = dimensions[1];
            }

            return animate("w_h", opts);
        }

        public function scale(fraction:Number, options = null):BXBlend {
            var opts = copyOptions(options);
            
            opts.to_x = graphics.width  * fraction;
            opts.to_y = graphics.height * fraction;
            
            return animate("w_h", opts);
        }
        
        /**************************
        *                         *
        * Non-Blending Animations *
        *                         *
        **************************/

        public function frame(frame_or_sequence, options = null):BXFrameAnimation {
            var opts = copyOptions(options);
            
            var sequence:Array;
            if (frame_or_sequence is Array)
                sequence = frame_or_sequence;
            else
                sequence = [ frame_or_sequence ];

            return new BXFrameAnimation(this, sequence, opts).autostart();
        }

        public function color(color:BXColor, options = null):BXColorAnimation {
            return new BXColorAnimation(this, color, copyOptions(options)).autostart();
        }
        
        /*****************
        *                *
        * Helper methods *
        *                *
        *****************/

        public function copyOptions(options) {
            var newOptions = new Object();
            
            if (options == null) return newOptions;
            
            for (var key in options) {
                newOptions[key] = options[key];
            }

            return newOptions;
        }

    }
    
}
