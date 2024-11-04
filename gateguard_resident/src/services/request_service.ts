import type { RequestModel } from '@/models/RequestModel'
import { currDatabase } from '@/stores/firedatabase'
import { useUserSessionStore } from '@/stores/user_session'
import {
  addDoc,
  collection,
  doc,
  getDocs,
  orderBy,
  query,
  Timestamp,
  where,
} from 'firebase/firestore'

async function getRequestsFromUser(cpf: string): Promise<RequestModel[]> {
  const requester = doc(currDatabase, 'users', cpf)
  const currQuery = query(
    collection(currDatabase, 'requests'),
    where('requester', '==', requester),
    orderBy('created_at', 'desc'),
  )

  const docs = await getDocs(currQuery)

  const requests: RequestModel[] = []

  docs.forEach(doc => {
    const docData = doc.data()
    docData.id = doc.id
    requests.push(docData as RequestModel)
  })

  return requests
}

async function saveRequest(request: RequestModel): Promise<void> {
  const user = useUserSessionStore()
  const requester = doc(currDatabase, 'users', user.value!.cpf)
  request.requester = requester
  await addDoc(collection(currDatabase, 'requests'), {
    requester: requester,
    title: request.title,
    description: request.description,
    status: request.status,
    type: request.type,
    created_at: Timestamp.now(),
  })
}

export { getRequestsFromUser, saveRequest }
