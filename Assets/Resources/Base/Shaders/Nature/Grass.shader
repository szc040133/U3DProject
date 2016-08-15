Shader "YangStudio/Nature/Grass (Transparent Cutout)" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
	}

	SubShader {
		Tags {"Queue"="AlphaTest" "IgnoreProjector"="True" "RenderType"="TransparentCutout" "GlowType" = "NoneTransparentCutout" }
		Cull Off
		LOD 200
	
		CGPROGRAM
		#pragma surface surf Lambert alphatest:_Cutoff vertex:WaveVertex noforwardadd addshadow

		#include "TerrainEngine.cginc"
		#include "GrassAnim.cginc"

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
			fixed4 color : COLOR;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
			c.rgb *= IN.color.rgb;

			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}

	Fallback Off//"YangStudio/Transparent/Cutout VertexLit"
}
