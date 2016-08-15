// Amplify Color - Advanced Color Grading for Unity Pro
// Copyright (c) Amplify Creations, Lda <info@amplify.pt>

Shader "Hidden/YangStudio/Image Effects/Amplify Color Base" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "" {}
	}

	CGINCLUDE
	#include "UnityCG.cginc"

	sampler2D _MainTex;	 
	sampler2D _RgbTex;

	struct v2f {
		float4 pos : SV_POSITION;
		float2 uv : TEXCOORD0;
	};

	v2f vert( appdata_img v ) { 
		v2f o; 
		o.pos = mul( UNITY_MATRIX_MVP, v.vertex );
		o.uv = v.texcoord.xy;
		return o;
	}


	float4 frag( v2f i ) : SV_Target { 
		// fetch
		float4 color = tex2D( _MainTex, i.uv );
		// clamp
		color.rgb = min( ( 0.999 ).xxx, color.rgb ); // dev/hw compatibility

		//apply
		const float4 coord_scale = float4( 0.0302734375, 0.96875, 31.0, 0.0 );
		const float4 coord_offset = float4( 0.00048828125, 0.015625, 0.0, 0.0 );
		const float2 texel_height_X0 = float2( 0.03125, 0.0 );
		float3 coord = color.rgb * coord_scale + coord_offset;
		float3 coord_floor = floor( coord + 0.5 );
		float2 coord_bot = coord.xy + coord_floor.zz * texel_height_X0;
		color.rgb = tex2D( _RgbTex, coord_bot ).rgb;

		return color;
	}
	ENDCG

	
	Subshader {
		ZTest Off Cull Off ZWrite Off Blend Off
		Fog { Mode off }

		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest 
			
			ENDCG
		}
	}

}
