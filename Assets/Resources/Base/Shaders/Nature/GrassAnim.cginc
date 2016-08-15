#ifndef GRASS_ANIM_CGINC
#define GRASS_ANIM_CGINC


inline float4 AnimateGrass(float4 pos, float animParams) {
	pos.xyz += animParams * _Wind.xyz * _Wind.w;
	return pos;
}

inline float4 AnimateGrassHQ(float4 pos, float animParam) {
	float2 vWavesIn = _Time.yy + pos.xz * 0.3;
	float4 vWaves = (frac( vWavesIn.xxyy * float4(1.975, 0.793, 0.375, 0.193) ) * 2.0 - 1.0);
	vWaves = SmoothTriangleWave( vWaves );
	float2 vWavesSum = vWaves.xz + vWaves.yw;
	pos.xz += (_Wind.xz * vWavesSum.y * animParam) * _Wind.w; 
			
	return pos;
}

void WaveVertex(inout appdata_full v) {
	v.vertex = AnimateGrassHQ(v.vertex, v.texcoord.y/10);
}


#endif