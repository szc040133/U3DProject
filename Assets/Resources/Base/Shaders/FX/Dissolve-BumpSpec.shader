Shader "YangStudio/FX/Dissolve/Bumped Specular" {
	Properties {
		_Color ("Main Color", Color) = (1,1,1,1)
		_Shininess ("Shininess", Range (0.03, 1)) = 0.078125
		_Amount ("Amount", Range (0, 1)) = 0.5
		_StartAmount("StartAmount", float) = 0.1
		_Illuminate ("Illuminate", Range (0, 0.9)) = 0.5
		_Tile("Tile", float) = 1
		_DissColor ("DissColor", Color) = (1,1,1,1)
		_ColorAnimate ("ColorAnimate", vector) = (1,1,1,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_BumpMap ("Normalmap", 2D) = "bump" {}
		_SpecIllumReflTex ("Glossiness (R) Shininess (B)", 2D) = "white" {}
		[HideInInspector]_SpecRamp ("Specular Ramp (R)", 2D) = "white" {}
		_DissolveTex ("DissolveSrc (R)", 2D) = "white" {} 
	}

	SubShader { 
		Tags { "RenderType"="Opaque" "GlowType" = "NoneOpaque" }
		LOD 400
		Cull off
	
	
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surfDissolve YSBlinnPhong addshadow
		#pragma fragmentoption ARB_precision_hint_fastest

	
		#define USE_NORMALMAP
		#define USE_SPECULAR

		#include "InputDissolve.cginc"
		#include "../Include/Lit.cginc"
		#include "SurfDissolve.cginc" 

		ENDCG
	}

	FallBack "Specular"
}
