Shader "Hidden/YangStudio/Image Effects/Sun Shafts" {
	Properties {
		_MainTex ("Base", 2D) = "" {}
		_ColorBuffer ("Color", 2D) = "" {}
		_Skybox ("Skybox", 2D) = "" {}
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
	sampler2D _ColorBuffer;
	sampler2D _Skybox;
		
	uniform half4 _SunColor;
	uniform half4 _BlurRadius4;
	uniform half4 _SunPosition;
	uniform half4 _MainTex_TexelSize;	

	#define SAMPLES_FLOAT 4.0f
	#define SAMPLES_INT 4
			
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
		
	half4 fragScreen(v2f i) : SV_Target { 
		half4 colorA = tex2D (_MainTex, i.uv.xy);
		#if UNITY_UV_STARTS_AT_TOP
		half4 colorB = tex2D (_ColorBuffer, i.uv1.xy);
		#else
		half4 colorB = tex2D (_ColorBuffer, i.uv.xy);
		#endif
		half4 depthMask = saturate (colorB * _SunColor);	
		return 1.0f - (1.0f-colorA) * (1.0f-depthMask);	
	}

	half4 fragAdd(v2f i) : SV_Target { 
		half4 colorA = tex2D (_MainTex, i.uv.xy);
		#if UNITY_UV_STARTS_AT_TOP
		half4 colorB = tex2D (_ColorBuffer, i.uv1.xy);
		#else
		half4 colorB = tex2D (_ColorBuffer, i.uv.xy);
		#endif
		half4 depthMask = saturate (colorB * _SunColor);	
		return colorA + depthMask;	
	}
	
	v2f_radial vert_radial( appdata_img v ) {
		v2f_radial o;
		o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
		
		o.uv.xy =  v.texcoord.xy;
		o.blurVector = (_SunPosition.xy - v.texcoord.xy) * _BlurRadius4.xy;	
		
		return o; 
	}
	
	half4 frag_radial(v2f_radial i) : SV_Target 
	{	
		half4 color = half4(0,0,0,0);
		for(int j = 0; j < SAMPLES_INT; j++)   
		{	
			half4 tmpColor = tex2D(_MainTex, i.uv.xy);
			color += tmpColor;
			i.uv.xy += i.blurVector; 	
		}
		return color / SAMPLES_FLOAT;
	}	
	
	half TransformColor (half4 skyboxValue) {
		//return max (skyboxValue.a, _NoSkyBoxMask * dot (skyboxValue.rgb, float3 (0.59,0.3,0.11))); 		
		return dot (skyboxValue.rgb, float3 (0.59,0.3,0.11)); 
	}
	
	half4 frag_nodepth (v2f i) : SV_Target {
		#if UNITY_UV_STARTS_AT_TOP
		float4 sky = (tex2D (_Skybox, i.uv1.xy));
		#else
		float4 sky = (tex2D (_Skybox, i.uv.xy));		
		#endif
		
		float4 tex = (tex2D (_MainTex, i.uv.xy));
		
		// consider maximum radius
		#if UNITY_UV_STARTS_AT_TOP
		half2 vec = _SunPosition.xy - i.uv1.xy;
		#else
		half2 vec = _SunPosition.xy - i.uv.xy;		
		#endif
		half dist = saturate (_SunPosition.w - length (vec));			
		
		half4 outColor = 0;		
		//if (Luminance ( abs(sky.rgb - tex.rgb)) < 0.05)
		if(abs(sky.r-tex.r)<0.05 && abs(sky.g-tex.g)<0.05 && abs(sky.b-tex.b)<0.05)
			outColor = TransformColor (sky) * dist;
		
		return outColor;
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
			#pragma vertex vert_radial
			#pragma fragment frag_radial
      
			ENDCG
		}
  
		//2
		Pass {
			ZTest Always Cull Off ZWrite Off
			Fog { Mode off }      

			CGPROGRAM
      
			#pragma target 3.0
			#pragma fragmentoption ARB_precision_hint_fastest      
			#pragma vertex vert
			#pragma fragment frag_nodepth
      
			ENDCG
		} 
  
		//3
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