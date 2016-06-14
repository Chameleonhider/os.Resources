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
 
namespace spades {
	class BasicViewWeapon: 
	IToolSkin, IViewToolSkin, IWeaponSkin {
		
		private int snd_maxDistance = ConfigItem("snd_maxDistance", "150").IntValue;
		private int defFireVib = ConfigItem("v_defaultFireVibration", "0").IntValue;
		private bool opt_muzzleFlash = ConfigItem("opt_muzzleFlash", "1").IntValue != 0;
		private bool opengl = ConfigItem("r_renderer", "gl").StringValue == "gl";
		private bool draw2d = ConfigItem("v_freeAim", "1").FloatValue == 0.f;
		
		// IToolSkin
		private float sprintState;
		private float raiseState;
		private IntVector3 teamColor;
		private bool muted;
		//Chameleon
		private float clientDistance;
		private float soundDistance;
		
		float SprintState { 
			set { sprintState = value; }
			get { return sprintState; }
		}
		
		float RaiseState { 
			set { raiseState = value; }
			get { return raiseState; }
		}
		
		IntVector3 TeamColor { 
			set { teamColor = value; }
			get { return teamColor; } 
		}
		
		float ClientDistance { 
			set { clientDistance = value; }
			get { return clientDistance; } 
		}
		
		float SoundDistance 
		{ 
			set { soundDistance = value; }
			get { return soundDistance; } 
		}
		
		bool IsMuted {
			set { muted = value; }
			get { return muted; }
		}
		
		
		
		// IWeaponSkin
		private float aimDownSightState;
		private float aimDownSightStateSmooth;
		private float readyState;
		private bool reloading;
		private float reloadProgress;
		private int ammo, clipSize;
		private float localFireVibration;
		
		float AimDownSightState 
		{
			set 
			{ 
				aimDownSightState = value;
				aimDownSightStateSmooth = SmoothStep(value);
			}
			get 
			{
				return aimDownSightState;
			}
		}
		
		float AimDownSightStateSmooth 
		{
			get { return aimDownSightStateSmooth; }
		}
		
		bool IsReloading
		{
			get { return reloading; }
			set { reloading = value; }
		}
		float ReloadProgress
		{
			get { return reloadProgress; }
			set { reloadProgress = value; }
		}
		int Ammo 
		{
			set { ammo = value; }
			get { return ammo; }
		}
		int ClipSize
		{
			set { clipSize = value; }
			get { return clipSize; }
		}
		
		float ReadyState
		{
			set { readyState = value; }
			get { return readyState; }
		}
		
		// IViewToolSkin
		//Chameleon
		private int scopeZoom;
		private Matrix4 eyeMatrix;
		private Vector3 swing;
		private Vector3 leftHand;
		private Vector3 rightHand;
		
		int ScopeZoom
		{
			set { scopeZoom = value; }
			get { return scopeZoom; }
		}
		
		Matrix4 EyeMatrix 
		{
			set { eyeMatrix = value; }
			get { return eyeMatrix; }
		}
		
		Vector3 Swing 
		{
			set { swing = value; }
			get { return swing; }
		}	
		
		Vector3 LeftHandPosition
		{
			get {
				return leftHand;
			}
			set {
				leftHand = value;
			}
		}
		Vector3 RightHandPosition 
		{ 
			get  {
				return rightHand;
			}
			set {
				rightHand = value;
			}
		}
		
		private Renderer@ renderer;
		private Image@ sightImage;
		private Image@ flashImage;
		private bool bHideWeap;
		
		BasicViewWeapon(Renderer@ renderer)
		{
			@this.renderer = renderer;
			localFireVibration = 0.f;
			@sightImage = renderer.RegisterImage("Gfx/Sight.tga");
			@flashImage = renderer.RegisterImage("Gfx/WhiteSmoke32.tga");
			bHideWeap = false;
		}
		
		float GetLocalFireVibration() 
		{
			if (defFireVib == 0) return localFireVibration/2;
				return localFireVibration; 
		}
		
		float GetMotionGain() 
		{
			return 1.f - AimDownSightStateSmooth * 0.2f;
		}
		
		float GetZPos()
		{
			return 0.2f - AimDownSightStateSmooth * 0.05f;
		}
		
		Vector3 GetLocalFireVibrationOffset()
		{
			if (defFireVib == 0) return Vector3(0,-0.1f,0)*GetLocalFireVibration();
			
			float vib = GetLocalFireVibration();
			float motion = GetMotionGain();
			Vector3 hip = Vector3(
				sin(vib * PiF * 2.f) * 0.008f * motion,
				vib * (vib - 1.f) * 0.14f * motion,
				vib * (1.f - vib) * 0.03f * motion);
			Vector3 ads = Vector3(0.f, vib * (vib - 1.f) * vib * 0.3f * motion, 0.f);
			return Mix(hip, ads, AimDownSightStateSmooth);
		}
		
		Matrix4 GetViewWeaponMatrix()
		{
			if (scopeZoom > 1 && AimDownSightState > 0.f)
			{
				if (swing.x > 0.01f)
					swing.x = 0.01f;
				if (swing.z > 0.01f)
					swing.z = 0.01f;
				if (swing.x < -0.01f)
					swing.x = -0.01f;
				if (swing.z < -0.01f)
					swing.z = -0.01f;
			}
			else if (AimDownSightState > 0.f)
			{
				swing.x *= -1;
				swing.z *= -1;
			}
		
			Matrix4 mat;
			if(sprintState > 0.f)
			{
				mat = CreateRotateMatrix(Vector3(0.f, 0.f, 1.f),
					sprintState * -1.3f) * mat;
				mat = CreateRotateMatrix(Vector3(0.f, 1.f, 0.f),
					sprintState * 0.2f) * mat;
				mat = CreateTranslateMatrix(Vector3(0.2f, -0.2f, 0.05f)
					* sprintState)  * mat;
			}
			
			if(raiseState < 1.f) 
			{
				float putdown = 1.f - raiseState;
				mat = CreateRotateMatrix(Vector3(0.f, 0.f, 1.f),
					putdown * -1.3f) * mat;
				mat = CreateRotateMatrix(Vector3(0.f, 1.f, 0.f),
					putdown * 0.2f) * mat;
				mat = CreateTranslateMatrix(Vector3(0.1f, -0.3f, 0.1f)
					* putdown)  * mat;
			}
			
			if(reloading) 
			{
				if (reloadProgress < 0.15f && !bHideWeap)
				{
					float per = reloadProgress/0.15f;
					per *= per;
					mat = CreateTranslateMatrix(0.f, 0.f, per) * mat;		
					mat = CreateRotateMatrix(Vector3(1.f, 0.f, -0.5f), per*0.8f) * mat;					
				}
				else if (reloadProgress < 0.75f || bHideWeap)
				{
					mat = CreateTranslateMatrix(0.f, 0.f, 1.f) * mat;		
					mat = CreateRotateMatrix(Vector3(1.f, 0.f, -0.5f), 0.8f) * mat;
				}
				else if (reloadProgress < 1.f)
				{
					float per = (0.75f-reloadProgress)/0.25f;
					per *= per * -1;
					mat = CreateTranslateMatrix(0.f, 0.f, per+1.f) * mat;		
					mat = CreateRotateMatrix(Vector3(1.f, 0.f, -0.5f), per*0.8f+0.8f) * mat;		
				}
			}
			
			Vector3 trans(0.f, 0.f, 0.f);
			trans += Vector3(-0.125f * (1.f - AimDownSightStateSmooth),
							 0.5f, GetZPos());
			trans += swing * GetMotionGain();
			//if (scopeZoom != -1) 
				//trans += swing * GetMotionGain() * AimDownSightStateSmooth * scopeZoom/2;
			trans += GetLocalFireVibrationOffset();
			mat = CreateTranslateMatrix(trans) * mat;
			
			mat = CreateTranslateMatrix(Vector3(0.f, -0.3f*(1-sprintState), 0.f)) * mat;			
			if (AimDownSightStateSmooth > 0.f)
				mat = CreateTranslateMatrix(Vector3(0.f, -0.3f*AimDownSightStateSmooth, 0.f)) * mat;
			
			return mat;
		}
		
		void Update(float dt)
		{
			if (localFireVibration > 0)
			{
				localFireVibration -= dt * 5.f;
				if(localFireVibration < 0.f) localFireVibration = 0.f;
			}
		}
		
		void WeaponFired()
		{
			localFireVibration = 1.f;
		}
		
		void AddToScene() 
		{
		
		}
		
		void ReloadingWeapon()
		{
		
		}
		
		void ReloadedWeapon()
		{
		
		}
		
		void Draw2D() 
		{
			renderer.ColorNP = (Vector4(1.f, 1.f, 1.f, 0.5f));
			renderer.DrawImage(sightImage,
				Vector2((renderer.ScreenWidth - sightImage.Width) * 0.5f,
						(renderer.ScreenHeight - sightImage.Height) * 0.5f));
		}
		void DrawFlash(Vector3 vec3) 
		{		
			if (opt_muzzleFlash)
			{
				renderer.Color = Vector4(1.02f, 1.02f, 1.01f, 0.75f-readyState); // premultiplied alpha
				renderer.AddSprite(flashImage, vec3, 0.4f+readyState/2, GetRandom());
			}
		}
		void DrawXH() 
		{			
			Vector3 xhPos = eyeMatrix * CreateTranslateMatrix(0.f, 10.f, 0.f) * Vector3(0.f, 1.f, 0.f);
			renderer.Color = Vector4(1.f, 1.f, 1.f, readyState); // premultiplied alpha
			renderer.AddSprite(sightImage, xhPos, 1.f, 0.f);
		}
	}
	
}
