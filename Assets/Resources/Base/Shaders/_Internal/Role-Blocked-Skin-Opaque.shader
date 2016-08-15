Shader "Hidden/YangStudio/Role/Blocked Skin Opaque" {
	Properties {
		_ThroughColor("Through Color", Color) = (0.9294, 0.8275, 0.051, 1)
		_Color("Main Color", Color) = (1, 1, 1, 1)
		_SpecIntensity("Specular Intensity", Float) = 0
		_Shininess("Shininess", Range(0.03, 1)) = 0.078125
		_MainTex("Base (RGB)", 2D) = "white" {}
		_BumpMap("Normalmap", 2D) = "bump" {}
		_SpecColorTex("Specular (RGB)", 2D) = "white" {}
		_SpecIllumReflTex("Skin Depth (G) Shininess (B)", 2D) = "white" {}
		[HideInInspector]_LookupSkinDiffuseSpec("Skin Diffuse Falloff(RGB)", 2D) = "gray" {}
		_ScatteringOffset("Scattering Boost", Range(0,1)) = 0.0
		_ScatteringPower("Scattering Power", Range(0,2)) = 1.0
		[HideInInspector]_SpecRamp("Specular Ramp (R)", 2D) = "white" {}
		_RimColor("Rim Color", Color) = (1, 1, 1, 1)
		_RimWidth("Rim Width", Float) = 0
	}

	SubShader { 
		Tags { "Queue"="AlphaTest+20" "RenderType" = "Opaque" "GlowType" = "NoneOpaque" }
		LOD 400

		UsePass "Hidden/YangStudio/Role/Blocked Opaque/BLOCKED"
	
		CGPROGRAM
		#pragma multi_compile SHADER_QUALITY_HIGH SHADER_QUALITY_MEDIUM SHADER_QUALITY_LOW
		#pragma surface surf YSBlinnPhong exclude_path:prepass nolightmap noforwardadd
		
#if defined(SHADER_QUALITY_HIGH) || defined(SHADER_QUALITY_MEDIUM)
		#define USE_SKIN
		#define USE_NORMALMAP
#if defined(SHADER_QUALITY_HIGH)
		#define USE_SPECULAR
		#define USE_RIM
#endif
#endif
		
		#include "../../Shaders/Include/Input.cginc"
		#include "../../Shaders/Include/Lit.cginc"
		#include "../../Shaders/Include/Surf.cginc" 

		ENDCG
	}

	FallBack "YangStudio/Diffuse"
}
