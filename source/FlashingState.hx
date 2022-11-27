package;

import flixel.tweens.FlxEase;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import source.shaders.*;
import openfl.filters.ShaderFilter;

class FlashingState extends MusicBeatState
{
	public static var leftState:Bool = false;
	var vcrStuff:VCRDistortionEffect = new VCRDistortionEffect();

	var warnText:FlxText;
	override function create()
	{
		super.create();

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLUE);
		bg.scrollFactor.set(0, 0);
		add(bg);

		TitleState.alreadyGotHere = true;

		warnText = new FlxText(0, 0, FlxG.width,
			"WARNING THIS MOD HAS:
			\nGORE
			\nFLASHING LIGHTS
			\nSTRONG MOVEMENTS
			\nPC USERNAME REVEAL
			\nPRESS ENTER TO CONTINUE",
			32);
		warnText.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		warnText.screenCenter(Y);
		add(warnText);
		
		#if android
		addVirtualPad(NONE, A_B);
		#end

		vcrStuff.setScanlines(false);
		vcrStuff.setPerspective(false);
		vcrStuff.setGlitchModifier(0);
		vcrStuff.setDistortion(true);
		vcrStuff.setNoise(true);
		vcrStuff.setVignette(true);
		vcrStuff.setVignetteMoving(true);

		new FlxTimer().start(17, function(timer:FlxTimer)
		{
			warnText.text = 'alright?';

			new FlxTimer().start(17, function(timer2:FlxTimer)
			{
				warnText.text = 'come on, go';

				new FlxTimer().start(17, function(timer2:FlxTimer)
				{
					FlxTween.tween(warnText, {alpha: 0}, 1.5, {ease: FlxEase.quadIn, onComplete: function(twn:FlxTween)
					{
						FlxTween.color(bg, 1.5, bg.color, FlxColor.RED, {ease: FlxEase.quadIn, onComplete: function(twn2:FlxTween)
						{
							new FlxTimer().start(5, function(tmr3:FlxTimer)
							{
								var logoSpook:FlxSprite	= new FlxSprite().loadGraphic(Paths.image('logo-title', 'creepy'));
								logoSpook.screenCenter();
								logoSpook.scrollFactor.set();
								add(logoSpook);

								FlxG.sound.play(Paths.sound('Spooky_Boo', 'creepy'));

								Application.current.window.close();
							});
						}});
					}});
				});
			});
		});

		FlxG.camera.setFilters([new ShaderFilter(vcrStuff.shader)]);
	}

	override function update(elapsed:Float)
	{
		vcrStuff.update(elapsed);
		if(!leftState) {
			if (controls.ACCEPT)
			{
				MusicBeatState.switchState(new TitleState());
				ClientPrefs.saveSettings();
			}

			if(controls.BACK)
			{
				ClientPrefs.saveSettings();
				Application.current.window.close();
				trace('nah fuck off');
			}
		}
		super.update(elapsed);
	}
}
