<script setup lang="ts">
import LoadingComponent from '@/components/LoadingComponent.vue';
import type { RequestModel } from '@/models/RequestModel';
import router from '@/router';
import { saveRequest } from '@/services/request_service';
import { ref } from 'vue';


const request = ref<RequestModel>({
  id: undefined,
  title: '',
  guestName: '',
  description: '',
  type: 'person',
  status: 'PENDENT',
  requester: undefined,
  created_at: new Date(),
  updated_at: new Date(),
})

const formValidation = ref({
  title: true,
  guestName: true,
  description: true,
})

function validateForm() {
  formValidation.value.title = !!request.value.title
  formValidation.value.description = !!request.value.description
  formValidation.value.guestName = !!request.value.guestName
  return formValidation.value.title && formValidation.value.description
}

async function onSubmit() {
  if (!validateForm()) return
  if (isLoading.value) return
  try {
    isLoading.value = true
    await saveRequest(request.value)
    router.push({ name: 'ListRequests' })
  } catch (error) {
    console.error(error)
  } finally {
    isLoading.value = false
  }
}

const isLoading = ref(false)

</script>

<template>
  <div class="p-5">
    <h1 class="text-2xl font-bold">Criar solicitação</h1>
    <div class="flex flex-col gap-1 mt-2">
      <label for="title">Título</label>
      <input v-model="request.title" id="title" type="text" class="p-2 border border-gray-300 rounded-md">
      <h6 v-if="!formValidation.title" class="text-red-600 text-xs">Título é obrigatório</h6>
    </div>
    <div class="flex flex-col gap-1 mt-2">
      <label for="guest_name">Nome do visitante</label>
      <input v-model="request.guestName" id="guest_name" type="text" class="p-2 border border-gray-300 rounded-md">
      <h6 v-if="!formValidation.guestName" class="text-red-600 text-xs">Nome do visitante é obrigatório</h6>
    </div>
    <div class="flex flex-col gap-2 mt-5">
      <label for="description">Descrição</label>
      <textarea v-model="request.description" id="description" class="p-2 border border-gray-300 rounded-md"></textarea>
      <h6 v-if="!formValidation.description" class="text-red-600 text-xs">Descrição é obrigatório</h6>
    </div>
    <div class="flex flex-col gap-2 mt-5">
      <label for="type">Tipo</label>
      <select v-model="request.type" id="type" class="p-2 border border-gray-300 rounded-md">
        <option value="person">Pessoa</option>
        <option value="car">Carro</option>
      </select>
    </div>
    <button @click="onSubmit" class="bg-blue-500 h-14 text-white rounded-md mt-5 justify-center px-3">
      <LoadingComponent class="w-14" v-if="isLoading" />
      <h4 v-if="!isLoading">Criar solicitação</h4>
    </button>
  </div>
</template>
