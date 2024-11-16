package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.system.ui.FlxSoundTray;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.math.FlxMath;
import io.newgrounds.NG;
import lime.app.Application;
import openfl.Assets;

#if windows
import Discord.DiscordClient;
#end

#if desktop
import sys.thread.Thread;
#end

using StringTools;

class TitleState extends MusicBeatState
{
	static var initialized:Bool = false;

	var blackScreen:FlxSprite;
	var credGroup:FlxGroup;
	var credTextShit:Alphabet;
	var textGroup:FlxGroup;
	var ngSpr:FlxSprite;

	var curWacky:Array<String> = [];

	var wackyImage:FlxSprite;

	override public function create():Void
	{
		
		#if sys
		if (!sys.FileSystem.exists("assets/replays"))
			sys.FileSystem.createDirectory("assets/replays");
		#end
		
		PlayerSettings.init();

		#if windows
		DiscordClient.initialize();

		Application.current.onExit.add (function (exitCode) {
			DiscordClient.shutdown();
		 });
		 
		#end

		curWacky = FlxG.random.getObject(getIntroTextShit());

		// DEBUG BULLSHIT

		super.create();

		// NGio.noLogin(APIStuff.API);

		#if ng
		var ng:NGio = new NGio(APIStuff.API, APIStuff.EncKey);
		trace('NEWGROUNDS LOL');
		#end

		FlxG.save.bind('funkin', 'Sector03');

		KadeEngineData.initSave();

		Highscore.load();

		if (FlxG.save.data.weekUnlocked != null)
		{
			// FIX LATER!!!
			// WEEK UNLOCK PROGRESSION!!
			// StoryMenuState.weekUnlocked = FlxG.save.data.weekUnlocked;

			if (StoryMenuState.weekUnlocked.length < 4)
				StoryMenuState.weekUnlocked.insert(0, true);

			// QUICK PATCH OOPS!
			if (!StoryMenuState.weekUnlocked[0])
				StoryMenuState.weekUnlocked[0] = true;
		}

		#if FREEPLAY
		FlxG.switchState(new FreeplayState());
		#elseif CHARTING
		FlxG.switchState(new ChartingState());
		#else
		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			startIntro();
		});
		#end

		bgFlash = new FlxSprite(0, 0).loadGraphic(Paths.image('startscreen/bgFlash'));
		bgFlash.visible = true;
		bgFlash.alpha = 0;
		bgFlash.updateHitbox();
		bgFlash.antialiasing = true;
		add(bgFlash);
	}

	var logoBl:FlxSprite;
	//var gfDance:FlxSprite;
	var mamiTitle:FlxSprite;
	var danceLeft:Bool = false;
	var titleText:FlxSprite;
	var bgFlash:FlxSprite;

	function startIntro()
	{
		if (!initialized)
		{
			var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
			diamond.persist = true;
			diamond.destroyOnNoUse = false;

			FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 1, new FlxPoint(0, -1), {asset: diamond, width: 32, height: 32},
				new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
			FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(0, 1),
				{asset: diamond, width: 32, height: 32}, new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));

			transIn = FlxTransitionableState.defaultTransIn;
			transOut = FlxTransitionableState.defaultTransOut;

			// HAD TO MODIFY SOME BACKEND SHIT
			// IF THIS PR IS HERE IF ITS ACCEPTED UR GOOD TO GO
			// https://github.com/HaxeFlixel/flixel-addons/pull/348

			// var music:FlxSound = new FlxSound();
			// music.loadStream(Paths.music('freakyMenu'));
			// FlxG.sound.list.add(music);
			// music.play();
			FlxG.sound.playMusic(Paths.music('freakyMenu'), 0); //this song prob copyrighted AF lol

			FlxG.sound.music.fadeIn(4, 0, 0.7);
		}

		Conductor.changeBPM(120);
		persistentUpdate = true;

		logoBl = new FlxSprite(-150, -45);
		logoBl.frames = Paths.getSparrowAtlas('mamilogo');
		logoBl.antialiasing = true;
		logoBl.animation.addByPrefix('bump', 'logo bumpin', 24, false);
		logoBl.animation.play('bump');
		logoBl.updateHitbox();
		add(logoBl);


		//gfDance = new FlxSprite(FlxG.width * 0.4, FlxG.height * 0.07);
		//gfDance.frames = Paths.getSparrowAtlas('gfDanceTitle');
		//gfDance.animation.addByIndices('danceLeft', 'gfDance', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
		//gfDance.animation.addByIndices('danceRight', 'gfDance', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
		//gfDance.antialiasing = true;
		//add(gfDance);

		mamiTitle = new FlxSprite(425, 50);
		mamiTitle.frames = Paths.getSparrowAtlas('startscreen/MAMI_TITLE');
		mamiTitle.antialiasing = true;
		mamiTitle.animation.addByPrefix('idle', 'MAMI_TITLE', 24);
		mamiTitle.setGraphicSize(Std.int(mamiTitle.width * 1.1));
		mamiTitle.animation.play('idle');
		mamiTitle.updateHitbox();
		add(mamiTitle);

		titleText = new FlxSprite(100, FlxG.height * 0.8);
		titleText.frames = Paths.getSparrowAtlas('titleEnter');
		titleText.animation.addByPrefix('idle', "Press Enter to Begin", 24);
		titleText.animation.addByPrefix('press', "ENTER PRESSED", 24);
		titleText.antialiasing = true;
		titleText.animation.play('idle');
		titleText.updateHitbox();
		// titleText.screenCenter(X);
		add(titleText);

		var logo:FlxSprite = new FlxSprite().loadGraphic(Paths.image('logo'));
		logo.screenCenter();
		logo.antialiasing = true;
		// add(logo);

		// FlxTween.tween(logoBl, {y: logoBl.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG});
		// FlxTween.tween(logo, {y: logoBl.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG, startDelay: 0.1});

		credGroup = new FlxGroup();
		add(credGroup);
		textGroup = new FlxGroup();

		blackScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		credGroup.add(blackScreen);

		credTextShit = new Alphabet(0, 0, "ninjamuffin99\nPhantomArcade\nkawaisprite\nevilsk8er", true);
		credTextShit.screenCenter();

		// credTextShit.alignment = CENTER;

		credTextShit.visible = false;

		ngSpr = new FlxSprite(0, FlxG.height * 0.52).loadGraphic(Paths.image('newgrounds_logo'));
		add(ngSpr);
		ngSpr.visible = false;
		ngSpr.setGraphicSize(Std.int(ngSpr.width * 0.8));
		ngSpr.updateHitbox();
		ngSpr.screenCenter(X);
		ngSpr.antialiasing = true;

		FlxTween.tween(credTextShit, {y: credTextShit.y + 20}, 2.9, {ease: FlxEase.quadInOut, type: PINGPONG});

		FlxG.mouse.visible = false;

		if (initialized)
			skipIntro();
		else
			initialized = true;

		// credGroup.add(credTextShit);
	}

	function getIntroTextShit():Array<Array<String>>
	{
		var fullText:String = Assets.getText(Paths.txt('introText'));

		var firstArray:Array<String> = fullText.split('\n');
		var swagGoodArray:Array<Array<String>> = [];

		for (i in firstArray)
		{
			swagGoodArray.push(i.split('--'));
		}

		return swagGoodArray;
	}

	var transitioning:Bool = false;

	override function update(elapsed:Float)
	{
		FlxG.camera.zoom = FlxMath.lerp(1, FlxG.camera.zoom, 0.95);

		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
		// FlxG.watch.addQuick('amp', FlxG.sound.music.amplitude);

		if (FlxG.keys.justPressed.F)
		{
			FlxG.fullscreen = !FlxG.fullscreen;
		}

		var pressedEnter:Bool = FlxG.keys.justPressed.ENTER;

		#if mobile
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
			{
				pressedEnter = true;
			}
		}
		#end

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null)
		{
			if (gamepad.justPressed.START)
				pressedEnter = true;

			#if switch
			if (gamepad.justPressed.B)
				pressedEnter = true;
			#end
		}

		if (FlxG.keys.justPressed.NINE && !transitioning)
			{
				transitioning = true;
				FlxG.switchState(new TitleStateOld());
			}

		if (pressedEnter && !transitioning && skippedIntro)
		{
			#if html //bootleggers please atleast link the mod to the offical download page? thanks
			FlxG.openURL('https://gamebanana.com/mods/303790');
			Sys.command('/usr/bin/xdg-open', ["https://gamebanana.com/mods/303790", "&"]);
			#end

			#if !switch
			NGio.unlockMedal(60960);

			// If it's Friday according to da clock
			if (Date.now().getDay() == 5)
				NGio.unlockMedal(61034);
			#end

			titleText.animation.play('press');

			FlxG.camera.flash(FlxColor.WHITE, 1);
			FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

			transitioning = true;
			// FlxG.sound.music.stop();

			FlxTween.tween(bgFlash, {y: 1280}, 2, {ease: FlxEase.quadIn});
			FlxTween.tween(logoBl, {y: 1280}, 2, {ease: FlxEase.quadIn});
			FlxTween.tween(mamiTitle, {y: 1280}, 2, {ease: FlxEase.quadIn});
			FlxTween.tween(titleText, {y: 1280}, 2, {ease: FlxEase.quadIn});

			new FlxTimer().start(2.5, function(tmr:FlxTimer) //orginally 2 lol
			{

				// Get current version of Kade Engine

				var http = new haxe.Http("https://raw.githubusercontent.com/KadeDev/Kade-Engine/master/version.downloadMe");

				http.onData = function (data:String) {
				  
				  	if (!MainMenuState.kadeEngineVer.contains(data.trim()) && !OutdatedSubState.leftState && MainMenuState.nightly == "")
					{
						//trace('outdated lmao! ' + data.trim() + ' != ' + MainMenuState.kadeEngineVer);
						OutdatedSubState.needVer = data;
						if (FlxG.save.data.spoilerStartScreen)
							FlxG.switchState(new SpoilerState());
						else
							FlxG.switchState(new MainMenuState());
					}
					else
					{
						if (FlxG.save.data.spoilerStartScreen)
							FlxG.switchState(new SpoilerState());
						else
							FlxG.switchState(new MainMenuState());
					}
				}
				
				http.onError = function (error) {
				  trace('error: $error');
				  if (FlxG.save.data.spoilerStartScreen)
					FlxG.switchState(new SpoilerState());
				else
					FlxG.switchState(new MainMenuState()); // fail but we go anyway
				}
				
				http.request();

			});
			// FlxG.sound.play(Paths.music('titleShoot'), 0.7);
		}

		if (pressedEnter && !skippedIntro)
		{
			skipIntro();
		}

		super.update(elapsed);
	}

	function createCoolText(textArray:Array<String>)
	{
		for (i in 0...textArray.length)
		{
			var money:Alphabet = new Alphabet(0, 0, textArray[i], true, false);
			money.screenCenter(X);
			money.y += (i * 60) + 200;
			credGroup.add(money);
			textGroup.add(money);
		}
	}

	function addMoreText(text:String)
	{
		var coolText:Alphabet = new Alphabet(0, 0, text, true, false);
		coolText.screenCenter(X);
		coolText.y += (textGroup.length * 60) + 200;
		credGroup.add(coolText);
		textGroup.add(coolText);
	}

	function deleteCoolText()
	{
		while (textGroup.members.length > 0)
		{
			credGroup.remove(textGroup.members[0], true);
			textGroup.remove(textGroup.members[0], true);
		}
	}

	override function beatHit()
	{
		super.beatHit();

		if (curBeat % 2 == 1 && !transitioning)
			{
			FlxTween.cancelTweensOf(bgFlash);
			bgFlash.alpha = 0.75;
			FlxTween.tween(bgFlash, {alpha: 0.25}, 1, {ease: FlxEase.quadIn});
			logoBl.animation.play('bump', true);
			mamiTitle.animation.play('idle', true);
			}

		if (curBeat % 4 == 0)
			{
				FlxG.camera.zoom += 0.02;
			}

		//danceLeft = !danceLeft;

		//if (danceLeft)
		//	gfDance.animation.play('danceRight');
		//else
		//	gfDance.animation.play('danceLeft');

		FlxG.log.add(curBeat);

		switch (curBeat)
		{
			case 1:
				createCoolText(['a fnf mod']);

			case 3:
				addMoreText('by a lot of people');

			case 6:
				deleteCoolText();

			case 7:
				createCoolText([curWacky[0]]);

			case 9:
				addMoreText(curWacky[1]);

			case 12:
				deleteCoolText();
				curWacky = FlxG.random.getObject(getIntroTextShit());

			case 13:
				createCoolText([curWacky[0]]);

			case 15:
				addMoreText(curWacky[1]);

			case 18:
				deleteCoolText();
				curWacky = FlxG.random.getObject(getIntroTextShit());

			case 19:
				createCoolText([curWacky[0]]);

			case 21:
				addMoreText(curWacky[1]);

			case 25:
				deleteCoolText();
				curWacky = FlxG.random.getObject(getIntroTextShit());

			case 26:
				addMoreText('The full');

			case 28:
				addMoreText('ass vs');

			case 30:
				addMoreText('Mami mod');

			case 32:
				skipIntro();
		}
	}
	
	var skippedIntro:Bool = false;

	function skipIntro():Void
	{
		if (!skippedIntro)
		{
			remove(ngSpr);
			bgFlash.alpha = 0.75;
			FlxG.camera.flash(FlxColor.WHITE, 4);
			remove(credGroup);
			skippedIntro = true;
		}
	}
}
