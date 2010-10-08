package bloxley.controller.mailbox {

    import bloxley.base.BXObject;

    public class BXMessageQueue extends BXObject {

        var queue:Array;

        public function BXMessageQueue() {
            this.queue = new Array();
        }

        /****************
        *               *
        * Queue Methods *
        *               *
        ****************/

        public function anyPendingMessages():Boolean {
            return queue.length > 0;
        }

        public function nextMessage():Object {
            return queue[0];
        }

        public function clearMessage(message:Object) {
            if (nextMessage() == message) {
                queue.shift();
            }
        }

        public function addMessage(object:Object) {
            queue.push(object);
        }

    }
    
}
