<script setup lang="ts">
defineProps({
  errorMessage: String
})
</script>

<template>
  <Transition>
    <span class="bg-red-500 text-white p-1 rounded-full flex justify-center text-sm" v-if="errorMessage!.length > 0">
      {{ errorMessage }}
    </span>
  </Transition>
</template>
<style>
.v-enter-active,
.v-leave-active {
  transition: opacity 0.5s ease;
}

.v-enter-from,
.v-leave-to {
  opacity: 0;
}
</style>
