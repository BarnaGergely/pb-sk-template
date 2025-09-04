import { redirect } from '@sveltejs/kit'
import { pocketBase } from '$lib/pocketbase'

export const load = async () => {
  if (!pocketBase.authStore.isValid) {
    throw redirect(303, '/login'); // TODO: Show message
  }
}