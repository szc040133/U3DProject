Shader "Hidden/YangStudio/Role/Transparent Cutout (FallBack)" {
	Properties {
		_Color ("Main Color", Color) = (1, 1, 1, 1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_AlphaTex("Alpha (G)", 2D) = "white" {}
		_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
		[MaterialEnum(On,0, Off,2)] _Cull ("2-Sided", Int) = 2
	}

	SubShader { 
		Tags { "Queue"="AlphaTest+30" "IgnoreProjector"="True" "RenderType"="RoleTransparentCutout" "GlowType" = "GlowTransparentCutout" }
		LOD 400
		Cull [_Cull]
	
		CGPROGRAM
		#pragma surface surf YSLambert alphatest:_Cutoff

		#define USE_ALPHA_CHANNEL
		#define USE_SPLIT_ALPHAMAP			
		#include "../Include/Input.cginc"
		#include "../Include/Surf.cginc" 
		#include "../Include/Lit.cginc"

		ENDCG
	}

	Fallback "YangStudio/Transparent/Cutout/VertexLit"
}
