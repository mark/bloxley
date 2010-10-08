package bloxley.controller.mailbox {
    
    public class BXMessage {

        public var message:String;
        public var source:Object;
        public var info:Object;

        public function BXMessage(message:String, source:Object, info:Object) {
            this.message = message;
            this.source = source;
            this.info = info;
        }

    }

}