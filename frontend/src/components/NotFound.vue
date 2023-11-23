<template>
    <div>
        <h1>Not Found</h1>
        <span v-html="error"></span>
    </div>
</template>

<script>
export default {
    name: "NotFound",
    computed: {
        error() {
            const params = new URLSearchParams(window.location.search)
            return params.get('error')
        },
    }
}

</script>

<style scoped></style>