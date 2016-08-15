Shader "Hidden/YangStudio/GlowObjects" {
	SubShader {
		Tags{ "RenderType" = "Opaque" "GlowType" = "GlowOpaque" }
		LOD 400
		Cull[_Cull]

		UsePass "Hidden/YangStudio/GlowObjects Base/OPAQUE"
	}

	SubShader {
		Tags{ "Queue" = "AlphaTest" "RenderType" = "TransparentCutout" "GlowType" = "GlowTransparentCutout" }
		LOD 400
		Cull[_Cull]
		AlphaTest Greater[_Cutoff]

		UsePass "Hidden/YangStudio/GlowObjects Base/ALPHA"
	}

	SubShader {
		Tags{ "Queue" = "Transparent" "RenderType" = "Transparent" "GlowType" = "GlowTransparent" }
		LOD 400
		Cull[_Cull]
		ZWrite Off
		Blend SrcAlpha OneMinusSrcAlpha

		UsePass "Hidden/YangStudio/GlowObjects Base/ALPHA"
	}


	Subshader {
		Tags { "GlowType" = "NoneOpaque" }
		Pass {
		}
	}

	Subshader {
		Tags { "Queue" = "AlphaTest" "GlowType" = "NoneTransparentCutout" }
		Pass {
			LOD 400
			Cull[_Cull]
			AlphaTest Greater[_Cutoff]
			Color[_Color]
			SetTexture[_MainTex] {
				constantColor(0,0,0,0)
				combine constant, previous * texture
			}
		}
	}

	Subshader {
		Tags { "Queue" = "Transparent" "GlowType" = "NoneTransparent" }
		Pass {
			LOD 400
			Cull[_Cull]
			Blend SrcAlpha OneMinusSrcAlpha
			Color[_Color]
			SetTexture[_MainTex] {
				constantColor(0,0,0,0)
				combine constant, previous * texture
			}
		}
	}

	FallBack Off
}
