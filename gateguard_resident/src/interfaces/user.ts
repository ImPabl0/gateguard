import type { DocumentReference } from 'firebase/firestore'

export interface User {
  cpf: string
  name: string
  condominium: DocumentReference | undefined
  role: string
}
