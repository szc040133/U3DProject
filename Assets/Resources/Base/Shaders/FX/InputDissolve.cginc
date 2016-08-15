#ifndef INPUT_DISSOLVE_CGINC
#define INPUT_DISSOLVE_CGINC

#include "../Include/Input.cginc"

sampler2D _DissolveTex;


half4 _DissColor;
half _Amount;
static half3 Color = float3(1,1,1);
half4 _ColorAnimate;
half _Illuminate;
half _Tile;
half _StartAmount;

#endif