<script setup lang="ts">
import type { NotificationModel } from '@/models/NotificationModel';
import { markNotificationAsRead } from '@/services/notification_service';



defineProps<{
  showingNotifications: boolean,
  notifications: NotificationModel[],
}>()

async function readNotification(notification: NotificationModel) {
  await markNotificationAsRead(notification)
  notification.read = true;
}
</script>

<template>
  <div v-if="showingNotifications"
    class="w-56 h-48 bg-white border absolute top-14 right-2 rounded-md notification-dialog overflow-scroll container-snap">
    <div class="flex flex-row justify-between items-center p-2" v-for="notification in notifications"
      v-bind:key="notification.id" v-on:click="readNotification(notification)">
      <div class="flex flex-col">
        <h6 class="text-sm font-semibold">
          {{ notification.title }}
        </h6>
        <p class="text-xs">
          {{ notification.message }}
        </p>
      </div>
      <div v-if="!notification.read" class="w-3 h-3 bg-red-500 ml-2 rounded-full">

      </div>
    </div>
  </div>
</template>
