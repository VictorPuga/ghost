import * as functions from 'firebase-functions';
import app from './oauth';

export const oauth = functions.https.onRequest(app);
