Shader "Hidden/YangStudio/Role/Transparent Transparent Cutout (FallBack)" {
	Properties {
		_Color ("Main Color", Color) = (1, 1, 1, 1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_AlphaTex("Alpha (G)", 2D) = "white" {}
		_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
		[MaterialEnum(On,0, Off,2)] _Cull ("2-Sided", Int) = 2
	}

	SubShader { 
		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"  "GlowType" = "GlowTransparent" }
		LOD 400
		Cull [_Cull]

		Pass {
			ColorMask A

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			sampler2D _AlphaTex;
			float4 _MainTex_ST;
			fixed _Cutoff;

			struct appdata_t {
				float4 vertex : POSITION;
				float4 texcoord : TEXCOORD0;
			};

			struct v2f {
				float4 position : SV_POSITION;
				float2 texcoord : TEXCOORD0;
			};

			v2f vert(appdata_t v) {
				v2f o;
				o.position = mul(UNITY_MATRIX_MVP, v.vertex);
				o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
				return o;
			}

			fixed4 frag(v2f i) : COLOR{
				fixed alpha = tex2D(_AlphaTex, i.texcoord).g;
				clip(alpha - _Cutoff);
				return fixed4(0.0, 0.0, 0.0, alpha);
			}

			ENDCG
		}
	
		CGPROGRAM
		#pragma surface surf YSLambert alpha

		#define USE_ALPHA_CHANNEL
		#define USE_SPLIT_ALPHAMAP			
		#include "../Include/Input.cginc"
		#include "../Include/Surf.cginc" 
		#include "../Include/Lit.cginc"

		ENDCG
	}

	Fallback "Hidden/YangStudio/Role/Transparent Cutout (FallBack)"
}
