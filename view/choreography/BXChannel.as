package bloxley.view.choreography {

    import bloxley.base.BXObject;
    import bloxley.model.collection.BXSet;
    import bloxley.controller.mailbox.BXMessage;
    import bloxley.view.animation.BXSchedulable;

    public class BXChannel extends BXObject {

        var waiting: BXSet;
        var active:  BXSet;

        var timePaused:int;

        public function BXChannel() {
            waiting  = new BXSet();
            active   = new BXSet();
        }

        /******************************
        *                             *
        * Adding Schedulable Elements *
        *                             *
        ******************************/

        public function add(schedulable:BXSchedulable) {
            if (schedulable.isStarted()) {
                active.insert( schedulable );
                listenFor("BXFinishAnimation", schedulable, animationFinished);
            } else {
                waiting.insert( schedulable );
                listenFor("BXStartAnimation",  schedulable, animationStarted );
                listenFor("BXFinishAnimation", schedulable, animationFinished);
            }
        }

        /******************************
        *                             *
        * Keeping Track of Animations *
        *                             *
        ******************************/

        public function animationStarted(message:BXMessage) {
            var schedulable = message.source;

            waiting.remove(schedulable);
            active.insert(schedulable);
        }

        public function animationFinished(message:BXMessage) {
            var schedulable = message.source;

            active.remove(schedulable);

            post("BXChannelAnimationFinished", schedulable);

            if (waiting.isEmpty() && active.isEmpty()) {
                post("BXChannelClear")
            }
        }

        /************************
        *                       *
        * Retrieving Animations *
        *                       *
        ************************/

        public function getAnimation(id:Number):BXSchedulable {
            var animation:BXSchedulable;

            animation = waiting.fetch(id);
            if (animation) return animation;

            animation = active.fetch(id);
            if (animation) return animation;

            return animation;
        }

        public function waitingAnimations():BXSet {
            return waiting;
        }

        public function activeAnimations():BXSet {
            return active;
        }

        /**************************
        *                         *
        * Channel Control Methods *
        *                         *
        **************************/
        
        public function pause() {

        }

        public function resume() {

        }

        public function finish() {
            
        }
        
        public function cancel() {
            
        }

    }

}
