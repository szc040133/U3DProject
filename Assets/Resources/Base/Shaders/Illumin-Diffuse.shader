Shader "YangStudio/Self-Illumin/Diffuse" {
	Properties {
		_Color ("Main Color", Color) = (1,1,1,1)
		_IllumStrength("Illumin Strength", Float) = 0.2
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_SpecIllumReflTex ("Illumin (G)", 2D) = "white" {}
		[MaterialEnum(On,0, Off,2)] _Cull ("2-Sided", Int) = 2
		_EmissionLM ("Emission (Lightmapper)", Float) = 0		
	}

	SubShader {
		Tags { "RenderType"="Opaque" "GlowType" = "NoneOpaque"}
		LOD 200
		Cull [_Cull]
	
		CGPROGRAM
		#pragma surface surf YSLambert

		#define USE_ILLUM		

		#include "Include/Input.cginc" 
		#include "Include/Surf.cginc"
		#include "Include/Lit.cginc"

		ENDCG
	} 
	FallBack "Self-Illumin/VertexLit"
}
