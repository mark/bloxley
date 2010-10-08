package bloxley.view.clock {

    import bloxley.base.BXObject;
    import bloxley.view.clock.BXSignal;

    public class BXSignalQueue extends BXObject {

        var signals:Array;

        public function BXSignalQueue() {
            this.signals = new Array();
        }

        /*****************
        *                *
        * Adding Signals *
        *                *
        *****************/

        public function addSignal(message:String, when:Number, source, info) {
            var newSignal = new BXSignal(message, when, source, info);

            for (var i = 0; i < signals.length; i++) {
                if (newSignal.isBefore(signals[i])) {
                    signals.splice(i, 0, newSignal);
                    return;
                }
            }

            // If we get here then the new signal is later than current signals
            signals.push( newSignal );
        }

        /********************
        *                   *
        * Resolving Signals *
        *                   *
        ********************/

        public function resolveSignals( now:Number ) {
            for (var i = 0; i < signals.length; i++) {
                if (! signals[i].post( now )) {
                    signals.splice(0, i);
                    return;
                }
            }
            
            // If we have gone through the entire list, then every signal has posted:
            signals.splice(0);
        }

    }
    
}

