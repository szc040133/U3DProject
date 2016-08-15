Shader "YangStudio/Nature/Grass (Self-Illumin Transparent Cutout)" {
	Properties {
		_IllumStrength("Illumin Strength", Float) = 1 
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_SpecIllumReflTex ("Illumin (G)", 2D) = "white" {}
		_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
		_EmissionLM ("Emission (Lightmapper)", Float) = 0
	}

	SubShader {
		Tags {"Queue"="AlphaTest" "IgnoreProjector"="True" "RenderType"="TransparentCutout" "GlowType" = "NoneTransparentCutout" }
		Cull Off
		LOD 200
	
		CGPROGRAM
		#pragma surface surf Lambert alphatest:_Cutoff vertex:WaveVertex noforwardadd addshadow

		#include "TerrainEngine.cginc"
		#include "GrassAnim.cginc"

		fixed _IllumStrength;
		sampler2D _MainTex;
		sampler2D _SpecIllumReflTex;

		struct Input {
			float2 uv_MainTex;
			fixed4 color : COLOR;
		};

 
		void surf (Input IN, inout SurfaceOutput o) {
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
			c.rgb *= IN.color.rgb;

			o.Albedo = c.rgb;
			o.Alpha = c.a;

			o.Emission = c.rgb * tex2D(_SpecIllumReflTex, IN.uv_MainTex).g * _IllumStrength;
		}
		ENDCG
	}

	Fallback Off//"YangStudio/Transparent/Cutout VertexLit"
}

