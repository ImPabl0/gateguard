<script setup lang="ts">
import MenuCard from '@/components/MenuCard.vue';
import router from '@/router';
function createRequest() {
  router.push({ name: 'CreateRequest' });
}

function listRequests() {
  router.push({ name: 'ListRequests' });
}


</script>

<template>
  <div class="w-full">
    <div class="w-full grid grid-cols-2 gap-3 px-5 py-2 overflow-scroll container-snap">
      <MenuCard name="../assets/access_icon.svg" title="Minhas solicitações" :onClick="listRequests" />
      <MenuCard name="../assets/access_icon.svg" title="Criar nova solicitação" :onClick="createRequest" />


    </div>

  </div>
</template>
