import { PUBLIC_POCKETBASE_API_URL } from '$env/static/public';
import PocketBase from 'pocketbase';

export const pocketBase: PocketBase = new PocketBase(PUBLIC_POCKETBASE_API_URL);
