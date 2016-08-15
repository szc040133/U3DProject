Shader "YangStudio/Reflective/Diffuse" {
	Properties {
		_Color ("Main Color", Color) = (1,1,1,1)
		_MainTex ("Base (RGB)", 2D) = "white" {} 
		_ReflectColor("Reflection Color", Color) = (1,1,1,1)
		_Cube("Reflection Cubemap", Cube) = "_Skybox" { TexGen CubeReflect }
		_SpecIllumReflTex ("RefStrength (R)", 2D) = "white" {}	
		[MaterialEnum(On,0, Off,2)] _Cull ("2-Sided", Int) = 2
	}

	SubShader {
		Tags { "RenderType"="Opaque" "GlowType" = "NoneOpaque" }
		LOD 200
		Cull [_Cull]
		
	
		CGPROGRAM
		#pragma surface surf YSLambert

		#define USE_CUBEMAP

		#include "Include/Input.cginc"
		#include "Include/Surf.cginc" 
		#include "Include/Lit.cginc" 

		ENDCG
	}
	
	FallBack "Reflective/VertexLit"
} 
