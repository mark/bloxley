package bloxley.controller.io {
    
    import bloxley.controller.game.*;
    import bloxley.controller.io.*;
    import bloxley.model.game.BXBoard;

    public class BXLevelLoader extends BXLoader {

        public function BXLevelLoader(game:BXGame) {
            super(game);
        }

        /****************************
        *                           *
        * Success Condition Methods *
        *                           *
        ****************************/

        override public function loadSucceeded(loadRequest:BXLoadRequest) {
            var xml    = loadRequest.xml();
            var rows   = loadRows(xml);
            var actors = loadActors(xml);
            
            game.loadLevel(rows, actors);
            
            // game.setCurrentGameController("Play");       
        }

        override public function loadFailed(loadRequest:BXLoadRequest) {
            //trace("LOAD FAILED: " + loadRequest.info);
        }

        /************************
        *                       *
        * Level Loading Methods *
        *                       *
        ************************/


        function loadRows(xml:XML):Array {
            var rows = [];
            
            for each (var row:XML in xml.board.row) {
                rows.push( row.text().toString() );
            }
            
            return rows;
        }

        function loadActors(xml:XML):Object {
            var actors = {};
            
            for each (var item:XML in xml.*) {
                var name = item.name();
                trace("name = " + name);
                
                if (name != "board") {
                    if (actors[name] == null) actors[name] = [];
                    
                    actors[name].push( loadActor(item) );
                }
            }
            
            return actors;
        }
        
        function loadActor(xml:XML):Object {
            var actor = { x: xml.@x, y: xml.@y };
            
            for each (var attribute:XML in xml.*) {
                actor[ attribute.name() ] = attribute.text();
            }
            
            return actor;
        }
        
    }
    
}