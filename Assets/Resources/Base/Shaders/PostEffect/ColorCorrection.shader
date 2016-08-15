Shader "Hidden/YangStudio/Image Effects/Color Correction" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "" {}
		_RgbTex ("_RgbTex (RGB)", 2D) = "" {}
	}
	
	CGINCLUDE
	#include "UnityCG.cginc"
	
	struct v2f {
		float4 pos : POSITION;
		half2 uv : TEXCOORD0;
	};
	
	sampler2D _MainTex;	
	sampler2D _RgbTex;
	
	v2f vert( appdata_img v ) {
		v2f o;
		o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
		o.uv = v.texcoord.xy;
		return o;
	} 
	
	fixed4 frag(v2f i) : COLOR {
		fixed4 color = tex2D(_MainTex, i.uv); 
		
		color.r = tex2D(_RgbTex, half2(color.r, 0.125)).r;
		color.g = tex2D(_RgbTex, half2(color.g, 0.375)).r;
		color.b = tex2D(_RgbTex, half2(color.b, 0.625)).r;
		
		return color;
	}

	ENDCG 
	
	Subshader {
		ZTest Always Cull Off ZWrite Off
		Fog { Mode off }  

		Pass {
   			CGPROGRAM
			#pragma fragmentoption ARB_precision_hint_fastest
      		#pragma vertex vert
   			#pragma fragment frag
      		ENDCG
  		}
	}
} 