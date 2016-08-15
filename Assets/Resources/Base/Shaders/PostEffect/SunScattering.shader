Shader "Hidden/YangStudio/Image Effects/Sun Scattering" {
	Properties {
		_MainTex ("Base", 2D) = "" {}
	}
	
	CGINCLUDE
				
	#include "UnityCG.cginc"
	
	struct v2f {
		float4 pos : SV_POSITION;
		float2 uv : TEXCOORD0;
#if UNITY_UV_STARTS_AT_TOP
		float2 uv1 : TEXCOORD1;
#endif		
	};
		
	struct v2f_radial {
		float4 pos : SV_POSITION;
		float2 uv : TEXCOORD0;
		float2 blurVector : TEXCOORD1;
	};
		
	sampler2D _MainTex;	
	uniform half4 _SunColor;
	uniform half4 _SunPosition;
	uniform half4 _MainTex_TexelSize;	

		
	v2f vert( appdata_img v ) {
		v2f o;
		o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
		o.uv = v.texcoord.xy;
		
#if UNITY_UV_STARTS_AT_TOP
		o.uv1 = v.texcoord.xy;
		if (_MainTex_TexelSize.y < 0)
			o.uv1.y = 1-o.uv1.y;
#endif				
		
		return o;
	}
		
	fixed4 fragScreen(v2f i) : SV_Target { 
		fixed4 colorA = tex2D (_MainTex, i.uv.xy);
#if UNITY_UV_STARTS_AT_TOP
		half2 vec = _SunPosition.xy - i.uv1.xy;
#else
		half2 vec = _SunPosition.xy - i.uv.xy;
#endif
		fixed4 colorB = saturate(_SunPosition.w - length(vec));
		fixed4 depthMask = saturate (colorB * _SunColor);
		return 1.0f - (1.0f-colorA) * (1.0f-depthMask);	
	}

	fixed4 fragAdd(v2f i) : SV_Target {
		fixed4 colorA = tex2D (_MainTex, i.uv.xy);
#if UNITY_UV_STARTS_AT_TOP
		half2 vec = _SunPosition.xy - i.uv1.xy;
#else
		half2 vec = _SunPosition.xy - i.uv.xy;
#endif
		fixed4 colorB = saturate(_SunPosition.w - length(vec));
		fixed4 depthMask = saturate (colorB * _SunColor);
		return colorA + depthMask;	
	}
	
	ENDCG
	


	Subshader {
		//0
		Pass {
			ZTest Always Cull Off ZWrite Off
			Fog { Mode off }      

			CGPROGRAM
      
			#pragma fragmentoption ARB_precision_hint_fastest 
			#pragma vertex vert
			#pragma fragment fragScreen
      
			ENDCG
		}
 
		//1
		Pass {
			ZTest Always Cull Off ZWrite Off
			Fog { Mode off }      

			CGPROGRAM
      
			#pragma fragmentoption ARB_precision_hint_fastest 
			#pragma vertex vert
			#pragma fragment fragAdd
      
			ENDCG
		} 
	}

	Fallback off
	
} // shader