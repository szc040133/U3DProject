Shader "Hidden/YangStudio/Role/Transparent (FallBack)" {
	Properties {
		_Color ("Main Color", Color) = (1, 1, 1, 1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		[MaterialEnum(On,0, Off,2)] _Cull ("2-Sided", Int) = 2
	}

	SubShader { 
		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"  "GlowType" = "GlowTransparent" }
		LOD 400
		Cull [_Cull]

		Pass {
			ZWrite On
			ColorMask 0
		}

	
		CGPROGRAM
		#pragma surface surf YSLambert alpha

		#define USE_ALPHA_CHANNEL		
		#include "../Include/Input.cginc"
		#include "../Include/Surf.cginc" 
		#include "../Include/Lit.cginc"

		ENDCG
	}

	Fallback "Transparent/VertexLit"
}
