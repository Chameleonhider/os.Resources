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

//SPADES_SETTING(r_renderer, "gl");
 
namespace spades
{
	class ViewRifleSkinA:
	IToolSkin, IViewToolSkin, IWeaponSkin,
	BasicViewWeapon
	{
		private bool opengl = ConfigItem("r_renderer", "gl").StringValue == "gl";
		private int snd_maxDistance = ConfigItem("snd_maxDistance", "150").IntValue;
		private AudioDevice@ audioDevice;
		
		private Model@ gunModel;
		private Model@ moveModel;
		private Model@ magModel;
		private Model@ sightModelR;
		private Model@ sightModelF;
		
		private Model@ scopeModel1;
		private Model@ scopeModel2;
		
		private AudioChunk@ fireSound;
		private AudioChunk@ reloadSound;
		
		private Image@ scopeImage1;
		private Image@ scopeImage2;
		
		ViewRifleSkinA(Renderer@ r, AudioDevice@ dev)
		{
			super(r);
			@audioDevice = dev;
			@gunModel = renderer.RegisterModel
				("Models/Weapons/RifleA/Weapon1st.kv6");
			@moveModel = renderer.RegisterModel
				("Models/Weapons/RifleA/Weapon1stMove.kv6");
			@magModel = renderer.RegisterModel
				("Models/Weapons/RifleA/Magazine.kv6");
			@sightModelR = renderer.RegisterModel
				("Models/Weapons/RifleA/SightRear.kv6");
			@sightModelF = renderer.RegisterModel
				("Models/Weapons/RifleA/SightFront.kv6");
				
			@scopeModel1 = renderer.RegisterModel
				("Models/Weapons/RifleA/ScopeStart.kv6");
			@scopeModel2 = renderer.RegisterModel
				("Models/Weapons/RifleA/ScopeTube.kv6");
				
			@fireSound = dev.RegisterSound
				("Sounds/Weapons/RifleA/Fire0.wav");
			@reloadSound = dev.RegisterSound
				("Sounds/Weapons/RifleA/Reload.wav");
				
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
			return 0.2f - AimDownSightStateSmooth * 0.175f * 1.0075f; // * debug_d; //0.05*3.5=0.175
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
			//if (ScopeZoom != -1)
				//BasicViewWeapon::DrawXH();
				
			float move = 0;			
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
			Vector3 rightHand3 = mat * Vector3(-2.f, -7.f, -4.f);
			Vector3 rightHand4 = mat * Vector3(-3.f, -4.f, -6.f);
			
			if(AimDownSightStateSmooth > 0.f)
			{
				//mat = AdjustToAlignSight(mat, Vector3(0.f, 16.f*debug_e, -4.6f*debug_f), (AimDownSightStateSmooth - 0.8f) / 0.2f);
				mat = AdjustToAlignSight(mat, Vector3(0.f, 75.f, -1.472f), (AimDownSightStateSmooth));
				//-4.6*0.25=-1.15
			}
			
			ModelRenderParam param;
			Matrix4 weapMatrix = eyeMatrix * mat;
			
			// if (ConfigItem("d_x", "0").IntValue == 1)
			// {
				// ConfigItem("d_x", "0").IntValue = 0;
				// ConfigItem("d_y", "0").StringValue = "Eye: " + eyeMatrix.GetOrigin().x + "; " + eyeMatrix.GetOrigin().y + "; " + eyeMatrix.GetOrigin().z;
				// ConfigItem("d_z", "0").StringValue = "Weap: " + weapMatrix.GetOrigin().x + "; " + weapMatrix.GetOrigin().y + "; " + weapMatrix.GetOrigin().z;
			// }
			
			//Chameleon: scope
			if (ScopeZoom != -1)
			{
				if (!opengl)
				{
					int spriteNum = 10;
					int dDist = 10;
					int distM = 75;
					int dist = 50;
					float rSize = 0.2f;				
					
					Vector3 pos = Vector3(0, 0, 0);
					Vector3 posM = (weapMatrix * CreateTranslateMatrix(0.f, distM, -1.5f)).GetOrigin();
					
					float eyeToSightM = (eyeMatrix.GetOrigin() - posM).Length;
					
					renderer.AddSprite(scopeImage1, posM, rSize, 3.14159265f);
					
					for (int i = 0; i < spriteNum; i++)
					{
						pos = (weapMatrix * CreateTranslateMatrix(0.f, dist+dDist*i, -1.5f)).GetOrigin();
						//pos = eyeMatrix.GetOrigin() - pos;
						
						float eyeToSight = (eyeMatrix.GetOrigin() - pos).Length;
						
						renderer.AddSprite(scopeImage2, pos, rSize*eyeToSight/eyeToSightM*1.1f, 3.14159265f);
					}
				}
				else if (!opengl)
				{
					// float distF = ConfigItem("d_b", "0").FloatValue + ConfigItem("d_d", "0").FloatValue;	//ditance far
					// float distM = ConfigItem("d_b", "0").FloatValue;										//distance middle
					// float distC = ConfigItem("d_b", "0").FloatValue - ConfigItem("d_d", "0").FloatValue;	//distance close
					float distF = 100 + 50;	//ditance far
					float distM = 100;										//distance middle
					float distC = 100 - 50;	//distance close
					
					Vector3 posF = (weapMatrix * CreateTranslateMatrix(0.f, distF, -1.5f)).GetOrigin();
					Vector3 posM = (weapMatrix * CreateTranslateMatrix(0.f, distM, -1.5f)).GetOrigin();
					Vector3 posC = (weapMatrix * CreateTranslateMatrix(0.f, distC, -1.5f)).GetOrigin();
					
					// Vector3 eyeToSightF = posF - eyeMatrix.GetOrigin();
					// Vector3 eyeToSightM = posM - eyeMatrix.GetOrigin();				
					// Vector3 eyeToSightC = posC - eyeMatrix.GetOrigin();
					
					Vector3 eyeToSightF = eyeMatrix.GetOrigin() - posF;
					Vector3 eyeToSightM = eyeMatrix.GetOrigin() - posM;				
					Vector3 eyeToSightC = eyeMatrix.GetOrigin() - posC;
					
					// if (ConfigItem("d_x", "0").IntValue == 2)
					// {
						// ConfigItem("d_x", "0").IntValue = 0;
						// ConfigItem("d_y", "0").StringValue = "F: " + eyeToSightF.x + "; " + eyeToSightF.y + "; " + eyeToSightF.z;
						// ConfigItem("d_z", "0").StringValue = "M: " + eyeToSightM.x + "; " + eyeToSightM.y + "; " + eyeToSightM.z;
						// ConfigItem("d_zz", "0").StringValue = "C: " + eyeToSightC.x + "; " + eyeToSightC.y + "; " + eyeToSightC.z;
					// }
					
					//float rSize = ConfigItem("d_f", "1").FloatValue;
					float rSize = 0.2f;
					
					renderer.Color = Vector4(1.f, 1.f, 1.f, 1.f);
					
					//d_b = 20
					//d_c = -1.5
					//d_d = 5
					//d_f = 0.2
					//ConfigItem("d_a", "0").FloatValue
					//ConfigItem("d_b", "1").FloatValue
					//ConfigItem("d_c", "1").FloatValue
					renderer.AddSprite(scopeImage2, posF, rSize*eyeToSightF.Length/eyeToSightM.Length, 3.14159265f);
					
					renderer.AddSprite(scopeImage1, posM, rSize, 3.14159265f);

					renderer.AddSprite(scopeImage2, posC, rSize*eyeToSightC.Length/eyeToSightM.Length, 3.14159265f);
					
					// draw xhair for accuracy tuning
					// posM = (eyeMatrix * CreateTranslateMatrix(0.f, distM*0.015625f, 0.f)).GetOrigin();
					// renderer.AddSprite(scopeImage1, posM, rSize, 3.14159265f);
					
					
				}
				else //OPENGL
				{
					// float distF = ConfigItem("d_b", "0").FloatValue + ConfigItem("d_d", "0").FloatValue;	//ditance far
					// float distM = ConfigItem("d_b", "0").FloatValue;										//distance middle
					// float distC = ConfigItem("d_b", "0").FloatValue - ConfigItem("d_d", "0").FloatValue;	//distance close
					float distF = 100 + 100;	//distance far
					float distM = 100;										//distance middle
					float distC = 100 - 50;	//distance close
					
					Vector3 posF = (weapMatrix * CreateTranslateMatrix(0.f, distF, -1.5f)).GetOrigin();
					Vector3 posM = (weapMatrix * CreateTranslateMatrix(0.f, distM, -1.5f)).GetOrigin();
					Vector3 posC = (weapMatrix * CreateTranslateMatrix(0.f, distC, -1.5f)).GetOrigin();
					
					// Vector3 eyeToSightF = posF - eyeMatrix.GetOrigin();
					// Vector3 eyeToSightM = posM - eyeMatrix.GetOrigin();				
					// Vector3 eyeToSightC = posC - eyeMatrix.GetOrigin();
					
					Vector3 eyeToSightF = eyeMatrix.GetOrigin() - posF;
					Vector3 eyeToSightM = eyeMatrix.GetOrigin() - posM;				
					Vector3 eyeToSightC = eyeMatrix.GetOrigin() - posC;
					
					// if (ConfigItem("d_x", "0").IntValue == 2)
					// {
						// ConfigItem("d_x", "0").IntValue = 0;
						// ConfigItem("d_y", "0").StringValue = "F: " + eyeToSightF.x + "; " + eyeToSightF.y + "; " + eyeToSightF.z;
						// ConfigItem("d_z", "0").StringValue = "M: " + eyeToSightM.x + "; " + eyeToSightM.y + "; " + eyeToSightM.z;
						// ConfigItem("d_zz", "0").StringValue = "C: " + eyeToSightC.x + "; " + eyeToSightC.y + "; " + eyeToSightC.z;
					// }
					
					//float rSize = ConfigItem("d_f", "1").FloatValue;
					float rSize = 0.21f;
					
					renderer.Color = Vector4(1.f, 1.f, 1.f, 1.f);
					
					//d_b = 20
					//d_c = -1.5
					//d_d = 5
					//d_f = 0.175?
					//ConfigItem("d_a", "0").FloatValue
					//ConfigItem("d_b", "1").FloatValue
					//ConfigItem("d_c", "1").FloatValue
					renderer.AddSprite(scopeImage2, posF, rSize*eyeToSightF.Length/eyeToSightM.Length+rSize, 3.14159265f);
					
					renderer.AddSprite(scopeImage1, posM, rSize+rSize, 3.14159265f);

					renderer.AddSprite(scopeImage2, posC, rSize*eyeToSightC.Length/eyeToSightM.Length+rSize, 3.14159265f);
					
					// draw xhair for accuracy tuning
					// posM = (eyeMatrix * CreateTranslateMatrix(0.f, distM*0.015625f, 0.f)).GetOrigin();
					// renderer.AddSprite(scopeImage1, posM, rSize, 3.14159265f);
				}
				if (false)
				{
				//draw scope
				param.matrix = weapMatrix;
				param.matrix *= CreateTranslateMatrix(0.f, 40.f, -1.5f);
				param.matrix *= CreateScaleMatrix(1.f);
				renderer.AddModel(scopeModel1, param); // start
				
				param.matrix = weapMatrix;
				param.matrix *= CreateTranslateMatrix(0.f, 60.f, -1.5f);
				param.matrix *= CreateScaleMatrix(1.5f);
				renderer.AddModel(scopeModel2, param); // tube
				
				param.matrix = weapMatrix;
				param.matrix *= CreateTranslateMatrix(0.f, 80.f, -1.5f);
				param.matrix *= CreateScaleMatrix(2.f);
				renderer.AddModel(scopeModel2, param); // tube
				
				param.matrix = weapMatrix;
				param.matrix *= CreateTranslateMatrix(0.f, 100.f, -1.5f);
				param.matrix *= CreateScaleMatrix(2.5f);
				renderer.AddModel(scopeModel2, param); // tube
				
				param.matrix = weapMatrix;
				param.matrix *= CreateTranslateMatrix(0.f, 120.f, -1.5f);
				param.matrix *= CreateScaleMatrix(3.0f);
				renderer.AddModel(scopeModel2, param); // tube
				
				param.matrix = weapMatrix;
				param.matrix *= CreateTranslateMatrix(0.f, 140.f, -1.5f);
				param.matrix *= CreateScaleMatrix(3.5f);
				renderer.AddModel(scopeModel2, param); // tube
				}
			}
			weapMatrix *= CreateTranslateMatrix(0.f, 0.f, 50.f);
			weapMatrix *= CreateScaleMatrix(4.f);
			
			//weapMatrix *= CreateTranslateMatrix(debug_a, debug_b, debug_c);
			// draw weapon
			param.matrix = weapMatrix;
			renderer.AddModel(gunModel, param);
			param.matrix *=	CreateTranslateMatrix(0.f, move, 0.f);
			renderer.AddModel(moveModel, param);
			
			// draw sights
			param.matrix = weapMatrix;
			param.matrix *= CreateTranslateMatrix(0.f, 55.75f, 0.f);
			param.matrix *= CreateScaleMatrix(0.5f);
			renderer.AddModel(sightModelR, param); // rear
			
			param.matrix = weapMatrix;
			param.matrix *= CreateTranslateMatrix(0.f, 106.75f, 0.f);
			param.matrix *= CreateScaleMatrix(0.5f);
			renderer.AddModel(sightModelF, param); // front			
			
			// magazine/reload action
			//mat *= CreateTranslateMatrix(0.f, 1.f, 1.f);
			reload *= 2.5f;
			if(reloading) {
				if(reload < 0.1f){
					// move hand to magazine
					float per = reload / 0.1f;
					leftHand = Mix(leftHand,
						mat * Vector3(0.f, 0.f, 4.f),
						SmoothStep(per));
				}else if(reload < 0.7f){
					// magazine release
					float per = (reload - 0.1f) / 0.6f;
					if(per < 0.2f){
						// non-smooth pull out
						per *= 4.0f; per -= 0.4f;
						per = Clamp(per, 0.0f, 0.2f);
					}
					if(per > 0.5f) {
						// when per = 0.5f, the hand no longer holds the magazine,
						// so the free fall starts
						per += per - 0.5f;
					}
					mat *= CreateTranslateMatrix(0.f, 0.f, per*per*10.f);
					
					leftHand = mat * Vector3(0.f, 0.f, 4.f);
					if(per > 0.5f){
						per = (per - 0.5f);
						leftHand = Mix(leftHand, leftHand2, SmoothStep(per));
					}
				}else if(reload < 1.4f) {
					// insert magazine
					float per = (1.4f - reload) / 0.7f;
					if(per < 0.3f) {
						// non-smooth insertion
						per *= 4.f; per -= 0.4f;
						per = Clamp(per, 0.0f, 0.3f);
					}
					
					mat *= CreateTranslateMatrix(0.f, 0.f, per*per*10.f);
					leftHand = mat * Vector3(0.f, 0.f, 4.f);
				}else if(reload < 1.9f){
					// move the left hand to the original position
					// and start doing something with the right hand
					float per = (reload - 1.4f) / 0.5f;
					Vector3 orig = leftHand;
					leftHand = mat * Vector3(0.f, 0.f, 4.f);
					leftHand = Mix(leftHand, orig, SmoothStep(per));
					rightHand = Mix(rightHand, rightHand3, SmoothStep(per));
				}else if(reload < 2.2f){
					float per = (reload - 1.9f) / 0.3f;
					rightHand = Mix(rightHand3, rightHand4, SmoothStep(per));
				}else{
					float per = (reload - 2.2f) / 0.3f;
					rightHand = Mix(rightHand4, rightHand, SmoothStep(per));
				}
			}
			
			param.matrix = weapMatrix;
			renderer.AddModel(magModel, param);
			
			leftHand = Vector3(0.f, 0.f, 0.f);
			rightHand = Vector3(0.f, 0.f, 0.f);
			
			LeftHandPosition = leftHand;
			RightHandPosition = rightHand;
		}
	}
	
	IWeaponSkin@ CreateViewRifleSkinA(Renderer@ r, AudioDevice@ dev) {
		return ViewRifleSkinA(r, dev);
	}
}
