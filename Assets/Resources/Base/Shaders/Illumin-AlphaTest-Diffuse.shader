Shader "YangStudio/Self-Illumin/Transparent Cutout" {
	Properties {
		_Color ("Main Color", Color) = (1,1,1,1)
		_IllumStrength("Illumin Strength", Float) = 0.2
		_MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
		_SpecIllumReflTex ("Illumin (G)", 2D) = "white" {}
		_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
		[MaterialEnum(On,0, Off,2)] _Cull ("2-Sided", Int) = 2
		_EmissionLM ("Emission (Lightmapper)", Float) = 0
	}

	SubShader {
		Tags { "Queue"="AlphaTest" "IgnoreProjector"="True" "RenderType"="TransparentCutout" "GlowType" = "NoneOpaque"}
		LOD 200
		Cull [_Cull]
	
		CGPROGRAM
		#pragma surface surf YSLambert alphatest:_Cutoff

		#define USE_ILLUM		
		#define USE_ALPHA_CHANNEL

		#include "Include/Input.cginc" 
		#include "Include/Surf.cginc"
		#include "Include/Lit.cginc"

		ENDCG
	} 
	FallBack "YangStudio/Transparent/Cutout/VertexLit"
}
