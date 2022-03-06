﻿using System.Collections.Generic;
using UniGLTF.UniUnlit;
using UniJSON;
using UnityEngine;


namespace UniGLTF
{
    public enum glTFBlendMode
    {
        OPAQUE,
        MASK,
        BLEND
    }

    public interface IMaterialExporter
    {
        glTFMaterial ExportMaterial(Material m, TextureExportManager textureManager);
    }

    public class MaterialExporter : IMaterialExporter
    {
        public virtual glTFMaterial ExportMaterial(Material m, TextureExportManager textureManager)
        {
            var material = CreateMaterial(m);

            // common params
            material.name = m.name;
            Export_Color(m, textureManager, material);
            Export_Metallic(m, textureManager, material);
            Export_Normal(m, textureManager, material);
            Export_Occlusion(m, textureManager, material);
            Export_Emission(m, textureManager, material);

            return material;
        }

        static void Export_Color(Material m, TextureExportManager textureManager, glTFMaterial material)
        {
            if (m.HasProperty("_Color"))
            {
                material.pbrMetallicRoughness.baseColorFactor = m.color.linear.ToArray();
            }

            if (m.HasProperty("_MainTex"))
            {
                var index = textureManager.CopyAndGetIndex(m.GetTexture("_MainTex"), RenderTextureReadWrite.sRGB);
                if (index != -1)
                {
                    material.pbrMetallicRoughness.baseColorTexture = new glTFMaterialBaseColorTextureInfo()
                    {
                        index = index,
                    };

                    Export_MainTextureTransform(m, material.pbrMetallicRoughness.baseColorTexture);
                }
            }
        }

        static void Export_Metallic(Material m, TextureExportManager textureManager, glTFMaterial material)
        {
            int index = -1;
            if (m.HasProperty("_MetallicGlossMap"))
            {
                float smoothness = 0.0f;
                if (m.HasProperty("_GlossMapScale"))
                {
                    smoothness = m.GetFloat("_GlossMapScale");
                }

                // Bake smoothness values into a texture.
                var converter = new MetallicRoughnessConverter(smoothness);
                index = textureManager.ConvertAndGetIndex(m.GetTexture("_MetallicGlossMap"), converter);
                if (index != -1)
                {
                    material.pbrMetallicRoughness.metallicRoughnessTexture =
                        new glTFMaterialMetallicRoughnessTextureInfo()
                        {
                            index = index,
                        };

                    Export_MainTextureTransform(m, material.pbrMetallicRoughness.metallicRoughnessTexture);
                }
            }

            if (index != -1)
            {
                material.pbrMetallicRoughness.metallicFactor = 1.0f;
                // Set 1.0f as hard-coded. See: https://github.com/dwango/UniVRM/issues/212.
                material.pbrMetallicRoughness.roughnessFactor = 1.0f;
            }
            else
            {
                if (m.HasProperty("_Metallic"))
                {
                    material.pbrMetallicRoughness.metallicFactor = m.GetFloat("_Metallic");
                }

                if (m.HasProperty("_Glossiness"))
                {
                    material.pbrMetallicRoughness.roughnessFactor = 1.0f - m.GetFloat("_Glossiness");
                }
            }
        }

        static void Export_Normal(Material m, TextureExportManager textureManager, glTFMaterial material)
        {
            if (m.HasProperty("_BumpMap"))
            {
                var index = textureManager.ConvertAndGetIndex(m.GetTexture("_BumpMap"), new NormalConverter());
                if (index != -1)
                {
                    material.normalTexture = new glTFMaterialNormalTextureInfo()
                    {
                        index = index,
                    };

                    Export_MainTextureTransform(m, material.normalTexture);
                }

                if (index != -1 && m.HasProperty("_BumpScale"))
                {
                    material.normalTexture.scale = m.GetFloat("_BumpScale");
                }
            }
        }

        static void Export_Occlusion(Material m, TextureExportManager textureManager, glTFMaterial material)
        {
            if (m.HasProperty("_OcclusionMap"))
            {
                var index = textureManager.ConvertAndGetIndex(m.GetTexture("_OcclusionMap"), new OcclusionConverter());
                if (index != -1)
                {
                    material.occlusionTexture = new glTFMaterialOcclusionTextureInfo()
                    {
                        index = index,
                    };

                    Export_MainTextureTransform(m, material.occlusionTexture);
                }

                if (index != -1 && m.HasProperty("_OcclusionStrength"))
                {
                    material.occlusionTexture.strength = m.GetFloat("_OcclusionStrength");
                }
            }
        }

        static void Export_Emission(Material m, TextureExportManager textureManager, glTFMaterial material)
        {
            if (m.IsKeywordEnabled("_EMISSION") == false)
                return;

            if (m.HasProperty("_EmissionColor"))
            {
                var color = m.GetColor("_EmissionColor");
                if (color.maxColorComponent > 1)
                {
                    color /= color.maxColorComponent;
                }
                material.emissiveFactor = new float[] { color.r, color.g, color.b };
            }

            if (m.HasProperty("_EmissionMap"))
            {
                var index = textureManager.CopyAndGetIndex(m.GetTexture("_EmissionMap"), RenderTextureReadWrite.sRGB);
                if (index != -1)
                {
                    material.emissiveTexture = new glTFMaterialEmissiveTextureInfo()
                    {
                        index = index,
                    };

                    Export_MainTextureTransform(m, material.emissiveTexture);
                }
            }
        }

        static void Export_MainTextureTransform(Material m, glTFTextureInfo textureInfo)
        {
            Export_TextureTransform(m, textureInfo, "_MainTex");
        }

        static void Export_TextureTransform(Material m, glTFTextureInfo textureInfo, string propertyName)
        {
            if (textureInfo != null && m.HasProperty(propertyName))
            {
                var offset = m.GetTextureOffset(propertyName);
                var scale = m.GetTextureScale(propertyName);
                offset.y = (offset.y + scale.y - 1) * -1.0f;

                glTF_KHR_texture_transform.Serialize(textureInfo, (offset.x, offset.y), (scale.x, scale.y));
            }
        }

        protected virtual glTFMaterial CreateMaterial(Material m)
        {
            switch (m.shader.name)
            {
                case "Unlit/Color":
                    return Export_UnlitColor(m);

                case "Unlit/Texture":
                    return Export_UnlitTexture(m);

                case "Unlit/Transparent":
                    return Export_UnlitTransparent(m);

                case "Unlit/Transparent Cutout":
                    return Export_UnlitCutout(m);

                case "UniGLTF/UniUnlit":
                    return Export_UniUnlit(m);

                default:
                    return Export_Standard(m);
            }
        }

        static glTFMaterial Export_UnlitColor(Material m)
        {
            var material = glTF_KHR_materials_unlit.CreateDefault();
            material.alphaMode = glTFBlendMode.OPAQUE.ToString();
            return material;
        }

        static glTFMaterial Export_UnlitTexture(Material m)
        {
            var material = glTF_KHR_materials_unlit.CreateDefault();
            material.alphaMode = glTFBlendMode.OPAQUE.ToString();
            return material;
        }

        static glTFMaterial Export_UnlitTransparent(Material m)
        {
            var material = glTF_KHR_materials_unlit.CreateDefault();
            material.alphaMode = glTFBlendMode.BLEND.ToString();
            return material;
        }

        static glTFMaterial Export_UnlitCutout(Material m)
        {
            var material = glTF_KHR_materials_unlit.CreateDefault();
            material.alphaMode = glTFBlendMode.MASK.ToString();
            material.alphaCutoff = m.GetFloat("_Cutoff");
            return material;
        }

        private glTFMaterial Export_UniUnlit(Material m)
        {
            var material = glTF_KHR_materials_unlit.CreateDefault();

            var renderMode = UniUnlit.Utils.GetRenderMode(m);
            if (renderMode == UniUnlitRenderMode.Opaque)
            {
                material.alphaMode = glTFBlendMode.OPAQUE.ToString();
            }
            else if (renderMode == UniUnlitRenderMode.Transparent)
            {
                material.alphaMode = glTFBlendMode.BLEND.ToString();
            }
            else if (renderMode == UniUnlitRenderMode.Cutout)
            {
                material.alphaMode = glTFBlendMode.MASK.ToString();
                material.alphaCutoff = m.GetFloat("_Cutoff");
            }
            else
            {
                material.alphaMode = glTFBlendMode.OPAQUE.ToString();
            }

            var cullMode = UniUnlit.Utils.GetCullMode(m);
            if (cullMode == UniUnlitCullMode.Off)
            {
                material.doubleSided = true;
            }
            else
            {
                material.doubleSided = false;
            }

            return material;
        }

        static glTFMaterial Export_Standard(Material m)
        {
            var material = new glTFMaterial
            {
                pbrMetallicRoughness = new glTFPbrMetallicRoughness(),
            };

            switch (m.GetTag("RenderType", true))
            {
                case "Transparent":
                    material.alphaMode = glTFBlendMode.BLEND.ToString();
                    break;

                case "TransparentCutout":
                    material.alphaMode = glTFBlendMode.MASK.ToString();
                    material.alphaCutoff = m.GetFloat("_Cutoff");
                    break;

                default:
                    material.alphaMode = glTFBlendMode.OPAQUE.ToString();
                    break;
            }

            return material;
        }
    }
}
