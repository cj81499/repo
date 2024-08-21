import { EleventyHtmlBasePlugin, IdAttributePlugin, InputPathToUrlTransformPlugin } from "@11ty/eleventy";

const _INPUT_DIR = "src";
const _PATH_PREFIX = process.env["PATH_PREFIX"];

/** @param {import("@11ty/eleventy").UserConfig} eleventyConfig */
export default function (eleventyConfig) {
    eleventyConfig.addPlugin(IdAttributePlugin);
    eleventyConfig.addPlugin(InputPathToUrlTransformPlugin);
    eleventyConfig.addPlugin(EleventyHtmlBasePlugin);

    eleventyConfig.setTemplateFormats(["html", "md", "njk"]);

    eleventyConfig.addPassthroughCopy(`${_INPUT_DIR}/static`)
    eleventyConfig.addPassthroughCopy(`${_INPUT_DIR}/Release`)
    eleventyConfig.addPassthroughCopy(`${_INPUT_DIR}/Packages`)
    eleventyConfig.addPassthroughCopy(`${_INPUT_DIR}/Packages.gz`)
    eleventyConfig.addPassthroughCopy(`${_INPUT_DIR}/CydiaIcon.png`)
};

export const config = {
    markdownTemplateEngine: "njk",
    htmlTemplateEngine: "njk",
    pathPrefix: _PATH_PREFIX,

    dir: {
        input: _INPUT_DIR,
        includes: "_includes",
        layouts: "_layouts",
        data: "_data",
        output: "_site"
    }
};
