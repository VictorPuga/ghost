"use strict";
var __assign = (this && this.__assign) || function () {
    __assign = Object.assign || function(t) {
        for (var s, i = 1, n = arguments.length; i < n; i++) {
            s = arguments[i];
            for (var p in s) if (Object.prototype.hasOwnProperty.call(s, p))
                t[p] = s[p];
        }
        return t;
    };
    return __assign.apply(this, arguments);
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
// var http = require('http');
// var express = require('express');
// var bodyParser = require('body-parser');
// var path = require('path');
// var cors = require('cors');
// const axios = require('axios');
var http_1 = __importDefault(require("http"));
var express_1 = __importDefault(require("express"));
var body_parser_1 = __importDefault(require("body-parser"));
var cors_1 = __importDefault(require("cors"));
var axios_1 = __importDefault(require("axios"));
var utilities_1 = require("./utilities");
// require('dotenv').config()
var _a = process.env, apiKey = _a.apiKey, clientId = _a.clientId, clientSecret = _a.clientSecret;
var configs = {
    method: 'POST',
    url: 'https://www.bungie.net/platform/app/oauth/token/',
    headers: {
        Accept: 'application/json',
        Authorization: 'Basic ' + utilities_1.stringToBase64(clientId + ':' + clientSecret),
        'Content-Type': 'application/x-www-form-urlencoded',
    },
};
var app = express_1.default();
// app.use(express.static(path.join(__dirname, 'src')))
app.use(body_parser_1.default.json({ limit: '50mb' }));
app.use(body_parser_1.default.urlencoded({ extended: false }));
app.use(cors_1.default());
app.get('/oauth/redirect', function (request, response) {
    var code = request.query.code;
    axios_1.default(__assign(__assign({}, configs), { data: "grant_type=authorization_code&code=" + code }))
        .then(function (_a) {
        var data = _a.data;
        var tokens = utilities_1.formatTokens(data);
        response.setHeader('Content-Type', 'text/html');
        response.status(200);
        response.send(utilities_1.responseHTML(tokens));
    })
        .catch(function (e) {
        // console.log(e);
        if ((e.response.headers['content-type'] = 'text/html; charset=UTF-8')) {
            response.setHeader('Content-Type', 'text/html');
            response.send(e.response.data);
        }
        else {
            response.status(e.response.status);
            response.json({
                code: e.response.status,
                message: e.response.statusText,
                error: e.response.data,
            });
        }
    });
});
app.post('/oauth/refresh', function (request, response) {
    var token = request.body.token;
    axios_1.default(__assign(__assign({}, configs), { data: "grant_type=refresh_token&refresh_token=" + token }))
        .then(function (_a) {
        var data = _a.data;
        var tokens = utilities_1.formatTokens(data);
        response.setHeader('Content-Type', 'text/html');
        response.status(200);
        response.send(utilities_1.responseHTML(tokens));
    })
        .catch(function (e) {
        // console.log(e)
        if ((e.response.headers['content-type'] = 'text/html; charset=UTF-8')) {
            response.setHeader('Content-Type', 'text/html');
            response.send(e.response.data);
        }
        else {
            response.status(e.response.status);
            response.json({
                code: e.response.status,
                message: e.response.statusText,
                error: e.response.data,
            });
        }
    });
});
app.get('/', function (request, response) {
    response.setHeader('Content-Type', 'application/json');
    response.status(200);
    response.json({ response: 'nothing to see here' });
});
var server = http_1.default.createServer(app);
var port = process.env.PORT || 1234;
server.listen(port);
console.log('http server listening on %d', port);
