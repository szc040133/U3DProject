Shader "Hidden/YangStudio/Image Effects/ColorSaturation" {
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
	fixed _Saturation;
	
	v2f vert( appdata_img v ) {
		v2f o;
		o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
		o.uv = v.texcoord.xy;
		return o;
	} 

	fixed4 frag(v2f i) : COLOR {
		fixed4 color = tex2D(_MainTex, i.uv);
		fixed lum = Luminance(color.rgb);
		color.rgb = lerp(fixed3(lum,lum,lum), color.rgb, _Saturation);
	
		return color;
	}

	ENDCG 
	
	Subshader {
		ZTest Always Cull Off ZWrite Off
		Fog { Mode off }  

		//0 
		Pass {
   			CGPROGRAM
			#pragma fragmentoption ARB_precision_hint_fastest
      		#pragma vertex vert
   			#pragma fragment frag
      		ENDCG
  		}
	}

} 