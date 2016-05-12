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
	class ViewRifleSkinB:
	IToolSkin, IViewToolSkin, IWeaponSkin,
	BasicViewWeapon
	{
		private bool opengl = ConfigItem("r_renderer", "gl").StringValue == "gl";
		private int snd_maxDistance = ConfigItem("snd_maxDistance", "150").IntValue;
		private AudioDevice@ audioDevice;
		
		private Model@ gunModel;
		private Model@ moveModel;
		private Model@ sightModelR;
		private Model@ sightModelF;
		private Model@ scopeModel;
		
		private AudioChunk@ fireSound;
		private AudioChunk@ fireLastSound;
		private AudioChunk@ reloadFullSound;
		private AudioChunk@ reloadEmptySound;
		
		private Image@ scopeImage1;
		private Image@ scopeImage2;
		
		ViewRifleSkinB(Renderer@ r, AudioDevice@ dev){
			super(r);
			@audioDevice = dev;
			@gunModel = renderer.RegisterModel
				("Models/Weapons/RifleB/Weapon1st.kv6");
			@moveModel = renderer.RegisterModel
				("Models/Weapons/RifleB/Weapon1stMove.kv6");
			@sightModelR = renderer.RegisterModel
				("Models/Weapons/RifleB/SightRear.kv6");
			@sightModelF = renderer.RegisterModel
				("Models/Weapons/RifleB/SightFront.kv6");
			@scopeModel = renderer.RegisterModel
				("Models/Weapons/RifleB/Scope.kv6");
			
			@fireSound = dev.RegisterSound
				("Sounds/Weapons/RifleB/Fire0.wav");
			@fireLastSound = dev.RegisterSound
				("Sounds/Weapons/RifleB/Fire0Last.wav");
			@reloadFullSound = dev.RegisterSound
				("Sounds/Weapons/RifleB/ReloadFull.wav");
			@reloadEmptySound = dev.RegisterSound
				("Sounds/Weapons/RifleB/ReloadEmpty.wav");
				
			@scopeImage1 = renderer.RegisterImage("Gfx/Weapons/CrosshairA.png");
			@scopeImage2 = renderer.RegisterImage("Gfx/Weapons/ScopeBlur.png");
		}
		
		void Update(float dt)
		{
			BasicViewWeapon::Update(dt);
		}
		
		void WeaponFired()
		{
			BasicViewWeapon::WeaponFired();
			
			if(!IsMuted)
			{
				Vector3 origin = Vector3(0.4f, -0.3f, 0.5f);
				AudioParam param;
				param.volume = 5.f;
				if (ammo > 1)
					audioDevice.PlayLocal(fireSound, origin, param);
				else
					audioDevice.PlayLocal(fireLastSound, origin, param);
			}
		}
		
		void ReloadingWeapon() 
		{
			if(!IsMuted)
			{
				Vector3 origin = Vector3(0.4f, -0.3f, 0.5f);
				AudioParam param;
				param.volume = 1.f;
				if (ammo > 0)
					audioDevice.PlayLocal(reloadFullSound, origin, param);
				else
					audioDevice.PlayLocal(reloadEmptySound, origin, param);
			}
		}
		
		float GetZPos() 
		{
			return 0.2f - AimDownSightStateSmooth * 0.175f * 1.0075; // * debug_d; //0.05*3.5=0.175
			//return 0.2f - AimDownSightStateSmooth * 0.0520f;
		}
		
		// rotates gun matrix to ensure the sight is in
		// the center of screen (0, ?, 0).
		Matrix4 AdjustToAlignSight(Matrix4 mat, Vector3 sightPos, float fade) 
		{
			Vector3 p = mat * sightPos;
			mat = CreateRotateMatrix(Vector3(0.f, 0.f, 1.f), atan(p.x / p.y) * fade) * mat;
			mat = CreateRotateMatrix(Vector3(-1.f, 0.f, 0.f), atan(p.z / p.y) * fade) * mat;
			return mat;
		}
		
		void Draw2D()
		{
			//if(AimDownSightState > 0.25)
				//return;
			//BasicViewWeapon::Draw2D();
		}
		
		void AddToScene() 
		{
			//if (ScopeZoom != -1)
				//BasicViewWeapon::DrawXH();			
				
			float move = 0;					
			Matrix4 mat = CreateScaleMatrix(0.015625f);
			mat = GetViewWeaponMatrix() * mat;
			
			bool reloading = IsReloading;
			float reload = ReloadProgress;
			Vector3 leftHand, rightHand;
			
			leftHand = Vector3(0.f, 0.f, 0.f);
			rightHand = Vector3(0.f, 0.f, 0.f);
			
			Vector3 leftHand2 = mat * Vector3(5.f, -10.f, 4.f);
			Vector3 rightHand3 = mat * Vector3(-2.f, -7.f, -4.f);
			Vector3 rightHand4 = mat * Vector3(-3.f, -4.f, -6.f);
			
			if(AimDownSightStateSmooth > 0.f)
			{
				mat = AdjustToAlignSight(mat, Vector3(0.f, 75.f, -1.472f), AimDownSightStateSmooth);
			}
			
			ModelRenderParam param;
			Matrix4 weapMatrix = eyeMatrix * mat;
			
			//Chameleon: scope
			if (ScopeZoom != 0 && ScopeZoom != -1 && AimDownSightState > 0.5f)
			{
				if (!opengl)
				{
					Matrix4 mat2 = GetViewWeaponMatrix() * CreateScaleMatrix(0.015625f);		
										
					// "front" sprite					
					if(AimDownSightStateSmooth > 0.f)
						mat2 = AdjustToAlignSight(mat2, Vector3(0.f, 50, -1.472f), (AimDownSightStateSmooth));
						
					Vector3 posM = (eyeMatrix * mat2 * CreateTranslateMatrix(0.f, 75, -1.5f)).GetOrigin();
					renderer.AddSprite(scopeImage2, posM, 0.2f, 3.14159265f);
					
					// "middle" sprite
					if(AimDownSightStateSmooth > 0.f)
						mat2 = AdjustToAlignSight(mat2, Vector3(0.f, 75, -1.472f), (AimDownSightStateSmooth));	
					
					posM = (eyeMatrix * mat2 * CreateTranslateMatrix(0.f, 75, -1.5f)).GetOrigin();
					renderer.AddSprite(scopeImage1, posM, 0.2f, 3.14159265f);
					
					// "rear" sprite					
					if(AimDownSightStateSmooth > 0.f)
						mat2 = AdjustToAlignSight(mat2, Vector3(0.f, 150, -1.472f), (AimDownSightStateSmooth));
						
					posM = (eyeMatrix * mat2 * CreateTranslateMatrix(0.f, 75, -1.5f)).GetOrigin();
					renderer.AddSprite(scopeImage2, posM, 0.2f, 3.14159265f);		
				}
				else //OPENGL
				{
					Matrix4 mat2 = GetViewWeaponMatrix() * CreateScaleMatrix(0.015625f);		
										
					// "front" sprite					
					if(AimDownSightStateSmooth > 0.f)
						mat2 = AdjustToAlignSight(mat2, Vector3(0.f, 50, -1.472f), (AimDownSightStateSmooth));
						
					Vector3 posM = (eyeMatrix * mat2 * CreateTranslateMatrix(0.f, 75, -1.5f)).GetOrigin();
					renderer.AddSprite(scopeImage2, posM, 0.4f, 3.14159265f);
					
					// "middle" sprite
					if(AimDownSightStateSmooth > 0.f)
						mat2 = AdjustToAlignSight(mat2, Vector3(0.f, 75, -1.472f), (AimDownSightStateSmooth));	
					
					posM = (eyeMatrix * mat2 * CreateTranslateMatrix(0.f, 75, -1.5f)).GetOrigin();
					renderer.AddSprite(scopeImage1, posM, 0.4f, 3.14159265f);
					
					// "rear" sprite					
					if(AimDownSightStateSmooth > 0.f)
						mat2 = AdjustToAlignSight(mat2, Vector3(0.f, 150, -1.472f), (AimDownSightStateSmooth));
						
					posM = (eyeMatrix * mat2 * CreateTranslateMatrix(0.f, 75, -1.5f)).GetOrigin();
					renderer.AddSprite(scopeImage2, posM, 0.4f, 3.14159265f);
				}
				weapMatrix *= CreateTranslateMatrix(0.f, -30.f*AimDownSightStateSmooth, 3.f*AimDownSightStateSmooth);
				weapMatrix *= CreateRotateMatrix(Vector3(1.f, 0.f, 0.f), 0.1f*AimDownSightStateSmooth);
				weapMatrix *= CreateScaleMatrix(Vector3(2.f, 2.f, 2.f)*AimDownSightStateSmooth);
			}
			
			if (readyState < 0.15f)
				move = readyState/0.15f;
			else if (readyState < 0.65f)
				move = 1 - (readyState-0.15f)/0.5f;
			
			// draw solid scope
			param.matrix = weapMatrix;
			if ((ScopeZoom != 0 && AimDownSightState < 0.5f) || ScopeZoom == -1)
				renderer.AddModel(scopeModel, param);
			
			// draw weapon
			param.matrix = weapMatrix;
			renderer.AddModel(gunModel, param);
			param.matrix *=	CreateTranslateMatrix(0.f, -10*move, 0.f);
			renderer.AddModel(moveModel, param);
			
			// draw sights			
			param.matrix = weapMatrix;
			param.matrix *= CreateTranslateMatrix(0.f, 35.75f, 0.f);
			param.matrix *= CreateScaleMatrix(0.25f);
			renderer.AddModel(sightModelR, param); // rear
			
			param.matrix = weapMatrix;
			param.matrix *= CreateTranslateMatrix(0.f, 106.75f, 0.f);
			param.matrix *= CreateScaleMatrix(0.5f);
			if (ScopeZoom == 0 || ScopeZoom == -1 || AimDownSightState < 0.5f)
				renderer.AddModel(sightModelF, param); // front
			
			LeftHandPosition = leftHand;
			RightHandPosition = rightHand;
		}
	}
	
	IWeaponSkin@ CreateViewRifleSkinB(Renderer@ r, AudioDevice@ dev) {
		return ViewRifleSkinB(r, dev);
	}
}
