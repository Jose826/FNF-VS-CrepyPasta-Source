package;
import editors.ChartingState;
import flixel.addons.text.FlxTypeText;
import lime.app.Application;
import flixel.group.FlxGroup.FlxTypedGroup;
import openfl.filters.ShaderFilter;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxTimer;
import flixel.FlxSprite;
import source.shaders.*;

class StreamerState extends MusicBeatState
{
    var stuff:Array<String> = [
        '', // bro this is very important fr
        '??? is god',
        '??? is drowned',
        '??? is dead',
        '??? is the only one',
        'go to teaser folders\non assets',
        'see you soon',
        ''
    ];
    var teaserTxt:FlxTypeText;
    var vcrStuff:VCRDistortionEffect = new VCRDistortionEffect();

    override public function create()
    {
        super.create();

        var blackShit:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		blackShit.setGraphicSize(Std.int(blackShit.width * 3.5));
		blackShit.screenCenter();
		blackShit.scrollFactor.set();
		add(blackShit);

        teaserTxt = new FlxTypeText(FlxG.width, FlxG.height, FlxG.width, "", 40);
        teaserTxt.scrollFactor.set();
        teaserTxt.setFormat(Paths.font('sonic-cd.ttf'), 40, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.GRAY);
        teaserTxt.screenCenter();
        teaserTxt.sounds = [FlxG.sound.load(Paths.sound('pixelText', 'week6'), 0.6)];
        add(teaserTxt);

        vcrStuff.setScanlines(false);
		vcrStuff.setPerspective(false);
		vcrStuff.setGlitchModifier(0);
		vcrStuff.setDistortion(true);
		vcrStuff.setNoise(true);
		vcrStuff.setVignette(true);

        new FlxTimer().start(2, function(flx:FlxTimer)
        {
            createTexts();
        });

        FlxG.camera.setFilters([new ShaderFilter(vcrStuff.shader)]);
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);
        vcrStuff.update(elapsed);
    }

    function createTexts()
    {
        var counter:Int = 0;

        new FlxTimer().start(3, function(tmr:FlxTimer)
        {
            counter += 1;

            trace('loop num: ' + counter);

            switch(counter)
            {
                case 7:
                    CoolUtil.browserLoad('https://twitter.com/FNF_CC');
                    MusicBeatState.switchState(new CreditsState());
                default:
                    teaserTxt.resetText(stuff[counter]);
                    teaserTxt.start(0.1, true);
            }
        }, 7);
    }
}