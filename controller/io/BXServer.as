package bloxley.controller.io {
    
    import bloxley.base.BXObject;
    import bloxley.controller.game.BXGame;
    
    public class BXServer extends BXObject {

        var levelLoader:BXLevelLoader;
        
        public function BXServer(game:BXGame) {
            levelLoader = new BXLevelLoader(game);
        }
        
        public function loadLevel(info) {
            levelLoader.load( url(info) );
        }
        
        public function url(info):String {
            // OVERRIDE ME!
            return "";
        }
    }

}