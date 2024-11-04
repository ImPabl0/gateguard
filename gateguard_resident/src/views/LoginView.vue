<script setup lang="ts">
import { mask as vMask } from 'vue-the-mask'

import { ref } from 'vue'
import LoadingComponent from '@/components/LoadingComponent.vue';
import { useUserSessionStore } from '@/stores/user_session';
import router from '@/router';
import ErrorMessage from '@/components/ErrorMessage.vue';
import type { UserRequest } from '@/interfaces/user_request_interface';
import { findUserByCpfAndPassword } from '@/services/user_service';

const user = useUserSessionStore();

if (user.value == null) {
  router.push({ name: 'Login' });

}

const userRequest = ref<UserRequest>({
  cpf: '',
  password: '',
  isLoading: false
})



async function login() {
  userRequest.value.isLoading = true;
  errorMessage.value = '';

  try {
    const foundUser = await findUserByCpfAndPassword(userRequest.value);
    if (foundUser) {
      user.setUserSession(foundUser);
      await router.push({ name: 'Home' });
    } else {
      errorMessage.value = 'Usuário ou senha inválido.';
    }
  } catch (error) {
    errorMessage.value = 'Erro ao realizar login.';
    console.error(error);
  } finally {
    userRequest.value.isLoading = false;
    if (errorMessage.value) {
      setTimeout(() => {
        errorMessage.value = '';
      }, 3000);
    }
  }
}
const errorMessage = ref('')
</script>

<template>

  <div
    class="flex items-center justify-center h-screen w-screen bg-no-repeat bg-cover bg-[url('https://blog.condlink.com.br/wp-content/uploads/2020/11/condomi%CC%81nio.jpg')]">
    <div
      class="p-5 flex flex-col rounded-md max-w-72 m-5 w-full border bg-white  backdrop-blur-md bg-opacity-65 shadow-sm">
      <div class="w-full flex justify-center">
        <img src="../assets/logo.png" alt="logo" class="">
      </div>
      <form class="gap-2 flex flex-col" @submit.prevent="login()">
        <div class="flex flex-col">
          <label for="cpf" class="text-sm font-semibold">CPF</label>
          <input type="text" v-model="userRequest.cpf" id="cpf" class="border rounded-md p-2"
            v-mask="['###.###.###-##']" />
        </div>
        <div class="flex flex-col">
          <label for="password" class="text-sm font-semibold">Senha</label>
          <input type="password" v-model="userRequest.password" id="password" class="border rounded-md p-2">
        </div>
        <ErrorMessage :errorMessage="errorMessage" />
        <button type="submit" class="bg-blue-500 max-h-20 border flex justify-center text-white rounded-md">
          <div class="w-10 h-12 flex justify-center items-center">
            <LoadingComponent v-if="userRequest.isLoading" />
            <h4 v-if="!userRequest.isLoading">Entrar</h4>
          </div>
        </button>
      </form>
    </div>
  </div>
</template>
