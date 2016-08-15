Shader "Hidden/YangStudio/Role/Transparent Transparent Cutout" {
	Properties {
		_Color ("Main Color", Color) = (1, 1, 1, 1)
		_SpecIntensity("Specular Intensity", Float) = 1.0
		_Shininess ("Shininess", Range (0.03, 1)) = 0.078125
		_IllumStrength("Illumin Strength", Float) = 0.2
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_AlphaTex("Alpha (G)", 2D) = "white" {}
		_BumpMap ("Normalmap", 2D) = "bump" {}
		_SpecColorTex("Specular (RGB)", 2D) = "white" {}
		_ReflectColor("Reflection Color", Color) = (0,0,0,1)
		_Cube("Reflection Cubemap", Cube) = "" { TexGen CubeReflect }
		_SpecIllumReflTex ("RefStrength (R) Illumin (G) Shininess (B)", 2D) = "white" {}
		//_MinGlowDist("Min Glow Distance", Float) = 1.5
		//_MaxGlowDist("Max Glow Distance", Float) = 5
		[HideInInspector]_SpecRamp ("Specular Ramp (R)", 2D) = "white" {}
		_RimColor ("Rim Color", Color) = (1, 1, 1, 1)
		_RimWidth ("Rim Width", Float) = 0
		//_MinRimDist("Min Rim Distance", Float) = 1.5
		//_MaxRimDist("Max Rim Distance", Float) = 5
		_Cutoff ("Alpha cutoff", Range(0,1)) = 0
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
		#pragma target 3.0
		#pragma multi_compile SHADER_QUALITY_HIGH SHADER_QUALITY_MEDIUM SHADER_QUALITY_LOW
		#pragma surface surf YSBlinnPhong alpha exclude_path:prepass nolightmap noforwardadd

		#define USE_ALPHA_CHANNEL
		#define USE_SPLIT_ALPHAMAP
#if defined(SHADER_QUALITY_HIGH) || defined(SHADER_QUALITY_MEDIUM)
		#define USE_NORMALMAP
#if defined(SHADER_QUALITY_HIGH)
		#define USE_SPECULAR
		#define USE_CUBEMAP
		#define USE_RIM
#endif
#endif
		#define USE_ILLUM
		
		#include "../../Shaders/Include/Input.cginc"
		#include "../../Shaders/Include/Lit.cginc"
		#include "../../Shaders/Include/Surf.cginc" 

		ENDCG
	}

	FallBack "Hidden/YangStudio/Role/Transparent Transparent Cutout (FallBack)"
}
