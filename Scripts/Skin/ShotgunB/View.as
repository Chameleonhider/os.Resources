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
	class ViewShotgunSkinB: 
	IToolSkin, IViewToolSkin, IWeaponSkin,
	BasicViewWeapon
	{
		private AudioDevice@ audioDevice;
		private Model@ gunModel;
		private Model@ gunModel2;
		private Model@ pumpModel;
		private Model@ sightModelF;
		private AudioChunk@ fireSound;
		private AudioChunk@ reloadSound;
		private AudioChunk@ pumpSound;
		
		private Image@ reflexImage1;
		private Image@ reflexImage2;
		
		ViewShotgunSkinB(Renderer@ r, AudioDevice@ dev){
			super(r);
			@audioDevice = dev;
			@gunModel = renderer.RegisterModel
				("Models/Weapons/ShotgunB/Weapon1stMain.kv6");	
			@gunModel2 = renderer.RegisterModel
				("Models/Weapons/ShotgunB/Weapon1stSecond.kv6");
			@pumpModel = renderer.RegisterModel
				("Models/Weapons/ShotgunB/Weapon1stPump.kv6");
			@sightModelF = renderer.RegisterModel
				("Models/Weapons/ShotgunB/SightFront.kv6");
			@fireSound = dev.RegisterSound
				("Sounds/Weapons/ShotgunB/Fire0.wav");
			@reloadSound = dev.RegisterSound
				("Sounds/Weapons/ShotgunB/Reload.wav");
			@pumpSound = dev.RegisterSound
				("Sounds/Weapons/ShotgunB/Pump.wav");
				
			@reflexImage1 = renderer.RegisterImage("Gfx/Weapons/ReflexSight.png");
			@reflexImage2 = renderer.RegisterImage("Gfx/Weapons/ReflexMirror.png");
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
				param.pitch += (GetRandom()-GetRandom())*0.1f;
				audioDevice.PlayLocal(fireSound, origin, param);
			}
		}
		
		void ReloadingWeapon()
		{
			if(!IsMuted)
			{
				Vector3 origin = Vector3(0.4f, -0.3f, 0.5f);
				AudioParam param;
				param.volume = 1.f;
				param.pitch += (GetRandom()-GetRandom())*0.1f;
				audioDevice.PlayLocal(reloadSound, origin, param);
			}
			if (Ammo < ClipSize)
				bHideWeap = true;
			else
				bHideWeap = false;
		}
		
		void ReloadedWeapon()
		{
			if(!IsMuted)
			{
				Vector3 origin = Vector3(0.4f, -0.3f, 0.5f);
				AudioParam param;
				param.volume = 1.f;
				audioDevice.PlayLocal(pumpSound, origin, param);
			}
			bHideWeap = false;
		}
		float GetZPos() 
		{
			return 0.2f - AimDownSightStateSmooth * 0.175f * 1.007; // * debug_d; //0.05*3.5=0.175
			//return 0.2f - AimDownSightStateSmooth * 0.0535f;
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
			if(AimDownSightState < 0.5 && draw2d)
				BasicViewWeapon::Draw2D();
		}
		
		void SetAlpha()
		{
			float alpha = 1.f;
			if (swing.x > 0.07f)
				alpha *= 8 - swing.x*100; 
			if (swing.x < -0.07f)
				alpha *= 8 + swing.x*100; 
			if (swing.z > 0.07f)
				alpha *= 8 - swing.z*100; 
			if (swing.z < -0.07f)
				alpha *= 8 + swing.z*100;
				
			alpha = alpha - 0.2f;	
				
			if (alpha < 0)
				alpha = 0;
			if (alpha > 1)
				alpha = 1;
		
			renderer.Color = Vector4(9*alpha, 7*alpha, 5*alpha, alpha);
		}
		
		void AddToScene()
		{
			//BasicViewWeapon::DrawXH();
			float move = 0;
			Matrix4 mat = CreateScaleMatrix(0.015625f);
			mat = GetViewWeaponMatrix() * mat;
			
			bool reloading = IsReloading;
			float reload = ReloadProgress;
			Vector3 leftHand, rightHand;
			
			//leftHand = mat * Vector3(0.f, 4.f, 2.f);
			//rightHand = mat * Vector3(0.f, -8.f, 2.f);
			leftHand = Vector3(0.f, 0.f, 0.f);
			rightHand = Vector3(0.f, 0.f, 0.f);
			
			Vector3 leftHand2 = mat * Vector3(5.f, -10.f, 4.f);
			Vector3 leftHand3 = mat * Vector3(1.f, 1.f, 2.f);
			
			if(AimDownSightStateSmooth > 0.01f)
			{
				//mat = AdjustToAlignSight(mat, Vector3(0.f, 8.5f, -4.4f), AimDownSightStateSmooth);
				mat = AdjustToAlignSight(mat, Vector3(0.f, -100.f, -1.472f), (AimDownSightStateSmooth));
			}
			
			ModelRenderParam param;
			Matrix4 weapMatrix = eyeMatrix * mat;
			weapMatrix *= CreateTranslateMatrix(Swing.x*-20*AimDownSightStateSmooth, 0.f, Swing.z*-20*AimDownSightStateSmooth); //Swing.z*40*AimDownSightStateSmooth);
			
			//Chameleon: reflex sight
			if (ScopeZoom != 0)
			{
				renderer.Color = Vector4(1.01f, 1.01f, 1.01f, 0.5f);
				
				weapMatrix *= CreateTranslateMatrix(0, 0, (2-Swing.z)*AimDownSightStateSmooth);
				weapMatrix *= CreateRotateMatrix(Vector3(0, 0, -1), Swing.x*AimDownSightStateSmooth);
				weapMatrix *= CreateRotateMatrix(Vector3(-1, 0, 0), Swing.z*AimDownSightStateSmooth);
				
				//Parallax adjustment
				float Length = Vector3(Swing.x, 0, Swing.z).Length;
				Matrix4 mat2 = GetViewWeaponMatrix() * CreateScaleMatrix(0.015625f);	
				mat2 = mat2 * CreateTranslateMatrix(0, 0, -1);
				int coef = 1;						
				if(Length > 0.0001f)
				{
					if(Swing.z >= 0)
						coef *= -1;
					else					
						coef *= 1;					
					
					float ang = asin(Swing.x/Length);
					mat2 *= CreateRotateMatrix(Vector3(0.f, coef, 0.f), ang);					
				}
				if(AimDownSightStateSmooth > 0.01f)
					mat2 = AdjustToAlignSight(mat2, Vector3(0, 50, 0), AimDownSightStateSmooth);
				//End of parallax adjustment
				
				if (!opengl)
				{
					Vector3 posM = (eyeMatrix * mat2 * CreateTranslateMatrix(0, 40, -4)).GetOrigin();
					renderer.AddSprite(reflexImage2, posM, 0.15f, 3.14159265f);
				
					if (AimDownSightState > 0.8f)
					{		
						SetAlpha();
					
						posM = (eyeMatrix * mat2 * CreateTranslateMatrix(0, 40, Length*40*coef)).GetOrigin();
						renderer.AddSprite(reflexImage1, posM, 0.1f, 3.14159265f);
					}
				}
				else //OPENGL
				{
					Vector3 posM = (weapMatrix * CreateTranslateMatrix(0, 50, -4)).GetOrigin();
					renderer.AddSprite(reflexImage2, posM, 0.3f, 3.14159265f);
				
					if (AimDownSightState > 0.8f)
					{
						SetAlpha();
					
						posM = (eyeMatrix * mat2 * CreateTranslateMatrix(0, 50, Length*50*coef)).GetOrigin();
						renderer.AddSprite(reflexImage1, posM, 0.2f, 3.14159265f);
					}
				}
				weapMatrix *= CreateRotateMatrix(Vector3(1.f, 0.f, 0.f), 0.05f*AimDownSightStateSmooth);
			}
			
			if (readyState < 0.07f)
				BasicViewWeapon::DrawFlash(weapMatrix * Vector3(0, 100, 2));
			
			param.matrix = weapMatrix;
			renderer.AddModel(gunModel, param);
			renderer.AddModel(gunModel2, param);
			param.matrix *=	CreateTranslateMatrix(0.f, move, 0.f);
			renderer.AddModel(pumpModel, param);
			
			param.matrix = weapMatrix;
			param.matrix *= CreateTranslateMatrix(0.f, 95.75f, 0.f);
			param.matrix *= CreateScaleMatrix(0.5f);
			renderer.AddModel(sightModelF, param); // front
			
			LeftHandPosition = leftHand;
			RightHandPosition = rightHand;
		}
	}
	
	IWeaponSkin@ CreateViewShotgunSkinB(Renderer@ r, AudioDevice@ dev) {
		return ViewShotgunSkinB(r, dev);
	}
}
