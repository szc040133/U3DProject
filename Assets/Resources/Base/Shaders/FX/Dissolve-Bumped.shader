Shader "YangStudio/FX/Dissolve/Bumped Diffuse" {
	Properties {
		_Color ("Main Color", Color) = (1,1,1,1)
		_Amount ("Amount", Range (0, 1)) = 0.5
		_StartAmount("StartAmount", float) = 0.1
		_Illuminate ("Illuminate", Range (0, 0.9)) = 0.5
		_Tile("Tile", float) = 1
		_DissColor ("DissColor", Color) = (1,1,1,1)
		_ColorAnimate ("ColorAnimate", vector) = (1,1,1,1)
		_MainTex ("Base (RGB) Gloss (A)", 2D) = "white" {}
		_BumpMap ("Normalmap", 2D) = "bump" {}
		_DissolveTex ("DissolveSrc (R)", 2D) = "white" {}
	}

	SubShader { 
		Tags { "RenderType"="Opaque" "GlowType" = "NoneOpaque" }
		LOD 400
		Cull off
	
	
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surfDissolve YSLambert addshadow
		#pragma fragmentoption ARB_precision_hint_fastest

	
		#define USE_NORMALMAP

		#include "InputDissolve.cginc"
		#include "SurfDissolve.cginc" 
		#include "../Include/Lit.cginc"


		ENDCG
	}

	FallBack "Diffuse"
}
