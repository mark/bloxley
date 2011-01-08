package bloxley.view.gui {
    
    import flash.display.*;
    
    import bloxley.view.sprite.BXSprite;
    import bloxley.view.sprite.BXCompositeSprite;
    
    public class BXScreen extends BXSprite {

        static var LAYERS = [ "background", "game", "interface", "foreground" ];

        var stage:Stage;
		var layers:Object;
        
        public function BXScreen(stage:Stage) {
            this.stage = stage;
			this.layers = new Object();
			
            super(null, { parent: this, depth: 0 });

			for (var depth = 0; depth < LAYERS.length; depth++) {
				var key = LAYERS[ depth ];
				layers[key] = new BXCompositeSprite({ parent: this, depth: depth });
			}
        }
                
        override public function getGraphics() {
            return stage;
        }

		public function layer(layerName:String): BXCompositeSprite {
			var l = layers[ layerName ];
			return l ? l : layers.foreground;
		}

    }
    
}