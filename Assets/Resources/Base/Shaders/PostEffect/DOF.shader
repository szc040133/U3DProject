
Shader "Hidden/YangStudio/Image Effects/DOF" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Blur ("Bloom (RGB)", 2D) = "black" {}
	}
	
	CGINCLUDE

	#include "UnityCG.cginc"

	sampler2D _MainTex;
	sampler2D_float _CameraDepthTexture;
	sampler2D _Blur;
		
	uniform half4 _MainTex_TexelSize;
	uniform fixed4 _Parameter; 

	#define FOCAL_DISTANCE _Parameter.x
	#define TRANS_DISTANCE _Parameter.y
	uniform half4 _OffsetsA;
	uniform half4 _OffsetsB;

	struct v2f_simple {
		half4 pos : SV_POSITION;
		half4 uv : TEXCOORD0;
	};
		
	struct v2f_tap {
		float4 pos : SV_POSITION;
		half2 uv20 : TEXCOORD0;
		half2 uv21 : TEXCOORD1;
		half2 uv22 : TEXCOORD2;
		half2 uv23 : TEXCOORD3;
	};	

	struct v2f_withBlurCoords {
		half4 pos : SV_POSITION;
		half2 uv20 : TEXCOORD0;
		half2 uv21 : TEXCOORD1;
		half2 uv22 : TEXCOORD2;
		half2 uv23 : TEXCOORD3;
	};	
		
	v2f_simple vertDOF (appdata_img v) {
		v2f_simple o;
		o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
        o.uv = v.texcoord.xyxy;			
        #if SHADER_API_D3D9
        	if (_MainTex_TexelSize.y < 0.0)
        		o.uv.w = 1.0 - o.uv.w;
        #endif
		return o; 
	}	

	v2f_withBlurCoords vertBlur(appdata_img v) {
		v2f_withBlurCoords o;
		o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
		o.uv20 = v.texcoord + _OffsetsA.xy;
		o.uv21 = v.texcoord + _OffsetsA.zw;
		o.uv22 = v.texcoord + _OffsetsB.xy;
		o.uv23 = v.texcoord + _OffsetsB.zw;
		return o;
	}

	fixed4 fragDOFBg ( v2f_simple i ) : COLOR {
		fixed4 color = tex2D(_MainTex, i.uv.xy);
		fixed4 blur = tex2D(_Blur, i.uv.zw);

		float d = SAMPLE_DEPTH_TEXTURE (_CameraDepthTexture, i.uv.xy);
		d = LinearEyeDepth (d);
		float f = d - FOCAL_DISTANCE;
		f = clamp(f/TRANS_DISTANCE, 0, 1);
		return lerp(color, blur, f);
	}
						
	fixed4 fragDOFBgFg ( v2f_simple i ) : COLOR {
		fixed4 color = tex2D(_MainTex, i.uv.xy);
		fixed4 blur = tex2D(_Blur, i.uv.zw);

		float d = SAMPLE_DEPTH_TEXTURE (_CameraDepthTexture, i.uv.xy);
		d = LinearEyeDepth (d);
		float f = 0;
		if(d < FOCAL_DISTANCE)
			f = FOCAL_DISTANCE - d;
		else
			f = d - FOCAL_DISTANCE;
		f = min(f/TRANS_DISTANCE, 1);
		return lerp(color, blur, f);
	}

	fixed4 fragBlur(v2f_withBlurCoords i) : COLOR{
		fixed4 color = tex2D(_MainTex, i.uv20);
		color += tex2D(_MainTex, i.uv21);
		color += tex2D(_MainTex, i.uv22);
		color += tex2D(_MainTex, i.uv23);
		return color * 0.25;
	}
			
	ENDCG
	
	SubShader {
	  ZTest Always Cull Off ZWrite Off Blend Off
	  Fog { Mode off }  
	  
	// 0
	Pass {
		CGPROGRAM
		
		#pragma vertex vertDOF
		#pragma fragment fragDOFBg
		#pragma fragmentoption ARB_precision_hint_fastest 
		
		ENDCG
		}
	// 1
	Pass {
		CGPROGRAM
		
		#pragma vertex vertDOF
		#pragma fragment fragDOFBgFg
		#pragma fragmentoption ARB_precision_hint_fastest 
		
		ENDCG
		}
	// 2
	Pass {
		CGPROGRAM
		
		#pragma vertex vertBlur
		#pragma fragment fragBlur
		#pragma fragmentoption ARB_precision_hint_fastest 
		
		ENDCG 
		}	
	}
}
