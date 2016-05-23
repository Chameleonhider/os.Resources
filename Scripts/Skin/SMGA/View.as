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
	class ViewSMGSkinA: 
	IToolSkin, IViewToolSkin, IWeaponSkin,
	BasicViewWeapon
	{
		private AudioDevice@ audioDevice;
		private Model@ gunModel;
		private Model@ moveModel;
		private Model@ magModel;
		private Model@ sightModelR;
		private Model@ sightModelF;
		
		private AudioChunk@ fireSound;
		private AudioChunk@ reloadSound;
		
		ViewSMGSkinA(Renderer@ r, AudioDevice@ dev)
		{
			super(r);
			@audioDevice = dev;
			@gunModel = renderer.RegisterModel
				("Models/Weapons/SMGA/Weapon1st.kv6");
			@moveModel = renderer.RegisterModel
				("Models/Weapons/SMGA/Weapon1stMove.kv6");
			@magModel = renderer.RegisterModel
				("Models/Weapons/SMGA/Magazine.kv6");
			@sightModelR = renderer.RegisterModel
				("Models/Weapons/SMGA/SightRear.kv6");
			@sightModelF = renderer.RegisterModel
				("Models/Weapons/SMGA/SightFront.kv6");
				
			@fireSound = dev.RegisterSound
				("Sounds/Weapons/SMGA/Fire0.wav");
			@reloadSound = dev.RegisterSound
				("Sounds/Weapons/SMGA/Reload.wav");
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
				audioDevice.PlayLocal(reloadSound, origin, param);
			}
		}
		
		float GetZPos()
		{
			//return 0.2f - AimDownSightStateSmooth * 0.038f;
			return 0.2f - AimDownSightStateSmooth * 0.175f * 1.006; // * debug_d; //0.05*3.5=0.175
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
			//BasicViewWeapon::Draw2D();
		}
		
		void AddToScene() 
		{
			//BasicViewWeapon::DrawXH();
			float move = 0;		
			if (readyState < 0.2f)
				move = 1;
			else if (readyState < 1.f)
				move = 1 - (readyState-0.2f)/0.8f;		
				
			Matrix4 mat = CreateScaleMatrix(0.015625f);
			mat = GetViewWeaponMatrix() * mat;
			
			bool reloading = IsReloading;
			float reload = ReloadProgress;
			Vector3 leftHand, rightHand;
			
			// leftHand = mat * Vector3(1.f, 6.f, 1.f);
			// rightHand = mat * Vector3(0.f, -8.f, 2.f);
			leftHand = Vector3(0.f, 0.f, 0.f);
			rightHand = Vector3(0.f, 0.f, 0.f);
			
			Vector3 leftHand2 = mat * Vector3(5.f, -10.f, 4.f);
			Vector3 leftHand3 = mat * Vector3(1.f, 6.f, -4.f);
			Vector3 leftHand4 = mat * Vector3(1.f, 9.f, -6.f);
			
			if(AimDownSightStateSmooth > 0.f)
			{
				//mat = AdjustToAlignSight(mat, Vector3(0.f, debug_b.FloatValue, debug_c.FloatValue), (AimDownSightStateSmooth - 0.5f) / 0.5f);
				mat = AdjustToAlignSight(mat, Vector3(0.f, 50.f, -1.472f), (AimDownSightStateSmooth));	
			}
			
			ModelRenderParam param;
			Matrix4 weapMatrix = eyeMatrix * mat;
			//weapMatrix *= CreateTranslateMatrix(debug_a, debug_b, debug_c);
			
			if (readyState < 0.3f)
				BasicViewWeapon::DrawFlash(weapMatrix * Vector3(0, 90, 4));
			
			// draw weapon
			param.matrix = weapMatrix;			
			renderer.AddModel(gunModel, param);
			param.matrix *=	CreateTranslateMatrix(0.f, -14*move, 0.f);
			renderer.AddModel(moveModel, param);
			
			// draw sights
			param.matrix = weapMatrix;
			param.matrix *= CreateTranslateMatrix(0.f, 39.75f, 0.f);
			param.matrix *= CreateScaleMatrix(0.5f);
			renderer.AddModel(sightModelR, param); // rear
			
			param.matrix = weapMatrix;
			param.matrix *= CreateTranslateMatrix(0.f, 77.75f, 0.f);
			param.matrix *= CreateScaleMatrix(0.5f);
			renderer.AddModel(sightModelF, param); // front

			param.matrix = weapMatrix;
			renderer.AddModel(magModel, param);
			
			leftHand = Vector3(0.f, 0.f, 0.f);
			rightHand = Vector3(0.f, 0.f, 0.f);
			
			LeftHandPosition = leftHand;
			RightHandPosition = rightHand;
		}
		
	}
	
	IWeaponSkin@ CreateViewSMGSkinA(Renderer@ r, AudioDevice@ dev) {
		return ViewSMGSkinA(r, dev);
	}
}
