Shader "YangStudio/Nature/Advanced Water" { 
	Properties {
		_WaveScale ("Wave scale", Range (0.02,0.15)) = 0.063
		_ReflDistort ("Reflection distort", Range (0,1.5)) = 0.44
		[HideInInspector] _Fresnel ("Fresnel (A) ", 2D) = "gray" {}
		[HideInInspector] _BumpMap ("Normalmap ", 2D) = "bump" {}
		WaveSpeed ("Wave speed (map1 x,y; map2 x,y)", Vector) = (19,9,-16,-7)
		_DepthColor( "Depth Color", COLOR) = ( .34, .85, .92, 1)
		_TransparencyDepth ("Transparency Depth", Float) = 1
		_SpecIntensity("Specular Intensity", Range(0,10)) = 1
		_Shininess("Shininess", Range(0.01, 1)) = 1
		_SpecColor("Specular Color", Color) = (1, 1, 1, 1)
		[HideInInspector] _ReflectionTex ("Internal Reflection", 2D) = "" {}
		[HideInInspector] _SpecRamp("Specular Ramp (R)", 2D) = "white" {}
	}


	Subshader { 
		Tags { "Queue" = "Transparent-120" "IgnoreProjector" = "True" "RenderType" = "Transparent" "GlowType" = "NoneTransparent" }
		Blend SrcAlpha OneMinusSrcAlpha
		ZWrite Off

		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest 
			#pragma multi_compile WATER_DEPTH WATER_SIMPLE

			#include "UnityCG.cginc"

			uniform float4 _WaveScale4;
			uniform float4 _WaveOffset;
			uniform float _ReflDistort;

			fixed4 _LightColor;
			fixed4 _LightDir;
			fixed4 _SpecColor;
			fixed _SpecIntensity;
			half _Shininess;

			sampler2D_float _CameraDepthTexture;

			struct appdata {
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct v2f {
				float4 pos : SV_POSITION;
				float depthView : TEXCOORD0;
				float4 ref : TEXCOORD01;
				half2 bumpuv0 : TEXCOORD2;
				half2 bumpuv1 : TEXCOORD3;
				fixed3 lightDir : TEXCOORD4;
				float3 viewDir : TEXCOORD5;
			};

			v2f vert(appdata v) {
				v2f o;
				o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
				o.depthView = -mul(UNITY_MATRIX_MV, v.vertex).z;
	
				half4 temp;
				temp.xyzw = v.vertex.xzxz * _WaveScale4 / unity_Scale.w + _WaveOffset;
				o.bumpuv0 = temp.xy;
				o.bumpuv1 = temp.wz;
	
				o.viewDir.xzy = ObjSpaceViewDir(v.vertex);
				o.lightDir.xzy = _LightDir.xyz;
				o.ref = ComputeScreenPos(o.pos);
	
				return o;
			}

			sampler2D _ReflectionTex;
			sampler2D _Fresnel;
			fixed4 _DepthColor;
			fixed _TransparencyDepth;
			sampler2D _BumpMap;
			sampler2D _SpecRamp;

			half4 frag( v2f i ) : SV_Target {
				i.viewDir = normalize(i.viewDir);
	
				half3 bump1 = UnpackNormal(tex2D( _BumpMap, i.bumpuv0 )).rgb;
				half3 bump2 = UnpackNormal(tex2D( _BumpMap, i.bumpuv1 )).rgb;
				half3 bump = (bump1 + bump2) * 0.5;

				half fresnelFac = dot( i.viewDir, bump );
				half fresnel = UNITY_SAMPLE_1CHANNEL( _Fresnel, float2(fresnelFac,fresnelFac) );
	

				float4 uv1 = i.ref; uv1.xy += bump * _ReflDistort;
				half4 refl = tex2Dproj( _ReflectionTex, UNITY_PROJ_COORD(uv1) );

				half4 color;	
				color = lerp( _DepthColor * (1 - fresnel), refl, fresnel );
	
				half3 h = normalize(i.lightDir + i.viewDir);
				float nh = max(0, dot(bump, h));
				float spec = tex2D(_SpecRamp, float2(nh, _Shininess)).a;
				color.rgb += _SpecColor.rgb * spec * _LightColor.rgb * _SpecIntensity;
				color.a = 1;


#if defined(WATER_DEPTH)
				float d = tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.ref)).r;
				d = LinearEyeDepth(d);
				fixed alpha = clamp((d - i.depthView)/ _TransparencyDepth, 0, 1);
				color.a = alpha;
#endif
	
				return color;
			}
			ENDCG

		}
	}

}
