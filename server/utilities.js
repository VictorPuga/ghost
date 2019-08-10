const btoa = (string) => Buffer.from(string, 'binary').toString('base64');
const responseHTML = (data) => `
<html>
<head>
  <title>App</title>
  <script>
    if (typeof Toaster !== 'undefined') {
      Toaster.postMessage('${JSON.stringify(data)}')
    }
  </script>
</head>
<body>
  <h1>You can close this window now...</h1>
</body>
</html>
`

const formatTokens = (data) => {
  const {
    access_token,
    token_type,
    expires_in,
    refresh_token,
    refresh_expires_in,
    membership_id,
  } = data;

  return {
    accessToken: access_token,
    tokenType: token_type,
    expirationDate: Date.now() + (expires_in * 1000),
    refreshToken: refresh_token,
    refreshExpirationDate: Date.now() + (refresh_expires_in * 1000),
    membershipId: membership_id,
  };
}

module.exports = { btoa, responseHTML, formatTokens }