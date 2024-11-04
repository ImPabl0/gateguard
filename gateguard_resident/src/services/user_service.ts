import type { User } from '@/interfaces/user'
import type { UserRequest } from '@/interfaces/user_request_interface'
import { currDatabase } from '@/stores/firedatabase'
import { collection, getDocs, query, where } from 'firebase/firestore'

function stringToNumber(value: string) {
  return value.replace(/\D/g, '')
}

async function findUserByCpfAndPassword(
  request: UserRequest,
): Promise<User | undefined> {
  const makeQuery = query(
    collection(currDatabase, 'users'),
    where('__name__', '==', stringToNumber(request.cpf)),
    where('password', '==', request.password),
  )
  const snapshot = await getDocs(makeQuery)

  if (snapshot.empty) {
    return undefined
  }

  const user = snapshot.docs[0].data() as User

  user.cpf = snapshot.docs[0].id

  return user
}

export { findUserByCpfAndPassword }
