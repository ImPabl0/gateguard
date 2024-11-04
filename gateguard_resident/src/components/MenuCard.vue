<script setup lang="ts">
// require svg name, card title and onClick function
defineProps<{ name: string; title: string; onClick: () => void }>();

function getImageUrl(name: string) {
  return new URL(name, import.meta.url).href;
}
</script>
<template>
  <div class="flex flex-col gap-2 items-center justify-center bg-white rounded-md shadow-md p-5">
    <img :src="getImageUrl(name)" alt="icon" class="w-6 h-w-6 text-red-600">
    <h4 class="text-center">{{ title }}</h4>
    <button @click="onClick" class="bg-blue-500 text-white rounded-md p-2">Acessar</button>
  </div>
</template>
