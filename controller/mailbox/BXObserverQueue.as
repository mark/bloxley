package bloxley.controller.mailbox {

    import bloxley.base.BXObject;
    import bloxley.controller.mailbox.*;

    public class BXObserverQueue {

        var observers:Array;
        var bySource:Object;

        public function BXObserverQueue() {
            this.observers = new Array();
            this.bySource = new Object();
        }

        public function addObserver(message:String, source:BXObject, observer:BXObject, action:Function) {
            var observerObj = new BXObserver(message, source, observer, action);

            if (source == null) {
                observers.push(observerObj);
            } else {
                if (bySource[ source.id() ] == null) {
                    bySource[ source.id() ] = new Array();
                }

                bySource[ source.id() ].push( observerObj );
            }
        }

        /*********************
        *                    *
        * Receiving Messages *
        *                    *
        *********************/

        public function receivedMessage(message:BXMessage) {
            if (message.source) {
                var watchers = bySource[ message.source.id() ];

                if ( watchers ) {
                    for (var i = 0; i < watchers.length; i++) {
                        watchers[i].receivedMessage(message);                
                    }
                }
            }

            for (var j = 0; j < observers.length; j++) {
                observers[j].receivedMessage(message);
            }
        }

        /*********************
        *                    *
        * Removing Observers *
        *                    *
        *********************/

        public function removeObserversBySource(source:BXObject) {
            delete observers[ source.id() ];
        }

        public function removeObserversByObserverFromArray(observer:Object, array:Array) {
            var i = 0;

            while (i < array.length) {
                if (array[i].isObserverEqualTo(observer))
                    array.splice(i, 1);
                else
                    i++;
            }
        }

        public function removeObserversByObserver(observer:Object) {
            removeObserversByObserverFromArray(observer, observers);

            for (var k in bySource) {
                removeObserversByObserverFromArray(observer, bySource[ k ]);
            }
        }

    }

}
