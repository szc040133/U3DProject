Shader "Hidden/YangStudio/Image Effects/Radial Blur" {
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
	half _BlurSpread;
	half _BlurRange;


	static const float samples[6] = {
		//-0.08,  
		//-0.05,  
		-0.03,  
		-0.02,  
		-0.01,  
		0.01,  
		0.02,  
		0.03,  
		//0.05,  
		//0.08  
	};
	
	v2f vert( appdata_img v ) {
		v2f o;
		o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
		o.uv = v.texcoord.xy;
		return o;
	} 
	
	fixed4 frag(v2f i) : COLOR {
		// 0.5,0.5 is the center of the screen  
		// so substracting uv from it will result in  
		// a vector pointing to the middle of the screen  
		half2 dir = 0.5 - i.uv;  
		// calculate the distance to the center of the screen  
		half dist = length(dir);  
		// normalize the direction (reuse the distance)  
		dir /= dist;  
     
		// this is the original colour of this pixel  
		// using only this would result in a nonblurred version  
		fixed4 color = tex2D(_MainTex, i.uv);
     
		half4 sum = color;  
		// take 10 additional blur samples in the direction towards  
		// the center of the screen  
		for (int s = 0; s < 6; ++s) {
			sum += tex2D(_MainTex, i.uv + dir * samples[s] * _BlurSpread);  
		}  
  
		// we have taken eleven samples  
		sum /= 7.0;  
     
		// weighten the blur effect with the distance to the  
		// center of the screen ( further out is blurred more)  
		fixed t = saturate(dist * _BlurRange);   
     
		//Blend the original color with the averaged pixels  
		return lerp(color, sum, t);  
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
