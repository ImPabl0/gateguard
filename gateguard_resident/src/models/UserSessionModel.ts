import { computed } from 'vue'

export class UserSession {
  user: string | null
  cpf: string | null
  token: string | null
  date: number | null

  constructor(
    user: string | null = null,
    cpf: string | null = null,
    token: string | null = null,
    date: number | null = null,
  ) {
    this.user = user
    this.token = token
    this.cpf = cpf
    this.date = date ?? Date.now()
  }

  isValid = computed(() => {
    if (this.date === null) {
      return false
    }
    const oneDayInMilliseconds = 24 * 60 * 60 * 1000
    return Date.now() - this.date < oneDayInMilliseconds
  })
}
