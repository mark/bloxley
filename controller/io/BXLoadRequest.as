package bloxley.controller.io {

    import flash.utils.getQualifiedClassName;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.net.*;
    
    import bloxley.controller.io.*;

    public class BXLoadRequest {

        var loader:BXLoader;
        var url:String;
        var urlLoader:URLLoader;
        var response:XML;
        
        var shouldLoad:Boolean;

        public function BXLoadRequest(loader:BXLoader, url:String) {
            // Provided to the constructor
            this.loader = loader;
            this.url    = url;

            // Initialize the loader...
        	loader.beforeLoad(this);

            // Initialize
            this.shouldLoad = true;
            this.urlLoader = new URLLoader( new URLRequest(url) );
            urlLoader.addEventListener(Event.COMPLETE, loadCompleted);
            urlLoader.addEventListener(IOErrorEvent.IO_ERROR, loadFailed);
        }

        public function xml():XML {
            return response;
        }
        
        /************************
        *                       *
        * From the BXController *
        *                       *
        ************************/

        public function cancel() {
            shouldLoad = false;
        }

        /*********************
        *                    *
        * From the URLLoader *
        *                    *
        *********************/
        
        public function loadCompleted(event:Event) {
            response = new XML(urlLoader.data);
            
            loader.loadSucceeded(this);
        }
        
        public function loadFailed(event:Event) {
            trace("Failed");
        }
        
        function OLDloadCompleted(success:Boolean) {
            if (success && shouldLoad) {
                loader.loadSucceeded(this);
            } else if (! success) {
                loader.loadFailed(this);
            } else {
                loader.loadCancelled(this);
            }
        }

    }
}