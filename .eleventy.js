const directoryOutputPlugin = require("@11ty/eleventy-plugin-directory-output");
const eleventyNavigationPlugin = require("@11ty/eleventy-navigation");

const SRC_DIR = "src";

const ASSETS_DIR = `${SRC_DIR}/assets`;

/** @param {import("@11ty/eleventy/src/UserConfig"} eleventyConfig */
module.exports = (eleventyConfig) => {
    eleventyConfig.addWatchTarget(ASSETS_DIR);

    eleventyConfig.addPassthroughCopy(ASSETS_DIR);

    eleventyConfig.setQuietMode(true);

    eleventyConfig.addPlugin(directoryOutputPlugin);
    eleventyConfig.addPlugin(eleventyNavigationPlugin);

    // eleventyConfig.on("eleventy.after", async () => {
    //     console.log("in eleventy.after");
    // });

    return {
        dir: {
            input: SRC_DIR,
            output: "_site",
            includes: "includes",
            layouts: "layouts",
            data: "data",
        },
        pathPrefix: "/",
        markdownTemplateEngine: "njk",
        htmlTemplateEngine: "njk",
    };
};
