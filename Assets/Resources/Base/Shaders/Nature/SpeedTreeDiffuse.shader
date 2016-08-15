﻿Shader "YangStudio/Nature/SpeedTree Diffuse" {
	Properties {
		_Color ("Main Color", Color) = (1,1,1,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}

	SubShader {
		Tags{ "RenderType" = "Opaque" }
		LOD 200
	
		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _MainTex;
		fixed4 _Color;

		struct Input { 
			float2 uv_MainTex;
			fixed3 color : COLOR;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
			c.rgb *= _Color.rgb * IN.color;

			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}

	Fallback "VertexLit"
}
