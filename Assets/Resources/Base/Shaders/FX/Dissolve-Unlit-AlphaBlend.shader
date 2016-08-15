Shader "YangStudio/FX/Dissolve/Unlit/Alpha Blended" {
	Properties {
		_Color ("Main Color", Color) = (1,1,1,1)
		_Amount ("Amount", Range (0, 1)) = 0.5
		_StartAmount("StartAmount", float) = 0.1
		_Illuminate ("Illuminate", Range (0, 0.9)) = 0.5
		_Tile("Tile", float) = 1
		_DissColor ("DissColor", Color) = (1,1,1,1)
		_ColorAnimate ("ColorAnimate", vector) = (1,1,1,1)
		_MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
		_DissolveTex ("DissolveSrc (R)", 2D) = "white" {}
	}

	SubShader { 
		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "GlowType" = "NoneTransparent" }
		LOD 400
		Cull Off
		Zwrite Off
		Blend SrcAlpha OneMinusSrcAlpha

		Pass {
			CGPROGRAM
			#pragma target 3.0
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest

			#define USE_ALPHA_CHANNEL
			#define USE_VERTEXCOLOR

			#include "UnityCG.cginc"
			#include "Lighting.cginc"		
			#include "InputDissolve.cginc"
			#include "SurfDissolve.cginc" 

			float4 _MainTex_ST;

			struct appdata_t {
				float4 vertex : POSITION;
				fixed4 color : COLOR;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				fixed4 color : COLOR;
				float2 texcoord : TEXCOORD0;
			};


			v2f vert (appdata_t v) {
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.color = v.color;
				o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
				return o;
			}

			fixed4 frag( v2f i ) : COLOR { 
				Input IN = (Input)0;
				YSSurfaceOutput o = (YSSurfaceOutput)0;
				IN.uv_MainTex = i.texcoord;
				IN.color = i.color;
				surfDissolve (IN, o);

				return fixed4(o.Albedo, o.Alpha);
			}

			ENDCG
		}	
	}
}
