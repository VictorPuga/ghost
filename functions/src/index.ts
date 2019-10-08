import * as functions from 'firebase-functions';
import server from './server';

export const v1 = functions.https.onRequest(server);
