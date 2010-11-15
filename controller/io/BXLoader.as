package bloxley.controller.io {
    
    import bloxley.controller.game.BXGame;
    import bloxley.controller.io.*;

    public class BXLoader { // extends BXObject ???

        var game:BXGame;

        public function BXLoader(game:BXGame) {
            this.game = game;
        }

        /********************
        *                   *
        * Starting the Load *
        *                   *
        ********************/

        public function load(url:String):BXLoadRequest {
    		return new BXLoadRequest(this, url);
        }

        /**********************
        *                     *
        * Processing the Load *
        *                     *
        **********************/

        public function beforeLoad(loadRequest:BXLoadRequest) {
            // OVERRIDE ME!!!
        }

        public function loadSucceeded(loadRequest:BXLoadRequest) {
            // OVERRIDE ME!!!
        }

        public function loadFailed(loadRequest:BXLoadRequest) {
            // OVERRIDE ME!!!
        }

        public function loadCancelled(loadRequest:BXLoadRequest) {
            // OVERRIDE ME!!!
        }

    }

}