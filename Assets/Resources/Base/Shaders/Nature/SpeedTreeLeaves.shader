Shader "YangStudio/Nature/SpeedTree Leaves (Transparent Cutout)" {
	Properties {
		_Color ("Main Color", Color) = (1,1,1,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
	}

	SubShader {
		Tags {"Queue"="AlphaTest" "IgnoreProjector"="True" "RenderType"="TransparentCutout" "GlowType" = "NoneTransparentCutout" }
		Cull Off
		LOD 200
	
		CGPROGRAM
		#pragma surface surf Lambert alphatest:_Cutoff addshadow

		sampler2D _MainTex;
		fixed4 _Color;

		struct Input { 
			float2 uv_MainTex;
			fixed3 color : COLOR;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
			c.rgb *= IN.color;

			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}

	Fallback Off//"YangStudio/Transparent/Cutout VertexLit"
}
