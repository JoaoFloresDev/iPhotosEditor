#include <metal_stdlib>
#include <simd/simd.h>
#import "ShaderTypes.h"

using namespace metal;

// Estrutura que define a saída do vertex shader.
struct VertexOut {
    float4 position [[position]]; // Posição transformada do vértice, no espaço de recorte.
    float3 fragmentPosition;      // Posição do fragmento, usada para cálculos de iluminação.
    float4 color;                 // Cor do vértice.
    float2 texCoord;              // Coordenadas de textura, não utilizadas aqui mas poderiam ser para mapeamento de texturas.
    half3 eyePosition;            // Posição do vértice no espaço da câmera.
    float3 normal;                // Normal do vértice transformada para iluminação.
    float vid;                    // ID do vértice, útil para debug ou cálculos específicos.
};

// Função vertex shader que transforma os vértices da geometria.
vertex VertexOut basic_vertex(
    const device Vertex* vertex_array [[ buffer(0) ]], // Array de vértices de entrada.
    constant SharedUniforms &uniforms [[ buffer(1) ]], // Uniformes compartilhados, como matrizes de transformação.
    unsigned int vid [[ vertex_id ]]                   // ID do vértice atual.
) {
    // Aplicando transformações de modelo-visualização (MV) e projeção.
    float4x4 mv_Matrix = uniforms.viewMatrix;
    float4x4 proj_Matrix = uniforms.projectionMatrix;

    // Carregando vértice de entrada usando o vertex_id.
    Vertex in = vertex_array[vid];

    // Posição do vértice no espaço do objeto.
    float3 pos = in.position.xyz;

    VertexOut out;

    // Transformando a posição do vértice para o espaço de recorte.
    out.position = proj_Matrix * mv_Matrix * float4(pos, 1);

    // Ajustando a coordenada Z para profundidade correta.
    out.position.z = out.position.z / out.position.w;
    out.position.z = 1.0 - out.position.z;
    out.position.z = out.position.z * out.position.w;

    // Calculando a posição do vértice no espaço da câmera para uso em iluminação.
    out.eyePosition = half3((mv_Matrix * float4(pos, 1)).xyz);

    // Passando a posição transformada para fragment shader.
    out.fragmentPosition = out.position.xyz;
    out.color.rgb = in.color.rgb;

    // Transformando a normal para uso no espaço da câmera.
    out.normal = (mv_Matrix * float4(in.normal.xyz, 0.0)).xyz;
    out.vid = vid;

    return out;
}

// Função fragment shader que calcula a cor final do pixel baseado na iluminação e na cor do vértice.
fragment float4 basic_fragment(VertexOut in [[stage_in]],
                               constant SharedUniforms &uniforms [[ buffer(1) ]]
) {
    // Recuperando a normal do vértice.
    float3 normal = float3(in.normal);

    // Calculando a contribuição da luz direcional.
    float3 directionalContribution = float3(0);
    {
        // Cálculo da intensidade difusa.
        float nDotL = saturate(dot(normal, -uniforms.directionalLightDirection));
        float3 diffuseTerm = uniforms.directionalLightColor * nDotL;

        // Cálculo da intensidade especular.
        float3 halfwayVector = normalize(-uniforms.directionalLightDirection - float3(in.eyePosition));
        float reflectionAngle = saturate(dot(normal, halfwayVector));
        float specularIntensity = saturate(powr(reflectionAngle, uniforms.materialShininess));
        float3 specularTerm = uniforms.directionalLightColor * specularIntensity;

        // Somando contribuições difusa e especular.
        directionalContribution = diffuseTerm + specularTerm;
    }

    // Contribuição de luz ambiente.
    float3 ambientContribution = uniforms.ambientLightColor;

    // Calculando a contribuição total da luz.
    float3 lightContributions = ambientContribution + directionalContribution;
    
    // Ajuste de cor baseado em uma condição (usado aqui como exemplo, poderia ser removido ou modificado).
    if (in.color.x < -0.5) {
        in.color.rgb = normal.rgb;
    }

    // Aplicando a contribuição de luz à cor do vértice.
    float3 color = in.color.rgb * lightContributions;

    // Assegurando que a cor final é completamente opaca.
    return float4(color, 1.0);
}
