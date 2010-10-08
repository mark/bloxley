package bloxley.view.choreography {

    import flash.utils.Dictionary;
    
    import bloxley.view.animation.BXEmptyAnimation;
    import bloxley.view.choreography.BXChannel;
    import bloxley.view.animation.BXSchedulable;

    public class BXRoutine extends BXSchedulable {

        var animationChannel:BXChannel;
        var waitingFor:Dictionary;
        var _options:Object;

        public function BXRoutine(options:Object = null) {
            this.animationChannel = new BXChannel();
            this.waitingFor = new Dictionary();
            this._options = options;

            // So we know when animations finish...
            listenFor("BXChannelAnimationFinished", animationChannel, tryStartingAnimations);
            listenFor("BXChannelClear", animationChannel, finish);
        }

        public function options(key:String) {
            return _options[key];
        }

        /*******************
        *                  *
        * Starting Methods *
        *                  *
        *******************/

        override public function setup() {
            // OVERRIDE ME!
        }

        override public function start(...rest) {
            super.start();

            tryStartingAnimations();
        }

        /********************
        *                   *
        * Finishing Methods *
        *                   *
        ********************/

        override public function finish(...rest) {
            super.finish();
        }

        /****************************
        *                           *
        * Animation Channel Methods *
        *                           *
        ****************************/
        
        public function channel():BXChannel {
            return animationChannel;
        }
        
        /*******************
        *                  *
        * Observer Methods *
        *                  *
        *******************/

        public function tryStartingAnimations(...rest) {
            //trace("routine#" + id() + ".tryStartingAnimations()");
            var waitingAnimations = animationChannel.waitingAnimations();
            var localWaitingFor = this.waitingFor;

            // Iterate through the animations that are waiting to start
            waitingAnimations.each( function(animation) {
                
                // Get the ids of the animations that they're waiting for
                var toStart = localWaitingFor[ animation ];

                for (var i = 0; i < toStart.length; i++) {
                    // If the animation that we're waiting for hasn't finished yet
                    if (! toStart[i].isFinished()) return;
                }

                // If we've gotten here, then all of the animations we're waiting for have started
                animation.start();
            });
        }

        /******************************
        *                             *
        * Atomic Choreography Methods *
        *                             *
        ******************************/

        public function add(animation:BXSchedulable) {
            if (animation == null) return;

            if (waitingFor[ animation ] == null) {
                animationChannel.add(animation);
                waitingFor[ animation ] = new Array();
            }
        }

        public function animateInSequence(animation1:BXSchedulable, animation2:BXSchedulable) {
            add(animation1);
            add(animation2);

            waitingFor[ animation2 ].push( animation1 );
        }

        public function animateInParallel(animation1:BXSchedulable, animation2:BXSchedulable) {
            add(animation1);
            add(animation2);

            var animation1Waiting = waitingFor[ animation1 ];
            var animation2Waiting = waitingFor[ animation2 ];

            // Combine the animations that each is waiting for...
            for (var i = 0; i < animation2Waiting.length; i++) {
                animation1Waiting.push( animation2Waiting[i] );
            }

            // Ensure that they are both waiting for the same animations...
            // (This will keep them in sync)
            waitingFor[ animation2 ] = animation1Waiting;
        }

        /***********************
        *                      *
        * Choreography Methods *
        *                      *
        ***********************/

        public function startWith(...animations) {
            for (var i = 0; i < animations.length; i++) {
                add(animations[i]);
            }
        }

        public function sequence(...animations) {
            var earlier = animations[0];

            for (var i = 1; i < animations.length; i++) {
                var later = animations[i];
                animateInSequence(earlier, later);
                earlier = later;
            }
        }

        public function parallel(...animations) {
            var animation1 = animations[0];

            for (var i = 1; i < animations.length; i++) {
                var animation2 = animations[i];
                animateInParallel(animation1, animation2);
            }
        }

        public function delay(seconds:Number) {
            return new BXEmptyAnimation(seconds);
        }

        public function replaceWith(original:BXSchedulable, replacement:BXSchedulable) {
            // ...yeah.  Good question...
            // Possible: rewrite all of the waitingFor arrays that include orginal.id()
            // Possible: add a level of indirection between animation.id() and the elements of waitingFor
            // Possible: use sets instead of arrays, and then do a remove-then-insert <-- I like this
            // Possible: hold off on this for a bit
        }
    }
    
}
