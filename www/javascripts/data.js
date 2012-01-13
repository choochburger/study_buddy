/**
 * This will eventually be pulled from a server and cached in
 * local storage to allow customization. For now, we'll bootstrap
 * some Thai vocab shit up in this
 **/

var SB = window.SB || {};

SB.Data = {
  "categories": [
    {
      "name": "Colors",
      "items": [
        ["Color", "See"],
        ["Black", "See Dam"],
        ["White", "See Khow"],
        ["Green", "See Keeyow"],
        ["Brown", "See Namdam"],
        ["Purple", "See Moo-ung"],
        ["Yellow", "See Loo-ung"],
        ["Red", "See Dang"],
        ["Blue", "See Na Nun"],
        ["Grey", "See Thau"]
      ]
    },

    {
      "name": "Classroom/House",
      "items": [
        ["Pen","Bpak Ga"],
        ["Pencil","Din Sor"],
        ["Book","Nang Seuhr"],
        ["Table","Dto"],
        ["Chair","Gau-ee"],
        ["Light","Lawd-fye"],
        ["Wall","Fa-panang"],
        ["Floor","Peuhne"],
        ["Room","Hong"],
        ["Ceiling","Paydahn"],
        ["Window","Nahdahng"],
        ["Door","Bradoo"],
        ["Picture","Ru-paab"]
      ]
    },

    {
      "name": "Misc Items",
      "items": [
        ["Card", "Gahdt"],
        ["Box", "Glong"]
      ]
    },

    {
      "name": "Commands",
      "items": [
        ["Read that","Aan Wa"],
        ["Spell please", "Sa goat ka/krap"]
      ]
    },

    {
      "name": "Questions",
      "items": [
        ["Is that right?", "Chai mai?"],
        ["What is this?", "Knee arye?"]
      ]
    },

    {
      "name": "Statements",
      "items": [
        ["This is", "Knee"]
      ]
    },

    {
      "name": "Exclamations",
      "items": [
        ["Yes", "Chai"],
        ["No", "Mai chai"]
      ]
    },

    {
      "name": "Pronouns",
      "items": [
        ["I", "Pom"],
        ["You", "Koon"]
      ]
    },

    {
      "name": "Numbers",
      "items": [
        ["One", "Neung"],
        ["Two", "Song"],
        ["Three", "Sahm"],
        ["Four", "See"],
        ["Five", "Hah"],
        ["Six", "Hogk"],
        ["Seven", "Jed"],
        ["Eight", "Bpad"],
        ["Nine", "Gao"],
        ["Ten", "Sihp"]
      ]
    }
  ]
}
