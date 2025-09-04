import { redirect } from '@sveltejs/kit'
import { pocketBase } from '$lib/pocketbase'

export const load = async () => {
  if (!pocketBase.authStore.isSuperuser) {
    throw redirect(303, '/login'); // TODO: Show message
  }
}