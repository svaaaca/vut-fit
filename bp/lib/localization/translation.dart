//
// @file translation.dart
// @author David Kvaček (xkvace00@stud.fit.vutbr.cz)
// @brief Source code of the app localization logic implemetation.
// @date 2025-05-14
//

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:veloo/localization/provider.dart';

String translate(BuildContext context, String key) {
  final locale = Provider.of<LanguageProvider>(context, listen: false).localeData.languageCode;
  final translation = {
    'actions': {
      'cs': 'AKCE',
      'en': 'ACTIONS',
    },
    'allow_access': {
      'cs': 'Povolit přístup k poloze tohoto zařízení.',
      'en': 'Allow Access to This Device\'s Location.',
    },
    'altitude_maximum': {
      'cs': 'Maximální výška',
      'en': 'Altitude Maximum',
    },
    'altitude_mean': {
      'cs': 'Průměrná výška',
      'en': 'Altitude Mean',
    },
    'altitude_minimum': {
      'cs': 'Minimální výška',
      'en': 'Altitude Minimum',
    },
    'analysis': {
      'cs': 'ANALÝZA',
      'en': 'ANALYSIS',
    },
    'appearance': {
      'cs': 'Vzhled',
      'en': 'Appearance',
    },
    'application': {
      'cs': 'APLIKACE',
      'en': 'APPLICATION',
    },
    'average_speed': {
      'cs': 'Průměrná rychlost',
      'en': 'Average Speed',
    },
    'browse_files': {
      'cs': 'PROCHÁZET SOUBORY',
      'en': 'BROWSE FILES',
    },
    'cancel': {
      'cs': 'ZRUŠIT',
      'en': 'CANCEL',
    },
    'center': {
      'cs': 'Vycentrovat',
      'en': 'Center',
    },
    'climbs': {
      'cs': 'STOUPÁNÍ',
      'en': 'CLIMBS',
    },
    'confirm': {
      'cs': 'Potvrdit',
      'en': 'Confirm',
    },
    'czech': {
      'cs': 'Čeština',
      'en': 'Czech',
    },
    'dark_mode': {
      'cs': 'Tmavý režim',
      'en': 'Dark Mode',
    },
    'delete': {
      'cs': 'SMAZAT',
      'en': 'DELETE',
    },
    'delete_analysis': {
      'cs': 'SMAZAT ANALÝZU',
      'en': 'DELETE ANALYSIS',
    },
    'delete_trip_analysis': {
      'cs': 'Opravdu chcete smazat analýzu výjezdu?',
      'en': 'Are You Sure You Want to Delete the Trip Analysis?',
    },
    'difficult': {
      'cs': 'Náročná',
      'en': 'Difficult',
    },
    'difficulty': {
      'cs': 'Obtížnost',
      'en': 'Difficulty',
    },
    'difficulty_index': {
      'cs': 'Index obtížnosti',
      'en': 'Difficulty Index',
    },
    'distance': {
      'cs': 'Vzdálenost',
      'en': 'Distance',
    },
    'drop_file': {
      'cs': 'Přetažením vyberte soubor',
      'en': 'Drag & Drop to Choose File',
    },
    'easy': {
      'cs': 'Snadná',
      'en': 'Easy',
    },
    'elevation': {
      'cs': 'Převýšení',
      'en': 'Elevation',
    },
    'elevation_gain': {
      'cs': 'Stoupání',
      'en': 'Elevation Gain',
    },
    'elevation_gain_mean': {
      'cs': 'Stoupání / km',
      'en': 'Elevation Gain / km',
    },
    'elevation_loss': {
      'cs': 'Klesání',
      'en': 'Elevation Loss',
    },
    'elevation_loss_mean': {
      'cs': 'Klesání / km',
      'en': 'Elevation Loss / km',
    },
    'elevation_mean': {
      'cs': 'Převýšení / km',
      'en': 'Elevation / km',
    },
    'elevation_profile': {
      'cs': 'VÝŠKOVÝ PROFIL',
      'en': 'ELEVATION PROFILE',
    },
    'english': {
      'cs': 'Angličtina',
      'en': 'English',
    },
    'empty_input': {
      'cs': 'PRÁZDNÝ VSTUP',
      'en': 'EMPTY INPUT',
    },
    'empty_list': {
      'cs': 'PRÁZDNÝ SEZNAM',
      'en': 'EMPTY LIST',
    },
    'error': {
      'cs': 'Chyba',
      'en': 'Error',
    },
    'estimated_time': {
      'cs': 'Odhadovaný čas',
      'en': 'Estimated Time',
    },
    'generate_analysis': {
      'cs': 'VYGENEROVAT ANALÝZU',
      'en': 'GENERATE ANALYSIS',
    },
    'generating': {
      'cs': 'Generování...',
      'en': 'Generating...',
    },
    'generation_success': {
      'cs': 'Analýza úspěšně vygenerována!',
      'en': 'The Analysis Generated Successfully!',
    },
    'gradient_maximum': {
      'cs': 'Maximální sklon',
      'en': 'Gradient Maximum',
    },
    'gradient_mean': {
      'cs': 'Průměrný sklon',
      'en': 'Gradient Mean',
    },
    'gradient_mean_positive': {
      'cs': 'Průměrný kladný sklon',
      'en': 'Gradient Mean Positive',
    },
    'help': {
      'cs': 'Nápověda',
      'en': 'Help',
    },
    'choose_file': {
      'cs': 'VYBRAT SOUBOR',
      'en': 'CHOOSE FILE',
    },
    'imperial': {
      'cs': 'Imperiální',
      'en': 'Imperial',
    },
    'import': {
      'cs': 'NAHRÁT',
      'en': 'IMPORT',
    },
    'import_file': {
      'cs': 'NAHRÁT SOUBOR',
      'en': 'IMPORT FILE',
    },
    'import_help': {
      'cs': 'Použijte korektní geografický soubor naplánované cyklistické trasy ve formátu FIT, GPX, KML, či TCX. Vytvořte jej vlastním záznamem sportovní aktivity, nebo pomocí libovolné plánovací služby, např. Komoot, Mapy.cz, Ride with GPS, Strava aj.',
      'en': 'Use the Correct Geographical File of the Planned Cycling Trip in FIT, GPX, KML or TCX Format. Create It with Own Sport Activity Record or with Any Planning Service, e.g., Komoot, Mapy.com, Ride with GPS, Strava, etc.',
    },
    'language': {
      'cs': 'Jazyk',
      'en': 'Language',
    },
    'location': {
      'cs': 'Poloha',
      'en': 'Location',
    },
    'map': {
      'cs': 'MAPA',
      'en': 'MAP',
    },
    'measurement': {
      'cs': 'MĚŘENÍ',
      'en': 'MEASUREMENT',
    },
    'medium': {
      'cs': 'Střední',
      'en': 'Medium',
    },
    'metric': {
      'cs': 'Metrické',
      'en': 'Metric',
    },
    'my_location': {
      'cs': 'Moje poloha',
      'en': 'My Location',
    },
    'no_input_data': {
      'cs': 'Nejsou k dispozici žádná vstupní data',
      'en': 'No Input Data is Available',
    },
    'no_file_chosen': {
      'cs': 'Nevybrán žádný soubor',
      'en': 'No File Chosen',
    },
    'no_saved_trips': {
      'cs': 'Nejsou k dispozici žádné výjezdy',
      'en': 'No Trips are Available',
    },
    'ok': {
      'cs': 'OK',
      'en': 'OK',
    },
    'open_settings': {
      'cs': 'Otevřít nastavení',
      'en': 'Open Settings',
    },
    'osm_contributors': {
      'cs': 'Přispěvatelé OpenStreetMap',
      'en': 'OpenStreetMap contributors',
    },
    'remove': {
      'cs': 'ODSTRANIT',
      'en': 'REMOVE',
    },
    'remove_trip_list': {
      'cs': 'Opravdu chcete odstranit všechny výjezdy?',
      'en': 'Are You Sure You Want to Remove All Trips?',
    },
    'remove_trips': {
      'cs': 'ODSTRANIT VÝJEZDY',
      'en': 'REMOVE TRIPS',
    },
    'save': {
      'cs': 'ULOŽIT',
      'en': 'SAVE',
    },
    'save_analysis': {
      'cs': 'ULOŽIT ANALÝZU',
      'en': 'SAVE ANALYSIS',
    },
    'save_success': {
      'cs': 'Analýza výjezdu úspěšně uložena!',
      'en': 'The Trip Analysis Saved Successfully!',
    },
    'save_trip_analysis': {
      'cs': 'Opravdu chcete uložit analýzu výjezdu?',
      'en': 'Are You Sure You Want to Save the Trip Analysis?',
    },
    'saved_trips': {
      'cs': 'ULOŽENÉ VÝJEZDY',
      'en': 'SAVED TRIPS',
    },
    'settings': {
      'cs': 'NASTAVENÍ',
      'en': 'SETTINGS',
    },
    'speed': {
      'cs': 'Rychlost',
      'en': 'Speed',
    },
    'statistics': {
      'cs': 'STATISTIKY',
      'en': 'STATISTICS',
    },
    'success': {
      'cs': 'Úspěch',
      'en': 'Success',
    },
    'top': {
      'cs': 'Vrchol',
      'en': 'Top',
    },
    'trip_analysis': {
      'cs': 'ANALÝZA VÝJEZDU',
      'en': 'TRIP ANALYSIS',
    },
    'trip_list': {
      'cs': 'SEZNAM VÝJEZDŮ',
      'en': 'TRIP LIST',
    },
    'trips': {
      'cs': 'VÝJEZDY',
      'en': 'TRIPS',
    },
    'units': {
      'cs': 'Jednotky',
      'en': 'Units',
    },
    'upload_error': {
      'cs': 'Neplatný obsah souboru! Vyberte soubor s platnými daty.',
      'en': 'Invalid File Content! Choose a File with Valid Data.',
    },
    'upload_missing': {
      'cs': 'Nevybrán žádný soubor! Vyberte soubor k nahrání.',
      'en': 'No File Chosen! Choose a File to Upload.',
    },
    'warning': {
      'cs': 'Upozornění',
      'en': 'Warning',
    },
    'zoom_in': {
      'cs': 'Přiblížit',
      'en': 'Zoom In',
    },
    'zoom_out': {
      'cs': 'Oddálit',
      'en': 'Zoom Out',
    },
  };
  return translation[key]?[locale] ?? key;
}
