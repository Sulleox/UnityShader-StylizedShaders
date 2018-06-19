Shader "sTools/Outline/OutlineShader" 
{
	Properties 
	{
		_OutlineColor ("Outline Color", Color) = (0,0,0,1)
        _OutlineWidth ("Outline width", Range (0, 0.2)) = .005
		_OutlineDepth ("Outline Depth", Range (0, 0.5)) = .1
        _MainTex ("Albedo", 2D) = "white" {}
	}

	SubShader 
	{
		//RENDER OBJECT
		Tags { "RenderMode" = "Opaque" }
		Cull Back
		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows
		#pragma target 3.0

		

		struct Input 
		{
			float2 uv_MainTex;
		};

		sampler2D _MainTex;
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
		ENDCG

		//PASS DRAWING OUTLINE
		Tags { "Queue" = "Transparent" "RenderMode" = "Opaque" }
		Cull Front
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

		UNITY_INSTANCING_BUFFER_START(Props)
		UNITY_INSTANCING_BUFFER_END(Props)

		void vert(inout appdata_full v)
		{
			v.vertex.xyz += v.normal * _OutlineWidth;
			v.vertex.xyz -= ObjSpaceViewDir(v.vertex) * _OutlineDepth;
		}

		void surf (Input IN, inout SurfaceOutput o) 
		{
			o.Albedo = _OutlineColor;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
