#ifndef SURF_DISSOLVE_CGINC
#define SURF_DISSOLVE_CGINC


void surfDissolve (Input IN, inout YSSurfaceOutput o) {
	fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
	fixed4 c = tex;
#ifdef USE_VERTEXCOLOR
	c *= IN.color;
#endif
	o.Albedo = c.rgb * _Color.rgb;
	
	float ClipTex = tex2D (_DissolveTex, IN.uv_MainTex/_Tile).r;
	float ClipAmount = ClipTex - _Amount;
#ifdef USE_NORMALMAP
	o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
	o.Normal.y = -o.Normal.y;
#endif

	if (_Amount > 0) {
		if (ClipAmount < 0) {
			clip(-0.1);
		} else {
			if (ClipAmount < _StartAmount) {
				if (_ColorAnimate.x == 0)
					Color.x = _DissColor.x;
				else
					Color.x = ClipAmount/_StartAmount;
          
				if (_ColorAnimate.y == 0)
					Color.y = _DissColor.y;
				else
					Color.y = ClipAmount/_StartAmount;
          
				if (_ColorAnimate.z == 0)
					Color.z = _DissColor.z;
				else
					Color.z = ClipAmount/_StartAmount;

				o.Albedo  = (o.Albedo *(Color.x+Color.y+Color.z)* Color*(Color.x+Color.y+Color.z))/(1-_Illuminate);
			}
		}
	}

#ifdef USE_ALPHA_CHANNEL 
#ifdef USE_SPLIT_ALPHAMAP
	o.Alpha = tex2D(_AlphaTex, IN.uv_MainTex).g * _Color.a;	
#else
	o.Alpha = c.a;	
#endif
#else
	o.Alpha = 1.0;
#endif

#ifdef USE_SPECULAR
	fixed4 specIllumRefl = tex2D(_SpecIllumReflTex, IN.uv_MainTex);
#endif

#ifdef USE_SPECULAR 
	o.Gloss = specIllumRefl.r;
	o.Specular = specIllumRefl.b * _Shininess;
	o.SpecColor = 1;
#endif
}

#endif