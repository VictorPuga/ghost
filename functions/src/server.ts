import express from 'express';
import bodyParser from 'body-parser';
import cors from 'cors';
import axios, { AxiosRequestConfig } from 'axios';

import { stringToBase64, responseHTML, formatTokens } from './utilities';

// import dotenv from 'dotenv'
// dotenv.config()

const {
  // apiKey,
  clientId,
  clientSecret,
} = process.env;

const configs: AxiosRequestConfig = {
  method: 'POST',
  url: 'https://www.bungie.net/platform/app/oauth/token/',
  headers: {
    Accept: 'application/json',
    Authorization: 'Basic ' + stringToBase64(clientId + ':' + clientSecret),
    'Content-Type': 'application/x-www-form-urlencoded',
  },
};

const app = express();

app.use(bodyParser.json({ limit: '50mb' }));
app.use(bodyParser.urlencoded({ extended: false }));
app.use(cors());

app.get('/oauth/redirect', function(request, response) {
  const { code } = request.query;
  axios({
    ...configs,
    data: `grant_type=authorization_code&code=${code}`,
  })
    .then(({ data }: any) => {
      const tokens = formatTokens(data);
      response.setHeader('Content-Type', 'text/html');
      response.status(200);
      response.send(responseHTML(tokens));
    })
    .catch((e: any) => {
      // console.log(e);
      if (e.response.headers['content-type'] == 'text/html; charset=UTF-8') {
        response.setHeader('Content-Type', 'text/html');
        response.send(e.response.data);
      } else {
        response.status(e.response.status);
        response.json({
          code: e.response.status,
          message: e.response.statusText,
          error: e.response.data,
        });
      }
    });
});

app.post('/oauth/refresh', function(request, response) {
  const { token } = request.body;
  axios({
    ...configs,
    data: `grant_type=refresh_token&refresh_token=${token}`,
  })
    .then(({ data }) => {
      const tokens = formatTokens(data);
      response.setHeader('Content-Type', 'text/html');
      response.status(200);
      response.send(responseHTML(tokens));
    })
    .catch(e => {
      // console.log(e)
      if (e.response.headers['content-type'] == 'text/html; charset=UTF-8') {
        response.setHeader('Content-Type', 'text/html');
        response.send(e.response.data);
      } else {
        response.status(e.response.status);
        response.json({
          code: e.response.status,
          message: e.response.statusText,
          error: e.response.data,
        });
      }
    });
});

app.get('/', function(request, response) {
  response.setHeader('Content-Type', 'application/json');
  response.status(200);
  response.json({ response: 'nothing to see here' });
});

// var server = http.createServer(app);
// var port = process.env.PORT || 1234;
// server.listen(port);

export default app;

// console.log('http server listening on %d', port);