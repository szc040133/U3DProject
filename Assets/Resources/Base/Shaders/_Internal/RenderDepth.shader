Shader "Hidden/YangStudio/Render Depth" {
	SubShader {
		Tags { "RenderType" = "Opaque" }
		Cull [_Cull]
		Fog { Mode Off }
		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct v2f {
				float4 pos : SV_POSITION;
				float2 depth : TEXCOORD0;
			};

			v2f vert(appdata_base v) {
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				//UNITY_TRANSFER_DEPTH(o.depth);
				o.depth = o.pos.zw;
				return o;
			}

			half4 frag(v2f i) : COLOR {
				//UNITY_OUTPUT_DEPTH(i.depth);
				return i.depth.x / i.depth.y;
			}
			ENDCG

		}
	}


	SubShader{
		Tags{ "RenderType" = "TransparentCutout" }
		Cull [_Cull]
		Fog { Mode Off }

		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			fixed4 _Color;
			sampler2D _MainTex;
			half4 _MainTex_ST;
			fixed _Cutoff;

			struct v2f {
				float4 pos : SV_POSITION;
				half2 texcoord : TEXCOORD0;
				float2 depth : TEXCOORD1;
			};

			v2f vert(appdata_base v) {
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
				//UNITY_TRANSFER_DEPTH(o.depth);
				o.depth = o.pos.zw;
				return o;
			}

			half4 frag(v2f i) : COLOR {
				fixed a = tex2D(_MainTex, i.texcoord).a * _Color.a;
				clip(a - _Cutoff);

				//UNITY_OUTPUT_DEPTH(i.depth);
				return i.depth.x / i.depth.y;
			}

			ENDCG
		}
	}

	SubShader {
		Tags { "RenderType" = "RoleTransparentCutout" }
		Cull [_Cull]
		Fog { Mode Off }

		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			fixed4 _Color;
			sampler2D _AlphaTex;
			half4 _AlphaTex_ST;
			fixed _Cutoff;

			struct v2f {
				float4 pos : SV_POSITION;
				half2 texcoord : TEXCOORD0;
				float2 depth : TEXCOORD1;
			};

			v2f vert(appdata_base v) {
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				o.texcoord = TRANSFORM_TEX(v.texcoord, _AlphaTex);
				//UNITY_TRANSFER_DEPTH(o.depth);
				o.depth = o.pos.zw;
				return o;
			}

			half4 frag(v2f i) : COLOR{
				fixed a = tex2D(_AlphaTex, i.texcoord).g * _Color.a;
				clip(a - _Cutoff);

				//UNITY_OUTPUT_DEPTH(i.depth);
				return i.depth.x / i.depth.y;
			}

			ENDCG
		}
	}
				
}
