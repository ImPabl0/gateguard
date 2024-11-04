// Import the functions you need from the SDKs you need
import { initializeApp } from 'firebase/app'
import { getFirestore } from 'firebase/firestore'
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
  apiKey: 'AIzaSyBph6EW-ZiQOqJtXnc8OvcbvOrWDdWZe0g',
  authDomain: 'gateguard-br.firebaseapp.com',
  databaseURL: 'https://gateguard-br-default-rtdb.firebaseio.com',
  projectId: 'gateguard-br',
  storageBucket: 'gateguard-br.firebasestorage.app',
  messagingSenderId: '29065634962',
  appId: '1:29065634962:web:1dd41316b0662cc9c7324b',
  measurementId: 'G-5FFVQDJ0FC',
}

// Initialize Firebase
const app = initializeApp(firebaseConfig)

const database = getFirestore(app)

export { database as currDatabase }
