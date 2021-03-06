// Clément Hue
'use strict';
let albums = {
    Fresh_Cream: {
        artist: 'Cream',
        year: '1966',
        title: 'Fresh Cream',
    },
    Hot_Rats: {
        artist: 'Frank Zappa',
        year: '1969',
        title: 'Hot Rats',
    },
    Space_Oddity: {
        artist: 'David Bowie',
        year: '1969',
        title: 'Space Oddity',
    },
    Merry_Christmas: {
        artist: 'Mariah Carey',
        year: '1994',
        title: 'Merry Christmas',
    },
    Songs_from_a_Room: {
        artist: 'Leonard Cohen',
        year: '1969',
        title: 'Song from a Room',
    },
    Ummagumma: {
        artist: 'Pink Floyd',
        year: '1969',
        title: 'Ummagumma',
    },
    Camembert_electrique: {
        artist: 'Gong',
        year: '1971',
        title: 'Camembert Electrique',
    },
    The_Piper_at_the_Gates_of_Dawn: {
        artist: 'Pink Floyd',
        year: '1967',
        title: 'The Piper athe Gates of Dawn',
    },
};

// création du fichier json
let albumsJson = JSON.stringify(albums);
let file = require('fs');
file.writeFile('albums.json', albumsJson, (error) => {
    console.log(error);
});

// récupération du fichier json
file.readFile('albums.json', (error, data) => {
    let albumsBis = JSON.parse(data);
    console.log(albumsBis);
});