export const // btoa
  stringToBase64 = (str: string) =>
    Buffer.from(str, 'binary').toString('base64');

export const responseHTML = (data: any) => `
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
`;

export const formatTokens = (data: any) => {
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
    expirationDate: Date.now() + expires_in * 1000,
    refreshToken: refresh_token,
    refreshExpirationDate: Date.now() + refresh_expires_in * 1000,
    membershipId: membership_id,
  };
};
