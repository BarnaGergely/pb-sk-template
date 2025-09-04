import { PUBLIC_POCKETBASE_API_URL } from '$env/static/public';
import PocketBase, { type AuthRecord, type RecordAuthResponse, type RecordModel } from 'pocketbase';

/**
 * Custom features for the PocketBase JavaScript SDK
 */
class ExtendedPocketBase extends PocketBase {
	async login(email: string, password: string): Promise<RecordAuthResponse<RecordModel>> {
		return this.collection('users').authWithPassword(email, password);
	}

	async register(email: string, password: string, passwordConfirm: string): Promise<RecordModel> {
		return this.collection('users').create({
			email,
			password,
			passwordConfirm
		});
	}

	logout(): void {
		this.authStore.clear();
	}

	get isLoggedIn(): boolean {
		return this.authStore.isValid;
	}

	get getCurrentUser(): AuthRecord {
		return this.authStore.record;
	}
}

export const pocketBase: ExtendedPocketBase = new ExtendedPocketBase(PUBLIC_POCKETBASE_API_URL);
