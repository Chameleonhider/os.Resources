/*
 Copyright (c) 2013 yvt
 
 This file is part of OpenSpades.
 
 OpenSpades is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 OpenSpades is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with OpenSpades.  If not, see <http://www.gnu.org/licenses/>.
 
 */
 
 namespace spades 
 {
	class ThirdPersonRifleSkinB: 
	IToolSkin, IThirdPersonToolSkin, IWeaponSkin 
	{
		private int snd_maxDistance = ConfigItem("snd_maxDistance", "150").IntValue;
	
		private float sprintState;
		private float raiseState;
		private IntVector3 teamColor;
		private bool muted = true;
		private Matrix4 originMatrix;
		private float aimDownSightState;
		private float readyState;
		private bool reloading;
		private float reloadProgress;
		private int ammo, clipSize;
		//Chameleon
		private float clientDistance;
		private float soundDistance;
		
		float SprintState { 
			set { sprintState = value; }
		}
		
		float RaiseState { 
			set { raiseState = value; }
		}
		
		bool IsMuted {
			set { muted = value; }
		}
		
		IntVector3 TeamColor { 
			set { teamColor = value; } 
		}
		
		Matrix4 OriginMatrix {
			set { originMatrix = value; }
		}
		
		float PitchBias {
			get { return 0.f; }
		}
		
		float AimDownSightState {
			set { aimDownSightState = value; }
		}
		
		bool IsReloading {
			set { reloading = value; }
		}
		float ReloadProgress {
			set { reloadProgress = value; }
		}
		int Ammo {
			set { ammo = value; }
		}
		int ClipSize {
			set { clipSize = value; }
		}
		float ReadyState {
			set { readyState = value; }
		}
		//Chameleon
		float ClientDistance
		{
			set { clientDistance = value; }
		}
		float SoundDistance
		{
			set { soundDistance = value; }
		}
		
		private Renderer@ renderer;
		private AudioDevice@ audioDevice;
		private Model@ model;
		private AudioChunk@ fire0;
		private AudioChunk@ fireLast0;
		private AudioChunk@ fire1;
		private AudioChunk@ fire2;
		private AudioChunk@ reloadFullSound;
		private AudioChunk@ reloadEmptySound;
		
		private Image@ flashImage;
		
		ThirdPersonRifleSkinB(Renderer@ r, AudioDevice@ dev) {
			@renderer = r;
			@audioDevice = dev;
			@model = renderer.RegisterModel
				("Models/Weapons/RifleB/Weapon3rd.kv6");
			
			@fire0 = dev.RegisterSound
				("Sounds/Weapons/RifleB/Fire0.wav");
			@fireLast0 = dev.RegisterSound
				("Sounds/Weapons/RifleB/Fire0Last.wav");
			@fire1 = dev.RegisterSound
				("Sounds/Weapons/RifleB/Fire1.wav");
			@fire2 = dev.RegisterSound
				("Sounds/Weapons/RifleB/Fire2.wav");
			@reloadFullSound = dev.RegisterSound
				("Sounds/Weapons/RifleB/ReloadFull.wav");
			@reloadEmptySound = dev.RegisterSound
				("Sounds/Weapons/RifleB/ReloadEmpty.wav");
				
			@flashImage = renderer.RegisterImage("Gfx/WhiteSmoke.tga");
		}
		
		void Update(float dt) {
		}
		
		void WeaponFired()
		{
			if(!muted)
			{
				Vector3 origin = originMatrix.GetOrigin();
				AudioParam param;
				param.referenceDistance = clientDistance;
				if (clientDistance < snd_maxDistance/2.f)
				{
					param.volume = 5.f;
					if (ammo > 1)
						audioDevice.Play(fire0, origin, param);
					else
						audioDevice.Play(fireLast0, origin, param);
				}
				else if (clientDistance < snd_maxDistance)
				{
					param.volume = 1.f;
					audioDevice.Play(fire1, origin, param);
				}
				else if (clientDistance < snd_maxDistance*2.f && soundDistance < snd_maxDistance*2)
				{
					param.volume = 0.5f;
					audioDevice.Play(fire2, origin, param);
				}
			}
		}
		
		void ReloadingWeapon() 
		{
			if(!muted)
			{
				Vector3 origin = originMatrix.GetOrigin();
				AudioParam param;
				param.volume = 1.f;
				param.referenceDistance = clientDistance;
				if (clientDistance*2 < soundDistance)
				{
					if (ammo > 0)
						audioDevice.PlayLocal(reloadFullSound, origin, param);
					else
						audioDevice.PlayLocal(reloadEmptySound, origin, param);
				}
			}
		}
		
		void ReloadedWeapon() 
		{
		
		}
		
		void AddToScene() 
		{
			Matrix4 mat = CreateScaleMatrix(0.03125f);
			mat = mat * CreateScaleMatrix(-1.f, -1.f, 1.f);
			//0 17 4
			mat = CreateTranslateMatrix(0.35f, -0.3f, -0.125f) * mat;
			
			ModelRenderParam param;
			param.matrix = originMatrix * mat;
			renderer.AddModel(model, param);
			
			if (readyState < 0.1f)
			{
				renderer.Color = Vector4(1.f, 1.f, 1.f, 0.5f); // premultiplied alpha
				renderer.AddSprite(flashImage, param.matrix*Vector3(0, 60, 0), 0.4f+readyState/2, 0);
			}
		}
	}
	
	IWeaponSkin@ CreateThirdPersonRifleSkinB(Renderer@ r, AudioDevice@ dev) {
		return ThirdPersonRifleSkinB(r, dev);
	}
}
