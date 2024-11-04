<script setup lang="ts">
import type { NotificationModel } from '@/models/NotificationModel';
import router from '@/router';
import { useUserSessionStore } from '@/stores/user_session';
import NotificationList from '@/components/NotificationList.vue';
import { computed, ref } from 'vue';
import { getNotificationsFromUser, listenToUserNotifications } from '@/services/notification_service';


const user = useUserSessionStore();

const notifications = ref<NotificationModel[]>([]);




const notificationCount = computed(() => {
  return notifications.value.filter((notification: NotificationModel) => !notification.read).length;
});

function onClickBell() {
  showingNotifications.value = !showingNotifications.value;
}

async function loadNotifications() {
  notifications.value = await getNotificationsFromUser(user.value.cpf)
}

const showingNotifications = ref(false);

function vibrateNotification() {
  const notificationBell = document.getElementById('notification-bell');
  if (notificationBell) {
    notificationBell.animate([
      { transform: 'rotate(0deg)' },
      { transform: 'rotate(30deg)' },
      { transform: 'rotate(-30deg)' },
      { transform: 'rotate(15deg)' },
      { transform: 'rotate(-15deg)' },
      { transform: 'rotate(0deg)' }
    ], {
      duration: 500,
      iterations: 1
    });
  }
}

function clickLogo() {
  router.push('/');
}
if (user.value) {
  listenToUserNotifications(user.value!.cpf, (receivedNotifications) => {
    notifications.value = receivedNotifications
    receivedNotifications.forEach(notification => {
      if (!notification.read) {
        vibrateNotification()
        return;
      }
    })
  });
  loadNotifications();
}
</script>

<template>
  <div class="flex flex-row h-20 w-screen border rounded-md p-3 bg-white shadow-md justify-between absolute top-0">
    <div class="flex flex-row items-center gap-2">
      <img class="max-w-16" src="../assets/logo.png" alt="" v-on:click="clickLogo()">
      <h4>
        Bem vindo, {{ user.value?.name }}
      </h4>
    </div>
    <div class="flex justify-start" v-on:click="onClickBell()">
      <img id="notification-bell" class="w-7" src="../assets/notification.svg" alt="">
      <span v-if="notificationCount > 0"
        class="bg-red-500 text-white items-center rounded-full w-5 h-5 text-center text-xs absolute top-5 right-1">
        {{ notificationCount <= 9 ? notificationCount : "9+" }} </span>
          <NotificationList :notifications="notifications" :showingNotifications="showingNotifications" />
    </div>
  </div>
</template>
