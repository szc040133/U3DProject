Shader "YangStudio/FX/Colored Rim Additive" {
	Properties {	
		_AlphaTex ("Alpha (A)", 2D) = "white" {}	
		_RimColor ("Rim Color", Color) = (1, 1, 1, 1)
		_RimWidth("Rim Width", Float) = 1.5
		[MaterialEnum(On,0, Off,2)] _Cull ("2-Sided", Int) = 2
	}

	Category {
		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"  "GlowType" = "NoneTransparent" }
		Cull [_Cull]
		ZWrite Off 
		Blend SrcAlpha One

		SubShader {
			Pass {
				CGPROGRAM  
				#include "UnityCG.cginc"
				#pragma vertex vert 
				#pragma fragment frag

				fixed4 _RimColor;
				sampler2D _AlphaTex;		
				fixed _RimWidth;

				struct appdata_t {
					float4 vertex : POSITION;
					fixed3 normal : NORMAL;
					fixed4 color : COLOR;
					float2 texcoord : TEXCOORD0;
				};

				struct v2f {
					float4 pos : SV_POSITION;
					half2 uv : TEXCOORD0;
					fixed4 color : COLOR;
				};

				v2f vert(appdata_t v) {
					v2f o;
					o.pos = mul(UNITY_MATRIX_MVP, v.vertex);

					o.uv = v.texcoord;

					float3 viewDir = normalize(ObjSpaceViewDir(v.vertex));
					fixed rim = 1.0 - abs(dot(viewDir, v.normal));
					rim *= _RimWidth;
					rim *= rim;
					o.color = rim * _RimColor * v.color;
					return o;
				}

				fixed4 frag(v2f i) : COLOR {
					fixed4 c = i.color;
					c.a *= tex2D(_AlphaTex, i.uv).a;
					return c;
				}
				ENDCG
			}			
		}
	}
}
