Shader "sTools/StylizedCharacterShader" 
{
	Properties 
	{
		_OutlineColor ("Outline Color", Color) = (0,0,0,1)
        _OutlineWidth ("Outline width", Range (0, 0.2)) = .005
<<<<<<< HEAD
		_OutlineDepth ("Outline Depth", Range (0.1, 0.5)) = .1
=======
		_OutlineDepth ("Outline Depth", Range (0, 0.5)) = .1
		_DepthAtten ("Outline Depth Atten", Range (0, 1)) = 0.5
>>>>>>> 50112de289665315dd61aabc24f6d92082f09996
        _MainTex ("Albedo", 2D) = "white" {}
		_RampTex ("Ramp Map", 2D) = "grey" {}
	}

	SubShader 
	{
		//RENDER OBJECT
		Tags { "RenderMode" = "Opaque" }
		Cull Back
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
		uniform float _OutlineWidth;
		uniform float4 _OutlineColor;


		UNITY_INSTANCING_BUFFER_START(Props)
		UNITY_INSTANCING_BUFFER_END(Props)

		void surf (Input IN, inout SurfaceOutputStandard o) 
		{
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}

		half4 LightingCelShadingForward(SurfaceOutputStandard s, half3 lightDir, half atten) 
		{
			half NormalDotLight = dot(s.Normal, lightDir);
			half2 uvRamp = half2(0,0.5);
			uvRamp.x = (NormalDotLight+1)/2;
			fixed ramp = tex2D (_RampTex, uvRamp);

			half3 newColor = (0,0,0);
			if (ramp <= 0.5)
			{
				newColor = 2 * ramp * s.Albedo;
			}
			else
			{
				newColor = 1 - 2 * (1 - s.Albedo) * (1-ramp);
			}

			half4 finalColor = half4(newColor.x,newColor.y,newColor.z,1);
			return finalColor;
		}
		ENDCG

		//PASS DRAWING OUTLINE
		Tags { "Queue" = "Transparent" "RenderMode" = "Opaque" }
		Cull Off
		CGPROGRAM
		
		#pragma surface surf Unlit vertex:vert fullforwardshadows
		#pragma target 3.0

		half4 LightingUnlit (SurfaceOutput s, half3 lightDir, half atten) 
		{
              half NdotL = dot (s.Normal, lightDir);
              half4 c;
              c.rgb = s.Albedo;
              c.a = s.Alpha;
              return c;
          }

		struct Input 
		{
			float2 uv_MainTex;
		};

		uniform float _OutlineWidth;
		uniform float _OutlineDepth;
		uniform float4 _OutlineColor;
		uniform float _DepthAtten;

		UNITY_INSTANCING_BUFFER_START(Props)
		UNITY_INSTANCING_BUFFER_END(Props)

		void vert(inout appdata_full v)
		{
			v.vertex.xyz += v.normal * (_OutlineWidth / 10);
<<<<<<< HEAD
			v.vertex.xyz += ObjSpaceViewDir(v.vertex) * (_OutlineWidth / 10);
			v.vertex.xyz -= ObjSpaceViewDir(v.vertex) * _OutlineDepth;
=======
			v.vertex.xyz -= ObjSpaceViewDir(v.vertex) * (_OutlineDepth/_DepthAtten);
>>>>>>> 50112de289665315dd61aabc24f6d92082f09996
		}

		void surf (Input IN, inout SurfaceOutput o) 
		{
			o.Albedo = _OutlineColor;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
