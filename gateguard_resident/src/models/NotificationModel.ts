export class NotificationModel {
  id: number
  title: string
  message: string
  read: boolean
  date: Date

  constructor(
    id: number,
    title: string,
    message: string,
    read: boolean,
    date: Date,
  ) {
    this.id = id
    this.title = title
    this.message = message
    this.read = read
    this.date = date
  }
}
