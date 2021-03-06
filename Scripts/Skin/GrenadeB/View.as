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
	class ViewGrenadeSkinB: 
	IToolSkin, IViewToolSkin, IGrenadeSkin {
		private bool opengl = ConfigItem("r_renderer", "gl").StringValue == "gl";
	
		private float sprintState;
		private float raiseState;
		private IntVector3 teamColor;
		private Matrix4 eyeMatrix;
		private Vector3 swing;
		private Vector3 leftHand;
		private Vector3 rightHand;
		private float cookTime;
		private float readyState;
		//Chameleon
		private float clientDistance;
		private float soundDistance;
		
		float SprintState { 
			set { sprintState = value; }
		}
		
		float RaiseState { 
			set { raiseState = value; }
		}
		
		IntVector3 TeamColor { 
			set { teamColor = value; } 
		}
		
		bool IsMuted {
			set {
				// nothing to do
			}
		}
		
		int ScopeZoom{set { }}
		
		Matrix4 EyeMatrix {
			set { eyeMatrix = value; }
		}
		
		Vector3 Swing {
			set { swing = value; }
		}	
		
		Vector3 LeftHandPosition {
			get {
				return leftHand;
			}
		}
		Vector3 RightHandPosition { 
			get  {
				return rightHand;
			}
		}
		
		float CookTime {
			set { cookTime = value; }
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
		private Image@ sightImage1;
		private Image@ sightImage2;
		
		ViewGrenadeSkinB(Renderer@ r, AudioDevice@ dev) {
			@renderer = r;
			@audioDevice = dev;
			@model = renderer.RegisterModel
				("Models/Weapons/GrenadeB/Grenade1st.kv6");
			@sightImage1 = renderer.RegisterImage
				("Gfx/SightHorizontal.png");
			@sightImage2 = renderer.RegisterImage
				("Gfx/SightVertical.png");
		}
		
		void Update(float dt) {
		}
		
		void AddToScene() {
			Matrix4 mat = CreateScaleMatrix(0.03125f);
			
			if(readyState > 0.9999)
			{
				float bring = 0.f;
				float pin = 0.f;
				float side = 0.f;
				
				bring = Min((readyState - 1.f) * 2.f, 1.f);
				bring = 1.f - bring;
				bring = 1.f - bring * bring;
				
				if(cookTime > 0.0001f) {
					pin = Min(cookTime * 8.f, 2.f);
				
					if(pin > 1.f) {
						side += pin - 1.f;
						bring -= (pin - 1.f) * 2.f;
					}
				}
			
				if(sprintState > 0.f){
					mat = CreateRotateMatrix(Vector3(0.f, 0.f, 1.f),
						sprintState * -0.3f) * mat;
					mat = CreateTranslateMatrix(Vector3(0.1f, -0.4f, -0.05f)
						* sprintState) * mat;
				}
				mat = CreateTranslateMatrix(-0.3f - side * 0.8f,
					0.8f - bring * 0.1f, 0.45f - bring * 0.15f) * mat;
				
				mat = CreateTranslateMatrix(Vector3(-0.1f, -0.3f, 0.1f) * (1.f - raiseState))
					* mat;
			
				mat = CreateTranslateMatrix(swing) * mat;
			
				leftHand = mat * Vector3(10.f, -1.f, 10.f);
				rightHand = mat * Vector3(-3.f, 1.f, 5.f);
			
				Vector3 leftHand2 = mat * Vector3(2.f, 1.f, -2.f);
				Vector3 leftHand3 = mat * Vector3(8.f, -1.f, 10.f);
			
				if(pin < 1.f){
					leftHand = Mix(leftHand, leftHand2, pin);
				}else{
					leftHand = Mix(leftHand2, leftHand3, pin - 1.f);
				}
			
				ModelRenderParam param;
				param.matrix = eyeMatrix * mat;
				param.matrix *= CreateScaleMatrix(0.25f);
				
				renderer.AddModel(model, param);
			}
			else 
			{
				// throwing
				float per = readyState;
				per = Min(per * 3.f, 1.f);
				
				// left hand shouldn't be visible
				leftHand = Vector3(0.f, 0.f, 0.f);
				
				float p2 = per - 0.6f;
				p2 = 0.9f - p2 * p2 * 2.5f;
				rightHand = Vector3(-0.2f, p2, -0.9f + per * 1.8f);
			}
			
			leftHand = Vector3(0.f, 0.f, 0.f);
			rightHand = Vector3(0.f, 0.f, 0.f);
			
			float xhSize = 0.05f;
			if (opengl)
				xhSize *= 4;
			
			// draw xhair
			Vector3 reflexPos = eyeMatrix * Vector3(0.f, 0.2f, 0.f);
			renderer.Color = Vector4(1.f, 1.f, 1.f, 1.f); // premultiplied alpha
			if (cookTime < 0.01f)
				renderer.AddSprite(sightImage1, reflexPos, xhSize, 0.f);
			else
				renderer.AddSprite(sightImage2, reflexPos, xhSize, 0.f);
		}
		void Draw2D() {
			// renderer.ColorNP = (Vector4(1.f, 1.f, 1.f, 1.f));
			// renderer.DrawImage(sightImage,
				// Vector2((renderer.ScreenWidth - sightImage.Width) * 0.5f,
						// (renderer.ScreenHeight - sightImage.Height) * 0.5f));
		}
	}
	
	IGrenadeSkin@ CreateViewGrenadeSkinB(Renderer@ r, AudioDevice@ dev) {
		return ViewGrenadeSkinB(r, dev);
	}
}
