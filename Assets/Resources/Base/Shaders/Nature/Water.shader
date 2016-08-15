Shader "YangStudio/Nature/Water" { 
	Properties {
		_WaveScale ("Wave scale", Range (0.02,0.15)) = 0.063
		_ReflDistort ("Reflection distort", Range (0,1.5)) = 0.44
		//_RefrDistort ("Refraction distort", Range (0,1.5)) = 0.40
		[HideInInspector] _Fresnel ("Fresnel (A) ", 2D) = "gray" {}
		[HideInInspector] _BumpMap ("Normalmap ", 2D) = "bump" {}
		WaveSpeed ("Wave speed (map1 x,y; map2 x,y)", Vector) = (19,9,-16,-7)
		_DepthColor( "Depth Color", COLOR) = ( .34, .85, .92, 1)
		//_HorizonColor ("Horizon color (Simple mode)", COLOR)  = ( .172, .463, .435, 1)
		//[HideInInspector] _MainTex ("Fallback texture", 2D) = "" {}
		[HideInInspector] _ReflectionTex ("Internal Reflection", 2D) = "" {}
		//[HideInInspector] _RefractionTex ("Internal Refraction", 2D) = "" {}
	}


	Subshader { 
		Tags { "RenderType"="Opaque" "GlowType" = "NoneOpaque" }

		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest 
			//#pragma multi_compile WATER_REFRACTIVE WATER_REFLECTIVE WATER_SIMPLE
			#pragma multi_compile WATER_REFLECTIVE WATER_SIMPLE

			/*
			#if defined (WATER_REFLECTIVE) || defined (WATER_REFRACTIVE)
			#define HAS_REFLECTION 1
			#endif
			#if defined (WATER_REFRACTIVE)
			#define HAS_REFRACTION 1
			#endif
			*/
			#if defined (WATER_REFLECTIVE) 
			#define HAS_REFLECTION 1
			#endif


			#include "UnityCG.cginc"

			uniform float4 _WaveScale4;
			uniform float4 _WaveOffset;

			#if HAS_REFLECTION
			uniform float _ReflDistort;
			#endif
			//#if HAS_REFRACTION
			//uniform float _RefrDistort;
			//#endif

			struct appdata {
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct v2f {
				float4 pos : SV_POSITION;
				#if defined(HAS_REFLECTION) || defined(HAS_REFRACTION)
					float4 ref : TEXCOORD0;
					float2 bumpuv0 : TEXCOORD1;
					float2 bumpuv1 : TEXCOORD2;
					float3 viewDir : TEXCOORD3;
				#else
					float2 bumpuv0 : TEXCOORD0;
					float2 bumpuv1 : TEXCOORD1;
					float3 viewDir : TEXCOORD2;
				#endif

			};

			v2f vert(appdata v) {
				v2f o;
				o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
	
				// scroll bump waves
				float4 temp;
				temp.xyzw = v.vertex.xzxz * _WaveScale4 / unity_Scale.w + _WaveOffset;
				o.bumpuv0 = temp.xy;
				o.bumpuv1 = temp.wz;
	
				// object space view direction (will normalize per pixel)
				o.viewDir.xzy = ObjSpaceViewDir(v.vertex);
	
				#if defined(HAS_REFLECTION) || defined(HAS_REFRACTION)
				o.ref = ComputeScreenPos(o.pos);
				#endif
	
				return o;
			}

			#if defined (WATER_REFLECTIVE) || defined (WATER_REFRACTIVE)
			sampler2D _ReflectionTex;
			#endif
			sampler2D _Fresnel;
			#if defined (WATER_REFRACTIVE)		
			sampler2D _RefractionTex;
			#endif
			uniform float4 _DepthColor;
			#if defined (WATER_SIMPLE)
			//uniform float4 _HorizonColor;
			//sampler2D _MainTex;
			#endif
			sampler2D _BumpMap;

			half4 frag( v2f i ) : SV_Target {
				i.viewDir = normalize(i.viewDir);
	
				// combine two scrolling bumpmaps into one
				//#if HAS_REFLECTION
				half3 bump1 = UnpackNormal(tex2D( _BumpMap, i.bumpuv0 )).rgb;
				half3 bump2 = UnpackNormal(tex2D( _BumpMap, i.bumpuv1 )).rgb;
				half3 bump = (bump1 + bump2) * 0.5;
	
				// fresnel factor
				half fresnelFac = dot( i.viewDir, bump );
				half fresnel = UNITY_SAMPLE_1CHANNEL( _Fresnel, float2(fresnelFac,fresnelFac) );
				//#endif
	
				// perturb reflection/refraction UVs by bumpmap, and lookup colors
	
				#if HAS_REFLECTION
				float4 uv1 = i.ref; uv1.xy += bump * _ReflDistort;
				half4 refl = tex2Dproj( _ReflectionTex, UNITY_PROJ_COORD(uv1) );
				#endif
				#if HAS_REFRACTION
				float4 uv2 = i.ref; uv2.xy -= bump * _RefrDistort;
				half4 refr = tex2Dproj( _RefractionTex, UNITY_PROJ_COORD(uv2) );
				#endif
	
				// final color is between refracted and reflected based on fresnel	
				half4 color;	
				#if defined(WATER_REFRACTIVE)
				color = lerp( refr * _DepthColor, refl, fresnel );
				#endif
	
				#if defined(WATER_REFLECTIVE)
				color = lerp( _DepthColor * (1 - fresnel), refl, fresnel );
				#endif
	
				#if defined(WATER_SIMPLE)
				color = lerp(_DepthColor * (1 - fresnel) * 0.4, _DepthColor, fresnel);
				
				/*
				half3 tex1 = tex2D( _MainTex, i.bumpuv0 * 3 ).rgb;
				half3 tex2 = tex2D( _MainTex, i.bumpuv1 * 3 ).rgb;
				color.rgb = (tex1 + tex2) * 0.5 * _DepthColor.rgb;
				color.a = _DepthColor.a;
				*/

				#endif
	
				return color;
			}
			ENDCG

		}
	}

}
