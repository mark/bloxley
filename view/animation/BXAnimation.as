package bloxley.view.animation {

    import bloxley.base.BXObject;
    import bloxley.controller.mailbox.BXMessage;
    import bloxley.view.clock.*;
    import bloxley.view.animation.*;

    public class BXAnimation extends BXSchedulable {

        var wait:Boolean;
        
        var duration:Number;

        /**************
        *             *
        * Constructor *
        *             *
        **************/

        public function BXAnimation() {
            duration = 0.0; // Instantaneous, unless otherwise specified

    		listenForAny("BXFinishAllAnimations", finish); // For finishing all animations
    		listenForAny("BXCancelAllAnimations", cancel); // For cancelling all animations
        }

        /*******************
        *                  *
        * Starting Methods *
        *                  *
        *******************/

        override public function start(...rest) {
            super.start();

            animate(0.0);

            readyDuration();
        }

        public function autostart(...rest) {
            if (isInstantaneous() && ! wait) {
                start();
            }
            
            return this;
        }
        
        /******************
        *                 *
        * Animation Frame *
        *                 *
        ******************/

        public function runFrame(message:BXMessage) {
            var runTimer = message.source;

            animate(completion(runTimer));
        }

        public function completion(runTimer:BXTimer) {
            if ( isContinuous() ) {
                return 0.0;
            } else if ( isInstantaneous() ) {
                return 1.0;
            } else {
                return runTimer.completion();
            }
        }

        public function animate(completion:Number) {
            // OVERRIDE ME!
        }

        public function elapsed():Number {
            return (BXClock.clock.now() - _startTime) / 1000.0;
        }

    	/*****************
    	*                *
    	* Ending Methods *
    	*                *
    	*****************/

    	override public function finish(...rest) {
            animate(1.0);
            super.finish();
        }

        override public function cancel() {
            cleanup();

            post("BXAnimationStop");
        }

        /*******************
        *                  *
        * Duration Methods *
        *                  *
        *******************/

        public function setDuration(duration:Number) {
            this.duration = duration;
        }

        public function isContinuous():Boolean {
            // FIXME:
            return false; //duration == null;
        }

        public function isInstantaneous():Boolean {
            return duration == 0.0 || isNaN(duration);
        }

        public function readyDuration() {
            if ( isContinuous() ) {
                // Continuous Animation:

                listenForAny("BXStartOfFrame", runFrame);
            } else if ( isInstantaneous() ) {
                // Instant Animation:

                later( finish );
            } else {
                // Run for specified period of time:

                var runTimer = timer("endInSeconds", duration);

                listenFor("BXTimerActive", runTimer, runFrame);
                listenFor("BXTimerStop",   runTimer, finish);
            }
        }

        /******************
        *                 *
        * Utility Methods *
        *                 *
        ******************/

        function timer(name:String, seconds:Number, tickPeriod:Number = 1.0):BXTimer {
            return new BXTimer(name + "_" + id(), seconds, tickPeriod);
        }

    }
    
}

