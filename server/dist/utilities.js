"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.stringToBase64 = function (str) {
    return Buffer.from(str, 'binary').toString('base64');
};
exports.responseHTML = function (data) { return "\n<html>\n<head>\n  <title>App</title>\n  <script>\n    if (typeof Toaster !== 'undefined') {\n      Toaster.postMessage('" + JSON.stringify(data) + "')\n    }\n  </script>\n</head>\n<body>\n  <h1>You can close this window now...</h1>\n</body>\n</html>\n"; };
exports.formatTokens = function (data) {
    var access_token = data.access_token, token_type = data.token_type, expires_in = data.expires_in, refresh_token = data.refresh_token, refresh_expires_in = data.refresh_expires_in, membership_id = data.membership_id;
    return {
        accessToken: access_token,
        tokenType: token_type,
        expirationDate: Date.now() + expires_in * 1000,
        refreshToken: refresh_token,
        refreshExpirationDate: Date.now() + refresh_expires_in * 1000,
        membershipId: membership_id,
    };
};
