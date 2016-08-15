#ifndef SURF_CGINC
#define SURF_CGINC

/*
void calcRimFade(inout appdata_full v, out Input o) {
float3 viewpos = mul(UNITY_MATRIX_MV, v.vertex).xyz;
o.RimFade = 1 - saturate((-viewpos.z - _MinRimDist) / (_MaxRimDist - _MinRimDist));
}
*/

void surf(Input IN, inout YSSurfaceOutput o) {
	fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
	fixed4 c = tex * _Color;
	o.Albedo = c.rgb;

#ifdef USE_RIM
	//o.RimFade = IN.RimFade;
#endif

#ifdef USE_ALPHA_CHANNEL 
#ifdef USE_SPLIT_ALPHAMAP
	o.Alpha = tex2D(_AlphaTex, IN.uv_MainTex).g * _Color.a;
#else
	o.Alpha = c.a;
#endif
#else
	o.Alpha = 1.0;
#endif


#ifdef USE_NORMALMAP
	o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
	o.Normal.y = -o.Normal.y;
#endif


#if defined(USE_SPECULAR) || defined(USE_ILLUM) || defined(USE_CUBEMAP) || defined(USE_SKIN)
	fixed4 specIllumRefl = tex2D(_SpecIllumReflTex, IN.uv_MainTex);
#endif

#ifdef USE_SKIN
	half depth = specIllumRefl.g;
	o.Scattering = saturate((depth + _ScatteringOffset) * _ScatteringPower);
#endif

#ifdef USE_SPECULAR 
	o.Gloss = _SpecIntensity;
	o.Specular = specIllumRefl.b * _Shininess;
	o.SpecColor = tex2D(_SpecColorTex, IN.uv_MainTex).rgb;
#endif

	o.Emission = 0;
#ifdef USE_ILLUM
	o.Emission += c.rgb * specIllumRefl.g * _IllumStrength;
#endif


#ifdef USE_CUBEMAP
#ifdef USE_NORMALMAP
	float3 worldRefl = WorldReflectionVector(IN, o.Normal);
#else
	float3 worldRefl = IN.worldRefl;
#endif

	fixed4 reflcol = texCUBE(_Cube, worldRefl);
	reflcol *= specIllumRefl.r;
	o.Emission += reflcol.rgb * _ReflectColor.rgb;
#endif

}

#endif