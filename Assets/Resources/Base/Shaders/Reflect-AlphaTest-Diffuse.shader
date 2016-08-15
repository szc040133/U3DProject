Shader "YangStudio/Reflective/Transparent/Cutout/Diffuse" {
	Properties {
		_Color ("Main Color", Color) = (1,1,1,1)
		_MainTex ("Base (RGB) Trans (A)", 2D) = "white" {} 
		_ReflectColor("Reflection Color", Color) = (1,1,1,1)
		_Cube("Reflection Cubemap", Cube) = "_Skybox" { TexGen CubeReflect }
		_SpecIllumReflTex ("RefStrength (G)", 2D) = "white" {}
		_Cube ("Reflection Cubemap", Cube) = "_Skybox" { TexGen CubeReflect }
		_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
		[MaterialEnum(On,0, Off,2)] _Cull ("2-Sided", Int) = 2
	}

	SubShader {
		Tags { "Queue"="AlphaTest" "IgnoreProjector"="True" "RenderType"="TransparentCutout" "GlowType" = "NoneTransparentCutout" }
		LOD 200
		Cull [_Cull]
		
	
		CGPROGRAM
		#pragma surface surf YSLambert alphatest:_Cutoff

		#define USE_CUBEMAP
		#define USE_ALPHA_CHANNEL

		#include "Include/Input.cginc"
		#include "Include/Surf.cginc" 
		#include "Include/Lit.cginc"

		ENDCG
	}
	
	FallBack "YangStudio/Transparent/Cutout/VertexLit"
} 
