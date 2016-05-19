2016.05.14 NoLeafClover release

To access settings in-game, press "Global say <T>" or "</>" keys. 
Then write down the name of the setting you want to change.
A list of available settings should pop up unless you make a typo.

|						|						|
Settings:
|Name:					|Possible values/range: |Explanation:
|	----		----	|	----		----	|	----	----	----
|cg_mouseCrouchScale	|0-1					|Mouse sensitivity scale when crouching. default 0.75
|cg_keyWeaponMode		|<key> default <x>		|Switches SMG firemodes. Switches rifle scope/ironsights(weap_scope 1)
|weap_burstFire			|0						|Enable(1)/Disable(0) SMG burst fire mode
|weap_burstRounds		|(-1)-30				|How many rounds does burst firemode produce(default 3)
|weap_scope				|0,1					|Mounts scope on rifle. Die/refill to apply changes. Press X to use ironsights
|weap_scopeZoom			|0-5					|Adjusts scope zoom on rifle. Die/refill to apply changes.
|						|						|
|	----		----	|	----		----	|	----	----	----
|						|						|
View/HUD settings:
|Name:					|Possible values/range: |Explanation:
|	----		----	|	----		----	|	----	----	----
|v_hitVibration			|0,1					|Close hit view vibration. 0-disable, 1-enable
|v_freeAim				|0-5					|Configureable freeaim. 0-disable, anything else - scaling of aiming deadzones. Default 1
|v_defaultSprintBob		|0,1					|Enables default sprint bobbing.
|v_drawArms				|0,1,2					|Enables 1st person Arms. 0-disable, 1-enable
|v_drawTorso			|0,1,2					|Enables 1st person Torso. 0-disable, 1-enable, 2-move away when looking down
|v_drawLegs				|0,1,2					|Enables 1st person Legs. 0-disable, 1-enable, 2-move away when looking down
|						|						|
|hud_playerDlines		|0,1,2					|Display teammate highlight. 0-disable, 1-enable precise, 2-enable all
|hud_playerNames		|0,1,2					|Display teammate names. 0-disable, 1-show distance, 2-show only name
|hud_playerNameX		|range +-400			|Displayed teammate name X location on screen. 0 is center.
|hud_playerNameY		|range +-300			|Displayed teammate name Y location on screen. 0 is center.
|hud_defaultSprintBob	|0,1					|Toggles between new and old sprint bobbing. 0-disable, 1-enable
|hud_blockDlines		|0,1,2					|Shows white/yellow/red lines when building. 0-disable, 1-enable white&red, 2-enable all
|hud_centerMessage		|0,1,2					|Controls the big center messages. 0-disable, 1-enable ctf/tc, 2-enable all (ctf/tc + kills)
|						|						|
|	----		----	|	----		----	|	----	----	----
|						|						|
Optimization settings:
|Name:					|Possible values/range: |Explanation:
|	----		----	|	----		----	|	----	----	----
|opt_particleMaxDist	|0-150 (default 125)	|Maximum particle display distance in blocks. For all particles.
|opt_particleNiceDist	|0-???			(def 1)	|Scales number of nice looking particles produced. 0-no particles will be produced, 0.5-half, 1-default.
|opt_particleNumScale	|0-???			(def 1) |Scales number of all particles produced. 0-no particles will be produced, 0.5-half, 1-default.
|opt_muzzleFlash		|0,1					|Toggles default muzzleflash on/off. There is no custom flash right now. 0-disable, 1-enable.
|opt_particleFallBlockReduce|0,1,2				|Reduce the amount of particles falling blocks produce. 0-no reduction, 1-constant reduction, 2-reduction above 250 blocks
|opt_brassTime			|0-???					|Sets how long spent shells lay on the ground, in seconds. Try doing 6000 on full server.
|opt_tracers			|0,1,2					|Togles display of tracers. 0-disable, 1-enable, 2-enable .kv6 tracers. FUCK YEA!
|						|						|
|snd_maxDistance		|0-1024					|Controls how far the sounds can be heard from, in blocks. Also mind that when shooting player will lose hearing, which he will gain back.
|						|						|
|	----		----	|	----		----	|	----	----	----
|						|						|