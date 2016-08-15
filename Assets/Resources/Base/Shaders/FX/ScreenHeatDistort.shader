Shader "YangStudio/FX/Distort/Screen Heat Distortion" {
    Properties {
		_NoiseTex("Noise Texture (RG)", 2D) = "white" {}
		_AlphaTex("Alpha Texture (G)", 2D) = "white" {}
		_HeatTime("Heat Time", range(0, 1.5)) = 1
		_HeatForce("Heat Force", range(0, 0.3)) = 0.1
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
				float _HeatForce;
				float _HeatTime;

				struct data {
					float4 vertex : POSITION;
					fixed4 color : COLOR;
					float4 texcoord : TEXCOORD0;
				};

				struct v2f {
					float4 position : POSITION;
					fixed4 color : COLOR;
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
					o.color = i.color;
					return o;
				}


				half4 frag( v2f i ) : COLOR {
					float4 screenPos = i.screenPos;

					half4 offsetColor1 = tex2D(_NoiseTex, i.uv2 + _Time.xz*_HeatTime);
					half4 offsetColor2 = tex2D(_NoiseTex, i.uv2 - _Time.yx*_HeatTime);
					screenPos.x += ((offsetColor1.r + offsetColor2.r) - 1) * _HeatForce;
					screenPos.y += ((offsetColor1.g + offsetColor2.g) - 1) * _HeatForce;

					half4 col = tex2Dproj( _SceneTex, UNITY_PROJ_COORD(screenPos) );				
					half alpha = tex2D(_AlphaTex, i.uv).g;
					col.rgb *= i.color.rgb;				
					col.a = i.color.a * alpha;

					return col;
				}
				ENDCG
			}
		}
	}
}
