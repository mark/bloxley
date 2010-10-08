package bloxley.model.collection {
    
    import bloxley.base.BXObject;
    import bloxley.model.game.BXPatch;
    import bloxley.model.collection.BXRegion;

    public class BXPath extends BXObject {

        var path:Array;

        public function BXPath() {
            path = new Array();
        }

        /***************
        *              *
        * Base Methods *
        *              *
        ***************/

        public function length():Number {
            return path.length;
        }

        public function addStep(patch:BXPatch) {
            path.push(patch);
        }

        public function region():BXRegion {
            return new BXRegion(path);
        }

        /***************
        *              *
        * Step Methods *
        *              *
        ***************/

        public function step(n:Number):BXPatch {
            return path[n];
        }

        public function start() {
            return step(0);
        }

        public function current() {
            return step( this.length() - 1 );
        }

        public function previous() {
            return step( this.length() - 2 );
        }

        /**************
        *             *
        * Walk Method *
        *             *
        **************/

        public function walk(walk_fcn:Function, info:Object):Object { //, start:Number, steps:Number)
            var prev:BXPatch;

            for (var i = 0; i < this.length(); i++) {
                info = walk_fcn.call(null, prev, step(i), info);
                prev = step(i);
            }

            return info;
        }

    }

}