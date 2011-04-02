package bloxley.view.sprite {

    import bloxley.view.sprite.*;

    public class BXSpriteChange {

        var sprite:BXSprite;

        var changes:Object;

        var realX:Number;
        var realY:Number;

        public function BXSpriteChange(sprite:BXSprite) {
            this.sprite = sprite;
            this.changes = { x: 0.0, y: 0.0 };
        }

        function get(method):Number {
            if (changes[method])
                return changes[method];
            else
                return sprite.get(method);
        }

        public function change(method, value) {
            changes[method] = value;

            sprite.updated();
        }

        public function update() {
            var didChange = false;
            var visibilityChanged = false;
            
            var clip = sprite.getGraphics();
            var virt = sprite.getVirtual();
            
            if (changes.x != null) {
                clip.x = changes.x;
                realX  = changes.x;
                didChange = true;
            }    

            if (changes.dx != null) {
                clip.x  = realX + changes.dx;
                virt.dx = changes.dx;
                didChange = true;
            }

            if (changes.y != null) {
                clip.y = changes.y;
                realY  = changes.y;
                didChange = true;
            }

            if (changes.dy != null) {
                clip.y  = realY + changes.dy;
                virt.dy = changes.dy;
            }

            var oldRotation = clip.rotation;
            clip.rotation = 0;

            if (changes.width != null) {
                clip.width = changes.width;
                didChange = true;
            }
            
            if (changes.height != null) {
                clip.height = changes.height;
                didChange = true;
            }

            if (changes.rotation != null) {
                clip.rotation = changes.rotation;
                didChange = true;
            } else {
                clip.rotation = oldRotation;
            }

            if (changes.fade != null) {
                didChange = true;
                var oldAlpha = clip.alpha;
                clip.alpha = changes.fade;
                
                if (oldAlpha < 0.1 && changes.fade >= 0.1 || oldAlpha >= 0.1 && changes.fade < 0.1) {
                    visibilityChanged = true;
                }
            }

            if (changes.frame != null) {
                didChange = true;
                clip.gotoAndStop(changes.frame);
            }
            
            // trace("didChange = " + didChange);
            sprite.post("BXSpriteUpdated");
            
            if (visibilityChanged) sprite.post("BXSpriteVisibilityChanged");
        }

        function clearChanges() {
            for (var key in changes) {
                changes[key] = null;
            }
        }

    }
    
}
