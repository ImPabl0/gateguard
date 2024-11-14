import { NotificationModel } from '@/models/NotificationModel'
import { currDatabase } from '@/stores/firedatabase'
import {
  collection,
  doc,
  getDocs,
  onSnapshot,
  orderBy,
  query,
  setDoc,
  where,
} from 'firebase/firestore'

const db = currDatabase

async function getNotificationsFromUser(
  cpf: string,
): Promise<NotificationModel[]> {
  const user = doc(db, 'users', cpf)
  const currQuery = query(
    collection(db, 'notifications'),
    orderBy('created_at', 'desc'),
    where('user', '==', user),
  )

  const docs = await getDocs(currQuery)

  const requests: NotificationModel[] = []

  docs.forEach(doc => {
    const docData = doc.data()
    docData.id = doc.id
    requests.push(docData as NotificationModel)
  })

  return requests
}

async function markNotificationAsRead(
  notification: NotificationModel,
): Promise<void> {
  const notificationDoc = doc(db, 'notifications', notification.id.toString())
  await setDoc(notificationDoc, { read: true }, { merge: true })
}

function listenToUserNotifications(
  cpf: string,
  callback: (notifications: NotificationModel[]) => void,
): () => void {
  const user = doc(db, 'users', cpf)
  const currQuery = query(
    collection(db, 'notifications'),
    orderBy('created_at', 'desc'),
    where('user', '==', user),
  )

  const unsubscribe = onSnapshot(currQuery, snapshot => {
    const notifications: NotificationModel[] = []
    snapshot.forEach(doc => {
      const docData = doc.data()
      docData.id = doc.id
      notifications.push(docData as NotificationModel)
    })
    callback(notifications)
  })

  return unsubscribe
}

export {
  getNotificationsFromUser,
  markNotificationAsRead,
  listenToUserNotifications,
}
