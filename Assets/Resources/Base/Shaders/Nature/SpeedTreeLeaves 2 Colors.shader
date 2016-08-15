Shader "YangStudio/Nature/SpeedTree Leaves (Transparent Cutout) 2 Colors" {
	Properties {
		_Color ("Outer Color", Color) = (1,1,1,1)
		_InnerColor("Inner Color", Color) = (0,0,0,1)
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
		fixed4 _InnerColor;

		struct Input { 
			float2 uv_MainTex;
			fixed3 color : COLOR;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
			c.rgb *= lerp(_InnerColor.rgb, _Color.rgb, IN.color.r);
			c.a *= _Color.a;

			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}

	Fallback Off//"YangStudio/Transparent/Cutout VertexLit"
}
