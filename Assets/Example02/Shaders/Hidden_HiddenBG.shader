Shader "Hidden/HiddenBG" {
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader {
        Tags { "RenderType"="Opaque" "Queue"="Transparent+2"}
        Pass {
            blend srcalpha oneminussrcalpha
            Stencil {
                Ref 5
                Comp equal
            }
        
            CGPROGRAM
            #include "UnityCG.cginc"
            #pragma vertex vert_img
            #pragma fragment frag


            sampler2D _MainTex;

            fixed4 frag (v2f_img i) : COLOR
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                col.a = 0.75f;
                return col;
            }
            ENDCG
        }
    }
}