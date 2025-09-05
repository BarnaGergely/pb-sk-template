<script lang="ts">
	import '../app.css';
	import favicon from '$lib/assets/favicon.svg';
	import Siteframe from '$lib/components/site-frame/siteframe.svelte';

	let { children } = $props();
</script>

<svelte:head>
	<link rel="icon" href={favicon} />
</svelte:head>

<Siteframe>
	{@render children?.()}
</Siteframe>
