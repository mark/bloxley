package bloxley.view.clock {

    import bloxley.controller.mailbox.*;
    
    public class BXSignal {

        var message:BXMessage;
        var when:int;

        public function BXSignal(message:String, when:int, source, info) {
            this.message = new BXMessage(message, source, info);
            this.when = when;
        }

        /*****************
        *                *
        * Helper Methods *
        *                *
        *****************/

        public function shouldOccur(now:int):Boolean {
            return now >= when;
        }

        public function isBefore(other:BXSignal):Boolean {
            return when < other.when;
        }

        public function post(now:int) {
            if (shouldOccur(now)) {
                BXMailbox.mailbox.postMessage( message );
            }

            return shouldOccur(now);
        }

    }
        
}
