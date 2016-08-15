Shader "YangStudio/FX/Distort/Textured Alpha Blended" {
	Properties {
		_Color ("Color", Color) = (0.5,0.5,0.5,0.5)
		_NoiseTex ("Distort Texture (RG)", 2D) = "white" {}
		_MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
		_HeatTime  ("Heat Time", range (-1,1)) = 0
		_ForceX  ("Strength X", range (0,1)) = 0.1
		_ForceY  ("Strength Y", range (0,1)) = 0.1
	}

	SubShader {
		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "GlowType" = "NoneTransparent" }
		Cull Off 
		Zwrite Off
		LOD 200

		Blend SrcAlpha OneMinusSrcAlpha

		Pass {				
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			#pragma multi_compile_particles
			#include "UnityCG.cginc"

			struct appdata_t {
				float4 vertex : POSITION;
				fixed4 color : COLOR;
				float2 texcoord: TEXCOORD0;
			};

			struct v2f {
				float4 vertex : POSITION;
				fixed4 color : COLOR;
				float2 uvmain : TEXCOORD1;
			};

			fixed4 _Color;
			fixed _ForceX;
			fixed _ForceY;
			fixed _HeatTime;
			float4 _MainTex_ST;
			float4 _NoiseTex_ST;
			sampler2D _NoiseTex;
			sampler2D _MainTex;

			v2f vert (appdata_t v) {
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.color = v.color;
				o.uvmain = TRANSFORM_TEX( v.texcoord, _MainTex );
				return o;
			}

			fixed4 frag( v2f i ) : COLOR { 
				fixed4 offsetColor1 = tex2D(_NoiseTex, i.uvmain + _Time.xz*_HeatTime);
				fixed4 offsetColor2 = tex2D(_NoiseTex, i.uvmain + _Time.yx*_HeatTime);
				i.uvmain.x += ((offsetColor1.r + offsetColor2.r) - 1) * _ForceX;
				i.uvmain.y += ((offsetColor1.r + offsetColor2.r) - 1) * _ForceY;
				return 2.0f * i.color * _Color * tex2D( _MainTex, i.uvmain);
			}
			ENDCG
		}
	}
}
