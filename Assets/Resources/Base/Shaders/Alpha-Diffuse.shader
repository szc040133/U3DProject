Shader "YangStudio/Transparent/Diffuse" {
	Properties {
		_Color ("Main Color", Color) = (1,1,1,1)
		_MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
		[MaterialEnum(On,0, Off,2)] _Cull ("2-Sided", Int) = 2
	}

	SubShader {
		Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "GlowType" = "NoneTransparent" }
		LOD 200
		Cull [_Cull]

		CGPROGRAM
		#pragma surface surf YSLambert alpha

		#define USE_ALPHA_CHANNEL	

		#include "Include/Input.cginc"
		#include "Include/Surf.cginc"
		#include "Include/Lit.cginc"

		ENDCG
	}

	Fallback "Transparent/VertexLit"
}
