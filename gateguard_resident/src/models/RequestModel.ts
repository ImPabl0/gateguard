import type { User } from '@/interfaces/user'
import type { DocumentReference } from 'firebase/firestore'

export class RequestModel {
  id: string | undefined
  created_at: Date
  description: string
  requester: User | undefined | DocumentReference
  status: string
  title: string
  type: string
  updated_at: Date

  constructor(
    created_at: Date,
    id: string | undefined,
    description: string,
    requester: User,
    status: string,
    title: string,
    type: string,
    updated_at: Date,
  ) {
    this.created_at = created_at
    this.description = description
    this.requester = requester
    this.status = status
    this.id = id
    this.type = type
    this.title = title
    this.updated_at = updated_at
  }
}
