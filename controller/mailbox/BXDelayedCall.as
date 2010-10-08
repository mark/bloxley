/*
    This class encapsulates a method that will be called "later"--at
    some unspecified point later in the frame.
    
    The method provided can be a function, or the name for the method
    to be called on the object.
    
    Do not instantiate these directly.  For subclasses of BXObject,
    you can create them by calling later(...).  For non-subclasses of
    BXObject, call BXMailbox.mailbox.callLater(...).
*/

package bloxley.controller.mailbox {

    public class BXDelayedCall {

        var self:Object;
        var action;
        var info:Object;

        public function BXDelayedCall(self:Object, action, info:Object) {
            this.self = self;
            this.action = action;
            this.info = info;
        }

        public function call() {
            if (action is Function) {
                action.call(self, info);
            } else {
                self[action].call(self, info);
            }
        }

    }
    
}
