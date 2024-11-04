<script setup lang="ts">
import router from '@/router';
import { useUserSessionStore } from '@/stores/user_session';
import TopMenu from '@/components/TopMenu.vue';

const user = useUserSessionStore();

if (user.value == null) {
  router.push({ name: 'Login' });
}

</script>


<template>
  <div class="flex flex-col w-screen h-screen bg-[#F9F9F9]">
    <TopMenu />
    <RouterView class="mt-24" v-slot="{ Component }">
      <Transition name="slide">
        <component :is="Component" />
      </Transition>
    </RouterView>
  </div>
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
