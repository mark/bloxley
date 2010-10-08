package bloxley.base {

    import flash.utils.getQualifiedClassName;
    import flash.utils.getDefinitionByName;

    import bloxley.controller.mailbox.BXMailbox;
    import bloxley.view.clock.BXClock;
    
    public class BXObject {

        // Global ID #
        static var __nextId:int = 0;
        var __id:int;

        // Mailbox system
        var __listening:Object;
        var __listenedTo:Object;

        public function BXObject() {
            __id = __nextId++;

            // trace("INIT " + id() + "\t " + className());
        }

        /*************
        *            *
        * Id Methods *
        *            *
        *************/

        // Return a unique BXObject id
        public function id():int {
            return __id;
        }

        /******************
        *                 *
        * Mailbox Methods *
        *                 *
        ******************/

        // When 'source' posts a message 'message' to the mailbox, call 'func' on this object
        public function listenFor(message, source, func) {
            BXMailbox.mailbox.listenForMessage(message, source, this, func);
        }

        // When any object posts a message 'message' to the mailbox, call 'func' on this object
        public function listenForAny(message, func) {
            listenFor(message, null, func);
        }

        // Post a message to the mailbox, optionally with some additional information
        public function post(message:String, info = null) {
            BXMailbox.mailbox.postNewMessage(message, this, info);
        }

        // In a provided number of seconds, post a message to the mailbox, optionally with some additional information
        public function postLater(message:String, seconds:Number, info = null) {
            BXClock.clock.addSignal(message, seconds, this, info);
        }

        // Later this frame, call the provided method
        public function later(action, info:Object = null) {
            BXMailbox.mailbox.callLater(this, action, info);
        }

        // These methods are to keep track of the object's presence in the mailbox,
        // So it can be cleared out.

        // Remove this object from the mailbox, preventing it from receiving any more messages
        public function stopListening(...rest) {
            BXMailbox.mailbox.removeListener(this);
            BXMailbox.mailbox.removeSource(this);
        }

        // Record that this object is listening for a particular message
        public function recordListeningFor(message) {
            if (__listening == null) __listening = new Object();
            __listening[message] = true;
        }

        // What messages are this object listening for?
        public function messagesListeningFor():Array {
            var messages = new Array();

            for (var msg in __listening) {
                messages.push(msg);
            }

            return messages;
        }

        // Record that some object is listening for a particular message from this object
        public function recordListenedTo(message) {
            if (__listenedTo == null) __listenedTo = new Object();
            __listenedTo[message] = true;
        }

        // What messages are objects waiting for from this object?
        public function messagesListenedTo():Array {
            var messages = new Array();

            for (var msg in __listenedTo) {
                messages.push(msg);
            }

            return messages;
        }
        
        /********************
        *                   *
        * Cascading Methods *
        *                   *
        ********************/

        // Given a list of methods, it will find the first that
        // this responds to, and call it
        public function callCascade(meths:Array, args:Array = null) {
            if (args == null) args = new Array();
            
            for (var i = 0; i < meths.length; i++) {
                if (this.respondsTo( meths[i] )) {
                    var m = this[meths[i]];
                    return m.apply( this, args );
                }
            }

            return null;
        }

        // Given a method and a list of objects, it will call the
        // method on the first object that responds to it
        public function callResolve(meth:String, objects:Array, args:Array = null) {
            if (args == null) args = new Array();
            
            for (var i = 0; i < objects.length; i++) {
                if (objects[i] is BXObject && objects[i].respondsTo(meth)) {
                    var m = objects[i][meth];
                    return m.apply( objects[i], args );
                }
            }
            
            return null;
        }
        
        /*********************
        *                    *
        * Reflection Methods *
        *                    *
        *********************/

        // Does this object have a method with the given name?
        public function respondsTo(method:String) {
            return hasOwnProperty(method) && typeof( this[method] ) == "function";
        }
        
        // What is the name of this class?
        public function className():String {
            return getQualifiedClassName(this);
        }
        
        // What is the class object that this is an instance of?
        public function klass():Class {
            return getDefinitionByName( className() ) as Class;
        }

        /******************
        *                 *
        * Utility Methods *
        *                 *
        ******************/

        // Return a string description of this object
        public function toString():String {
            return "#<" + className() + ": " + id() + ">";
        }

    }

}
