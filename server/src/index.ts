import express from 'express';
import bodyParser from 'body-parser';
import cors from 'cors';
import axios, { AxiosRequestConfig, AxiosResponse } from 'axios';
import http from 'http';

import { stringToBase64, responseHTML, formatTokens } from './utilities';

// import { client_id, client_secret } from '../keys';

const { client_id, client_secret } = process.env;

const configs: AxiosRequestConfig = {
  method: 'POST',
  url: 'https://www.bungie.net/platform/app/oauth/token/',
  headers: {
    Accept: 'application/json',
    Authorization: 'Basic ' + stringToBase64(client_id + ':' + client_secret),
    'Content-Type': 'application/x-www-form-urlencoded',
  },
};

const app = express();

app.use(bodyParser.json({ limit: '50mb' }));
app.use(bodyParser.urlencoded({ extended: false }));
app.use(cors());

app.get('/oauth/redirect', async function(request, response) {
  const { code } = request.query;
  let res, error;
  try {
    res = await axios({
      ...configs,
      data: `grant_type=authorization_code&code=${code}`,
    });
  } catch (e) {
    error = e;
    if (e.response.headers['content-type'] === 'text/html; charset=UTF-8') {
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
  } finally {
    if (!error) {
      const tokens = formatTokens((res as AxiosResponse).data);
      response.setHeader('Content-Type', 'text/html');
      response.status(200);
      response.send(responseHTML(tokens));
    }
  }

  // axios({
  //   ...configs,
  //   data: `grant_type=authorization_code&code=${code}`,
  // })
  //   .then(({ data }: any) => {
  //     const tokens = formatTokens(data);
  //     response.setHeader('Content-Type', 'text/html');
  //     response.status(200);
  //     response.send(responseHTML(tokens));
  //   })
  //   .catch((e: any) => {
  //     // console.log(e);
  //     if (e.response.headers['content-type'] === 'text/html; charset=UTF-8') {
  //       response.setHeader('Content-Type', 'text/html');
  //       response.send(e.response.data);
  //     } else {
  //       response.status(e.response.status);
  //       response.json({
  //         code: e.response.status,
  //         message: e.response.statusText,
  //         error: e.response.data,
  //       });
  //     }
  //   });
});

app.post('/oauth/refresh', async function(request, response) {
  const { token } = request.body;
  let res, error;
  try {
    res = await axios({
      ...configs,
      data: `grant_type=refresh_token&refresh_token=${token}`,
    });
  } catch (e) {
    error = e;
    if (e.response.headers['content-type'] === 'text/html; charset=UTF-8') {
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
  } finally {
    if (!error) {
      const tokens = formatTokens((res as AxiosResponse).data);
      response.setHeader('Content-Type', 'application/json');
      response.status(200);
      // response.send(responseHTML(tokens));
      response.send(tokens);
    }
  }
});

app.get('/', function(request, response) {
  response.setHeader('Content-Type', 'application/json');
  response.status(200);
  response.json({ response: 'nothing to see here' });
});

var server = http.createServer(app);
var port = process.env.PORT || 1234;
server.listen(port);

console.log('http server listening on %d', port);
