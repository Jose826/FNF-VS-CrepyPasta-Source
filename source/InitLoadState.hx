package;

import lime.utils.Assets;
import WiggleEffect.WiggleEffectType;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.input.keyboard.FlxKey;
import flixel.text.FlxText;
#if cpp
import sys.FileSystem;
import sys.io.File;
#end

// tracing Caching.hx from kade babyyyyyyyyy
class InitLoadState extends MusicBeatState
{
    var music = [];
	var stages = [];
	var characters = [];
    var loaded:Bool = false;
    var loadingText:FlxText;
    var loadedStuff:Int = 0;
    var toBeLoaded:Int = 0;
    var logo:FlxSprite;
    var logoSpook:FlxSprite;
	var wiggle:WiggleEffect;
	var bgColorTHING:FlxSprite;

    override public function create()
    {
        super.create();

        #if desktop
		DiscordClient.initialize();
		Application.current.onExit.add (function (exitCode) {
			DiscordClient.shutdown();
		});
		#end

        bgColorTHING = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLUE);
        bgColorTHING.scrollFactor.set();
        bgColorTHING.screenCenter();
        add(bgColorTHING);

		

		wiggle = new WiggleEffect();
		wiggle.effectType = WiggleEffectType.FLAG;
		wiggle.waveSpeed = 0.9;
		wiggle.waveFrequency = 0.2;
		wiggle.waveAmplitude = 0.4;

		loadingText = new FlxText(0, FlxG.height - 65, FlxG.width, "", 36);
        loadingText.setFormat(Paths.font("vcr.ttf"), 36, FlxColor.WHITE, CENTER);
        loadingText.screenCenter(X);
		add(loadingText);

		logo = new FlxSprite();
		logo.frames = Paths.getSparrowAtlas('logoBumpin');
		logo.animation.addByIndices('shit', 'logo bumpin', [0], '');
		logo.animation.play('shit');
		logo.scrollFactor.set();
		logo.screenCenter();
		add(logo);

		logoSpook = new FlxSprite().loadGraphic(Paths.image('logo-title', 'creepy'));
		logoSpook.screenCenter();
		logoSpook.scrollFactor.set();
		logoSpook.shader = wiggle.shader;
		logoSpook.alpha = 0;
		add(logoSpook);

		var vhs:FlxSprite = new FlxSprite();
		vhs.frames = Paths.getSparrowAtlas('vhs_effect', 'creepy');
		vhs.animation.addByPrefix('vhs', 'VHS');
		vhs.scrollFactor.set();
		vhs.alpha = 0.5;
		vhs.setGraphicSize(Std.int(vhs.width * 3.5));
		vhs.screenCenter();
		vhs.animation.play('vhs');
		add(vhs);

		#if cpp
		for(i in HSys.readDirectory(Main.path + "assets/songs"))
		{
			music.push(i);
		}

		#if MODS_ALLOWED
		for(i in HSys.readDirectory(Paths.modFolders(Main.path + 'songs')))
		{
			music.push(i);
		}

		for(i in HSys.readDirectory(Paths.modFolders(Main.path + 'stages')))
		{
			if (!i.endsWith(".lua"))
                
				continue;
			stages.push(i);
		}

		for(i in HSys.readDirectory(Main.path + "assets/characters"))
		{
			if (!i.endsWith('.json'))
				continue;
			characters.push(i);
		}
		#end
		#end

		#if cpp
		sys.thread.Thread.create(() -> {
			cache();
		});
		#end

		toBeLoaded = Lambda.count(music) + Lambda.count(characters) + Lambda.count(stages);
    }

	function cache()
	{
		for (i in music)
		{
			FlxG.sound.cache(Paths.inst(i));
			FlxG.sound.cache(Paths.voices(i));
			trace("cached " + i);
			loadedStuff++;
		}

		#if MODS_ALLOWED
		for (i in characters)
		{
			FlxG.bitmap.add(Paths.modFolders('characters/' + i));
			trace("cached " + i);
			loadedStuff++;
		}

		for (i in stages)
		{
				FlxG.bitmap.add(Paths.modFolders('stages/' + i));
				trace("cached " + i);
				loadedStuff++;
		}
		#end

		trace('ready!');

		if(ClientPrefs.firstTime){

		}
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		wiggle.update(elapsed);
	}
}
