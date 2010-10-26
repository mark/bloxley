package bloxley.view.sprite {

    import bloxley.view.sprite.*;

    public class BXSpriteChange {

        var sprite:BXSprite;

        var changes:Object;

        var realX:Number;
        var realY:Number;

        public function BXSpriteChange(sprite:BXSprite) {
            this.sprite = sprite;
            this.changes = new Object();
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
            var clip = sprite.getGraphics();
            var virt = sprite.getVirtual();
            
            if (changes.x != null) {
                clip.x = changes.x;
                realX  = changes.x;
            }    

            if (changes.dx != null) {
                clip.x  = realX + changes.dx;
                virt.dx = changes.dx;
            }

            if (changes.y != null) {
                clip.y = changes.y;
                realY  = changes.y;
            }

            if (changes.dy != null) {
                clip.y  = realY + changes.dy;
                virt.dy = changes.dy;
            }

            var oldRotation = clip.rotation;
            clip.rotation = 0;

            if (changes.width != null) clip.width = changes.width;
            if (changes.height != null) clip.height = changes.height;

            if (changes.rotation != null)
                clip.rotation = changes.rotation;
            else
                clip.rotation = oldRotation;

            if (changes.fade != null) clip.alpha = changes.fade;

            if (changes.frame != null) clip.gotoAndStop(changes.frame);
        }

        function clearChanges() {
            for (var key in changes) {
                changes[key] = null;
            }
        }

    }
    
}
