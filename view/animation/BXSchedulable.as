package bloxley.view.animation {

    import bloxley.base.BXObject;
    import bloxley.view.clock.BXClock;

    public class BXSchedulable extends BXObject {


        var _isStarted:Boolean;
        var _startTime:Number;
        var _isFinished:Boolean;

        public function BXSchedulable() {
            _isStarted = false;
            _isFinished = false;
        }

        /***********
        *          *
        * Starting *
        *          *
        ***********/

        public function start(...rest) {
            _isStarted = true;
            _startTime = BXClock.clock.now();

            post("BXStartAnimation");

            setup();
        }

        public function isStarted():Boolean {
            return _isStarted;
        }

        public function setup() {
            // OVERRIDE ME!
        }

        /************
        *           *
        * Finishing *
        *           *
        ************/

        public function finish(...rest) {
            _isFinished = true;
            post("BXFinishAnimation");

            cleanup();
        }

        public function cancel() {
            cleanup();
        }

        public function isFinished():Boolean {
            return _isFinished;
        }

        public function cleanup() {
            later(stopListening);
        }

        /**********
        *         *
        * Forcing *
        *         *
        **********/
        
        public function forceCancel() {
            post("BXCancelAnimation");
        }
        
        public function setParent(parent:BXSchedulable) {
            listenFor("BXCancelAnimation", parent, forceCancel);
        }

    }
    
}
