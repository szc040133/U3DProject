Shader "Hidden/YangStudio/Image Effects/Vignetting" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "" {}
	}

	
	CGINCLUDE
	#include "UnityCG.cginc"
	
	struct v2f {
		float4 pos : POSITION;
		half2 uv : TEXCOORD0;
	};
	
	sampler2D _MainTex;	
	fixed _Intensity;
	
	v2f vert( appdata_img v ) {
		v2f o;
		o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
		o.uv = v.texcoord.xy;
		return o;
	} 
	
	fixed4 frag(v2f i) : COLOR {
		half2 coords = (i.uv - 0.5) * 2.0;
		half coordDot = dot(coords, coords);
		float mask = 1.0 - coordDot * _Intensity * 0.1;
		
		fixed4 color = tex2D(_MainTex, i.uv);		
		return color * mask;	
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