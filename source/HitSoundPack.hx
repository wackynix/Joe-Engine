package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxSubState;
import flixel.addons.ui.FlxUIInputText;
import flixel.addons.ui.FlxInputText;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import Controls.Control;
import haxe.Json;
import haxe.format.JsonParser;
#if MODS_ALLOWED
import sys.io.File;
import sys.FileSystem;
#end

using StringTools;

typedef HitSoundFile = {
	var displayname:String;
}

class HitSoundPack extends MusicBeatState
{
    #if MODS_ALLOWED
    static var directories:Array<String> = [Paths.mods('hitsounds/'), Paths.mods(Paths.currentModDirectory + '/hitsounds/'), Paths.getPreloadPath('hitsounds/')];
    #else
    static var directories:Array<String> = [Paths.getPreloadPath('hitsounds/')];
    #end
    public static var packFile:String = '';
    static var tempMap:Map<String, Bool> = new Map<String, Bool>();
    public static var hitsoundpacks:Array<String> = [];

    #if (haxe >= "4.0.0")
	public static var hitsoundpacksdisplay:Map<String, String> = new Map();
	#else
	public static var hitsoundpacksdisplay:Map<String, String> = new Map<String, String>();
	#end

    public static var hitsoundsformatted:Array<String> = [];

    static var curPack:String = 'default';

    public static var hspackinstance:HitSoundPack;

    public function new()
    {
        super();
    }
    
    public static function checkhitsoundpacks()
    {
        for (i in 0...hitsoundpacks.length) {
            tempMap.set(hitsoundpacks[i], true);
        }

        hitsoundpacks = [];
        hitsoundsformatted = [];
        tempMap = [];
    
        #if MODS_ALLOWED
        for (i in 0...directories.length) {
            var directory:String = directories[i];
            if(FileSystem.exists(directory)) {
                for (file in FileSystem.readDirectory(directory)) {
                    var path = haxe.io.Path.join([directory, file]);
                    if (!FileSystem.isDirectory(path) && file.endsWith('.json')) {
                        var fileToCheck:String = file.substr(0, file.length - 5);
                        var packPath:String = directory + fileToCheck + '.json';
                        var rawJson = File.getContent(packPath);
                        var json:HitSoundFile = cast Json.parse(rawJson);
                        if(!tempMap.exists(fileToCheck)) {
                            tempMap.set(fileToCheck, true);
                            hitsoundpacks.push(fileToCheck);
                            packFile = json.displayname;
                            hitsoundpacksdisplay.set(fileToCheck, packFile); 
                            hitsoundsformatted.push(getPackDisplayName(fileToCheck));
                            trace('hitsound: ' + hitsoundsformatted);
                        }
                    }
                }
            }
        }
        #end
    } 

    public static function getPackDisplayName(pack:String):String
    {
        return hitsoundpacksdisplay.get(pack);  
    }
}
