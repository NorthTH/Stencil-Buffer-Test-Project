Shader "Hidden/MultiEffect" {
    Properties {
        _MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
    }
    SubShader {
        Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent+1"}
        cull off
        zwrite off
        ztest always
        GrabPass {"_BackGround"}

        Pass {
            Stencil {
                    Ref 11
                    Comp equal
                    Pass keep
                }
            CGPROGRAM
            #include "UnityCG.cginc"
            #pragma vertex vert
            #pragma fragment frag

            struct appdata {
                float4 vertex : POSITION;
                float4 uv : TEXCOORD0;
            };

            struct v2f {
                float4 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float2 alphaUV : TEXCOORD1;
            };

            sampler2D _BackGround;
            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert(appdata v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = ComputeGrabScreenPos(o.vertex);
                o.alphaUV = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            half4 frag(v2f i) : SV_Target {
                half ratioX = 1 / 0.5;
                half ratioY = 1 / 0.5;
                half2 uv = half2((int)(i.uv.x / ratioX) * ratioX, (int)(i.uv.y / ratioY) * ratioY);
                

                fixed4 col = tex2Dproj(_BackGround, i.uv);
                float alpha = tex2D(_MainTex, i.alphaUV).a;
                if(alpha > 0)
                {
                    i.uv.xy = uv.xy;
                    col = tex2Dproj(_BackGround, i.uv);
                }
                else
                {
                    col = tex2Dproj(_BackGround, i.uv);
                }

                return col;
            }
            ENDCG
        }

        Pass {
            Stencil {
                    Ref 10
                    Comp equal
                    Pass keep
                }
            CGPROGRAM
            #include "UnityCG.cginc"
            #pragma vertex vert
            #pragma fragment frag

            struct appdata {
                float4 vertex : POSITION;
                float4 uv : TEXCOORD0;
            };

            struct v2f {
                float4 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float2 alphaUV : TEXCOORD1;
            };

            sampler2D _BackGround;
            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert(appdata v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = ComputeGrabScreenPos(o.vertex);
                o.alphaUV = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            half4 frag(v2f i) : SV_Target {
                fixed4 col = tex2Dproj(_BackGround, i.uv);
                float alpha = tex2D(_MainTex, i.alphaUV).a;
                if(alpha > 0)
                {
                    col = tex2Dproj(_BackGround, i.uv);
                    half gray = col.r * 0.3 + col.g * 0.6 + col.b * 0.1 - 0.01;
                    gray = ( gray < 0 ) ? 0 : gray;

                    half R = gray + 0.05;
                    half B = gray - 0.05;

                    R = ( R > 1.0 ) ? 1.0 : R;
                    B = ( B < 0 ) ? 0 : B;
                    col.rgb = fixed3(R, gray, B);
                }
                else
                {
                    col = tex2Dproj(_BackGround, i.uv);
                }

                return col;
            }
            ENDCG
        }
    }

}