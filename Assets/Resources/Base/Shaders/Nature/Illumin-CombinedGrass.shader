Shader "Hidden/YangStudio/Nature/CombinedGrass (Self-Illumin Transparent Cutout)" {
	Properties {
		_IllumStrength("Illumin Strength", Float) = 1
		_MainTex("Base (RGB)", 2D) = "white" {}
		_SpecIllumReflTex("Illumin (G)", 2D) = "white" {}
		_LightMap("LightMap(RGB)", 2D) = "black" {}
		_Cutoff("Alpha cutoff", Range(0,1)) = 0.5
	}

	SubShader {
		Tags { "Queue" = "AlphaTest" "IgnoreProjector" = "True" "RenderType" = "TransparentCutout" "GlowType" = "NoneTransparentCutout" }
		Cull Off

		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest

			#include "UnityCG.cginc"
			#include "TerrainEngine.cginc"
			#include "GrassAnim.cginc"

			fixed _IllumStrength;
			sampler2D _MainTex;
			sampler2D _SpecIllumReflTex;
			sampler2D _LightMap;
			fixed _Cutoff;


			struct appdata_t {
				float4 vertex : POSITION;
				float4 tangent : TANGENT;
				fixed4 color : COLOR;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD1;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				fixed4 color : COLOR;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD1;
				float4 test : TEXCOORD2;
			};


			v2f vert(appdata_t v) {
				v2f o;
				v.vertex = AnimateGrassHQ(v.vertex, v.texcoord.y / 10);
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);		 	
				o.color = v.color;
				o.texcoord = v.texcoord;
				o.texcoord2 = v.texcoord2 * v.tangent.xy + v.tangent.zw;
				o.test = v.tangent;
				return o;
			}

			fixed4 frag(v2f i) : SV_Target {
				fixed4 c = tex2D(_MainTex, i.texcoord);
				clip(c.a - _Cutoff);

				c *= i.color;
				fixed3 emission = c.rgb * tex2D(_SpecIllumReflTex, i.texcoord).g * _IllumStrength;

				fixed4 lmtex = tex2D(_LightMap, i.texcoord2);
				c.rgb *= lmtex.rgb * 2;
				c.rgb += emission;

				return c;
			}


			ENDCG
		}
	}
}
