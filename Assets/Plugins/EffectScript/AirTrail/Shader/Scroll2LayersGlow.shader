Shader "Custom/Scroll 2 Layers Glow" {
	Properties {
		_MainTex ("Base layer (RGB)", 2D) = "white" {}
		_DetailTex ("2nd layer (RGB)", 2D) = "white" {}
		_Scroll2X ("2nd layer scroll speed X", Float) = 1.0
		_Scroll2Y ("2nd layer scroll speed Y", Float) = 0.0
		_Color("Color", Color) = (1,1,1,1)
	}

	SubShader {
		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
	
		Blend One One
		Cull Off Lighting Off ZWrite Off Fog { Color (0,0,0,0) }
	
		LOD 100
	
	
	
		CGINCLUDE
		#include "UnityCG.cginc"
		sampler2D _MainTex;
		sampler2D _DetailTex;

		float4 _MainTex_ST;
		float4 _DetailTex_ST;
			
		float _Scroll2X;
		float _Scroll2Y;
		fixed4 _Color;
	
	
		struct v2f {
			float4 pos : SV_POSITION;
			float4 uv : TEXCOORD0;
		};

	
		v2f vert (appdata_full v)
		{
			v2f o;
			o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
			o.uv.xy = TRANSFORM_TEX(v.texcoord.xy,_MainTex);
			o.uv.zw = TRANSFORM_TEX(v.texcoord.xy,_DetailTex) + frac(float2(_Scroll2X, _Scroll2Y) * _Time);
	
			return o;
		}
		ENDCG


		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest		
			fixed4 frag (v2f i) : COLOR
			{
				fixed4 o;
				fixed4 tex = tex2D (_MainTex, i.uv.xy);
				fixed4 tex2 = tex2D (_DetailTex, i.uv.zw);
			
				o = tex * tex2 * _Color;
			
				return o;
			}
			ENDCG 
		}	
	}
}
