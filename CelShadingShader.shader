Shader "sTools/CelShadingShader" 
{
	Properties 
	{
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_RampTex ("Ramp Map", 2D) = "white" {}
		_BumpMap ("Normal Map", 2D) = "bump" {}
	}
	SubShader 
	{
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		#pragma surface surf CelShadingForward
		#pragma target 3.0
		#include "UnityPBSLighting.cginc"

		struct Input 
		{
			float2 uv_MainTex;
			float2 uv_RampTex;
		};

		sampler2D _MainTex;
		sampler2D _RampTex;
		sampler2D _BumpMap;

		UNITY_INSTANCING_BUFFER_START(Props)
		UNITY_INSTANCING_BUFFER_END(Props)

		void surf (Input IN, inout SurfaceOutputStandard o) 
		{
			fixed4 mainTex = tex2D (_MainTex, IN.uv_MainTex);
			o.Normal = UnpackNormal (tex2D(_BumpMap, IN.uv_MainTex));
			o.Albedo = mainTex.rgb;
		}

		//RENDU DE LA LIGHT APRES LE SURFACE
		half4 LightingCelShadingForward(SurfaceOutputStandard s, half3 lightDir, half atten) 
		{
			half NormalDotLight = dot(s.Normal, lightDir);
			half2 uvRamp = half2(0.5,0.5);
			uvRamp.x = (NormalDotLight+1)/2;
			fixed ramp = tex2D (_RampTex, uvRamp);

			half3 newColor = (0,0,0);
			if (ramp <= 0.5)
			{
				newColor = 2 * ramp * s.Albedo;
			}
			else
			{
				newColor = 1 - 2 * (1-s.Albedo) * (1-ramp);
			}

			half4 finalColor = half4(newColor.x,newColor.y,newColor.z,0);
			return finalColor;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
