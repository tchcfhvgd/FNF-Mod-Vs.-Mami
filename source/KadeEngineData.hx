import openfl.Lib;
import flixel.FlxG;
import flixel.math.FlxMath;

class KadeEngineData
{
    public static function initSave()
    {
        if (FlxG.save.data.newInput == null)
			FlxG.save.data.newInput = true;

		if (FlxG.save.data.downscroll == null)
			FlxG.save.data.downscroll = false;

		if (FlxG.save.data.dfjk == null)
			FlxG.save.data.dfjk = false;
			
		if (FlxG.save.data.accuracyDisplay == null)
			FlxG.save.data.accuracyDisplay = true;

		if (FlxG.save.data.offset == null)
			FlxG.save.data.offset = 0;

		if (FlxG.save.data.offset == null)
			FlxG.save.data.offset = 0;

		if (FlxG.save.data.songPosition == null)
			FlxG.save.data.songPosition = false;

		if (FlxG.save.data.fps == null)
			FlxG.save.data.fps = false;

		if (FlxG.save.data.changedHit == null)
		{
			FlxG.save.data.changedHitX = -1;
			FlxG.save.data.changedHitY = -1;
			FlxG.save.data.changedHit = false;
		}

		if (FlxG.save.data.fpsRain == null)
			FlxG.save.data.fpsRain = false;
        
	        if (FlxG.save.data.fpsCap == null)
			FlxG.save.data.fpsCap = 60;

		if (FlxG.save.data.fpsCap > 285 || FlxG.save.data.fpsCap < 60)
			FlxG.save.data.fpsCap = 60; // baby proof so you can't hard lock ur copy of kade engine
		
		if(FlxG.save.data.fpsCap == null) {
			final refreshRate:Int = FlxG.stage.application.window.displayMode.refreshRate;
			FlxG.save.data.fpsCap = Std.int(FlxMath.bound(refreshRate, 60, 240));
		}

		if(FlxG.save.data.fpsCap > FlxG.drawFramerate)
		{
			FlxG.updateFramerate = FlxG.save.data.fpsCap;
			FlxG.drawFramerate = FlxG.save.data.fpsCap;
		}
		else
		{
			FlxG.drawFramerate = FlxG.save.data.fpsCap;
			FlxG.updateFramerate = FlxG.save.data.fpsCap;
		}
	    
	        if (FlxG.save.data.scrollSpeed == null)
			FlxG.save.data.scrollSpeed = 1;

		if (FlxG.save.data.npsDisplay == null)
			FlxG.save.data.npsDisplay = false;

		if (FlxG.save.data.frames == null)
			FlxG.save.data.frames = 10;

		if (FlxG.save.data.accuracyMod == null)
			FlxG.save.data.accuracyMod = 1;

		if (FlxG.save.data.watermark == null)
			FlxG.save.data.watermark = true;

		if (FlxG.save.data.arrowColorCustom == null)
			FlxG.save.data.arrowColorCustom = true;

		if (FlxG.save.data.resetButton == null)
			FlxG.save.data.resetButton = true;

		if (FlxG.save.data.langoEnglish == null)
			FlxG.save.data.langoEnglish = true;

		if (FlxG.save.data.langoSpanish == null)
			FlxG.save.data.langoSpanish = false;

		if (FlxG.save.data.langoRussian == null)
			FlxG.save.data.langoRussian = false;

		if (FlxG.save.data.flashingLights == null)
			FlxG.save.data.flashingLights = true;

		if (FlxG.save.data.ghostTapping == null)
			FlxG.save.data.ghostTapping = true;

		if (FlxG.save.data.copyrightedMusic == null)
			FlxG.save.data.copyrightedMusic = false;

		if (FlxG.save.data.cpuStrums == null)
			FlxG.save.data.cpuStrums = false;

		if (FlxG.save.data.hitSound == null)
			FlxG.save.data.hitSound = false;

		if (FlxG.save.data.reducedMotion == null)
			FlxG.save.data.reducedMotion = false;

		if (FlxG.save.data.spoilerStartScreen == null)
			FlxG.save.data.spoilerStartScreen = true;

		if (FlxG.save.data.progressStoryClear == null)
			FlxG.save.data.progressStoryClear = false;

		if (FlxG.save.data.progressStoryClearHard == null)
			FlxG.save.data.progressStoryClearHard = false;

		if (FlxG.save.data.progressStoryClearTetris == null)
			FlxG.save.data.progressStoryClearTetris = false;

		if (FlxG.save.data.progressStoryClearMamigation == null)
			FlxG.save.data.progressStoryClearMamigation = false;

		if (FlxG.save.data.useShaders == null)
			FlxG.save.data.useShaders = true;

		if (FlxG.save.data.noteSplash == null)
			FlxG.save.data.noteSplash = true;

		if (FlxG.save.data.tickets == null)
			FlxG.save.data.tickets = 0;

		Conductor.recalculateTimings();

		Main.watermarks = FlxG.save.data.watermark;

		(cast (Lib.current.getChildAt(0), Main)).setFPSCap(FlxG.save.data.fpsCap);
	}
}
