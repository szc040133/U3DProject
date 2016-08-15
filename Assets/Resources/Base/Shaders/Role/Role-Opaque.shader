Shader "YangStudio/Role/Opaque" {
	Properties {
		_Color ("Main Color", Color) = (1, 1, 1, 1)	
		_SpecIntensity("Specular Intensity", Float) = 1.0
		_Shininess ("Shininess", Range (0.03, 1)) = 0.078125
		_IllumStrength("Illumin Strength", Float) = 0
		_MainTex ("Base (RGB)", 2D) = "white" {}
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
		[MaterialEnum(On,0, Off,2)] _Cull ("2-Sided", Int) = 2
	}

	SubShader { 
		Tags { "Queue"="AlphaTest+30" "RenderType" = "Opaque" "GlowType" = "GlowOpaque" }
		LOD 400
		Cull [_Cull]
	
		CGPROGRAM
		#pragma target 3.0
		#pragma multi_compile SHADER_QUALITY_HIGH SHADER_QUALITY_MEDIUM SHADER_QUALITY_LOW
		#pragma surface surf YSBlinnPhong exclude_path:prepass nolightmap noforwardadd

#if defined(SHADER_QUALITY_HIGH) || defined(SHADER_QUALITY_MEDIUM)
		#define USE_NORMALMAP
#if defined(SHADER_QUALITY_HIGH)
		#define USE_SPECULAR
		#define USE_CUBEMAP
		#define USE_RIM
#endif
#endif
		#define USE_ILLUM
		
		#include "../Include/Input.cginc"
		#include "../Include/Surf.cginc" 
		#include "../Include/Lit.cginc"

		ENDCG
	}

	FallBack "YangStudio/Diffuse"
}
