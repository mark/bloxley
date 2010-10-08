package bloxley.controller.mailbox {

    import bloxley.base.BXObject;
    import bloxley.controller.mailbox.*;

    public class BXObserver {

        var sourceObject:Object;
        var anySource:Boolean;
        var sourceId:Number;

        var observer:Object;

        var action:Function;

        public function BXObserver(message:String, source:Object, observer:Object, action:Function) {
            if (source is BXObject) {
                this.sourceId = source.id();
                this.anySource = false;
                source.recordListenedTo(message);
            } else if (source) {
                this.sourceObject = source;
                this.anySource = false;
            } else {
                this.anySource = true;
            }

            this.observer = observer;

            if (observer is BXObject) {
                observer.recordListeningFor(message);
            }

            this.action = action;
        }

        /*********************
        *                    *
        * Receiving Messages *
        *                    *
        *********************/

        public function receivedMessage(message:BXMessage) {
            if (anySource || isSourceEqualTo(message.source)) {
                notifyObserver(message);
            }
        }

        public function notifyObserver(message:BXMessage) {
            action.call(observer, message);
        }

        /***************
        *              *
        * For Clearing *
        *              *
        ***************/

        public function isSourceEqualTo(source:Object):Boolean {
            return source == sourceObject || (source is BXObject && source.id() == sourceId);
        }

        public function isObserverEqualTo(otherObserver:Object):Boolean {
            return observer == otherObserver;
        }

    }

}
