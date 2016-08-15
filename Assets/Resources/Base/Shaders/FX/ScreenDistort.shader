Shader "YangStudio/FX/Distort/Screen" {
    Properties {
		[HideInInSpector]_Brightness("Brightness", Range(1, 8)) = 1
		_NoiseTex ("Noise Texture (R)", 2D) = "white" {}
		_AlphaTex ("Alpha Texture (G)", 2D) = "white" {}
		_Distort("Distort", Range(0, 0.3)) = 0.1
		[HideInInSpector]_Alpha("Alpha", Range(0, 1)) = 1
	}

	Category {
		Tags { "Queue"="Transparent+10" "IgnoreProjector"="True" "RenderType"="Transparent" "GlowType" = "NoneTransparent" }
		SubShader {
			Pass {
				Name "BASE"
				//Fog { Color (0,0,0,0) }
				Lighting Off
				Cull Off
				ZWrite Off
				Blend SrcAlpha OneMinusSrcAlpha


				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#pragma fragmentoption ARB_precision_hint_fastest
				#include "UnityCG.cginc"

				sampler2D _SceneTex;
				sampler2D _AlphaTex;
				sampler2D _NoiseTex;
				float4 _AlphaTex_ST;
				float4 _NoiseTex_ST;
				float _Brightness;
				float _Distort;
				fixed _Alpha;

				struct data {
					float4 vertex : POSITION;
					float4 texcoord : TEXCOORD0;
				};

				struct v2f {
					float4 position : POSITION;
					float4 screenPos : TEXCOORD0;
					float2 uv : TEXCOORD1;
					float2 uv2 : TEXCOORD2;
				};

				v2f vert(data i) {
					v2f o;
					o.position = mul(UNITY_MATRIX_MVP, i.vertex);
					o.uv = TRANSFORM_TEX(i.texcoord, _AlphaTex);
					o.uv2 = TRANSFORM_TEX(i.texcoord, _NoiseTex);
					o.screenPos = ComputeScreenPos(o.position);
					return o;
				}


				half4 frag( v2f i ) : COLOR {
					half alpha = tex2D( _AlphaTex, i.uv).g;					
					half4 offset = tex2D(_NoiseTex, i.uv2);
					float4 screenPos = i.screenPos;
					screenPos += (offset.r*2 - 1) * _Distort; 

					half4 col = tex2Dproj( _SceneTex, UNITY_PROJ_COORD(screenPos))*_Brightness;
					col.a = alpha*_Alpha;

					return col;
				}
				ENDCG
			}
		}
	}
}
