<div align="center">
<h1>Dice Sound</h1>

By [Mullet Mafia Dev](https://www.roblox.com/groups/5018486/Mullet-Mafia-Dev#!/about)
</div>

Dice Sound is a sweet music player that can play music in a loop, a custom playlist, or even an individual play. Dice Sound also comes with the entire Mullet Mafia collection (free to use!) and Mad Studio's music provided by Loleris. This also contains APM music we at Mullet Mafia Dev have been using, so rock on!

## Documentation

### DiceSound:Play
```lua
DiceSound:Play(audio,amount)
```
Play a song with the specific audio table for the first audio argument. Specify an amount of times you should loop the song or play repeatedly in the second `amount` parameter. To loop the music, set `amount` to true. To play a song once, you can either leave the `amount` argument blank or 1. You can provide a number in the `amount` parameter such as 16 to play the song over and over 16 times.

*Example:*

```lua
DiceSound:Play(DiceSound.Audios['Mfia_Click']) -- will only play once (great for sound FX!)
DiceSound:Play(DiceSound.Audios['Mfia_Jingle'],true) -- will loop infinitely unless stopped
DiceSound:Play(DiceSound.Audios['Mfia_Music1'],10) -- will loop the song 10 times
```

### DiceSound:Stop
```lua
DiceSound:Stop(audio)
```
To stop a song, you must provide the reference to the audio in the audio table. This will soft stop by lowering the volume over 0.5 seconds and then halt the music.

*Example*

```lua
DiceSound:Stop(DiceSound.Audios['Mfia_Jingle']) -- stops the infite music from playing
```

### DiceSound:CreatePlaylist
```
DiceSound:CreatePlaylist(playlist,amount)
```
Create & play a playlist table that you **must** define before you hook a table to this function, otherwise you lose control to stop this playlist later. `playlist` will play in the order you provide the table, and `playlist` **must** be a table. To loop the music, set `amount` to true. To play a song once, you can either leave the `amount` argument blank or 1. You can provide a number in the `amount` parameter such as 16 to play the song over and over 16 times.

*Example:*

```lua
local Soundtrack = {
	DiceSound.Audios.APM_Music5;
	DiceSound.Audios.APM_Music6;
	DiceSound.Audios.APM_Music7;
}

DiceSound:CreatePlaylist(Soundtrack,true) -- loops the playlist infinitely
```

### DiceSound:StopPlaylist
```
DiceSound:StopPlaylist(playlist)
```
To stop a playlist, you must provide the reference to the playlist table you used in `:CreatePlaylist`. This will soft stop by lowering the volume over 0.5 seconds and then halt the music.

*Example:*

```lua
local Soundtrack = {
	DiceSound.Audios.APM_Music5;
	DiceSound.Audios.APM_Music6;
	DiceSound.Audios.APM_Music7;
}

DiceSound:StopPlaylist(Soundtrack) -- halts the infinitely playing playlist
```
