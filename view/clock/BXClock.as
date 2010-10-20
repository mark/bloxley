package bloxley.view.clock {

    import bloxley.base.BXObject;
    import bloxley.view.clock.*;
    import bloxley.controller.mailbox.BXMailbox;
    
    import flash.utils.getTimer;
    import flash.display.Stage;
    import flash.events.Event;
    
    public class BXClock extends BXObject {

        // The global clock object
        public static var clock:BXClock;

        // What time is it now?
        var zeroTime:int;
        var currentTime:int;

        // Keeping track of timers
        var timers:Object;

        // Keeping track of signals
        var signals:BXSignalQueue;

        /***************
        *              *
        * Constructors *
        *              *
        ***************/

        public function BXClock(stage:Stage) {
            BXClock.clock = this;

            setupRoot(stage);

            this.zeroTime = getTimer();
            this.currentTime = zeroTime;        
            this.timers = new Object();
            this.signals = new BXSignalQueue();
        }

        function setupRoot(stage:Stage) {
            stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
        }

        /***************
        *              *
        * Root Methods *
        *              *
        ***************/

        public function now() {
            return currentTime - zeroTime;
        }

        function onEnterFrame(event:Event) {
            this.currentTime = getTimer();

            // Prime the pump...
            post("BXStartOfFrame", now());
            signals.resolveSignals( now() );
            
            // Start the reactor...
            BXMailbox.mailbox.resolveMessages();
        }

        /****************
        *               *
        * Timer Methods *
        *               *
        ****************/

        function addTimer(timer:BXTimer) {
            timers[timer.name] = timer;
        }

        function removeTimer(timer:BXTimer) {
            timers[timer.name] = null;
        }

        function timerNamed(name:String):BXTimer {
            return timers[name];
        }

        /*****************
        *                *
        * Signal Methods *
        *                *
        *****************/

        public function addSignal(message:String, seconds:Number, source = null, info = null) {
            var triggerWhen = now() + seconds * 1000.0;

            signals.addSignal(message, triggerWhen, source, info);
        }
        
        /******************
        *                 *
        * Utility Methods *
        *                 *
        ******************/

        override public function toString():String {
            return "#<BXClock:" + zeroTime + ">";
        }

    }
        
}
