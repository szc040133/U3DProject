#ifndef LIT_CGINC
#define LIT_CGINC


inline fixed4 LightingYSBlinnPhong(YSSurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten) {
	float NdotL = dot(s.Normal, lightDir);
#ifdef USE_SKIN
	half diffNdotL = 0.5 + 0.5 * NdotL;
	half3 diff = tex2D(_LookupSkinDiffuseSpec, half2(diffNdotL, s.Scattering)).rgb;
#else
	fixed diff = max(0, NdotL);
#endif


	fixed4 c;
	c.rgb = s.Albedo * diff;
#ifdef USE_SPECULAR
	half3 h = normalize(lightDir + viewDir);
	float nh = max(0, dot(s.Normal, h));
	float spec = tex2D(_SpecRamp, float2(nh, s.Specular)).a * s.Gloss;

	c.rgb += s.SpecColor.rgb * spec;
#endif

#ifdef USE_RIM
	half rim = 1.0 - abs(dot(viewDir, s.Normal));
	rim *= _RimWidth;
	rim *= rim;
	rim *= rim;
	c.rgb += s.Albedo.xyz * _RimColor.xyz * rim;// *s.RimFade;
#endif

	c.rgb *= _LightColor0.rgb * (atten * 2);

	c.a = s.Alpha
		/*
		+ _LightColor0.a
		#ifdef USE_SPECULAR
		* s.SpecColor.a * spec
		#endif
		* atten
		*/
		;

	return c;
}


inline fixed4 LightingYSLambert(YSSurfaceOutput s, fixed3 lightDir, fixed atten)
{
	fixed diff = max(0, dot(s.Normal, lightDir));

	fixed4 c;
	c.rgb = s.Albedo * _LightColor0.rgb * (diff * atten * 2);
	c.a = s.Alpha;
	return c;
}


#endif