Shader "YangStudio/FX/Dissolve/Specular" {
	Properties {
		_Color ("Main Color", Color) = (1,1,1,1)
		_SpecColor ("Specular Color", Color) = (0.5, 0.5, 0.5, 1)
		_Shininess ("Shininess", Range (0.03, 1)) = 0.078125
		_Amount ("Amount", Range (0, 1)) = 0.5
		_StartAmount("StartAmount", float) = 0.1
		_Illuminate ("Illuminate", Range (0, 0.9)) = 0.5
		_Tile("Tile", float) = 1
		_DissColor ("DissColor", Color) = (1,1,1,1)
		_ColorAnimate ("ColorAnimate", vector) = (1,1,1,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
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

	
		#define USE_SPECULAR

		#include "InputDissolve.cginc"
		#include "../Include/Lit.cginc"
		#include "SurfDissolve.cginc" 


		ENDCG
	}

	FallBack "VertexLit"
}
