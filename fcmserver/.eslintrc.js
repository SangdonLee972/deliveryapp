module.exports = {
  root: true,
  env: {
    es6: true,
    node: true,
  },
  extends: [
    "eslint:recommended",
    "google",
  ],
  rules: {
    "quotes": ["error", "double"],
    "indent": "off",
    "max-len": ["error", 500, 2, {
      "ignoreUrls": true,
      "ignoreComments": false,
      "ignoreRegExpLiterals": true,
      "ignoreStrings": false,
      "ignoreTemplateLiterals": false,
    }],

    "require-jsdoc": ["error", {
      "require": {
          "FunctionDeclaration": false,
          "MethodDefinition": false,
          "ClassDeclaration": false,
          "ArrowFunctionExpression": false,
          "FunctionExpression": false,
      },
  }],
     "linebreak-style": 0,
  },
};
