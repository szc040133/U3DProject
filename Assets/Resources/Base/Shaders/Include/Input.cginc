#ifndef INPUT_CGINC
#define INPUT_CGINC


sampler2D _MainTex;
fixed4 _Color;

#ifdef USE_SPLIT_ALPHAMAP
sampler2D _AlphaTex;
#endif

#ifdef USE_NORMALMAP
sampler2D _BumpMap;
#endif

#ifdef USE_RIM
fixed4 _RimColor;
fixed _RimWidth;
#endif
//half _MinRimDist;
//half _MaxRimDist;




#ifdef USE_SPECULAR
half _SpecIntensity;
half _Shininess;
sampler2D _SpecColorTex;
sampler2D _SpecRamp;
//half _MinGlowDist;
//half _MaxGlowDist;
#endif

#ifdef USE_SKIN
sampler2D _LookupSkinDiffuseSpec;
float _ScatteringOffset;
float _ScatteringPower;
#endif

#if defined(USE_SPECULAR) || defined (USE_ILLUM) || defined(USE_CUBEMAP) || defined(USE_SKIN)
fixed _IllumStrength;
sampler2D _SpecIllumReflTex;
#endif

#ifdef USE_CUBEMAP
fixed4 _ReflectColor;
samplerCUBE _Cube;
#endif


struct Input {
	float2 uv_MainTex;
#ifdef USE_NORMALMAP
	float2 uv_BumpMap;
#endif
	//fixed RimFade;

#ifdef USE_VERTEXCOLOR
	fixed4 color : COLOR;
#endif

#ifdef USE_CUBEMAP
	float3 worldRefl;
#ifdef USE_NORMALMAP
	INTERNAL_DATA
#endif
#endif
};

struct YSSurfaceOutput {
	fixed3 Albedo;
	fixed3 Normal;
	fixed3 Emission;
	half Specular;
	half Gloss;
	fixed Alpha;
	fixed3 SpecColor;
	//fixed RimFade;
#ifdef USE_SKIN
	half Scattering;
#endif
};



#endif