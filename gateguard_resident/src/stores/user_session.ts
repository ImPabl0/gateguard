import { ref } from 'vue'
import { defineStore } from 'pinia'
import { UserSession as UserSessionModel } from '@/models/UserSessionModel'
import type { User } from '@/interfaces/user'

export const useUserSessionStore = defineStore('user_session', () => {
  const value = ref<User>()

  function setUserSession(userSession: User) {
    value.value = userSession
  }

  return { value, setUserSession, UserSession: UserSessionModel }
})
