Shader "Hidden/YangStudio/GlowObjects Base" {
	SubShader {

		CGINCLUDE
		#include "UnityCG.cginc"
		#include "Lighting.cginc"
		#include "AutoLight.cginc"

		fixed4 _Color;
		half4 _MainTex_ST;
		sampler2D _AlphaTex;
		sampler2D _BumpMap;
		sampler2D _SpecColorTex;
		sampler2D _SpecIllumReflTex;
		sampler2D _SpecRamp;
		half _Shininess;
		half _MinGlowDist;
		half _MaxGlowDist;

		struct v2f {
			float4 pos : SV_POSITION;
			half2 texcoord : TEXCOORD0;
			fixed3 lightDir : TEXCOORD1;
			half4 viewDir : TEXCOORD2;
		};

		v2f vert(appdata_full v) {
			v2f o;
			o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
			o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);

			TANGENT_SPACE_ROTATION;
			o.lightDir = mul(rotation, ObjSpaceLightDir(v.vertex));
			o.viewDir.xyz = mul(rotation, ObjSpaceViewDir(v.vertex));
			float3 viewpos = mul(UNITY_MATRIX_MV, v.vertex).xyz;
			o.viewDir.w = 1 - saturate((-viewpos.z - _MinGlowDist) / (_MaxGlowDist - _MinGlowDist));
			return o;
		}

		fixed4 fragColor(v2f i) {
			i.viewDir = normalize(i.viewDir);

			fixed3 normal = UnpackNormal(tex2D(_BumpMap, i.texcoord));
			normal.y = -normal.y;

			fixed4 SpecColor = tex2D(_SpecColorTex, i.texcoord);
			fixed4 specIllumRefl = tex2D(_SpecIllumReflTex, i.texcoord);
			fixed gloss = specIllumRefl.r;
			half specular = specIllumRefl.b * _Shininess;

			half3 h = normalize(i.lightDir + i.viewDir.xyz);
			float nh = max(0, dot(normal, h));
			float spec = tex2D(_SpecRamp, float2(nh, specular)).a * gloss;
			fixed4 c = _LightColor0 * SpecColor  * spec * i.viewDir.w * 2;
			return c;
		}

		fixed4 frag(v2f i) : COLOR {
			fixed4 c = fragColor(i);
			c.a = 1;
			return c;
		}

		fixed4 fragAlpha(v2f i) : COLOR {
			fixed4 c = fragColor(i);
			c.a = tex2D(_AlphaTex, i.texcoord).g * _Color.a;		
			return c;
		}
		ENDCG


		Pass {
			Name "OPAQUE"
			Tags { "LightMode" = "ForwardBase" }

			CGPROGRAM	
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			ENDCG
		}	

		Pass {
			Name "ALPHA"
			Tags { "LightMode" = "ForwardBase" }

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment fragAlpha
			#pragma fragmentoption ARB_precision_hint_fastest
			ENDCG
		}
	
	}

	FallBack Off
}
