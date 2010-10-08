package bloxley.view.clock {

    import bloxley.base.BXObject;
    import bloxley.controller.mailbox.BXMessage;
    import bloxley.view.clock.*;

    public class BXTimer extends BXObject {

        public static const NO_TIME = -1;
        
        // The name of this timer
        var name:String;

        // For calculating seconds(), secondsLeft(), and completion()
        var startingTime:Number;
        var now:Number;

        // For secondsLong()
        var totalSeconds:Number;

        // For sending ticks
        var interval:Number;
        var nextInterval:Number;
        var storedUntilNextInterval:Number;

        // For stopping
        var endingTime:Number;

        // For pausing
        var isPaused:Boolean;
        var timeStored:Number;

        public function BXTimer(name:String, totalSeconds:Number = NO_TIME, tickSeconds:Number = 1.0) {
            this.name = name;

            this.startingTime = BXClock.clock.now();
            this.now = startingTime;

            this.isPaused = false;

            this.interval = Math.floor(tickSeconds * 1000);
            this.nextInterval = startingTime + interval;

            if (totalSeconds != NO_TIME) {
                this.totalSeconds = totalSeconds;
                this.endingTime = startingTime + totalSeconds * 1000;
            } else {
                this.endingTime = NO_TIME;
            }

            BXClock.clock.addTimer(this);

            later(start);
        }

        /******************
        *                 *
        * Clock Functions *
        *                 *
        ******************/

        public function start(info = null) {
            listenForAny("BXStartOfFrame", everyFrame);

            post("BXTimerStart");
        }

        public function everyFrame(message:BXMessage) {
            this.now = Number(message.info);

            if (isPaused) return;

            if (endingTime != NO_TIME && now >= endingTime) {
                post("BXTimerStop");

                later(stopListening);
                BXClock.clock.removeTimer(this);
            } else {
                if (now >= nextInterval) {
                    nextInterval += interval;

                    post("BXTimerTick", seconds());
                }

                post("BXTimerActive", seconds());
            }
        }

        /****************
        *               *
        * Timer methods *
        *               *
        ****************/

        public function reset() {
            this.endingTime = now + (endingTime - startingTime);
            this.nextInterval = now + interval;

            this.startingTime = now;
        }

        public function pause() {
            if (isPaused) return;

            isPaused = true;

            this.timeStored = endingTime - now;
            this.storedUntilNextInterval = nextInterval - now;    
        }

        public function unpause() {
            if (! isPaused) return;

            isPaused = false;

            this.endingTime = now + timeStored;
            //trace("storedUntilNextInterval = " + storedUntilNextInterval);
            this.nextInterval = now + storedUntilNextInterval;
        }

        /********************
        *                   *
        * Seconds() Methods *
        *                   *
        ********************/

        public function seconds():Number {
            return (now - startingTime) / 1000.0;
        }

        public function secondsLong():Number {
            return totalSeconds;
        }

        public function secondsLeft():Number {
            return secondsLong() - seconds();
        }

        public function completion():Number {
            var rawCompletion = seconds() / secondsLong();

            return (rawCompletion > 1.0) ? 1.0 : rawCompletion;
        }

        /******************
        *                 *
        * Utility Methods *
        *                 *
        ******************/

        public override function toString():String {
            return "#<BXTimer: " + name + ">";
        }

    }
    
}

