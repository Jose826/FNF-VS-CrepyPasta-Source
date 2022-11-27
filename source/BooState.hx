package;

import lime.app.Application;
import flixel.FlxCamera;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.addons.effects.FlxTrail;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.FlxG;

class BooState extends MusicBeatState
{
    var sonicBoo:FlxSprite;
    var dumbText:FlxText;
    var daText:String = 'youre playing an illegal copy';
    var uselessCam:FlxCamera;
    var defaultCam:FlxCamera;
    var vfxCam:FlxCamera;
    var isGettingSpooky:Bool = false;
    var floatingShit:Float = 0;

    override public function create()
    {
        super.create();

        defaultCam = new FlxCamera();
        defaultCam.bgColor.alpha = 0;
        uselessCam = new FlxCamera();
        uselessCam.bgColor.alpha = 0;
        vfxCam = new FlxCamera();
        vfxCam.bgColor.alpha = 0;
        FlxG.cameras.reset(defaultCam);
        FlxG.cameras.add(uselessCam);
        FlxG.cameras.add(vfxCam);

        FlxCamera.defaultCameras = [defaultCam];

        var shit:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        shit.screenCenter();
        shit.scrollFactor.set();
        add(shit);

        sonicBoo = new FlxSprite();
        sonicBoo.frames = Paths.getSparrowAtlas('sonic/sonic_expresions', 'creepy');
        sonicBoo.animation.addByIndices('boo', 'Xintro', [19], '');
        sonicBoo.animation.addByPrefix('laugh', 'Xlaugh', 24);
        sonicBoo.animation.play('boo');
        sonicBoo.screenCenter();
        sonicBoo.scrollFactor.set();
        add(sonicBoo);

        dumbText = new FlxText(FlxG.width, FlxG.height, 0, 'youre playing an illegal copy', 42);
        dumbText.setFormat(Paths.font('sonic-cd.ttf'), 42, FlxColor.RED, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.WHITE);
        dumbText.screenCenter();
        dumbText.scrollFactor.set();
        dumbText.alpha = 0;
        dumbText.cameras = [uselessCam];
        add(dumbText);

        var vhs:FlxSprite = new FlxSprite();
		vhs.frames = Paths.getSparrowAtlas('vhs_effect', 'creepy');
		vhs.animation.addByPrefix('vhs', 'VHS');
		vhs.scrollFactor.set();
		vhs.alpha = 0.5;
		vhs.setGraphicSize(Std.int(vhs.width * 3.5));
		vhs.screenCenter();
		vhs.animation.play('vhs');
        vhs.cameras = [vfxCam];
		add(vhs);

        timerNtext();
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        dumbText.text = daText;

        floatingShit += 0.1;

        if(isGettingSpooky == true)
        {
            Application.current.window.x += Std.int(Math.sin(floatingShit));
            Application.current.window.y +=  Std.int(Math.sin(floatingShit));
            Application.current.window.width += Std.int(Math.sin(floatingShit));
            Application.current.window.height += Std.int(Math.sin(floatingShit));
        }
    }

    function timerNtext()
    {
        new FlxTimer().start(2, function(tmr:FlxTimer)
        {
            FlxTween.tween(dumbText, {alpha: 1}, 0.8, {ease: FlxEase.quadIn});

            new FlxTimer().start(4, function(tmr:FlxTimer)
            {
                daText = 'report this copy now';

                new FlxTimer().start(4, function(tmr:FlxTimer)
                {
                    FlxG.sound.play(Paths.sound('Drowning_Theme', 'creepy'), 1, false, null, true, function()
                    {
                        Application.current.window.close();
                    });

                    uselessCam.shake(0.05, 10000);

                    isGettingSpooky = true;
                });
            });
        });
    }
}