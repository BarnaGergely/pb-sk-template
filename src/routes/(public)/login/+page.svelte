<script lang="ts">
	import { pocketBase } from '$lib/pocketbase';

	let email = '';
	let password = '';
	let loading = false;
	let error = '';

	async function handleLogin() {
		if (!email || !password) {
			error = 'Please fill in all fields';
			return;
		}

		loading = true;
		error = '';

		try {
			await pocketBase.login(email, password);
			history.back(); // Go back to the previous page
		} catch (err: any) {
			error = err.message || 'Login failed. Please check your credentials.';
		} finally {
			loading = false;
		}
	}

	function handleKeydown(event: KeyboardEvent) {
		if (event.key === 'Enter') {
			handleLogin();
		}
	}
</script>

<h1>Bejelentkezés</h1>

<form on:submit|preventDefault={handleLogin}>
	<div class="form-group">
		<label for="email">Email</label>
		<input
			id="email"
			type="email"
			bind:value={email}
			placeholder="Enter your email"
			disabled={loading}
			on:keydown={handleKeydown}
			required
		/>
	</div>

	<div class="form-group">
		<label for="password">Password</label>
		<input
			id="password"
			type="password"
			bind:value={password}
			placeholder="Enter your password"
			disabled={loading}
			on:keydown={handleKeydown}
			required
		/>
	</div>

	{#if error}
		<div class="error-message">
			{error}
		</div>
	{/if}

	<button type="submit" disabled={loading}>
		{loading ? 'Logging in...' : 'Login'}
	</button>
</form>

<p class="register-link">
	Don't have an account? <a href="/register">Sign up</a>
</p>
