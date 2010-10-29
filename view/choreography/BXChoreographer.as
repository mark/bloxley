package bloxley.view.choreography {
    
    import bloxley.base.BXObject;
    import bloxley.controller.event.*;
    import bloxley.controller.mailbox.*;
    import bloxley.view.animation.*;

    public class BXChoreographer extends BXObject {

        var routine:BXRoutine;
        
        /*  NOTES:

            I would also like to include some sort of table of object -> latest animation
        */

        public function BXChoreographer() {
            this.routine = createRoutine();
            //listenForAny("BXStartOfChoreography", cancel);
        }

        /********************
        *                   *
        * Animation Methods *
        *                   *
        ********************/
        
        public function createRoutine():BXRoutine {
            return new BXRoutine({ ros: true });
        }
        
        public function animationChannel():BXChannel {
            return routine.channel();
        }
        
        public function animationRoutine():BXRoutine {
            return routine;
        }
        
        /*********************
        *                    *
        * Sequencing Methods *
        *                    *
        *********************/
        
        public function choreographEvent(event:BXEvent) {
            post("BXStartOfChoreography");
            
            var action = event.originalCause();
            
            routine.startWith( action.animation() );
            choreographAction( action );
            
            return routine;
        }
        
        public function choreographAction(cause:BXAction) {
            var actionKey = cause.key();

            //cause.animation().listenFor("BXCancelAnimation", this, cause.animation().cancel);

            for (var i = 0; i < cause.effects.length; i++) {
                var effect = cause.effects[i];

                if (! effect.didFail()) {
                    var effectKey = effect.key();

                    var choreographyType = callCascade( ["arrange" + effectKey + "CausedBy" + actionKey,
                                                         "arrangeActionCausedBy" + actionKey,
                                                         "arrange" + effectKey,
                                                         "arrangeActions"], [ cause, effect] );

                    var choreographyMethod = choreographyType + "Choreography";
                    
                    if (respondsTo(choreographyMethod)) {
                        this[choreographyMethod](cause.animation(), effect.animation());
                    }

                    choreographAction(effect);
                }
            }
        }

        /************************
        *                       *
        * Built-In Arrangements *
        *                       *
        ************************/

        public function arrangeMoveCausedByMove(cause:BXMoveAction, effect:BXMoveAction):String {
            return (cause.actor() == effect.actor()) ? "serial" : "parallel";
        }

        public function arrangeDisableCausedByMove(move:BXMoveAction, disable:BXDisableAction) {
            return (move.actor() == disable.actor()) ? "serial" : "parallel";
        }

        public function arrangeActions(cause:BXAction, effect:BXAction):String {
            return "parallel";
        }

        /************************
        *                       *
        * Built-In Choreography *
        *                       *
        ************************/

        public function serialChoreography(cause:BXSchedulable, effect:BXSchedulable) {
            routine.sequence(cause, effect);
        }

        public function parallelChoreography(cause:BXSchedulable, effect:BXSchedulable) {
            routine.parallel(cause, effect);
        }

    }

}