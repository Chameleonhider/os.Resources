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
	class ViewShotgunSkin: 
	IToolSkin, IViewToolSkin, IWeaponSkin,
	BasicViewWeapon {
		
		private AudioDevice@ audioDevice;
		//barrel
		private Model@ BarrelModel1;
		private Model@ BarrelModel2;
		private Model@ BarrelModel3A;
		private Model@ BarrelModel3B;
		//frontsight
		private Model@ FrontSModel1;
		//cylinder
		private Model@ CylinderModel1;
		private Model@ CylinderModel2;
		private Model@ CylinderModel3;
		//casing
		private Model@ CasingModel1;
		private Model@ CasingModel2A;
		//burned casing
		private Model@ CasingBModel1;
		private Model@ CasingBModel2A;
		//frame
		private Model@ FrameModel1;
		private Model@ FrameModel2;
		private Model@ FrameModel3A;
		private Model@ FrameModel3B;
		private Model@ FrameModel3C;
		//rearsight
		private Model@ RearSModel1;
		//hammer
		private Model@ HammerModel1;
		private Model@ HammerModel2;
		//trigger
		private Model@ TriggerModel1;
		
		int shotsfired;
		int bullet; 		//number of bullets in current magazine
		int rbullet;
		int basebullet;
		bool first = true;
		int Ready;
		int shellState1;
		int shellState2;
		int shellState3;
		int shellState4;
		int shellState5;
		int shellState6;
		
		/*private AudioChunk@[] fireSounds(4);
		private AudioChunk@ fireFarSound;
		private AudioChunk@ fireStereoSound;
		private AudioChunk@ reloadSound;*/
		
		ViewShotgunSkin(Renderer@ r, AudioDevice@ dev){
			super(r);
			@audioDevice = dev;
			//barrel
			@BarrelModel1 = renderer.RegisterModel
				("Models/Weapons/Revolver/Barrel-P1.kv6");
			@BarrelModel2 = renderer.RegisterModel
				("Models/Weapons/Revolver/Barrel-P2.kv6");
			@BarrelModel3A = renderer.RegisterModel
				("Models/Weapons/Revolver/Barrel-P3A.kv6");
			@BarrelModel3B = renderer.RegisterModel
				("Models/Weapons/Revolver/Barrel-P3B.kv6");
			//front sight, together with barrel
			@FrontSModel1 = renderer.RegisterModel
				("Models/Weapons/Revolver/FrontS-P3.kv6");
				
			//cylinder
			@CylinderModel1 = renderer.RegisterModel
				("Models/Weapons/Revolver/Cylinder-P1.kv6");
			@CylinderModel2 = renderer.RegisterModel
				("Models/Weapons/Revolver/Cylinder-P2.kv6");
			@CylinderModel3 = renderer.RegisterModel
				("Models/Weapons/Revolver/Cylinder-P3.kv6");
			//casing
			@CasingModel1 = renderer.RegisterModel
				("Models/Weapons/Revolver/Casing-P1.kv6");
			@CasingModel2A = renderer.RegisterModel
				("Models/Weapons/Revolver/Casing-P2.kv6");
			//burned casing
			@CasingBModel1 = renderer.RegisterModel
				("Models/Weapons/Revolver/CasingB-P1.kv6");
			@CasingBModel2A = renderer.RegisterModel
				("Models/Weapons/Revolver/CasingB-P2.kv6");
				
			//frame
			@FrameModel1 = renderer.RegisterModel
				("Models/Weapons/Revolver/Frame-P1.kv6");
			@FrameModel2 = renderer.RegisterModel
				("Models/Weapons/Revolver/Frame-P2.kv6");
			@FrameModel3A = renderer.RegisterModel
				("Models/Weapons/Revolver/Frame-P3A.kv6");
			@FrameModel3B = renderer.RegisterModel
				("Models/Weapons/Revolver/Frame-P3B.kv6");
			@FrameModel3C = renderer.RegisterModel
				("Models/Weapons/Revolver/Frame-P3C.kv6");
			//rear sight, together with frame
			@RearSModel1 = renderer.RegisterModel
				("Models/Weapons/Revolver/RearS-P1.kv6");
				
			//hammer	
			@HammerModel1 = renderer.RegisterModel
				("Models/Weapons/Revolver/Hammer-P1.kv6");
			@HammerModel2 = renderer.RegisterModel
				("Models/Weapons/Revolver/Hammer-P2.kv6");
			//trigger
			@TriggerModel1 = renderer.RegisterModel
				("Models/Weapons/Revolver/Trigger-P1.kv6");
				
			/*@fireSounds[0] = dev.RegisterSound
				("Sounds/Weapons/SMG/FireLocal1.wav");
			@fireSounds[1] = dev.RegisterSound
				("Sounds/Weapons/SMG/FireLocal2.wav");
			@fireSounds[2] = dev.RegisterSound
				("Sounds/Weapons/SMG/FireLocal3.wav");
			@fireSounds[3] = dev.RegisterSound
				("Sounds/Weapons/SMG/FireLocal4.wav");
			@fireFarSound = dev.RegisterSound
				("Sounds/Weapons/SMG/FireFar.wav");
			@fireStereoSound = dev.RegisterSound
				("Sounds/Weapons/SMG/FireStereo.wav");
			@reloadSound = dev.RegisterSound
				("Sounds/Weapons/SMG/ReloadLocal.wav");*/
				
		}
		
		void Update(float dt) {
			BasicViewWeapon::Update(dt);
		}
		
		void WeaponFired(){
			//BasicViewWeapon::WeaponFired();
			
			/*if(!IsMuted){
				Vector3 origin = Vector3(0.4f, -0.3f, 0.5f);
				AudioParam param;
				param.volume = 8.f;
				audioDevice.PlayLocal(fireSounds[GetRandom(fireSounds.length)], origin, param);
				
				param.volume = 4.f;
				audioDevice.PlayLocal(fireFarSound, origin, param);
				param.volume = 1.f;
				audioDevice.PlayLocal(fireStereoSound, origin, param);
				
			}*/
			shotsfired += 1;
			//if (shotsfired == 6)
			//{
			//	shotsfired = 0;
			//}
			if (bullet < 1) //just make sure it's not negative
			{
				bullet = 0;
			}
			bullet -= 1;
			rbullet = 0;
			basebullet = bullet;
		}
		
		void ReloadingWeapon() {
			if (bullet < 1)
			{
				bullet = 0;
			}
			bullet += 1;
			//shotsfired = 0;
			/*if(!IsMuted){
				Vector3 origin = Vector3(0.4f, -0.3f, 0.5f);
				AudioParam param;
				param.volume = 0.2f;
				audioDevice.PlayLocal(reloadSound, origin, param);
			}*/
		}
		
		void ReloadedWeapon() 
		{
			if (bullet < ClipSize)
			{
				bullet = Ammo; //maybe there aren't enough bullets?
			}
			else
			{
				bullet = ClipSize; //set it to max
			}
			basebullet = bullet;
			shotsfired = 0;
			rbullet = 0;
		}
		
		float GetZPos() {
			return 0.2f - AimDownSightStateSmooth * 0.038f;
		}
		
		// rotates gun matrix to ensure the sight is in
		// the center of screen (0, ?, 0).
		Matrix4 AdjustToAlignSight(Matrix4 mat, Vector3 sightPos, float fade) {
			Vector3 p = mat * sightPos;
			mat = CreateRotateMatrix(Vector3(0.f, 0.f, 1.f), atan(p.x / p.y) * fade) * mat;
			mat = CreateRotateMatrix(Vector3(-1.f, 0.f, 0.f), atan(p.z / p.y) * fade) * mat;
			return mat;
		}
		
		void Draw2D() {
			//if(AimDownSightState > 0.6)
			//	return;
			BasicViewWeapon::Draw2D();
		}
		
		void AddToScene() {	
		
if (first == true)	
{	
	shotsfired = 0;
	bullet = ClipSize; 		//number of bullets in current magazine
	rbullet = 0;
	shellState1 = 1;
	shellState2 = 1;
	shellState3 = 1;
	shellState4 = 1;
	shellState5 = 1;
	shellState6 = 1;
	first = false;
}

//make sure its not over ClipSize
if (bullet > ClipSize)
{
	bullet = ClipSize; 
}
//just in case make sure its not negative
if (bullet < 0)
{
	bullet = 0; 
}
//set reloaded bullet count-----IMPORTANT-------
rbullet = bullet - basebullet;

//set Ready states - might NOT be USED later
if (ReadyState < 0.4f)
{
	Ready = -1;
}
else if (ReadyState < 1.f)
{
	Ready = 0;
}
else if (ReadyState >= 1.f)
{
	Ready = 1;
}

//sets all bullets to be all either unused or used
if (shotsfired == 0 && bullet == 6)
{
	shellState1 = 1;
	shellState2 = 1;
	shellState3 = 1;
	shellState4 = 1;
	shellState5 = 1;
	shellState6 = 1;
}
if (shotsfired == 6 && bullet == 6)
{
	shellState1 = 2;
	shellState2 = 2;
	shellState3 = 2;
	shellState4 = 2;
	shellState5 = 2;
	shellState6 = 2;
}

//check after shooting which ones turn black
if (ReadyState < 1.f)
{
	if (shotsfired == 1)
	{
		shellState1 = 2;
		shellState2 = 1;
		shellState3 = 1;
		shellState4 = 1;
		shellState5 = 1;
		shellState6 = 1;
	}
	if (shotsfired == 2)
	{
		shellState1 = 2;
		shellState2 = 2;
		shellState3 = 1;
		shellState4 = 1;
		shellState5 = 1;
		shellState6 = 1;
	}
	if (shotsfired == 3)
	{
		shellState1 = 2;
		shellState2 = 2;
		shellState3 = 2;
		shellState4 = 1;
		shellState5 = 1;
		shellState6 = 1;
	}
	if (shotsfired == 4)
	{
		shellState1 = 2;
		shellState2 = 2;
		shellState3 = 2;
		shellState4 = 2;
		shellState5 = 1;
		shellState6 = 1;
	}
	if (shotsfired == 5)
	{
		shellState1 = 2;
		shellState2 = 2;
		shellState3 = 2;
		shellState4 = 2;
		shellState5 = 2;
		shellState6 = 1;
	}
}

//the cylinder rotates after shooting and then resets, so we need to push shells "forward"
//and put an unused shell to be ready to fire
else
{
	if (shotsfired == 1)
	{
		shellState1 = 1;
		shellState2 = 2;
		shellState3 = 1;
		shellState4 = 1;
		shellState5 = 1;
		shellState6 = 1;
	}
	if (shotsfired == 2)
	{
		shellState1 = 1;
		shellState2 = 2;
		shellState3 = 2;
		shellState4 = 1;
		shellState5 = 1;
		shellState6 = 1;
	}
	if (shotsfired == 3)
	{
		shellState1 = 1;
		shellState2 = 2;
		shellState3 = 2;
		shellState4 = 2;
		shellState5 = 1;
		shellState6 = 1;
	}
	if (shotsfired == 4)
	{
		shellState1 = 1;
		shellState2 = 2;
		shellState3 = 2;
		shellState4 = 2;
		shellState5 = 2;
		shellState6 = 1;
	}
	if (shotsfired == 5)
	{
		shellState1 = 1;
		shellState2 = 2;
		shellState3 = 2;
		shellState4 = 2;
		shellState5 = 2;
		shellState6 = 2;
	}
}












			Matrix4 mat = CreateScaleMatrix(0.033f);
			mat = GetViewWeaponMatrix() * mat;
			
//side
			
	//mat *= CreateRotateMatrix(Vector3(0.f, 0.f, 1.f), asin(1));
	//mat *= CreateRotateMatrix(Vector3(0.f, 0.f, 1.f), asin(1));
//----
//normal
	//mat *= CreateTranslateMatrix(-4.75f, 0.f, -6.f);
	
	//mat *= CreateRotateMatrix(Vector3(0.f, 0.f, 1.f), 0.15f);
//----
			
			bool reloading = IsReloading;
			float reload = ReloadProgress * 0.5f;
			Vector3 leftHand, rightHand;
			//(x,y,z) (x+down/-up, y+rollright/-rollleft, z+turnleft?/-turnright?)
			//(x,y,z) (x+left/-right, y+further/-closer, z+down/-up)
			leftHand = mat * Vector3(0.f, -100.f, 100.f);
			rightHand = mat * Vector3(0.f, -100.f, 100.f);
			
			Vector3 leftHand2 = mat * Vector3(5.f, -10.f, 4.f);
			Vector3 leftHand3 = mat * Vector3(1.f, 6.f, -4.f);
			Vector3 leftHand4 = mat * Vector3(1.f, 9.f, -6.f);
			
			if(AimDownSightStateSmooth > 0.8f){
				mat = AdjustToAlignSight(mat, Vector3(0.f, 0.f, -5.2f), (AimDownSightStateSmooth - 0.8f) / 0.2f);
			}
			mat *= CreateTranslateMatrix(AimDownSightStateSmooth * 3.625f , AimDownSightStateSmooth * -4.f, AimDownSightStateSmooth * -4.6f);
			mat *= CreateTranslateMatrix(-4.f, -2.f, 0.f);
			mat *= CreateScaleMatrix(0.5f);
			
			ModelRenderParam param;
			ModelRenderParam paramCustom;
			
			param.depthHack = true;
			paramCustom.depthHack = true;
			
			Matrix4 weapMatrix = eyeMatrix * mat;			
			Matrix4 tempMatrix = weapMatrix;
			Matrix4 customModelMatrix = weapMatrix;
			
			//(x,y,z) (x+left/-right, y+further/-closer, z+down/-up)
//BARREL
			customModelMatrix = weapMatrix;	
			//customModelMatrix *= CreateScaleMatrix(0.375f, 1.25f, 0.375f);
			customModelMatrix *= CreateScaleMatrix(1.f/3.f, 1.25f, 1.f/3.f);
			customModelMatrix *= CreateTranslateMatrix(2.25f, 11.9f, 6.5f);
			//main part 
			param.matrix = customModelMatrix;
			renderer.AddModel(BarrelModel1, param);
			
			param.matrix = customModelMatrix;
			param.matrix *= CreateRotateMatrix(Vector3(0.f, 1.f, 0.f), atan(1));
			param.matrix *= CreateScaleMatrix(sqrt(2), 1.f, sqrt(2));
			renderer.AddModel(BarrelModel2, param);
			
			//LEFT SIDE UP
			param.matrix = customModelMatrix;
			param.matrix *= CreateTranslateMatrix(0.f, 0.f, -1.0f);
			param.matrix *= CreateRotateMatrix(Vector3(0.f, 1.f, 0.f), atan(0.5f));
			param.matrix *= CreateScaleMatrix(sqrt(5)/2, 1.f, sqrt(5)/2);
			renderer.AddModel(BarrelModel3A, param);
			
			//LEFT SIDE DOWN
			param.matrix = customModelMatrix;
			param.matrix *= CreateTranslateMatrix(0.f, 0.f, 1.0f);
			param.matrix *= CreateRotateMatrix(Vector3(0.f, -1.f, 0.f), atan(0.5f));
			param.matrix *= CreateScaleMatrix(sqrt(5)/2, 1.f, sqrt(5)/2);
			renderer.AddModel(BarrelModel3A, param);
			
			//RIGHT SIDE UP
			param.matrix = customModelMatrix;
			param.matrix *= CreateTranslateMatrix(0.f, 0.f, -1.0f);
			param.matrix *= CreateRotateMatrix(Vector3(0.f, -1.f, 0.f), atan(0.5f));
			param.matrix *= CreateScaleMatrix(sqrt(5)/2, 1.f, sqrt(5)/2);
			renderer.AddModel(BarrelModel3B, param);
			
			//RIGHT SIDE DOWN
			param.matrix = customModelMatrix;
			param.matrix *= CreateTranslateMatrix(0.f, 0.f, 1.0f);
			param.matrix *= CreateRotateMatrix(Vector3(0.f, 1.f, 0.f), atan(0.5f));
			param.matrix *= CreateScaleMatrix(sqrt(5)/2, 1.f, sqrt(5)/2);
			renderer.AddModel(BarrelModel3B, param);
			
		//FRONT SIGHT			
			customModelMatrix = weapMatrix;
			//customModelMatrix *= CreateScaleMatrix(1.f, 1.f, 1.f);
			//customModelMatrix *= CreateTranslateMatrix(0.f, 0.f, 0.f);
			//customModelMatrix *= CreateRotateMatrix(Vector3(0.f, 1.f, 0.f), atan(0.f));
			
			//SLOPE
			param.matrix = customModelMatrix;
			param.matrix *= CreateTranslateMatrix(0.25f, -0.5f, 0.f);
			param.matrix *= CreateRotateMatrix(Vector3(1.f, 0.f, 0.f), atan(50.f));
			param.matrix *= CreateScaleMatrix(1.f, sqrt(26)/25, 1.f);
			renderer.AddModel(FrontSModel1, param);			
//END OF BARREL
			//(x,y,z) (x+left/-right, y+further/-closer, z+down/-up)
//CYLINDER
			
			customModelMatrix = weapMatrix;	
			customModelMatrix *= CreateScaleMatrix(0.375f, 2.0f, 0.375f);
			customModelMatrix *= CreateTranslateMatrix(2.f, 2.25f, 9.4f);
		//SHOOTING
			if(ReadyState < 1.f && Ammo != 0)
			{
				if (ReadyState < 0.3f)
				{
					//nuthing but a g thang
				}
				else if (ReadyState < 0.9f)
				{
					float per = (ReadyState - 0.3f) / 0.6f;
					customModelMatrix *= CreateRotateMatrix(Vector3(0.f, 1.f, 0.f), per*per*acos(0.5f));
				}
				else
				{
					customModelMatrix *= CreateRotateMatrix(Vector3(0.f, 1.f, 0.f), acos(0.5f));
				}
			}
			else
			{
				//customModelMatrix *= CreateRotateMatrix(Vector3(0.f, 1.f, 0.f), shotsfired*acos(0.5f));
			}
		//RELOADING
			if(reload < 2.f)
			{
				if (reload > 1.f)
				{
					float per = (reload - 1.f) / 2.f;
					customModelMatrix *= CreateTranslateMatrix(-20.f, 0.f, 0.f);
					customModelMatrix *= CreateRotateMatrix(Vector3(0.f, 1.f, 0.f), per*atan(1));
					customModelMatrix *= CreateTranslateMatrix(20.f, 0.f, 0.f);
				}
			}
			
			if (rbullet <= 1 && bullet == ClipSize && reload < 0.53f)
			{
				if (reload < 0.1f)
				{
					float per = reload / 0.1f;
					customModelMatrix *= CreateTranslateMatrix(0.f, 0.f, 20.f);
					customModelMatrix *= CreateRotateMatrix(Vector3(0.f, -1.f, 0.f), per*atan(1));
					customModelMatrix *= CreateTranslateMatrix(0.f, 0.f, -20.f);
				}
				else if (reload < 0.4f)
				{
					customModelMatrix *= CreateTranslateMatrix(0.f, 0.f, 20.f);
					customModelMatrix *= CreateRotateMatrix(Vector3(0.f, -1.f, 0.f), atan(1));
					customModelMatrix *= CreateTranslateMatrix(0.f, 0.f, -20.f);
				}
				else if (reload < 0.53f)
				{
					float per = (reload - 0.4f) / 0.13f;
					customModelMatrix *= CreateTranslateMatrix(0.f, 0.f, 20.f);
					customModelMatrix *= CreateRotateMatrix(Vector3(0.f, -1.f, 0.f), atan(1));
					customModelMatrix *= CreateRotateMatrix(Vector3(0.f, 1.f, 0.f), per*atan(1));
					customModelMatrix *= CreateTranslateMatrix(0.f, 0.f, -20.f);
				}
			}
			//main part
			//customModelMatrix *= CreateScaleMatrix(1.f, 1.f, 4.f);
			
			//customModelMatrix *= CreateTranslateMatrix(0.f, 0.f, -15.f);
			//customModelMatrix *= CreateRotateMatrix(Vector3(0.f, 1.f, 0.f), 10*reload*atan(-1.f));
			//customModelMatrix *= CreateTranslateMatrix(0.f, 0.f, 15.f);
			
			//customModelMatrix *= CreateScaleMatrix(1.f, 1.f, 0.25f);
			
			param.matrix = customModelMatrix;			
			//0 DEGREE PART
			//param.matrix *= CreateTranslateMatrix(0.f, 0.f, 0.f);
			//param.matrix *= CreateScaleMatrix(1.f, 1.f, 1.f);
			tempMatrix = param.matrix;
			paramCustom = param;
			renderer.AddModel(CylinderModel1, param);
			//CASING 0
			if (shellState1 == 1)
			{
				renderer.AddModel(CasingModel1, param);
			}
			else if (shellState1 == 2)
			{
				if (reload < 0.08f)
				{
				
				}
				else if (reload < 0.12f)
				{
					float per = (reload - 0.08f) / 0.07f;
					paramCustom.matrix *= CreateTranslateMatrix(0.f, per*-2.f, 0.f);
				}
				else if (reload < 0.3f)
				{
					float per = (reload - 0.15f) / 0.25f;
					paramCustom.matrix *= CreateTranslateMatrix(0.f, -2.f, 0.f);
					paramCustom.matrix *= CreateTranslateMatrix(0.f, per*-3.f, per*per*10.f);
					paramCustom.matrix *= CreateRotateMatrix(Vector3(1.f, 0.2f, 0.1f), per*asin(1)); 
				}
				renderer.AddModel(CasingBModel1, paramCustom);
			}
			//CASING 180
			param.matrix *= CreateRotateMatrix(Vector3(0.f, 1.f, 0.f), 2*asin(1));
			if (shellState4 == 1)
			{
				renderer.AddModel(CasingModel1, param);
			}
			else if (shellState4 == 2)
			{
				renderer.AddModel(CasingBModel1, param);
			}
			//0+30 DEGREE PART
			param.matrix = tempMatrix;
			param.matrix *= CreateTranslateMatrix(0.f, 0.f, 0.f);
			param.matrix *= CreateRotateMatrix(Vector3(0.f, 1.f, 0.f), asin(0.5f));
			param.matrix *= CreateScaleMatrix(sqrt(2.5f)/2.5f, 1.f, 0.815);
			renderer.AddModel(CylinderModel3, param);
			//0+45 DEGREE PART
			param.matrix = tempMatrix;
			param.matrix *= CreateRotateMatrix(Vector3(0.f, 1.f, 0.f), atan(1));
			param.matrix *= CreateScaleMatrix(sqrt(2)/2, 1.f, sqrt(2)/2);
			renderer.AddModel(CylinderModel2, param);
			//CASING 0+45
			param.matrix = tempMatrix;
			param.matrix *= CreateRotateMatrix(Vector3(0.f, 1.f, 0.f), atan(1));
			param.matrix *= CreateScaleMatrix(sqrt(2)/2, 1.f, sqrt(2)/2);
			if (shellState1 == 1)
			{
				renderer.AddModel(CasingModel2A, param);
			}
			else if (shellState1 == 2)
			{
				renderer.AddModel(CasingBModel2A, param);
			}
			//CASING 180+45
			param.matrix *= CreateRotateMatrix(Vector3(0.f, 1.f, 0.f), 2*asin(1));
			if (shellState4 == 1)
			{
				renderer.AddModel(CasingModel2A, param);
			}
			else if (shellState4 == 2)
			{
				renderer.AddModel(CasingBModel2A, param);
			}
			
			//60 DEGREE PART
			param.matrix = tempMatrix;
			param.matrix *= CreateRotateMatrix(Vector3(0.f, 1.f, 0.f), acos(0.5f));
			tempMatrix = param.matrix;
			renderer.AddModel(CylinderModel1, param);
			//CASING 60
			if (shellState2 == 1)
			{
				renderer.AddModel(CasingModel1, param);
			}
			else if (shellState2 == 2)
			{
				renderer.AddModel(CasingBModel1, param);
			}
			//CASING 240
			param.matrix *= CreateRotateMatrix(Vector3(0.f, 1.f, 0.f), 2*asin(1));
			if (shellState5 == 1)
			{
				renderer.AddModel(CasingModel1, param);
			}
			else if (shellState5 == 2)
			{
				renderer.AddModel(CasingBModel1, param);
			}
			//60+30 DEGREE PART
			param.matrix = tempMatrix;
			param.matrix *= CreateTranslateMatrix(0.f, 0.f, 0.f);
			param.matrix *= CreateRotateMatrix(Vector3(0.f, 1.f, 0.f), asin(0.5f));
			param.matrix *= CreateScaleMatrix(sqrt(2.5f)/2.5f, 1.f, 0.815);
			renderer.AddModel(CylinderModel3, param);
			//60+45 DEGREE PART
			param.matrix = tempMatrix;
			param.matrix *= CreateRotateMatrix(Vector3(0.f, 1.f, 0.f), atan(1));
			param.matrix *= CreateScaleMatrix(sqrt(2)/2, 1.f, sqrt(2)/2);
			renderer.AddModel(CylinderModel2, param);
			//CASING 60+45
			param.matrix = tempMatrix;
			param.matrix *= CreateRotateMatrix(Vector3(0.f, 1.f, 0.f), atan(1));
			param.matrix *= CreateScaleMatrix(sqrt(2)/2, 1.f, sqrt(2)/2);
			if (shellState2 == 1)
			{
				renderer.AddModel(CasingModel2A, param);
			}
			else if (shellState2 == 2)
			{
				renderer.AddModel(CasingBModel2A, param);
			}
			//CASING 240+45
			param.matrix *= CreateRotateMatrix(Vector3(0.f, 1.f, 0.f), 2*asin(1));
			if (shellState5 == 1)
			{
				renderer.AddModel(CasingModel2A, param);
			}
			else if (shellState5 == 2)
			{
				renderer.AddModel(CasingBModel2A, param);
			}
			
			//120 DEGREE PART
			param.matrix = tempMatrix;
			param.matrix *= CreateRotateMatrix(Vector3(0.f, 1.f, 0.f), acos(0.5f));
			tempMatrix = param.matrix;
			renderer.AddModel(CylinderModel1, param);
			//CASING 120
			if (shellState3 == 1)
			{
				renderer.AddModel(CasingModel1, param);
			}
			else if (shellState3 == 2)
			{
				renderer.AddModel(CasingBModel1, param);
			}
			//CASING 300
			param.matrix *= CreateRotateMatrix(Vector3(0.f, 1.f, 0.f), 2*asin(1));
			if (shellState6 == 1)
			{
				renderer.AddModel(CasingModel1, param);
			}
			else if (shellState6 == 2)
			{
				renderer.AddModel(CasingBModel1, param);
			}
			//120+30 DEGREE PART
			param.matrix = tempMatrix;
			param.matrix *= CreateTranslateMatrix(0.f, 0.f, 0.f);
			param.matrix *= CreateRotateMatrix(Vector3(0.f, 1.f, 0.f), asin(0.5f));
			param.matrix *= CreateScaleMatrix(sqrt(2.5f)/2.5f, 1.f, 0.815);
			renderer.AddModel(CylinderModel3, param);
			//120+45 DEGREE PART
			param.matrix = tempMatrix;
			param.matrix *= CreateRotateMatrix(Vector3(0.f, 1.f, 0.f), atan(1));
			param.matrix *= CreateScaleMatrix(sqrt(2)/2, 1.f, sqrt(2)/2);
			renderer.AddModel(CylinderModel2, param);
			//CASING 120+45
			param.matrix = tempMatrix;
			param.matrix *= CreateRotateMatrix(Vector3(0.f, 1.f, 0.f), atan(1));
			param.matrix *= CreateScaleMatrix(sqrt(2)/2, 1.f, sqrt(2)/2);
			if (shellState3 == 1)
			{
				renderer.AddModel(CasingModel2A, param);
			}
			else if (shellState3 == 2)
			{
				renderer.AddModel(CasingBModel2A, param);
			}
			//CASING 300+45
			param.matrix *= CreateRotateMatrix(Vector3(0.f, 1.f, 0.f), 2*asin(1));
			if (shellState6 == 1)
			{
				renderer.AddModel(CasingModel2A, param);
			}
			else if (shellState6 == 2)
			{
				renderer.AddModel(CasingBModel2A, param);
			}
				
//END OF CYLINDER
			//(x,y,z) (x+left/-right, y+further/-closer, z+down/-up)
//FRAME
			customModelMatrix = weapMatrix;	
			customModelMatrix *= CreateScaleMatrix(0.5f, 1.f, 1.f);
			//customModelMatrix *= CreateTranslateMatrix(0.25f, 0.f, 0.f);
			//main part
			param.matrix = customModelMatrix;
			renderer.AddModel(FrameModel1, param);
			//45 degrees
			param.matrix = customModelMatrix;
			param.matrix *= CreateRotateMatrix(Vector3(1.f, 0.f, 0.f), atan(1));
			param.matrix *= CreateScaleMatrix(1.f, sqrt(2)/2, sqrt(2)/2);
			renderer.AddModel(FrameModel2, param);
			//arctangent(0.5) degrees
			param.matrix = customModelMatrix;
			param.matrix *= CreateRotateMatrix(Vector3(1.f, 0.f, 0.f), atan(0.5f));
			param.matrix *= CreateScaleMatrix(1.f, sqrt(5)/2, sqrt(5)/2);
			renderer.AddModel(FrameModel3A, param);
			//arctangent(0.5) degrees
			param.matrix = customModelMatrix;
			param.matrix *= CreateTranslateMatrix(0.f, 0.f, -0.5f);
			param.matrix *= CreateRotateMatrix(Vector3(1.f, 0.f, 0.f), atan(0.5f));
			param.matrix *= CreateScaleMatrix(1.f, sqrt(5)/2, sqrt(5)/2);
			renderer.AddModel(FrameModel3B, param);
			//arctangent(0.5) degrees
			param.matrix = customModelMatrix;
			param.matrix *= CreateTranslateMatrix(0.f, 0.f, 0.f);
			param.matrix *= CreateRotateMatrix(Vector3(-1.f, 0.f, 0.f), atan(0.5f));
			param.matrix *= CreateScaleMatrix(1.f, sqrt(5)/2, sqrt(5)/2);
			renderer.AddModel(FrameModel3C, param);
			
		//REAR SIGHT			
			param.matrix = customModelMatrix;
			param.matrix *= CreateScaleMatrix(0.25f, 0.125f, 0.125f);
			param.matrix *= CreateTranslateMatrix(4.5f, 7.f, -4.f);
			renderer.AddModel(RearSModel1, param);
//END OF FRAME
//HAMMER
			customModelMatrix = weapMatrix;	
			customModelMatrix *= CreateTranslateMatrix(-0.5f, -0.5f, 6.5f);
			
			param.matrix = customModelMatrix;
			param.matrix *= CreateScaleMatrix(0.5f, 0.25f, 0.25f);
			renderer.AddModel(HammerModel1, param);
			
			param.matrix = customModelMatrix;
			param.matrix *= CreateRotateMatrix(Vector3(1.f, 0.f, 0.f), atan(1));
			param.matrix *= CreateScaleMatrix(0.5f, sqrt(2)/8, sqrt(2)/8);
			renderer.AddModel(HammerModel2, param);
			/*
//END OF HAMMER
//TRIGGER
			param.matrix = weapMatrix;
			renderer.AddModel(TriggerModel1, param);
			
//END OF TRIGGER

			// draw sights
			/*
			Matrix4 sightMat = weapMatrix;
			sightMat *= CreateTranslateMatrix(0.05f, 5.f, -4.85f);
			sightMat *= CreateScaleMatrix(0.1f);
			param.matrix = sightMat;
			renderer.AddModel(sightModel1, param); // front
			
			sightMat = weapMatrix;
			sightMat *= CreateTranslateMatrix(0.025f, 5.f, -4.85f);
			sightMat *= CreateScaleMatrix(0.05f);
			param.matrix = sightMat;
			renderer.AddModel(sightModel3, param); // front pin
			
			sightMat = weapMatrix;
			sightMat *= CreateTranslateMatrix(0.04f, -9.f, -4.9f);
			sightMat *= CreateScaleMatrix(0.08f);
			param.matrix = sightMat;
			renderer.AddModel(sightModel2, param); // rear
			*/
			
			LeftHandPosition = leftHand;
			RightHandPosition = rightHand;
		}
		
	}
	
	IWeaponSkin@ CreateViewShotgunSkin(Renderer@ r, AudioDevice@ dev) 
	{
		return ViewShotgunSkin(r, dev);
	}
}
