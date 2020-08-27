import { usePlugin } from "@nomiclabs/buidler/config";

usePlugin("@nomiclabs/buidler-waffle");

// You have to export an object to set up your config
// This object can have the following optional entries:
// defaultNetwork, networks, solc, and paths.
// Go to https://buidler.dev/config/ to learn more
export default {
    // This is a sample solc configuration that specifies which version of solc to use
    solc: {
        version: "0.6.8",
    },
};
