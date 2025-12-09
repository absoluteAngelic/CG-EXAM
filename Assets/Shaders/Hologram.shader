Shader "Custom/Hologram"
{
    Properties
    {
        _MainTex ("Main Texture", 2D) = "black" {}
        _FresnelColor ("Fresnel Color", Color) = (0, 0.8, 1, 1)
        _RimIntensity ("Rim Intensity", Float) = 1.5
        _FresnelPower ("Fresnel Power", Range(1, 5)) = 2.0
        _Transparency ("Transparency", Range(0, 1)) = 0.5
    }

    SubShader
    {
        Tags { "RenderPipeline" = "UniversalPipeline" "Queue" = "Transparent" "RenderType" = "Transparent" }

        Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct Attributes
            {
                float4 positionOS : POSITION;
                float3 normalOS : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct Varyings
            {
                float4 positionHCS : SV_POSITION;
                float3 normalWS : TEXCOORD1;
                float3 viewDirWS : TEXCOORD2;
                float2 uv : TEXCOORD0;
            };

            TEXTURE2D(_MainTex);
            SAMPLER(sampler_MainTex);
            float4 _FresnelColor;
            float _RimIntensity;
            float _FresnelPower;
            float _Transparency;

            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);
                
                OUT.normalWS = normalize(TransformObjectToWorldNormal(IN.normalOS));

                OUT.viewDirWS = normalize(GetWorldSpaceViewDir(IN.positionOS.xyz));

                OUT.uv = IN.uv;

                return OUT;
            }

            half4 frag(Varyings IN) : SV_Target
            {
                half4 texColor = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.uv);

                half3 normalWS = normalize(IN.normalWS);
                half3 viewDirWS = normalize(IN.viewDirWS);
                half fresnel = pow(1.0 - saturate(dot(viewDirWS, normalWS)), _FresnelPower);
                half3 fresnelColor = _FresnelColor.rgb * fresnel * _RimIntensity;

                half3 finalColor = texColor.rgb + fresnelColor;

                return half4(finalColor, _Transparency);
            }

            ENDHLSL
        }
    }
}