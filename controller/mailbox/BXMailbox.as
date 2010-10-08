package bloxley.controller.mailbox {

    import bloxley.base.BXObject;
    import bloxley.controller.mailbox.*;

    public class BXMailbox extends BXObject {

        public static var mailbox:BXMailbox;

        var messageQueue:BXMessageQueue;
        var observers:Object;

        var holdResolution:Boolean;

        public function BXMailbox() {
            this.messageQueue = new BXMessageQueue();
            this.observers = new Object();

            this.holdResolution = false;

            BXMailbox.mailbox = this;
        }

        /****************************
        *                           *
        * Resolving Posted Messages *
        *                           *
        ****************************/

        function resolveMessages() {
            while (messageQueue.anyPendingMessages()) {
                var nextMessage = messageQueue.nextMessage();

                if (nextMessage is BXMessage) {
                    resolveMessage( nextMessage );
                } else if (nextMessage is BXDelayedCall) {
                    nextMessage.call();
                }

                messageQueue.clearMessage( nextMessage );
            }
        }

        function resolveMessage(message:BXMessage) {
            var observersForMessage = observers[message.message];

            if (observersForMessage) {
                observersForMessage.receivedMessage(message);
            }
        }

        /********************
        *                   *
        * Posting a Message *
        *                   *
        ********************/

        public function postNewMessage(message:String, source:Object, info:Object) {
            var newMessage = new BXMessage(message, source, info);

            postMessage( newMessage );
        }

        public function callLater(object:Object, action, info:Object) {
            var newDelayedCall = new BXDelayedCall(object, action, info);

            postMessage( newDelayedCall );
        }

        public function postMessage(message) {
            var shouldStartResolution = ! messageQueue.anyPendingMessages() && ! holdResolution;

            messageQueue.addMessage(message);

            if (shouldStartResolution) { // if not currently resolving messages...
                resolveMessages();
            }
        }

        /*****************************************
        *                                        *
        * Holding and Resuming the Message Queue *
        *                                        *
        *****************************************/

        public function pause() {
            holdResolution = true;
        }

        public function resume() {
            holdResolution = false;

            if (messageQueue.anyPendingMessages()) {
                resolveMessages();
            }
        }

        /********************
        *                   *
        * Adding a Listener *
        *                   *
        ********************/

        public function listenForMessage(message:String, source:Object, observer:Object, action:Function) {
            // Uncomment next line to track all listeners...
            // //trace("?> " + message + "\t" + observer);

            var observerQueue = observers[message];

            if (observerQueue == null) {
                observerQueue = new BXObserverQueue();
                observers[message] = observerQueue;
            }

            observerQueue.addObserver(message, source, observer, action);
        }

        /**********************
        *                     *
        * Removing a Listener *
        *                     *
        **********************/

        public function removeListener(observer:BXObject) {
            var listeningTo = observer.messagesListeningFor();

            for (var i = 0; i < listeningTo.length; i++) {
                var message = listeningTo[i];

                removeListenerForMessage(observer, message);
            }
        }

        public function removeListenerForMessage(observer:Object, message:String) {
            var observerQueue = observers[message];

            observerQueue.removeObserversByObserver(observer);
        }

        /********************
        *                   *
        * Removing a Source *
        *                   *
        ********************/

        public function removeSource(source) {
            var listenedTo = source.messagesListenedTo();

            for (var i = 0; i < listenedTo.length; i++) {
                var message = listenedTo[i];

                removeSourceForMessage(source, message);
            }
        }

        function removeSourceForMessage(source:Object, message:String) {
            var observerQueue = observers[message];

            observerQueue.removeObserversBySource(source);
        }

    }
    
}

