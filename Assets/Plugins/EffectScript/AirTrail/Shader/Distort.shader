Shader "Custom/Distort" {
    Properties {
		_Brightness("Brightness", Range(1, 8)) = 1.2
        _SceneTex ("Main Texture (RG)", 2D) = "white" {}
		_NoiseTex ("Noise Texture (RG)", 2D) = "white" {}
		_Distort("Distort", Range(0, 0.03)) = 0.01
		_Alpha("Alpha", Range(0, 1)) = 0.9
	}

	Category {
		Tags { "Queue"="Transparent+10" "IgnoreProjector"="True" "RenderType"="Opaque" }
		SubShader {
			Pass {
				Name "BASE"
				Fog { Color (0,0,0,0) }
				Lighting Off
				Cull Off
				ZWrite Off
				Blend SrcAlpha OneMinusSrcAlpha


				CGPROGRAM
				// Upgrade NOTE: excluded shader from DX11 and Xbox360; has structs without semantics (struct v2f members distortion)
				#pragma exclude_renderers d3d11 xbox360
				#pragma vertex vert
				#pragma fragment frag
				#pragma fragmentoption ARB_precision_hint_fastest
				//#pragma fragmentoption ARB_fog_exp2
				#include "UnityCG.cginc"

				sampler2D _SceneTex;
				sampler2D _NoiseTex;
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
					float2 uvmain : TEXCOORD2;
				};

				v2f vert(data i)
				{
					v2f o;
					o.position = mul(UNITY_MATRIX_MVP, i.vertex);
					o.uvmain = TRANSFORM_TEX(i.texcoord, _NoiseTex);
					o.screenPos = ComputeScreenPos(o.position);
					return o;
				}


				half4 frag( v2f i ) : COLOR
				{
					float2 screenPos = i.screenPos.xy / i.screenPos.w;
					half4 offset = tex2D(_NoiseTex, i.uvmain);
					screenPos += (offset.r*2 - 1) * _Distort; 

					half4 col = tex2D( _SceneTex, screenPos )*_Brightness; 
					col.a = offset.g*offset.b*_Alpha;

					return col;
				}
				ENDCG
			}
		}
	}
}
