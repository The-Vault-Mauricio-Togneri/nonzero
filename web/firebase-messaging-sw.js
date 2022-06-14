importScripts('https://www.gstatic.com/firebasejs/8.10.1/firebase-app.js');
importScripts('https://www.gstatic.com/firebasejs/8.10.1/firebase-auth.js');
importScripts('https://www.gstatic.com/firebasejs/8.10.1/firebase-firestore.js');

var firebaseConfig = {
    apiKey: "AIzaSyBJNztg4PE-RDaE58kZTdSqeUKoXcNQdYM",
    authDomain: "andstoreapps.firebaseapp.com",
    databaseURL: "https://andstoreapps.firebaseio.com",
    projectId: "andstoreapps",
    storageBucket: "andstoreapps.appspot.com",
    messagingSenderId: "364551387093",
    appId: "1:364551387093:web:89565f932f9cdf3c6aaf5c",
    measurementId: "G-MM6DTYH6RX"
};

firebase.initializeApp(firebaseConfig);