module.exports = {
    tags: "package",
    layout: "package",
    eleventyComputed: {
        eleventyNavigation: {
            key: (data) => data.title,
            parent: (data) => "Packages",
        },
    },
};
