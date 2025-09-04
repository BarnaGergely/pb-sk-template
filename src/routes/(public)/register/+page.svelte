<script lang="ts">
	import { pocketBase } from '$lib/pocketbase';
	
	let email = '';
	let password = '';
	let passwordConfirm = '';
	let loading = false;
	let error = '';
	let success = false;

	async function handleRegister() {
		// Basic validation
		if (!email || !password || !passwordConfirm) {
			error = 'Please fill in all fields';
			return;
		}

		if (password !== passwordConfirm) {
			error = 'Passwords do not match';
			return;
		}

		loading = true;
		error = '';

		try {
			await pocketBase.register(email, password, passwordConfirm);
            await pocketBase.login(email, password);
			success = true;
		} catch (err: any) {
			error = err.message || 'Registration failed. Please try again.';
		} finally {
			loading = false;
		}
	}

	function handleKeydown(event: KeyboardEvent) {
		if (event.key === 'Enter') {
			handleRegister();
		}
	}
</script>

<h1>Regisztráció</h1>

{#if success}
	<div>
		<h2>Registration successful! You are logged in.</h2>
	</div>
{:else}
	<form on:submit|preventDefault={handleRegister}>
		<div>
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

		<div>
			<label for="password">Password</label>
			<input
				id="password"
				type="password"
				bind:value={password}
				placeholder="Enter your password (min. 8 characters)"
				disabled={loading}
				on:keydown={handleKeydown}
				required
				minlength="8"
			/>
		</div>

		<div>
			<label for="passwordConfirm">Confirm Password</label>
			<input
				id="passwordConfirm"
				type="password"
				bind:value={passwordConfirm}
				placeholder="Confirm your password"
				disabled={loading}
				on:keydown={handleKeydown}
				required
				minlength="8"
			/>
		</div>

		{#if error}
			<div>
				{error}
			</div>
		{/if}

		<button type="submit" disabled={loading}>
			{loading ? 'Creating account...' : 'Create Account'}
		</button>
	</form>

	<p>
		Already have an account? <a href="/login">Sign in</a>
	</p>
{/if}