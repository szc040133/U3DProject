
Shader "Hidden/YangStudio/Image Effects/BenchmarkPostEffect" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_MaskTex ("Mask (RGB)", 2D) = "white" {}
	}
	
	CGINCLUDE
	#include "UnityCG.cginc"

	sampler2D _MainTex;	
	sampler2D _MaskTex;
	half4 _MaskTex_ST;


	struct v2f_simple {
		half4 pos : SV_POSITION;
		half2 uv : TEXCOORD0;
	};

			
	v2f_simple vert (appdata_img v) {
		v2f_simple o;		
		o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
		o.uv = TRANSFORM_TEX(v.texcoord, _MaskTex);
		return o; 
	}	
						
	fixed4 frag ( v2f_simple i ) : COLOR {
		return tex2D(_MaskTex, i.uv);
	} 
				
	ENDCG
	

	SubShader {
		ZTest Off Cull Off ZWrite Off 
		Fog { Mode off }  
	  
		// 0
		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest 	
			ENDCG	 
		}
	}
}
