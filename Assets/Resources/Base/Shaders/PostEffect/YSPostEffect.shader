
Shader "Hidden/YangStudio/Image Effects/YSPostEffect" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	
	CGINCLUDE
	#include "UnityCG.cginc"

	sampler2D _MainTex;
#if UNITY_UV_STARTS_AT_TOP
	uniform half4 _MainTex_TexelSize;
#endif

	sampler2D _ColorBuffer;
	sampler2D _Skybox;	
	uniform half4 _SunColor;
	uniform half4 _BlurRadius4;
	uniform half4 _SunPosition;
	#define SAMPLES_FLOAT 4.0f
	#define SAMPLES_INT 4

	sampler2D_float _CameraDepthTexture;
	sampler2D _DOFBlur;
	uniform fixed4 _DOFParameter;
	#define FOCAL_DISTANCE _DOFParameter.x
	#define TRANS_DISTANCE _DOFParameter.y

	sampler2D _Bloom;
	uniform fixed4 _Parameter;
	uniform half4 _OffsetsA;
	uniform half4 _OffsetsB;
	#define ONE_MINUS_THRESHHOLD_TIMES_INTENSITY _Parameter.w
	#define THRESHHOLD _Parameter.z

	half _RadialBlurWidth;
	half _RadialBlurRange;

	sampler2D _CCRgbTex;

	fixed _VignettingIntensity;

	fixed _Saturation;


	
	struct v2f_simple {
		half4 pos : SV_POSITION;
		half4 uv : TEXCOORD0;
	};

	struct v2f_radial {
		float4 pos : SV_POSITION;
		float2 uv : TEXCOORD0;
		float2 blurVector : TEXCOORD1;
	};

	struct v2f_withMaxCoords {
		half4 pos : SV_POSITION;
		half2 uv : TEXCOORD0;
		half2 uv20 : TEXCOORD1;
		half2 uv21 : TEXCOORD2;
		half2 uv22 : TEXCOORD3;
		half2 uv23 : TEXCOORD4;
	};

	struct v2f_withBlurCoords {
		half4 pos : SV_POSITION;
		half2 uv20 : TEXCOORD0;
		half2 uv21 : TEXCOORD1;
		half2 uv22 : TEXCOORD2;
		half2 uv23 : TEXCOORD3;

	};
			
	v2f_simple vert (appdata_img v) {
		v2f_simple o;		
		o.pos = mul (UNITY_MATRIX_MVP, v.vertex);		
        o.uv = v.texcoord.xyxy;		      	
#if UNITY_UV_STARTS_AT_TOP			
        if (_MainTex_TexelSize.y < 0.0)
        	o.uv.w = 1.0 - o.uv.w;
#endif      	        	
		return o; 
	}	

	v2f_withMaxCoords vertMax(appdata_img v) {
		v2f_withMaxCoords o;
		o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
		o.uv20 = v.texcoord + _OffsetsA.xy;
		o.uv21 = v.texcoord + _OffsetsA.zw;
		o.uv22 = v.texcoord + _OffsetsB.xy;
		o.uv23 = v.texcoord + _OffsetsB.zw;
		o.uv = v.texcoord;
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

	v2f_radial vertSunShaftsRadial( appdata_img v ) {
		v2f_radial o;
		o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
		
		o.uv.xy =  v.texcoord.xy;
		o.blurVector = (_SunPosition.xy - v.texcoord.xy) * _BlurRadius4.xy;	
		
		return o; 
	}

	half4 fragSunShaftsRadial(v2f_radial i) : SV_Target {
		half4 color = half4(0,0,0,0);
		for(int j = 0; j < SAMPLES_INT; j++)   
		{	
			half4 tmpColor = tex2D(_MainTex, i.uv.xy);
			color += tmpColor;
			i.uv.xy += i.blurVector; 	
		}
		return color / SAMPLES_FLOAT;
	}	
	
	fixed TransformColor (fixed4 skyboxValue) {
		//return max (skyboxValue.a, _NoSkyBoxMask * dot (skyboxValue.rgb, float3 (0.59,0.3,0.11))); 		
		return dot (skyboxValue.rgb, fixed3 (0.59,0.3,0.11)); 
	}
	
	fixed4 fragSunShaftsMask (v2f_simple i) : SV_Target {
		fixed4 tex = tex2D (_MainTex, i.uv.xy);
		fixed4 sky = tex2D (_Skybox, i.uv.zw);			
		
		half2 vec = _SunPosition.xy - i.uv.zw;
		fixed dist = saturate (_SunPosition.w - length (vec));				
		fixed4 outColor = 0;		
		//if (Luminance ( abs(sky.rgb - tex.rgb)) < 0.05)
		if(abs(sky.r-tex.r)<0.05 && abs(sky.g-tex.g)<0.05 && abs(sky.b-tex.b)<0.05)
			outColor = TransformColor (sky) * dist;
		
		return outColor;
	}	


	fixed4 fragMax(v2f_withMaxCoords i) : COLOR{
		fixed4 color = tex2D(_MainTex, i.uv.xy);
		color = max(color, tex2D(_MainTex, i.uv20));
		color = max(color, tex2D(_MainTex, i.uv21));
		color = max(color, tex2D(_MainTex, i.uv22));
		color = max(color, tex2D(_MainTex, i.uv23));
		return saturate(color - THRESHHOLD) * ONE_MINUS_THRESHHOLD_TIMES_INTENSITY;
	}

	fixed4 fragBlur(v2f_withBlurCoords i) : COLOR{
		fixed4 color = tex2D(_MainTex, i.uv20);
		color += tex2D(_MainTex, i.uv21);
		color += tex2D(_MainTex, i.uv22);
		color += tex2D(_MainTex, i.uv23);
		return color * 0.25;
	}


	fixed4 outSunShaftsScreen(v2f_simple i, fixed4 color){ 
		fixed4 colorB = tex2D (_ColorBuffer, i.uv.zw);
		fixed4 depthMask = saturate (colorB * _SunColor);	
		return 1.0f - (1.0f-color) * (1.0f-depthMask);	
	}

	fixed4 outSunShaftsAdd(v2f_simple i, fixed4 color)  { 
		fixed4 colorB = tex2D (_ColorBuffer, i.uv.zw);
		fixed4 depthMask = saturate (colorB * _SunColor);		
		return min(color + depthMask, 1);	
	}

	fixed4 outDOFBg(v2f_simple i, fixed4 color) {
		fixed4 blur = tex2D(_DOFBlur, i.uv.zw);
		float d = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, i.uv.xy);
		d = LinearEyeDepth(d);
		float f = d - FOCAL_DISTANCE;
		f = clamp(f / TRANS_DISTANCE, 0, 1);
		return lerp(color, blur, f);
	}

	fixed4 outDOFBgFg(v2f_simple i, fixed4 color) {
		fixed4 blur = tex2D(_DOFBlur, i.uv.zw);

		float d = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, i.uv.xy);
		d = LinearEyeDepth(d);
		float f = 0;
		if (d < FOCAL_DISTANCE)
			f = FOCAL_DISTANCE - d;
		else
			f = d - FOCAL_DISTANCE;
		f = min(f / TRANS_DISTANCE, 1);
		return lerp(color, blur, f);
	}

	fixed4 outBloom(v2f_simple i, fixed4 color) {
		fixed4 blur = tex2D(_Bloom, i.uv.zw);
		return min(color + blur, (1).xxxx);
	}

	fixed4 outRadialBlur(v2f_simple i, fixed4 color) {
		half2 dir = 0.5 - i.uv.xy;
		half dist = length(dir);
		dir /= dist;
		dir *= _RadialBlurWidth;
		half4 sum = color;
		sum += tex2D(_MainTex, i.uv.xy + dir * -0.03);
		sum += tex2D(_MainTex, i.uv.xy + dir * -0.02);
		sum += tex2D(_MainTex, i.uv.xy + dir * -0.01);
		sum += tex2D(_MainTex, i.uv.xy + dir * 0.01);
		sum += tex2D(_MainTex, i.uv.xy + dir * 0.02);
		sum += tex2D(_MainTex, i.uv.xy + dir * 0.03);
		sum /= 7.0;
		fixed t = saturate(dist * _RadialBlurRange);
		return lerp(color, sum, t);
	}

	fixed4 outColorCorrectionSimple(v2f_simple i, fixed4 color) {
		color.r = tex2D(_CCRgbTex, half2(color.r, 0.125)).r;
		color.g = tex2D(_CCRgbTex, half2(color.g, 0.375)).r;
		color.b = tex2D(_CCRgbTex, half2(color.b, 0.625)).r;
		return color;
	}

	fixed4 outColorCorrectionAmplify(v2f_simple i, fixed4 color) {
		color.rgb = min((0.999).xxx, color.rgb); // dev/hw compatibility
		const float4 coord_scale = float4(0.0302734375, 0.96875, 31.0, 0.0);
		const float4 coord_offset = float4(0.00048828125, 0.015625, 0.0, 0.0);
		const float2 texel_height_X0 = float2(0.03125, 0.0);
		float3 coord = color.rgb * coord_scale.xyz + coord_offset.xyz;
		float3 coord_floor = floor(coord + 0.5);
		float2 coord_bot = coord.xy + coord_floor.zz * texel_height_X0;
		color = tex2D(_CCRgbTex, coord_bot);
		return color;
	}

	fixed4 outVignetting(v2f_simple i, fixed4 color) {
		half2 coords = (i.uv.xy - 0.5) * 2.0;
		half coordDot = dot(coords, coords);
		float mask = 1.0 - coordDot * _VignettingIntensity * 0.1;
		return color * mask;
	}

	fixed4 outColorSaturation(v2f_simple i, fixed4 color) {
		fixed lum = Luminance(color.rgb);
		return lerp(fixed4(lum, lum, lum, lum), color, _Saturation);
	}



						
	fixed4 frag ( v2f_simple i ) : COLOR {
		fixed4 color = tex2D(_MainTex, i.uv.xy);

#if defined(RB_ON) 
	color = outRadialBlur(i, color);
#endif

#if defined(DOF_BG) 
		color = outDOFBg(i, color);
#elif defined(DOF_BGFG) 
		color = outDOFBgFg(i, color);
#endif

#if defined(SS_SCREEN) 
		color = outSunShaftsScreen(i, color);
#elif defined(SS_ADD) 
		color = outSunShaftsAdd(i, color);
#endif

#if defined(BLOOM_ON) 
		color = outBloom(i, color);
#endif

#if defined(CC_SIMPLE) 
		color = outColorCorrectionSimple(i, color);
#elif defined(CC_AMPLIFY) 
		color = outColorCorrectionAmplify(i, color);
#endif
	
#if defined(VIGN_ON) 
		color = outVignetting(i, color);
#endif

#if defined(SAT_ON) 
		color = outColorSaturation(i, color);
#endif

		return color;
	} 
				
	ENDCG
	

	SubShader {
		ZTest Off Cull Off ZWrite Off 
		Fog { Mode off }  
	  
		// 0
		Pass {
			CGPROGRAM	
			#pragma target 3.0		
			#pragma multi_compile DOF_OFF DOF_BG DOF_BGFG
			#pragma multi_compile SS_OFF SS_SCREEN SS_ADD
			#pragma multi_compile BLOOM_OFF BLOOM_ON
			#pragma multi_compile CC_OFF CC_SIMPLE CC_AMPLIFY
			#pragma multi_compile VIGN_OFF VIGN_ON
			#pragma multi_compile SAT_OFF SAT_ON
			#pragma multi_compile RB_OFF RB_ON
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest 	
			ENDCG	 
		}

		// 1
		Pass {
			CGPROGRAM
			#pragma vertex vertMax
			#pragma fragment fragMax
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

		//3
		Pass {
			ZTest Always Cull Off ZWrite Off
			Fog { Mode off }      

			CGPROGRAM
      
			#pragma fragmentoption ARB_precision_hint_fastest
			#pragma vertex vertSunShaftsRadial
			#pragma fragment fragSunShaftsRadial
      
			ENDCG
		}
  
		//4
		Pass {
			ZTest Always Cull Off ZWrite Off
			Fog { Mode off }      

			CGPROGRAM
      
			#pragma target 3.0
			#pragma fragmentoption ARB_precision_hint_fastest      
			#pragma vertex vert
			#pragma fragment fragSunShaftsMask
      
			ENDCG
		} 
 

	}
}
