import spotipy
import pandas as pd
import enchant
dictionary = enchant.Dict("en_US")

from spotipy.oauth2 import SpotifyClientCredentials


my_id = '655e62800e724511b9a6f74b1bfa635f'
secret_key = '9e1f1feb45874771b24d1d10d19e87bd'

client_credentials_manager = SpotifyClientCredentials(client_id=my_id, client_secret=secret_key)
sp = spotipy.Spotify(client_credentials_manager=client_credentials_manager)

# Kpop
bts = 'https://open.spotify.com/artist/3Nrfpe0tUJi4K4DXYWgMUX'

apink = 'https://open.spotify.com/artist/2uWcrwgWmZcQc3IPBs3tfU'
blackpink = 'https://open.spotify.com/artist/41MozSoPIsD1dJM0CLPjZF'
exo = 'https://open.spotify.com/artist/3cjEqqelV9zb4BYE3qDQ4O'
ikon = 'https://open.spotify.com/artist/5qRSs6mvI17zrkJpOHkCoM'
twice = 'https://open.spotify.com/artist/7n2Ycct7Beij7Dj7meI4X0'
wannaone = 'https://open.spotify.com/artist/2CvaqAMMsX576VBehaJ0Wx'
mamamoo = 'https://open.spotify.com/artist/0XATRDCYuuGhk0oE7C0o5G'
btob = 'https://open.spotify.com/artist/2hcsKca6hCfFMwwdbFvenJ'

# Bolbbalgan4 does not have a Spotify
bigbang = 'https://open.spotify.com/artist/4Kxlr1PRlDKEB0ekOCyHgX'

artist_list = [bts, apink, blackpink, exo, ikon, twice, wannaone, mamamoo, btob, bigbang]

feature_list = []

for artist in artist_list:

    artistalbums = sp.artist_albums(artist_id=artist, limit=50)

    # go to their individual albums
    for i in range(len(artistalbums['items'])):
        album_uri = artistalbums['items'][i]['uri']
        album_tracks = sp.album_tracks(album_uri)


        # go to their individual tracks
        for j in range(len(album_tracks['items'])):
            album_song = album_tracks['items'][j]['uri']
            audiofeatures = sp.audio_features(album_song)

            # Formatting track names to sync with lyrics dataframe

            title = album_tracks['items'][j]['name']
            name = title.split()
            name_list = []
            for word in name:
                if word.isalnum() and dictionary.check(word) == True:
                    name_list.append(word.lower())

            track_name_changed = '-'.join(name_list)

            # extract individual audio features of individual tracks
            for feature in audiofeatures:
                feature_list.append([feature['danceability'], feature['energy'], feature['key'], feature['speechiness'],
                                     feature['acousticness'], feature['instrumentalness'], feature['liveness'],
                                     feature['valence'],
                                     feature['tempo'], feature['duration_ms'], feature['time_signature'],
                                     artistalbums['items'][0]['artists'][0]['name'],
                                     artistalbums['items'][i]['release_date'], album_tracks['items'][j]['name'],
                                     [track_name_changed]])

data = pd.DataFrame(feature_list,
                    columns=['danceability', 'energy', 'key', 'speechiness', 'acousticness', 'instrumentalness',
                             'liveness', 'valence', 'tempo', 'duration_ms', 'time_signature', 'artist_name',
                             'release_date', 'song_name', 'song_name_formatted'])

data.to_csv('kpop_top10.csv')
