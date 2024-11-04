<script setup lang="ts">
import type { RequestModel } from '@/models/RequestModel';
import { getRequestsFromUser } from '@/services/request_service';
import { useUserSessionStore } from '@/stores/user_session';
import { ref } from 'vue';

const user = useUserSessionStore();

const requests = ref<RequestModel[]>([]);
const loading = ref(false);

async function getRequests() {
  if (!user.value) return
  loading.value = true
  try {
    requests.value = await getRequestsFromUser(user.value.cpf)

  } catch (error) {
    console.error(error)
  } finally {
    loading.value = false
  }
}

function getRequestStatus(requestStatus: string) {
  switch (requestStatus) {
    case 'PENDENT':
      return 'PENDENTE'
    case 'ACCEPTED':
      return 'ACEITO'
    case 'DENIED':
      return 'NEGADO'
    default:
      return 'DESCONHECIDO'
  }
}

function getRequestStatusColor(requestStatus: string) {
  switch (requestStatus) {
    case 'PENDENT':
      return 'bg-yellow-500'
    case 'ACCEPTED':
      return 'bg-green-700'
    case 'DENIED':
      return 'bg-red-700'
    default:
      return 'bg-gray-700'
  }
}

getRequests()
</script>

<template>
  <div class="flex flex-col p-5 overflow-scroll">
    <h1 class="text-2xl font-bold">Minhas solicitações</h1>
    <div v-if="loading" class="flex justify-center items-center h-64">
      <svg class="animate-spin h-5 w-5 text-blue-500" xmlns="http://www.w3.org/2000/svg" fill="none"
        viewBox="0 0 24 24">
        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
        <path class="opacity-75" fill="currentColor"
          d="M4 12a8 8 0 018-8V0c4.418 0 8 3.582 8 8h-2c0-3.314-2.686-6-6-6V0c-2.209 0-4 1.791-4 4v4H4zm2 8a8 8 0 01-8-8h2c0 3.314 2.686 6 6 6v2c0 2.209 1.791 4 4 4h4v2a8 8 0 01-8-8z">
        </path>
      </svg>
    </div>
    <div v-else>
      <div v-if="requests.length === 0" class="flex justify-center items-center h-64">
        <p class="text-lg">Nenhuma solicitação encontrada</p>
      </div>
      <div v-else>
        <div v-for="request in requests" :key="request.created_at"
          class="bg-white shadow-md rounded-lg p-5 my-5 h-full flex flex-col w-full">

          <div class="w-3 h-3 relative self-end rounded-full ml-3" :class="getRequestStatusColor(request.status)">

          </div>
          <div class="flex flex-row w-full h-full relative bottom-3 justify-between">
            <div class="flex w-full break-words">
              <h4 class="break-words w-full font-bold text-base leading-tight">
                {{ request.title }}
              </h4>
            </div>


          </div>
          <p class="text-sm relative bottom-1">{{ request.description }}</p>

        </div>
      </div>
    </div>
  </div>
</template>
