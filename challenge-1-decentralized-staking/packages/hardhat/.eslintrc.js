module.exports = {
  env: {
    mocha: true,
  },
  extends: ["airbnb", "plugin:prettier/recommended"],
  plugins: ["babel"],
  rules: {
    "prettier/prettier": ["warning"],
    "import/extensions": [
      "error",
      "ignorePackages",
      {
        js: "never",
        ts: "never",
      },
    ],
    "import/prefer-default-export": "off",
    "prefer-destructuring": "off",
    "prefer-template": "off",
    "no-console": "off",
    "func-names": "off",
  },
};
