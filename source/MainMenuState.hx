package;
import openfl.filters.ShaderFilter;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import flixel.FlxCamera;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
#if desktop
import Discord.DiscordClient;
#end
import options.OptionsState;
import flixel.FlxSprite;
import flixel.FlxG;
import source.shaders.*;

class MainMenuState extends MusicBeatState
{
	var curSelected:Int = 0;
	var soncFace:FlxSprite;
	var textGrp:FlxTypedGroup<Alphabet>;
	var options:Array<String> = [
		'start',
		
		'others',
		
		'options',
		
		'twitter',
		'credits'
	];
	var vhs:FlxSprite;
	var camShit:FlxCamera;
	var selectedSomethin:Bool = false;
	var textDev:FlxText;
	public static var firstTime:Bool = false;
	static var canSelect = true;
	var vcrStuff:VCRDistortionEffect = new VCRDistortionEffect();

	override public function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end
		
		var blackShit:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		blackShit.setGraphicSize(Std.int(blackShit.width * 3.5));
		blackShit.screenCenter();
		blackShit.scrollFactor.set();
		add(blackShit);

		soncFace = new FlxSprite(0, 1000);
		soncFace.frames = Paths.getSparrowAtlas('sonic/sonic_expresions', 'creepy');
		soncFace.animation.addByIndices('hi', 'Xlaugh', [2], '');
		soncFace.animation.addByPrefix('damn', 'Xlaugh');
		soncFace.scrollFactor.set();
		soncFace.animation.play('hi', true);
		add(soncFace);
		soncFace.screenCenter();

		firstTime = true;

		textGrp = new FlxTypedGroup<Alphabet>();
		add(textGrp);

		for (i in 0...options.length)
		{
			var text:Alphabet = new Alphabet(0, (70 * i) + 30, options[i], true);
			text.isMenuItem = true;
			text.targetY = i;
			textGrp.add(text);

			trace('added ' + i + ' texts');
		}

		if(FlxG.sound.music.volume == 0)
		{
			FlxG.sound.music.fadeIn(0.5, 0, 1);
		}

		textDev = new FlxText(FlxG.width - 10, 0, 0, 'SEX', 40);
		textDev.scrollFactor.set();
		textDev.setFormat(Paths.font('sonic-cd'), 40, FlxColor.RED);
		textDev.visible = false;
		add(textDev);

		vhs = new FlxSprite();
		vhs.scrollFactor.set();
		vhs.screenCenter();
		vhs.frames = Paths.getSparrowAtlas('vhs_effect', 'creepy');
		vhs.animation.addByPrefix('uh', 'VHS');
		vhs.setGraphicSize(Std.int(vhs.width * 3.5));
		vhs.alpha = 0.5;
		vhs.animation.play('uh');
		// add(vhs);

		vcrStuff.setScanlines(false);
		vcrStuff.setPerspective(false);
		vcrStuff.setGlitchModifier(0);
		vcrStuff.setDistortion(true);
		vcrStuff.setNoise(true);
		vcrStuff.setVignette(true);
		vcrStuff.setVignetteMoving(true);

		FlxG.camera.setFilters([new ShaderFilter(vcrStuff.shader)]);

		super.create();
		
		#if android
		addVirtualPad(UP_DOWN, A_B);
		#end
		
		textGrp.forEach(function(text:Alphabet)
		{
			text.alpha = 0;
		});
	}

	override function closeSubState()
	{
		super.closeSubState();

		vhs.visible = true;

		selectedSomethin = false;

		textGrp.forEach(function (text:Alphabet)
		{
			FlxTween.tween(text, {alpha: 1}, 0.5, {ease: FlxEase.quadIn});
		});
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		vcrStuff.update(elapsed);

		if(selectedSomethin == false && canSelect == true)
		{
			if (controls.BACK)
				MusicBeatState.switchState(new TitleState());
	
			if (controls.UI_UP_P)
				changeSelection(-1);
	
			if (controls.UI_DOWN_P)
				changeSelection(1);
	
			if (controls.ACCEPT)
			{
				if (options[curSelected] == 'twitter')
				{
					CoolUtil.browserLoad('https://twitter.com/FNF_CC');
				}
			else
				{
					selectedSomethin = true;
						
					damnDaniel(options[curSelected]);
				}
			}
		}

		textGrp.forEach(function (text:Alphabet)
		{
			text.screenCenter(X);
		});
	}

	function changeSelection(change:Int = 0)
	{
		curSelected += change;

		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		if (curSelected < 0)
			curSelected = options.length - 0;
		
		if (curSelected >= options.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in textGrp.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			
			if (item.targetY == 0)
			{
				item.alpha = 1;
			}
		}
	}

	function damnDaniel(curOption:String)
	{
		soncFace.animation.play('damn', true);

		textGrp.forEach(function (text:Alphabet)
		{
			FlxTween.tween(text, {alpha: 0}, 0.5, {ease: FlxEase.quadIn});
		});

		FlxG.sound.play(Paths.sound('Kekfa_Laugh', 'creepy'), 1, false, null, true, function()
		{
			soncFace.animation.play('hi', true);

			switch(curOption)
			{
				case 'start':
					if(Main.isForLuigikid == false)
					{
						vhs.visible = false;

						openSubState(new StartSubstate());
					}
				else
					{
						PlayState.SONG = Song.loadFromJson('found-you', 'found-you');
						PlayState.isStoryMode = false;
						PlayState.storyDifficulty = 1;
						LoadingState.loadAndSwitchState(new PlayState());
					}

				case 'others': 
					vhs.visible = false;

					openSubState(new OthersSubState());

				case 'credits':
					MusicBeatState.switchState(new CreditsState());

				case 'options':
					MusicBeatState.switchState(new OptionsState());
			}
		});
	}
}

class StartSubstate extends MusicBeatSubstate
{
	var curSelected:Int = 0;
	var options:Array<String> = [
		'story',
		'freeplay'
	];
	var textGrp:FlxTypedGroup<Alphabet>;
	var vcrStuff:VCRDistortionEffect = new VCRDistortionEffect();

	public function new()
	{
		super();

		textGrp = new FlxTypedGroup<Alphabet>();
		add(textGrp);

		for(i in 0...options.length)
		{
			var text:Alphabet = new Alphabet(0, (70 * i) + 30, options[i], true);
			text.isMenuItem = true;
			text.targetY = i;
			textGrp.add(text);
		}

		vcrStuff.setScanlines(false);
		vcrStuff.setPerspective(false);
		vcrStuff.setGlitchModifier(0);
		vcrStuff.setDistortion(true);
		vcrStuff.setNoise(true);
		vcrStuff.setVignette(true);
		vcrStuff.setVignetteMoving(true);

		FlxG.camera.setFilters([new ShaderFilter(vcrStuff.shader)]);

		var vhs:FlxSprite = new FlxSprite();
		vhs.scrollFactor.set();
		vhs.screenCenter();
		vhs.frames = Paths.getSparrowAtlas('vhs_effect', 'creepy');
		vhs.animation.addByPrefix('uh', 'VHS');
		vhs.setGraphicSize(Std.int(vhs.width * 3.5));
		vhs.alpha = 0.5;
		vhs.animation.play('uh');
		// add(vhs);
		
		#if android
		addVirtualPad(UP_DOWN, A_B_C);
		#end
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		vcrStuff.update(elapsed);

		if (controls.UI_UP_P)
			changeSelection(-1);

		if (controls.UI_DOWN_P)
			changeSelection(1);

		if (controls.BACK)
			close();

		#if android
		if (virtualPad.buttonC.justPressed) {
			#if android
			removeVirtualPad();
			#end
			openSubState(new android.AndroidControlsSubState());
		}
		#end
		if (controls.ACCEPT)
		{
			switch(options[curSelected])
			{
				case 'story':
					MusicBeatState.switchState(new StoryMenuState());

				case 'freeplay':
					MusicBeatState.switchState(new FreeplayState());
			}
		}

		textGrp.forEach(function (text:Alphabet)
		{
			text.screenCenter(X);
		});
	}

	function changeSelection(change:Int = 0)
	{
		curSelected += change;
		
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		
		if (curSelected < 0)
			curSelected = options.length - 0;
				
		if (curSelected >= options.length)
			curSelected = 0;
		
		var bullShit:Int = 0;
		
		for (item in textGrp.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;
		
			item.alpha = 0.6;
					
			if (item.targetY == 0)
			{
				item.alpha = 1;
			}
		}
	}
}

class OthersSubState extends MusicBeatSubstate
{
	var curSelected:Int = 0;
	var options:Array<String> = [
		'mods',
		'options'
	];
	var optionsAlt:Array<String> = [
		'edit mods',
		'options'
	];
	var showModsOPT:Bool = false;
	var textGrp:FlxTypedGroup<Alphabet>;
	var arrowGrp:FlxTypedGroup<FlxSprite>;
	var vcrStuff:VCRDistortionEffect = new VCRDistortionEffect();

	public function new()
	{
		super();

		vcrStuff.setScanlines(false);
		vcrStuff.setPerspective(false);
		vcrStuff.setGlitchModifier(0);
		vcrStuff.setDistortion(true);
		vcrStuff.setNoise(true);
		vcrStuff.setVignette(true);
		vcrStuff.setVignetteMoving(true);

		FlxG.camera.setFilters([new ShaderFilter(vcrStuff.shader)]);

		textGrp = new FlxTypedGroup<Alphabet>();
		add(textGrp);

		arrowGrp = new FlxTypedGroup<FlxSprite>();
		// add(arrowGrp);

		changeSelection();
		regenText(0, false);
	
		var vhs:FlxSprite = new FlxSprite();
		vhs.scrollFactor.set();
		vhs.screenCenter();
		vhs.frames = Paths.getSparrowAtlas('vhs_effect', 'creepy');
		vhs.animation.addByPrefix('uh', 'VHS');
		vhs.setGraphicSize(Std.int(vhs.width * 3.5));
		vhs.alpha = 0.5;
		vhs.animation.play('uh');
		// add(vhs);
		
		#if android
		addVirtualPad(UP_DOWN, B);
		#end
	}

	function regenText(idThing:Int, clearGrp:Bool = true)
	{
		if(clearGrp == true)
		{
			textGrp.clear();	
		}

		switch(idThing)
		{
			case 0:
			{
				var arrowUselessShit:Array<String> = ['right', 'left'];

				for(i in 0...arrowUselessShit.length)
				{
					var xForArrow:Array<Float> = [];
					var yForArrow:Float = 0;
		
					textGrp.forEach(function(text:Alphabet)
					{
						xForArrow = [
							text.x + text.width,
							text.x - text.width
						];
		
						yForArrow = text.y;
					});
		
					var arrow:FlxSprite = new FlxSprite(xForArrow[i], yForArrow);
					arrow.frames = Paths.getSparrowAtlas('campaign_menu_UI_assets');
					arrow.animation.addByPrefix('idle', 'arrow ' + arrowUselessShit[i]);
					arrow.animation.addByPrefix('press', 'arrow push ' + arrowUselessShit[i]);
					arrow.animation.play('idle');
					arrowGrp.add(arrow);
				}

				for(i in 0...options.length)
				{
					var text:Alphabet = new Alphabet(0, (70 * i) + 30, options[i], true);
					text.isMenuItem = true;
					text.targetY = i;
					textGrp.add(text);
				}
			}

			case 1:
			{
				var arrowUselessShit:Array<String> = ['right', 'left'];

				for(i in 0...arrowUselessShit.length)
				{
					var xForArrow:Array<Float> = [];
					var yForArrow:Float = 0;
		
					textGrp.forEach(function(text:Alphabet)
					{
						xForArrow = [
							text.x + text.width,
							text.x - text.width
						];
		
						yForArrow = text.y;
					});
		
					var arrow:FlxSprite = new FlxSprite(xForArrow[i], yForArrow);
					arrow.frames = Paths.getSparrowAtlas('campaign_menu_UI_assets');
					arrow.animation.addByPrefix('idle', 'arrow ' + arrowUselessShit[i]);
					arrow.animation.addByPrefix('press', 'arrow push ' + arrowUselessShit[i]);
					arrow.animation.play('idle');
					arrowGrp.add(arrow);

					arrow.animation.finishCallback = function(name:String)
					{
						arrow.animation.play('idle');
					}
				}

				for(i in 0...optionsAlt.length)
				{
					var text:Alphabet = new Alphabet(0, (70 * i) + 30, optionsAlt[i], true);
					text.isMenuItem = true;
					text.targetY = i;
					textGrp.add(text);
				}
			}
		}
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		vcrStuff.update(elapsed);

		if (controls.UI_UP_P)
			changeSelection(-1);

		if (controls.UI_DOWN_P)
			changeSelection(1);

		if (controls.BACK)
			close();

		if (FlxG.keys.justPressed.SEVEN)
		{
			#if MODS_ALLOWED
			MusicBeatState.switchState(new editors.MasterEditorMenu());
			#end
		}

		if (controls.ACCEPT)
		{
			switch(options[curSelected])
			{
				#if MODS_ALLOWED
				case 'mods':
					MusicBeatState.switchState(new ModsMenuState());

				case 'edit mods':
					MusicBeatState.switchState(new editors.MasterEditorMenu());
				#end

				case 'options':
					MusicBeatState.switchState(new options.OptionsState());
			}
		}

		textGrp.forEach(function (text:Alphabet)
		{
			text.screenCenter(X);
		});
	}

	function changeSelection(change:Int = 0)
	{
		curSelected += change;
		
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		
		if (curSelected < 0)
			curSelected = options.length - 0;
				
		if (curSelected >= options.length)
			curSelected = 0;

		if (options[curSelected] == 'edit mods' || options[curSelected] == 'mods')
		{
			showModsOPT = true;
		}
	else
		{
			showModsOPT = false;
		}
		
		var bullShit:Int = 0;
		
		for (item in textGrp.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;
		
			item.alpha = 0.6;
					
			if (item.targetY == 0)
			{
				item.alpha = 1;
			}
		}
	}
}
